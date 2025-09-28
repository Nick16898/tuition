const Joi = require("joi");
const BaseValidator = require("../../../core/BaseValidator");

class enrollmentValidator extends BaseValidator {
  // ✅ Add/Edit Enrollment
  static addEditEnrollment = Joi.object({
    enrollmentId: Joi.number().optional().allow(null, ""),
    courseId: Joi.number().required(),
    userId: Joi.number().required(),
    enrollmentDate: Joi.date().optional(),
    status: Joi.string()
      .valid("ACTIVE", "COMPLETED", "DROPPED")
      .default("ACTIVE"),
    enrollmentType: Joi.string()
      .valid("MONTHLY", "ANNUAL")
      .default("MONTHLY"),
    amount: Joi.optional().allow(null, ""),
  });

  // ✅ Delete Enrollment
  static deleteEnrollment = Joi.object({
    enrollmentId: Joi.number().required(),
  });

  // ✅ List Enrollments
  static enrollmentList = Joi.object({
    enrollmentId: Joi.number().optional().allow(null, ""),
    limit: Joi.number().integer().min(1).default(10),
    offset: Joi.number().integer().min(0).default(0),
    sort: Joi.string().optional().allow(null, ""),
    sortBy: Joi.string().valid("ASC", "DESC").default("DESC"),
    searchTerm: Joi.string().allow(null, "").optional(),
  });
}

module.exports = enrollmentValidator;
