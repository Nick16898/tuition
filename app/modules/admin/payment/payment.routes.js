const { apiAdminAuth } = require("../../../middleware/apiAuth.js");
const AuthenticationController =
  new (require("./paymentController.js"))();
const authenticationValidator = require("./paymentValidator.js");
const bodyParser = require("body-parser");
var route = require("express").Router();
const fn = require("../../../helpers/string_helper.js");
const multer = require("multer");
const path = require("path");


route.use(bodyParser.json());
route.use(apiAdminAuth);
route.use(fn.decryptRequest);


route.post(`/addeditpayment`, fn.validate(authenticationValidator.addEditPayment), AuthenticationController.addEditPayment);

route.post(`/paymentlist`, AuthenticationController.paymentList);

route.delete(`/deletepayment`, fn.validate(authenticationValidator.deletePayment), AuthenticationController.deletePayment);

route.post(`/studentswithexpiringpayments`, AuthenticationController.studentsWithExpiringPayments);

module.exports = route;
