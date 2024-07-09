module.exports = function(config) {
	const db = require("./database.js")(config);
	const uuid = require("uuid/v4");
	const paypal = require("paypal-rest-sdk");
	require('dotenv').config();

	function deleteTransaction(txId) {
		db.query("DELETE FROM transactions WHERE transaction_id = ?", [txId]);
	}

	function createPayment(req, res) {
		if (res.locals.trolleyTracks && res.locals.trolleyTracks.length > 0 && res.locals.transactionId) {
			paypal.configure(config.paypal_sdk);
			const paymentRequest = {
				"intent": "sale",
				"payer": {
					"payment_method": "paypal"
				},
				"redirect_urls": {
					"return_url":"https://"+req.get("host")+"/trolley/payment_success/"+res.locals.transactionId,
					"cancel_url":"https://"+req.get("host")+"/trolley/payment_cancel/"+res.locals.transactionId
				},
				"transactions": [{
					"item_list": {
						"items": []
					},
					"amount": {
						"currency": "GBP"
					},
					"description": "This is the payment description."
				}]
			};
			for (const track of res.locals.trolleyTracks) {
				paymentRequest.transactions[0].item_list.items.push({
					"name": track.title+" by "+track.artist,
					"sku": track.id,
					"price": track.licence ? track.licence.track_price : track.comm_licence.price,
					"currency": "GBP",
					"quantity": 1
				});
			}
			paymentRequest.transactions[0].amount.total = res.locals.total;
			paypal.payment.create(paymentRequest, (error, payment) => {
				if (error) {
					console.error(error);
					res.sendStatus(500);
				} else {
					console.log("Create Payment Response");
					db.query("UPDATE transactions SET paypal_pay_key = ?, paypal_status = 'created' WHERE transaction_id = ?", [payment.id, res.locals.transactionId]).then(() => {
						for (const link of payment.links) {
							if (link.rel === 'approval_url') {
								res.redirect(link.href);
								return;
							}
						}
						res.sendStatus(500);
					}).catch((err) => {
						deleteTransaction(res.locals.transactionId);
						console.error(err);
						res.sendStatus(500);
					});
				}
			});
		} else {
			res.sendStatus(500);
		}
	}

	async function getTransactionTotal(transactionId) {
		let result = await db.query("SELECT SUM(amount) AS `total` FROM commercial_transaction_tracks WHERE transaction_id = ?", [transactionId]);
		let total = result[0].total;
		if (!total) {
			total = 0;
		}
		result = await db.query("SELECT SUM(amount) AS `total` FROM transaction_tracks WHERE transaction_id = ?", [transactionId]);
		if (result[0].total) {
			total += result[0].total;
		}
		return total;
	}

	async function executePayment(req, res, next) {
		try {
			const transactionId = req.params[0];
			const payerId = req.query.payerID || req.query.payer_id || req.query.PayerID;
			let result = await db.query("SELECT count(*) AS `ct` FROM transactions WHERE transaction_id = ? AND paypal_status = 'approved'",[transactionId]);
			if (result[0].ct > 0) {
				next();
				return;
			}
			const total = await getTransactionTotal(transactionId);
			if (!total) {
				next();
				return;
			}
			result = await db.query("SELECT paypal_pay_key, paypal_status FROM transactions WHERE transaction_id = ?", [transactionId]);
			if (result.length == 0) {
				res.sendStatus(500);
				return;
			}
			const executeRequest = {
				"payer_id": payerId,
				"transactions":[{
					"amount": {
						"currency": "GBP",
						"total": total
					}
				}]
			};
			paypal.payment.execute(result[0].paypal_pay_key, executeRequest, function (error, payment) {
				if (error) {
					console.log(error.response);
					res.sendStatus(500);
				} else {
					console.log("Get Payment Response");
					console.log(JSON.stringify(payment));
					if (payment && payment.state) {
						const updates = ["paypal_status = ?"];
						const values = [payment.state];
						if (payment.payer && payment.payer.payer_info && payment.payer.payer_info.email) {
							updates.push("paypal_sender_email = ?");
							values.push(payment.payer.payer_info.email);
						}
						values.push(transactionId);
						const query = "UPDATE transactions SET "+updates.join(", ")+" WHERE transaction_id = ?";
						db.query(query, values).catch((err) => console.warn(err)).finally(() => {
							if (payment.state == "approved") {
								next();
							} else if (payment.state == "pending" || payment.state == "processing") {
								res.render("message", {"message":"We are still processing your payment. Please reload the page later."});
							} else {
								res.render("message", "Payment failed");
							}
						});
					} else {
						res.sendStatus(500);
					}
				}
			});
		} catch (error) {
			console.error(error)
			res.send("error",{"error":error})
		}
	}

	function formatTime(seconds) {
		return Math.floor(seconds/60)+":"+Math.round(seconds % 60);
	}

	async function getTransactionTracks(transactionId) {
		let placeholders;
		if (Array.isArray(transactionId)) {
			placeholders = new Array(transactionId.length);
			placeholders.fill('?');
		} else if (typeof(transactionId) === "string") {
			placeholders = ["?"];
			transactionId = [transactionId];
		} else {
			throw new Error(`Invalid transaction id type: ${typeof(transactionId)}`)
		}
		if (placeholders.length == 0) {
			return {"commercial":[],"nonCommercial":[]};
		}
		placeholders = placeholders.join(",");

		const nonComQuery = "SELECT \
		tracks.track_id AS `id`, \
		tracks.title, \
		tracks.artist, \
		tracks.writer, \
		tracks.duration, \
		tracks.master_recording_owner, \
		checksum, \
		tracks.file_name, \
		transaction_tracks.licence_type_id, \
		licence_types.name AS 'licence_name', \
		licence_types.description AS 'licence_description', \
		track_price, \
		transaction_tracks.transaction_id \
		FROM tracks LEFT JOIN transaction_tracks ON transaction_tracks.track_id = tracks.track_id \
		LEFT JOIN licence_types ON licence_types.id = transaction_tracks.licence_type_id \
		WHERE transaction_tracks.transaction_id IN ("+placeholders+") AND transaction_tracks.licence_type_id IS NOT NULL \
		GROUP BY concat(id,licence_type_id)";

		const comQuery = "SELECT \
		tracks.track_id AS `id`, \
		tracks.title, \
		tracks.artist, \
		tracks.writer, \
		tracks.duration, \
		tracks.master_recording_owner, \
		checksum, \
		tracks.file_name, \
		commercial_transaction_tracks.licence_id, \
		commercial_licence_categories.name AS 'comm_licence_name', \
		commercial_licence_categories.description AS 'comm_licence_description', \
		`use` AS 'comm_licence_use', \
		territory AS 'comm_licence_territory', \
		unit AS 'comm_licence_unit', \
		price AS 'comm_licence_price', \
		commercial_transaction_tracks.transaction_id, \
		commercial_transaction_tracks.first_name, \
		commercial_transaction_tracks.last_name, \
		commercial_transaction_tracks.company, \
		commercial_transaction_tracks.email, \
		commercial_transaction_tracks.website, \
		commercial_transaction_tracks.project_title \
		FROM tracks LEFT JOIN commercial_transaction_tracks ON commercial_transaction_tracks.track_id = tracks.track_id \
		LEFT JOIN commercial_licences ON commercial_licences.id = commercial_transaction_tracks.licence_id \
		LEFT JOIN commercial_licence_categories ON (commercial_licence_categories.id = commercial_licences.category) \
		WHERE commercial_transaction_tracks.transaction_id IN ("+placeholders+") \
		GROUP BY concat(tracks.track_id,licence_id,commercial_transaction_tracks.first_name,commercial_transaction_tracks.last_name,commercial_transaction_tracks.company,commercial_transaction_tracks.email,commercial_transaction_tracks.website,commercial_transaction_tracks.project_title)";

		const commercial = await db.query(comQuery, transactionId);
		commercial.forEach(element => {
			element.duration = formatTime(element.duration);
		});
		const nonCommercial = await db.query(nonComQuery, transactionId);
		const response = {};
		if (nonCommercial.length > 0) {
			response.nonCommercial = nonCommercial;
		}
		if (commercial.length > 0) {
			response.commercial = commercial;
		}
		return response;
	}

	function addTransactionTracks(transactionId, tracks) {
		if (tracks.length == 0) {
			return;
		}
		const inserts = tracks.map(track => {
			return "('"+track.track.id+"','"+transactionId+"','"+track.licence.id+"','"+track.licence.track_price+"')";
		});
		return db.query("INSERT INTO transaction_tracks (track_id, transaction_id, licence_type_id, amount) VALUES "+inserts.join(", ")).catch(onTransactionError(transactionId));
	}

	function addCommercialTransactionTracks(transactionId, tracks) {
			if (tracks.length == 0) {
				return;
			}
			const inserts = tracks.map(track => {
				return "('"+track.track.id+"','"+transactionId+"','"+track.comm_licence.id+"','"+track.comm_licence.price+"','"+track.first_name+"','"+track.last_name+"','"+track.company+"','"+track.email+"','"+track.website+"','"+track.project_title+"')";
			});
			return db.query("INSERT INTO commercial_transaction_tracks (track_id, transaction_id, licence_id, amount, first_name, last_name, company, email, website, project_title) VALUES "+inserts.join(", ")).catch(onTransactionError(transactionId));
	}

	async function insertTransaction() {
		const txId = uuid();
		await db.query("INSERT INTO transactions (transaction_id, date_created) VALUES (?, NOW())", [txId]);
		return txId;
	}

	function onTransactionError(transactionId) {
		return function(error) {
			if (error) {
				return deleteTransaction(transactionId)
			}
		}
	}

	return {
		"deleteTransaction": deleteTransaction,
		"createTransaction": async function(_req, res, next) {
			try {
				if (res.locals.trolleyTracks && res.locals.trolleyTracks.length > 0 && res.locals.total) {
					const transactionId = await insertTransaction();
					let tracks = res.locals.trolleyTracks.filter(track => {return track.hasOwnProperty("licence")});
					if (tracks.length > 0) {
						await addTransactionTracks(transactionId, tracks);
					}
					tracks = res.locals.trolleyTracks.filter(track => {return track.hasOwnProperty("comm_licence")});
					if (tracks.length > 0) {
						await addCommercialTransactionTracks(transactionId, tracks);
					}
					res.locals.transactionId = transactionId;
					next();
				} else {
					res.sendStatus(500);
				}
			} catch (error) {
				console.error(error);
				res.sendStatus(500);
			}
		},
		"executePayment": executePayment,
		"createPayment": createPayment,
		"getTransactionTracks": getTransactionTracks
	};
}