
"use strict";
const config = require("./config.js");
const paypal = require("paypal-rest-sdk");
require('dotenv').config();
paypal.configure(config.paypal_sdk);
const db = require("./database.js")(config);

async function addPayout(payouts, payoutJson, emails, payoutIndex) {
	if (payoutIndex < emails.length) {
		try {
			const result = await db.query("INSERT INTO artist_payout (time_created) VALUES (now())");
			const email = emails[payoutIndex];
			const itemId = result.insertId;
			payoutJson.items.push({
				"recipient_type": "EMAIL",
				"amount": {
					"value": payouts[email].total,
					"currency": "GBP"
				},
				"receiver": email,
				"sender_item_id": ""+itemId
			});
			const inPlaceholders = new Array(payouts[email].tracks.length);
			inPlaceholders.fill("?");
			const where = [itemId];
			payouts[email].tracks.forEach(track => {
				where.push(""+track.identifier);
			});
			await db.query("UPDATE transaction_tracks SET sender_item_id = ? WHERE CONCAT(track_id,transaction_id) IN ("+inPlaceholders.join(",")+")", where);
			await addPayout(payouts, payoutJson, emails, payoutIndex+1);
		} catch (error) {
			console.error(error);
			process.exit(1)
		}
	} else {
		paypal.payout.create(payoutJson, (error, payout) => {
			if (error) {
				console.log(error.response);
				process.exit(1);
			} else {
				console.log("Create Payout Response");
				console.log(JSON.stringify(payout));
				if (payout.batch_header.batch_status == "SUCCESS") {
					processPayoutResponse(payout);
				} else if (payout.batch_header.batch_status != "DENIED") {
					setTimeout(function(){
						queryPayout(payout.batch_header.payout_batch_id);
					}, 5000);
				} else {
					process.exit(1);
				}
			}
		});
	}
}

async function updatePayout(payout, itemIndex) {
	if (itemIndex < payout.items.length) {
		const item = payout.items[itemIndex];
		const queryParams = [
			item.transaction_status,
			item.payout_item.amount.value,
			item.payout_item.amount.currency,
			item.payout_item.receiver,
			item.payout_item_fee.value,
			item.payout_item_fee.currency,
			item.payout_item.sender_item_id
		];
		await db.query("UPDATE artist_payout SET transaction_status = ?, amount = ?, currency = ?, receiver = ?, payout_item_fee = ?, fee_currency = ? WHERE sender_item_id = ?", queryParams);
		await updatePayout(itemIndex + 1);
	} else {
		if (payout.batch_header.batch_status == "SUCCESS") {
			process.exit();
		} else if (payout.batch_header.batch_status == "DENIED") {
			process.exit(1);
		} else {
			setTimeout(function(){
				queryPayout(payout.batch_header.payout_batch_id);
			}, 5000);
		}
	}
}

async function sendPayout() {
	try {
		const query = "select tracks.email, amount, transaction_tracks.track_id, transaction_tracks.transaction_id, tracks.title, tracks.artist, sender_item_id from transaction_tracks join transactions on transactions.transaction_id = transaction_tracks.transaction_id join tracks on tracks.track_id = transaction_tracks.track_id where sender_item_id is null AND email is not null";
		const result = await db.query(query);
		if (result.length > 0) {
			const payouts = {};
			result.forEach(element => {
				if (!payouts[element.email]) {
					payouts[element.email] = {"total":0,"tracks":[]};
				}
				const track = {
					"amount": parseFloat(element.amount) * 0.5,
					"id": element.track_id,
					"title": element.title,
					"artist": element.artist,
					"identifier": ""+element.track_id+element.transaction_id
				};
				payouts[element.email].total += track.amount;
				payouts[element.email].tracks.push(track);
			});
			const senderBatchId = Math.random().toString(36).substring(9);
			const payoutJson = {
				"sender_batch_header": {
					"sender_batch_id": senderBatchId,
					"email_subject": "You have a payment"
				},
				"items": []
			};
			const emails = Object.keys(payouts);
			await addPayout(payouts, payoutJson, emails, 0);
		} else {
			process.exit(1);
		}
	} catch (error) {
		console.error(error);
		process.exit(1);
	}
}

function queryPayout(payoutId) {
	paypal.payout.get(payoutId, function (error, payout) {
		if (error) {
			console.log(error);
			process.exit(1);
		} else {
			console.log("Get Payout Response");
			console.log(JSON.stringify(payout));
			processPayoutResponse(payout);
		}
	});
}

function processPayoutResponse(payout) {
	if (payout.items && payout.items.length > 0) {
		updatePayout(payout, 0);
	}
}

sendPayout().then(() => console.log("Artists paid out")).catch(error => console.error("Artist payout failed: ", error));