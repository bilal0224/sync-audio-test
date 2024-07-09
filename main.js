module.exports = function(config) {
	const express = require('express');
	const router = express.Router();
	const db = require("./database.js")(config);
	require('dotenv').config();
	const fs = require('fs');
	const md = require('jstransformer')(require('jstransformer-markdown-it'));

	const featuredArtistsQuery = "SELECT id, artist AS `name`, job FROM featured_artists WHERE priority IS NOT NULL ORDER BY priority LIMIT 3";

	async function getGenres() {
		const result = await db.query("SELECT DISTINCT genre FROM genres ORDER BY genre")
		return result.map(val => val.genre)
	}

	router.get("/", async function(_req, res) {
		let artists;
		try {
			artists = await db.query(featuredArtistsQuery);
		} catch (_error) {
			artists = []
		}
		res.render("index",{"artists":artists,"clients":["bbc", "apple", "mobo", "mtv", "target", "materialid", "t7", "dreambox"],playlist:['whats_new','energizing','uplifting','commerical','alt','cine','chill','swag']});
	});

	router.get("/mailing_list", (_req, res) => {
		res.render("mailing_list");
	});

	router.get("/rates", async (_req, res) => {
		try {
			const rates = await db.query("SELECT id, name, description, track_price FROM licence_types WHERE id != 10");
			res.render("rate_card", {"rates": rates});
		} catch (error) {
			res.render("error",{"error":error})
		}
	});

	router.get("/music", async function(_req, res) {
		try {
			const genres = await getGenres();
			const moods = (await db.query("SELECT DISTINCT mood FROM moods ORDER BY mood")).map(val => {
				return val.mood;
			});
			const styles = (await db.query("SELECT DISTINCT style FROM tracks WHERE style IS NOT NULL ORDER BY style")).map(val => {
				return val.style;
			});
			const artists = await db.query(featuredArtistsQuery);
			const result = await db.query("SELECT tracks.track_id AS `id`, checksum, title, artist, genres.genre, moods.mood, duration, priority IS NOT NULL AS `featured`, style, tempo FROM tracks LEFT OUTER JOIN featured_tracks ON (tracks.track_id = featured_tracks.track_id) LEFT OUTER JOIN genres ON genres.track_id = tracks.track_id LEFT OUTER JOIN moods ON moods.track_id = tracks.track_id WHERE accepted = 1 ORDER BY priority IS NOT NULL DESC, priority, title, artist");
			const tracks = [];
			const tempos = [];
			result.forEach(element => {
				let index = tracks.findIndex(val => {
					return val.id == element.id;
				});
				if (index == -1) {
					element.genres = [];
					element.moods = [];
					tracks.push(element);
					index = tracks.length - 1;
				}
				if (element.genre && tracks[index].genres.indexOf(element.genre) == -1) {
					tracks[index].genres.push(element.genre);
				}
				if (element.mood && tracks[index].moods.indexOf(element.mood) == -1) {
					tracks[index].moods.push(element.mood);
				}
				tracks[index].genre = tracks[index].genres.join(", ");
				tracks[index].mood = tracks[index].moods.join(", ");
				if (element.tempo && tempos.indexOf(element.tempo) == -1) {
					tempos.push(element.tempo);
				}
			});
			tempos.sort((a,b)=>{
				if (a == b) {
					return 0;
				}
				if (parseInt(a) > parseInt(b)) {
					return 1;
				}
				return -1;
			});
			const minTempo = Math.floor(tempos[0]/10)*10;
			const maxTempo = Math.ceil(tempos[tempos.length-1]/10)*10;
			const tempoBuckets = [];
			for (let i = minTempo; i<=maxTempo; i+=10) {
				for (const tempo of tempos) {
					if (tempo >= i && tempo < i+10) {
						const tempoName = i+"–"+(i+9)+" BPM";
						if (tempoBuckets.indexOf(tempoName) == -1) {
							tempoBuckets.push(tempoName);
						}
					}
				}
			}
			res.render("music",{"tracks":tracks,"artists":artists,"genres":genres,"moods":moods,"styles":styles,"tempos":tempoBuckets});
		} catch (error) {
			res.render("error",{"error":error});
		}
	});

	router.get("/artist/(*)", async function(req, res) {
		try {
			const artistId = req.params[0];
			const result = await db.query("SELECT tracks.track_id AS `id`, checksum, title, tracks.artist, genres.genre, moods.mood, duration, 1 AS `featured`, style, tempo, text FROM tracks JOIN featured_artists ON (featured_artists.artist = tracks.artist) LEFT OUTER JOIN featured_tracks ON (tracks.track_id = featured_tracks.track_id) LEFT OUTER JOIN genres ON genres.track_id = tracks.track_id LEFT OUTER JOIN moods ON moods.track_id = tracks.track_id WHERE featured_artists.id = ? AND accepted = 1 ORDER BY title", [artistId]);
			const tracks = [];
			result.forEach(element => {
				let index = tracks.findIndex(val => {
					return val.id == element.id;
				});
				if (index == -1) {
					element.genres = [];
					element.moods = [];
					tracks.push(element);
					index = tracks.length - 1;
				}
				if (element.genre && tracks[index].genres.indexOf(element.genre) == -1) {
					tracks[index].genres.push(element.genre);
				}
				if (element.mood && tracks[index].moods.indexOf(element.mood) == -1) {
					tracks[index].moods.push(element.mood);
				}
				tracks[index].genre = tracks[index].genres.join(", ");
				tracks[index].mood = tracks[index].moods.join(", ");
			});
			const text = result.length > 0 ? result[0].text : "";
			res.render("artist", {"tracks":tracks,"text":text,"id":artistId});
		} catch (error) {
			res.render("error",{"error":error});
		}
	});

	router.get("/about", function(_req, res) {
		res.render("about");
	});
	router.get("/contact", function(_req, res) {
		res.render("contact");
	});
	router.get("/site_use_disclaimer", function(_req, res) {
		res.render("site_use_disclaimer");
	});
	router.get("/privacy_policy", function(_req, res) {
		res.render("privacy_policy");
	});
	router.get("/purchase_policy", function(_req, res) {
		res.render("purchase_policy");
	});
	router.get("/copyright", function(_req, res) {
		res.render("copyright");
	});
	router.get("/submissions", (_req, res) => {
		res.render("submissions");
	});
	router.get("/submissions/faq", (_req, res) => {
		res.render("submissions_faq");
	});
	router.get("/submissions/payment_policy", (_req, res) => {
		res.render("artist_payment_policy");
	});
	router.get("/print_licence/(*)", async (req, res) => {
		try {
			const result = await db.query("SELECT id, name FROM licence_types WHERE id = ?", [req.params[0]]);
			if (result.length == 0) {
				res.render("error");
				return;
			}
			const buffer = await fs.promises.readFile("views/licence/generic.md");
			const text = buffer.toString("utf8").replace("___name___", result[0].name);
			const html = md.render(text).body
			res.render("licence_tnc", {"text":html,"print":true});
		} catch (error) {
			res.render("error",{"error":error});
		}
	});
	router.get("/print_com_licence/(*)", async (req, res) => {
		try {
			const result = await db.query("SELECT cl.id, clc.name, clc.description, cl.`use`, cl.territory FROM commercial_licences AS `cl` LEFT JOIN commercial_licence_categories AS `clc` ON clc.id = cl.category WHERE cl.id = ?", [req.params[0]]);
			if (result.length == 0) {
				res.render("error");
				return;
			}
			res.render("com_licence_tnc", {"licence":result[0],"print":true});
		} catch (error) {
			res.render("error",{"error":error});
		}
	});

	return router
}