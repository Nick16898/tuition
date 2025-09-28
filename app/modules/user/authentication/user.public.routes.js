const { accessAuth } = require("../../../middleware/apiAuth.js");
const controller = new (require("./UserController.js"))();
const validator = require("./UserValidator.js");
const bodyParser = require("body-parser");
const rateLimit = require("express-rate-limit");
var route = require("express").Router();
const fn = require("../../../helpers/string_helper.js");
const multer = require("multer");
const path = require("path");

const storage = multer.diskStorage({
  destination: path.join(__dirname, "../../../media/user"),
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now();
    const ext = file.originalname.substring(
      file.originalname.lastIndexOf("."),
      file.originalname.length
    );
    cb(null, uniqueSuffix + ext);
  },
});

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
route.post(`/login`, loginLimiter,  controller.login);

//registe
route.post(`/register`, controller.userRegister);

module.exports = route;
