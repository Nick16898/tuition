const { apiAdminAuth } = require("../../../middleware/apiAuth.js");
const AuthenticationController =
  new (require("./enrollmentController.js"))();
const authenticationValidator = require("./enrollmentValidator.js");
const bodyParser = require("body-parser");
var route = require("express").Router();
const fn = require("../../../helpers/string_helper.js");
const multer = require("multer");
const path = require("path");


route.use(bodyParser.json());
route.use(apiAdminAuth);
route.use(fn.decryptRequest);


route.post(`/addeditenrollment`, fn.validate(authenticationValidator.addEditEnrollment), AuthenticationController.addEditEnrollment);

route.post(`/enrollmentlist`, AuthenticationController.enrollmentList);

route.delete(`/deleteenrollment`, fn.validate(authenticationValidator.deleteEnrollment), AuthenticationController.deleteEnrollment);

module.exports = route;
