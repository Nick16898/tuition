const Joi = require("joi");
const BaseValidator = require("../../../core/BaseValidator");

class AdminValidator extends BaseValidator {
  //verify email
  static verifyEmail = Joi.object({
    otp: this.strRequired,
    email: this.strRequired,
  });

  //forget password
  static forgetPassword = Joi.object({
    email: this.strRequired,
  });

  //verify email
  static resetPassword = Joi.object({
    adminId: this.intAlternativeOptional,
    password: this.strRequired,
  });

  static login = Joi.object({
    email: this.strRequired,
    password: this.strRequired,
  });

  static editProfile = Joi.object({
    fullName: this.strRequired,
    email: this.strRequired,
    countryCode: this.strRequired,
    mobileNumber: this.strRequired,
    profilePicthre: this.strOptional,
  });
  static changePassword = Joi.object({
    currentPassword: this.strRequired,
    newPassword: this.strRequired,
  });
}

module.exports = AdminValidator;
