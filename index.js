const express = require('express');
const bodyParser = require('body-parser');
const cookieParser = require('cookie-parser');
const config = require("./config.js");
const mysql = require("mysql2");
const protobuf = require("protobufjs");
config.database.waitForConnections = true;
config.database.connectionLimit = 10;
config.database.queueLimit = 0;
config.database.pool = mysql.createPool(config.database);
const paypalLogin = require("./paypal_login.js")(config);
require('dotenv').config();

const app = express();
app.set('view engine', 'pug');
app.use((_req,res,next) => {
	res.locals.year = new Date().getFullYear();
	next();
});
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended:true}));
app.use(cookieParser());
app.use(express.static("static"));
app.use("/proto", express.static("proto"));
app.enable('trust proxy');
app.set('trust proxy','loopback');

app.use(async function(req, res, next) {
	if (typeof(req.cookies.trolley) === "string") {
		res.locals.trolley = JSON.parse(req.cookies.trolley);
	}
	if (typeof(req.cookies.shortlists) === "string") {
		const root = await protobuf.load("proto/shortlist.proto");
		const Shortlist = root.lookupType("syncaudio.Shortlist");
		const shortlists = JSON.parse(req.cookies.shortlists).map(item => {
			const msg = Shortlist.decode(Buffer.from(item, "base64"));
			const obj = Shortlist.toObject(msg);
			obj.encoded = item;
			return obj;
		});
		res.locals.shortlists = shortlists;
	}
	if (req.cookies.paypal_access_token) {
		res.locals.paypalAccessToken = req.cookies.paypal_access_token;
	}
	next();
});

const admin = require('./admin.js')(config, paypalLogin);
const main = require('./main.js')(config);
const trolley = require("./trolley.js")(config);
const user = require("./user.js")(config, paypalLogin);
const shortlist = require("./shortlist.js")(config, paypalLogin);
app.use("/", main);
app.use("/trolley", trolley);
app.use("/admin", admin);
app.use("/account", user);
app.use("/shortlist", shortlist);

try {
	app.listen(config.port, () => {
		console.log(`Server listening on port ${config.port}`)
	});
} catch (error) {
	console.log("Error starting server: ", error);
}