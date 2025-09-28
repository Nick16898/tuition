const {
  errorResponse,
  successResponse,
} = require("../../../helpers/string_helper.js");
const {
  encryptPassword,
  verifyPassword,
} = require("../../../helpers/encryptdecrypt_helper.js");
const { send_mail_to_user } = require("../../../helpers/mail.js");

const fn = require("../../../helpers/string_helper.js");
const jwt = require("jsonwebtoken");
const BaseController = require("../../../core/BaseController.js");
const UserService = require("../../../services/UserService.js");
const moment = require("moment");

/*global process*/

class userController extends BaseController {
  constructor() {
    super(UserService, "user");
    /** @type {UserService} */
    this.service;

    this.sessionService =
      new (require("../../../services/SessionService.js"))();
    this.UserService = new (require("../../../services/UserService.js"))();
  }

  //provider register (provider)
  userRegister = async (req, res) => {
    let fullName = req.body.fullName || "";
    let userName = req.body.userName || "";
    let email = req.body.email || "";
    let mobileNumber = req.body.mobileNumber || "";
    let countryCode = req.body.countryCode || "";
    let password = req.body.password || "";

    try {
      //register
      let register = await this.service.create({ fullName, userName, email, mobileNumber, password: await encryptPassword(password), ...(countryCode && { countryCode: countryCode }) });

      //generate jwt token
      let token = jwt.sign({}, process.env.TUITION_JWT_SECRET_KEY, {
        expiresIn: "1h",
      });

      //gettin session time form systemsetting and generate session
      let sessionTime = await this.service.systemSettingService.findById(
        1,
        (query) => query.select("value")
      );
      this.sessionService.save({
        userId: register.userId,
        type: "USER",
        extendMinute: sessionTime?.value,
        token: token,
      });

      return successResponse(res, "User Register Successfully", {
        token: token,
      });
    } catch (error) {
      console.log(error);
      return errorResponse(res, "Something Went Wrong");
    }
  };

  login = async (req, res) => {
    let loginField = req.body.loginField || "";
    let password = req.body.password || "";
    try {

      let data = await this.service.findAll(qr => qr.where(qr=>qr.orWhere({ userName: loginField, email: loginField, mobileNumber: loginField })))
      if (data.length == 0) {
        return errorResponse(res, "Invalid Credentials");
      }

      const isMatch = await verifyPassword(password, data[0].password);
      if (!isMatch) {
        return errorResponse(res, "Invalid Credentials");
      }
      if (data[0]["block"] == 1) {
        return errorResponse(res, "You Block By Admin");
      }

      //generate jwt token
      let token = jwt.sign({}, process.env.TUITION_JWT_SECRET_KEY, {
        expiresIn: "1h",
      });
      //getting session time from setting and creating session for user
      let sessionTime = await this.service.systemSettingService.findById(
        1,
        (query) => query.select("value")
      );
      await this.sessionService.save({
        userId: data[0].userId,
        type: "USER",
        extendMinute: sessionTime?.value,
        token: token,
      });
      data[0]["token"] = token;
      delete data[0]["password"];
      return successResponse(res, "Login Successfully", data[0]);

    } catch (error) {
      console.log(error);
      return errorResponse(res, "Something Went Wrong");
    }
  }

}

module.exports = userController;
