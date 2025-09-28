const Joi = require("joi");
const BaseValidator = require("../../../core/BaseValidator");

class courseValidator extends BaseValidator {
  static addEditCourse = Joi.object({
    courseId: Joi.number().optional().allow(null, ""),
    courseName: Joi.string().min(2).max(100).required(),
    description: Joi.string().max(500).optional().allow(""),
    fee: Joi.number().min(0).required(),
    duration: Joi.string().max(50).required(),
    durationType: Joi.string().valid("WEEK", "MONTH", "YEAR").required(),
  });

  static deleteCourse = Joi.object({
    courseId: Joi.number().required(),
  });
}

module.exports = courseValidator;
