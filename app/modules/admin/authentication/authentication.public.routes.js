const { accessAuth } = require("../../../middleware/apiAuth.js");
const controller = new (require("./authenticationController.js"))();
const validator = require("./authenticationValidator.js");
const bodyParser = require("body-parser");
const rateLimit = require("express-rate-limit");
var route = require("express").Router();
const fn = require("../../../helpers/string_helper.js");

const loginLimiter = rateLimit({
  windowMs: 20 * 60 * 1000, // 20 minutes
  max: 100,
  statusCode: 200,
  message: {
    message:
      "Too many login attempts from this IP, please try again after 20 minutes",
  },
});

route.use(bodyParser.json());
route.use(fn.decryptRequest);
route.use(accessAuth);

// Routes

// login
route.post("/login", loginLimiter, fn.validate(validator.login), controller.login);

//forget password
route.post("/forgetpassword", fn.validate(validator.forgetPassword), controller.forgetPassword);

//verify forget password otp
route.post("/verifyotp", fn.validate(validator.verifyEmail), controller.verifyOtp);

module.exports = route;
