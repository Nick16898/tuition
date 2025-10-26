const Joi = require("joi");
const BaseValidator = require("../../../core/BaseValidator");

class userValidator extends BaseValidator {
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

  static addEditStudent = Joi.object({
    userId: Joi.number().optional().allow(null, ""),
    fullName: Joi.string().min(2).max(100).required(),
    email: Joi.string().email().required(),
    mobileNumber: Joi.string().pattern(/^[0-9]{10,15}$/).required(),
    address: Joi.string().max(255).optional(),
    joiningDate: Joi.date().optional(),
    profilePicthre: this.strOptional,
    medium: this.strOptional,
    gender: Joi.valid("MALE", "FEMALE", "OTHER").required(),
    cast: Joi.valid("SC", "ST", "OBC", "GENERAL", "OTHER").required(),
    schooling: this.strOptional,
  });

  static deleteStudent = Joi.object({
    userId: Joi.number().required(),
  });
}

module.exports = userValidator;
