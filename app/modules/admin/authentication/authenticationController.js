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
const {
  getAdminByTokenOrEmail,
  checkEmail,
  checkMobileNumber,
} = require("../../../core/AdminQuery.js");
const jwt = require("jsonwebtoken");
// const { checkExistData } = require('../../../core/Query.js')
const BaseController = require("../../../core/BaseController.js");
const AdminService = require("../../../services/AdminService.js");
const SessionService = require("../../../services/SessionService.js");
const moment = require("moment");

class adminController extends BaseController {
  constructor() {
    super(AdminService, "admin");
    /** @type {AdminService} */
    this.service;
    this.sessionService = new SessionService();
  }

  //login
  login = async (req, res) => {
    let email = (req.body.email || "").toLowerCase()
    let password = req.body.password || "";

    console.log(`Attempting login for email: ${email}`);


    try {
      //check for email and password
      let adminDetail = await this.service.findByemail(email);
      if (!adminDetail) {
        return errorResponse(res, "Invalid Credentials");
      }
      console.log(adminDetail);


      //match the password
      const isMatch = await verifyPassword(password, adminDetail.password);
      if (!isMatch) {
        return errorResponse(res, "Invalid Credentials");
      }

      if (adminDetail["block"] == 1) {
        return errorResponse(res, "You Block By Admin");
      }

      const token = jwt.sign({}, process.env.TUITION_JWT_SECRET_KEY, {
        expiresIn: "1h",
      }); // generate token

      // getting session time from setting and creating session for admin
      let sessionTime = await this.service.systemSettingService.findById(
        1,
        (qb) => qb.select("value")
      );

      await this.sessionService.save({
        userId: adminDetail.adminId,
        type: "ADMIN",
        extendMinute: sessionTime?.value,
        token: token,
      });

      adminDetail["token"] = token;
      delete adminDetail["password"];
      return successResponse(res, "Login Successfully", adminDetail);
    } catch (error) {
      console.log(error);
      return errorResponse(res, "Something Went Wrong");
    }
  };

  //forget password
  forgetPassword = async (req, res) => {
    let email = (req.body.email || "").toLowerCase()
    try {
      //get the detail based on email
      let adminDetail = await this.service.findByemail(email);

      if (!adminDetail) {
        return errorResponse(res, "Email is not Registered.");
      }

      //check that is block by admin
      if (adminDetail["block"] == 1) {
        return errorResponse(res, "You Block By Admin");
      }

      //generate the otp and send to the email
      let OTP = fn.generateOTP(6);

      // await send_mail_to_user(email, "Forgot Password", OTP, "forgetPassword");

      await this.service.updateById(adminDetail["adminId"], {
        otp: JSON.stringify({
          otp: OTP,
          expireTime: moment().add(2, "minutes").utc(),
        }),
        updatedBy: adminDetail["adminId"],
      });

      const token = jwt.sign({}, process.env.TUITION_JWT_SECRET_KEY, {
        expiresIn: "1h",
      }); // generate token

      // getting session time from setting and creating session for admin
      let sessionTime = await this.service.systemSettingService.findById(
        1,
        (qb) => qb.select("value")
      );

      await this.sessionService.save({
        userId: adminDetail.adminId,
        type: "ADMIN",
        extendMinute: sessionTime?.value,
        token: token,
      });

      return successResponse(res, "OTP Send to Email Successfully", { otp: OTP });
    } catch (error) {
      console.log(error);
      return errorResponse(res, "Something Went Wrong");
    }
  };

  //verify forget password otp
  verifyOtp = async (req, res) => {
    let otp = req.body.otp || "";
    let email = (req.body.email || "").toLowerCase()

    try {
      //get detail based on token
      const adminDetail = await this.service.findByemail(email);


      if (!adminDetail) {
        return errorResponse(res, "OTP is Invalid");
      }

      let otpDetail = JSON.parse(adminDetail["otp"]) || {
        otp: "",
        expireTime: moment().subtract(5, "minutes").utc(),
      };


      //check otp expire time
      if (moment().utc().isBefore(moment(otpDetail["expireTime"]).utc())) {
        //compare otp
        if (otpDetail["otp"] == otp) {
          //set otp to blank
          await this.service.updateById(adminDetail["adminId"], {
            otp: null,
            updatedBy: adminDetail["adminId"],
          });

          // getting session time from setting and creating session for admin
          let sessionTime = await this.service.systemSettingService.findById(
            1,
            (qb) => qb.select("value")
          );

          await this.sessionService.save({
            userId: adminDetail.adminId,
            type: "ADMIN",
            extendMinute: sessionTime?.value,
            token: adminDetail["token"],
          });

          return successResponse(res, "OTP Verify Successfully.", {
            token: adminDetail["token"],
          });
        } else {
          return errorResponse(res, "OTP Is Invalid.");
        }
      } else {
        return errorResponse(res, "OTP Expired.");
      }
    } catch (error) {
      console.log(error);
      return errorResponse(res, "Something Went Wrong");
    }
  };

  //reset password
  resetPassword = async (req, res) => {
    let adminId = req.headers.adminId || "";
    let password = req.body.password || "";
    try {
      //set otp to blank
      await this.service.updateById(adminId, {
        password: await encryptPassword(password),
        updatedBy: adminId,
      });

      const token = jwt.sign({}, process.env.TUITION_JWT_SECRET_KEY, {
        expiresIn: "1h",
      }); // generate token

      // getting session time from setting and creating session for admin
      let sessionTime = await this.service.systemSettingService.findById(
        1,
        (qb) => qb.select("value")
      );

      await this.sessionService.save({
        userId: adminId,
        type: "ADMIN",
        extendMinute: sessionTime?.value,
        token: token,
      });
      return successResponse(res, "Password Reset Successfully");
    } catch (error) {
      console.log(error);
      return errorResponse(res, "Something Went Wrong");
    }
  };

  // get profile
  getProfile = async (req, res) => {
    let adminId = req.headers.adminId || "";
    try {
      const adminDetail = await getAdminByTokenOrEmail({ adminId: adminId });
      var obj = {
        fullName: adminDetail[0]["fullName"],
        email: adminDetail[0]["email"],
        countryCode: adminDetail[0]["countryCode"],
        mobileNumber: adminDetail[0]["mobileNumber"],
        profilePicture: adminDetail[0]["profilePicture"] || "",
      };
      return successResponse(res, "Profile Get Successfully", obj, true);
    } catch (error) {
      console.log(error);
      return errorResponse(res, "Something Went Wrong");
    }
  };

  // edit profile
  editProfile = async (req, res) => {
    let adminId = req.headers.adminId || "";
    let fullName = req.body.fullName || "";
    let email = req.body.email || "";
    let countryCode = req.body.countryCode || "";
    let mobileNumber = req.body.mobileNumber || "";
    try {
      // const adminDetail = await getAdminByTokenOrEmail({ adminId: adminId })
      let chkmobile = await checkMobileNumber({
        table: "admin",
        countryCode: countryCode,
        mobileNumber: mobileNumber,
        id: adminId,
      });
      let chkmail = await checkEmail({
        table: "admin",
        email: email,
        id: adminId,
      });

      if (chkmail == true) {
        return errorResponse(res, "Email Already Exist");
      }

      if (chkmobile == true) {
        return errorResponse(res, "Mobile Number Already Exist");
      }
      var obj = {
        fullName: fullName,
        email: email,
        countryCode: countryCode,
        mobileNumber: mobileNumber,
      };
      if (
        req.file != undefined &&
        req.file["filename"] != undefined &&
        req.file["filename"] != null &&
        req.file["filename"] != ""
      ) {
        obj["profilePicture"] = "admin/profile/" + req.file["filename"];
      }
      console.log(obj);
      //await this.service.update(obj, query =>query.where({adminId: adminId,delete:0}))
      await this.service.updateById(adminId, obj);

      return successResponse(res, "Profile Updated Successfully");
    } catch (error) {
      console.log(error);
      return errorResponse(res, "Something Went Wrong");
    }
  };

  // change password
  changePassword = async (req, res) => {
    let adminId = req.headers.adminId || "";
    let currentPassword = req.body.currentPassword || "";
    let newPassword = req.body.newPassword || "";

    try {
      const adminDetail = await getAdminByTokenOrEmail({ adminId: adminId });
      const isMatch = await verifyPassword(
        currentPassword,
        adminDetail[0]["password"]
      );
      if (!isMatch) {
        return errorResponse(res, "Invalid Old Password");
      }

      await this.service.updateById(adminId, {
        password: await encryptPassword(newPassword),
        updatedBy: adminId,
      });

      //await this.service.update(obj, query => query.where('adminId', adminId).andWhere('delete', 0))

      return successResponse(res, "Password Change Successfully");
    } catch (error) {
      console.log(error);
      return errorResponse(res, "Something Went Wrong");
    }
  };
}

module.exports = adminController;
