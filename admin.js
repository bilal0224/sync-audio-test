module.exports = function(config, paypalLogin) {
	const express = require('express');
	const router = express.Router();
	const db = require('./database.js')(config);
	const fs = require('fs');
	const multer = require('multer');
	const upload = require('./upload.js')(config);
	const multerUpload = multer({"dest":"./tmp/"});
	require('dotenv').config();
	const mailgun = require('mailgun-js')({"apiKey": config.mailgun.api_key, "domain": "sync-audio.com"});
	const url = require("url")
	const baseURL = "https://"+url.parse(config.paypal_sdk.return_url).host

	function adminLogin(_req, res, next) {
		if (res.locals.isAdminUser) {
			next();
		} else {
			res.render("error", {"error": "Access denied"});
		}
	}

	function onArtists(resolve, reject) {
		return function(error, artists) {
			if (error) {
				return reject(error);
			} else {
				return resolve(artists.map(element => { return element.artist; }));
			}
		}
	}

	async function getFeaturedArtists() {
		const q = "SELECT artist FROM featured_artists ORDER BY artist";
		const result = await db.query(q)
		return result.map(entry => entry.artist)
	}

	async function getArtists(exclude) {
		let q = "SELECT DISTINCT artist FROM tracks ";
		if (exclude && exclude.length > 0) {
			const placeholders = new Array(exclude.length);
			placeholders.fill('?');
			q += "WHERE artist NOT IN ("+placeholders.join(", ")+") ";
		} else {
			exclude = [];
		}
		q += "ORDER BY artist";
		const result = await db.query(q, exclude)
		return result.map(entry => entry.artist)
	}

	async function renderArtistTracks(req, res) {
		try {
			const artist = req.params[0];
			const status = req.params[1] || req.params[2] || req.params[3];
			let qParams = "1";
			if (status == "accepted") {
				qParams = "accepted = 1";
			} else if (status == "rejected") {
				qParams = "accepted = 0 AND reviewed = 1";
			} else if (status == "pending") {
				qParams = "reviewed = 0";
			}
			const tracks = await db.query("SELECT track_id AS `id`, checksum, title, DATE_FORMAT(date_added, '%e %b %Y') AS `date_added`, commercial_licence_only FROM tracks WHERE email = ? AND "+qParams, [artist]);
			res.render("admin/artist_tracks", {"artist":artist, "tracks":tracks, "status": status});
		} catch (error) {
			renderError(res)(error)
		}
	}

	function renderError(res) {
		return function(error) {
			res.render("error",{"error":error});
		}
	}

	router.post("/artist/(*)/((accepted)|(rejected)|(pending))", (req,res,next) => {
		res.locals.redirectUrl = baseURL+req.originalUrl;
		next();
	}, paypalLogin.login, adminLogin, async (req, _res, next) => {
		try {
			const trackIds = req.body.commercial_only;
			const artist = req.params[0];
			const status = req.params[1] || req.params[2] || req.params[3];
			let qParams = "1";
			if (status == "accepted") {
				qParams = "accepted = 1";
			} else if (status == "rejected") {
				qParams = "accepted = 0 AND reviewed = 1";
			} else if (status == "pending") {
				qParams = "reviewed = 0";
			}
			await db.query("UPDATE tracks SET commercial_licence_only = 0 WHERE email = ? AND "+qParams, [artist])
			if (trackIds && trackIds.length > 0) {
				const placeholders = new Array(trackIds.length);
				placeholders.fill("?");
				await db.query("UPDATE tracks SET commercial_licence_only = 1 WHERE track_id IN ("+placeholders.join(",")+")", trackIds);
				next();
			} else {
				next();
			}
		} catch (_error) {
			next();
		}
	}, renderArtistTracks);

	router.get("/artist/(*)/((accepted)|(rejected)|(pending))", (req,res,next) => {
		res.locals.redirectUrl = baseURL+req.originalUrl;
		next();
	}, paypalLogin.login, adminLogin, renderArtistTracks);

	router.get("/artist", paypalLogin.login, adminLogin, async (_req, res) => {
		try {
			const featured = await getFeaturedArtists();
			const artists = await getArtists(featured);
			res.render("admin/artist", {"artists":artists});
		} catch (error) {
			renderError(res)(error)
		}
	});

	router.get("/artist/(*)/delete", paypalLogin.login, adminLogin, async (req, res) => {
		try {
			await db.query("DELETE FROM featured_artists WHERE id = ?", [req.params[0]]);
			res.redirect("/admin/featured_artists");
		} catch (error) {
			renderError(res)(error)
		}
	});

	router.get("/artist/(*)", paypalLogin.login, adminLogin, async (req, res) => {
		try {
			const artists = await db.query("SELECT id, artist, job, text FROM featured_artists WHERE id = ?",[req.params[0]]);
			if (artists.length == 0) {
				res.sendStatus(404);
				return;
			}
			const featured = await getFeaturedArtists();
			const idx = featured.indexOf(artists[0].artist);
			if (idx > -1) {
				featured.splice(idx, 1);
			}
			const allArtists = await getArtists(featured);
			res.render("admin/artist", {"artist": artists[0], "artists": allArtists});
		} catch (error) {
			renderError(res)(error)
		}
	});

	router.post("/artist", multerUpload.single("image"), paypalLogin.login, adminLogin, async (req, res, next) => {
		try {
			if (req.body.id) {
				res.locals.artistId = req.body.id;
				await db.query("UPDATE featured_artists SET artist = ?, job = ?, text = ? WHERE id = ?", [req.body.artist, req.body.job, req.body.text, req.body.id]);
				next();
			} else if (req.file) {
				const result = await db.query("SELECT max(priority) AS `priority` FROM featured_artists");
				let priority = 1;
				if (result.priority != null) {
					priority = result.priority + 1;
				}
				if (priority > 3) {
					priority = null;
				}
				const insert = await db.query("INSERT INTO featured_artists (artist, job, text, priority) VALUES (?,?,?)", [req.body.artist, req.body.job, req.body.text, priority]);
				res.locals.artistId = insert.insertId;
				next();
			} else {
				res.render("error",{"error":"You must upload a picture"});
			}
		} catch (error) {
			renderError(res)(error)
		}
	}, upload.uploadArtistImage, (_req, res) => {
		res.redirect("/admin/featured_artists");
	});

	router.get("/featured_artists", paypalLogin.login, adminLogin, async function(_req, res) {
		try {
			const artists = await db.query("SELECT id, artist, job, text, priority FROM featured_artists ORDER BY priority IS NOT NULL DESC, priority");
			const featured = artists.filter(artist => {
				return artist.priority;
			});
			const overflow = featured.splice(3);
			const other = artists.filter(artist => {
				return !artist.priority;
			});
			overflow.forEach(element => {
				other.unshift(element);
			});
			res.render("admin/featured_artists", {"featured": featured, "other": other});
		} catch (error) {
			renderError(res)(error)
		}
	});

	router.post("/featured_artists", paypalLogin.login, adminLogin, async function(req, res) {
		try {
			const ids = req.body.featured_artists.map(artist => {
				return artist.id;
			});
			await db.query("UPDATE featured_artists SET priority = NULL WHERE id NOT IN ("+ids.join(",")+")");
			await Promise.all(req.body.featured_artists.map(element => db.query("UPDATE featured_artists SET priority = ? WHERE id = ?", [element.priority, element.id])))
			res.sendStatus(200);
		} catch (error) {
			console.error(error);
			res.sendStatus(500);
		}
	});

	router.get("/featured_tracks", paypalLogin.login, adminLogin, async function(_req, res) {
		try {
			const tracks = await db.query("SELECT tracks.track_id AS `id`, title, artist, priority FROM tracks LEFT JOIN featured_tracks ON featured_tracks.track_id = tracks.track_id WHERE accepted = 1 ORDER BY priority IS NOT NULL DESC, priority");
			const featured = tracks.filter((track) => {
				return track.priority;
			});
			const other = tracks.filter((track) => {
				return !track.priority;
			});
			res.render("admin/featured_tracks", {"featured": featured, "other": other});
		} catch (error) {
			renderError(res)(error)
		}
	});

	router.post("/featured_tracks", paypalLogin.login, adminLogin, async (req, res) => {
		try {
			await db.query("DELETE FROM featured_tracks");
			const values = req.body.featured_tracks.map((val) => {
				return "("+val.id+", "+val.priority+")";
			}).join(",");
			await db.query("INSERT INTO featured_tracks (track_id, priority) VALUES "+values);
			res.sendStatus(200);
		} catch (error) {
			console.error(error);
			res.sendStatus(500);
		}
	});

	router.get("/tracks", paypalLogin.login, adminLogin, async function(_req, res) {
		try {
			const tracks = await db.query("SELECT track_id AS `id`, title, artist, accepted, reviewed FROM tracks ORDER BY reviewed, accepted DESC, title, artist");
			const unreviewed = tracks.filter(track => { return !track.reviewed; });
			const accepted = tracks.filter(track => { return track.reviewed && track.accepted; });
			const rejected = tracks.filter(track => { return track.reviewed && !track.accepted; });
			const moods = require("./moods.json");
			const genres = require("./genres.json");
			res.render("admin/tracks.pug", {
				"unreviewed": unreviewed,
				"accepted": accepted,
				"rejected": rejected,
				"moods": moods,
				"genres": genres
			});
		} catch (error) {
			renderError(res)(error)
		}
	});

	router.get("/tracks/(*)/delete", paypalLogin.login, adminLogin, async function(req, res) {
		try {
			const id = req.params[0];
			const tracks = await db.query("SELECT title, artist, checksum FROM tracks WHERE track_id = ?", [id]);
			if (tracks.length == 0) {
				res.sendStatus(404);
				return;
			}
			const track = tracks[0];
			await db.query("DELETE FROM tracks WHERE track_id = ?", [id]);
			try {
				await Promise.all([
					fs.promises.unlink('./static/tracks/'+track.checksum+'.wav'),
					fs.promises.unlink('./static/tracks/'+track.checksum+'.mp3'),
					fs.promises.unlink('./static/images/waveforms/'+track.checksum+'-gray.png'),
					fs.promises.unlink('./static/images/waveforms/'+track.checksum+'-blue.png')
				])
			} catch (err) {
				console.warn(err)
			} finally {
				res.render("admin/track_deleted");
			}
		} catch (error) {
			renderError(res)(error)
		}
	});

	router.get("/tracks/(*)", paypalLogin.login, adminLogin, async function(req, res) {
		try {
			const id = req.params[0];
			const tracks = await db.query("SELECT tracks.track_id AS `id`, checksum, title, artist, genres.genre, moods.mood, writer, duration, tempo, accepted, reviewed, cae_number, master_recording_owner, tracks.date_added, tracks.date_reviewed FROM tracks LEFT OUTER JOIN genres ON tracks.track_id = genres.track_id LEFT OUTER JOIN moods ON moods.track_id = tracks.track_id WHERE tracks.track_id = ?", [id]);
			if (tracks.length == 0) {
				res.sendStatus(404);
				return;
			}
			const moods = require("./moods.json");
			const genres = require("./genres.json");
			const track = tracks[0];
			track.genres = [];
			track.moods = [];
			tracks.forEach(element => {
				if (element.genre && track.genres.indexOf(element.genre) == -1) {
					track.genres.push(element.genre);
				}
				if (element.mood && track.moods.indexOf(element.mood) == -1) {
					track.moods.push(element.mood);
				}
			});
			delete track.genre;
			delete track.mood;
			res.render("admin/track",{"track":track, "genres": genres, "moods": moods});
		} catch (error) {
			renderError(res)(error)
		}
	});
	router.post("/tracks/(*)", paypalLogin.login, adminLogin, async function(req, res) {
		try {
			const id = req.params[0];
			const track = req.body;
			if (track.accepted == "-1") {
				track.reviewed = 0;
				track.accepted = 0;
			} else {
				track.reviewed = 1;
			}
			let existingTrack = await db.query("SELECT email, accepted FROM tracks WHERE track_id = ?", [id]);
			if (existingTrack.length == 0) {
				res.status(404).send(`Track ${id} not found`)
				return
			}
			existingTrack = existingTrack[0]
			await db.query("UPDATE tracks SET title = ?, artist = ?, writer = ?, tempo = ?, accepted = ?, reviewed = ?, style = ? WHERE track_id = ?", [track.title, track.artist, track.writer, track.tempo, track.accepted, track.reviewed, track.style, id]);
			await db.query("DELETE FROM moods WHERE track_id = ?", [id]);
			if (track.mood && track.mood.length > 0) {
				const values = new Array(track.mood.length);
				values.fill("(?,?)");
				const args = [];
				track.mood.forEach(mood => {
					args.push(mood);
					args.push(id);
				});
				await db.query("INSERT INTO moods (mood, track_id) VALUES "+values.join(", "), args);
			}
			await db.query("DELETE FROM genres WHERE track_id = ?", [id]);
			if (track.genres && track.genres.length > 0) {
				const values = new Array(track.genres.length);
				values.fill("(?,?)");
				const args = [];
				track.genres.forEach(genre => {
					args.push(genre);
					args.push(id);
				});
				await db.query("INSERT INTO genres (genre, track_id) VALUES "+values.join(", "), args);
			}
			if (track.reviewed == 1 && track.accepted != existingTrack.accepted && existingTrack.email && existingTrack.email != res.locals.paypalUserInfo.email) {
				const message = {
					"from": "Sync-Audio <no-reply@sync-audio.com>",
					"to": existingTrack.email,
					"subject": "Track reviewed"
				};
				if (track.accepted) {
					message.text = "Congratulations. Your track "+track.title+" has been published by Sync-Audio. Let the good times roll.\nBest wishes,\nSync-Audio team";
				} else {
					message.text = "Due to a large volume of recent submissions we were unable to accept your track "+track.title+" for publication on Sync-Audio. Please do not let this discourage you to upload more tracks. Thank you for sharing your music.";
				}
				mailgun.messages().send(message).catch(err => {
					console.error("Failed to send a track review result notification to "+existingTrack.email, err)
				});
			}
			res.render("admin/track_saved", {"track":track});
		} catch (error) {
			renderError(res)(error)
		}
	});
	router.get("/artists", (req,res,next) => {
		res.locals.redirectUrl = baseURL+req.originalUrl;
		next();
	}, paypalLogin.login, adminLogin, async (_req, res) => {
		try {
			const result = await db.query("SELECT email, count(*) as `all`, sum(accepted) as `accepted`, count(*)-sum(reviewed) as `pending` FROM tracks WHERE email IS NOT NULL GROUP BY email ORDER BY email");
			result.forEach((val)=>{
				val.rejected = val.all - val.accepted - val.pending;
			});
			res.render("admin/artists", {"artists":result});
		} catch (err) {
			renderError(res)(err)
		}
	});

	router.get("/commercial_licensees", (req,res,next) => {
		res.locals.redirectUrl = baseURL+req.originalUrl;
		next();
	}, paypalLogin.login, adminLogin, async (req, res) => {
		try {
			if (req.query.email && req.query.first_name && req.query.last_name) {
				const result = await db.query("SELECT DATE_FORMAT(tx.date_created, '%D %M %Y %H:%i:%s') AS `date_created`, tx.paypal_status, t.title, t.artist, ctt.company, ctt.website, ctt.project_title, cl.use, cl.territory, clc.name, clc.description FROM commercial_transaction_tracks AS `ctt` JOIN tracks AS `t` ON (ctt.track_id = t.track_id) JOIN commercial_licences AS `cl` ON (cl.id = ctt.licence_id) JOIN commercial_licence_categories AS `clc` ON (clc.id = cl.category) JOIN transactions AS `tx` ON (tx.transaction_id = ctt.transaction_id) WHERE ctt.first_name = ? AND ctt.last_name = ? AND ctt.email = ? ORDER BY tx.date_created DESC", [req.query.first_name, req.query.last_name, req.query.email]);
				res.render("admin/licensee_tracks", {"tracks":result, "first_name":req.query.first_name, "last_name":req.query.last_name, "email":req.query.email});
			} else {
				const result = await db.query("SELECT DISTINCT first_name, last_name, email FROM commercial_transaction_tracks ORDER BY email");
				res.render("admin/commercial_licensees", {"licensees":result});
			}
		} catch (error) {
			renderError(res)(error)
		}
	});

	router.get("/", (req,res,next) => {
		res.locals.redirectUrl = baseURL+req.originalUrl
		next();
	}, paypalLogin.login, adminLogin, (_req, res) => {
		res.render("admin/index");
	});

	return router
}
