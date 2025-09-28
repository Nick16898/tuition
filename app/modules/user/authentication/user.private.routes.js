const bodyParser = require('body-parser');
var route = require("express").Router();
const fn = require("../../../helpers/string_helper.js");
const multer = require("multer");


route.use(bodyParser.json());
route.use(fn.decryptRequest);

// Routes
//view profile

module.exports = route;
