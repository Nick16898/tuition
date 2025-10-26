const Joi = require("joi");
const BaseValidator = require("../../../core/BaseValidator");

class paymentValidator extends BaseValidator {
  // ✅ Add/Edit Payment
  static addEditPayment = Joi.object({
    paymentId: Joi.number().optional().allow(null, ""),
    enrollmentId: Joi.number().required(),
    userId: Joi.number().required(),
    amount: Joi.optional().allow(null, ""),
    paidAmount: Joi.optional().allow(null, ""),
    paymentMode: Joi.string().valid("CASE", "ONLINE", "UPI").default("CASE"),
    note: Joi.string().optional().allow(null, ""),
    startDate: Joi.date().optional(),
    endDate: Joi.date().optional(),
  });

  // ✅ Delete Payment
  static deletePayment = Joi.object({
    paymentId: Joi.number().required(),
  });

  // ✅ List Payments
  static paymentList = Joi.object({
    paymentId: Joi.number().optional().allow(null, ""),
    enrollmentId: Joi.number().optional().allow(null, ""),
    userId: Joi.number().optional().allow(null, ""),
    limit: Joi.number().integer().min(1).default(10),
    offset: Joi.number().integer().min(0).default(0),
    sort: Joi.string().optional().allow(null, ""),
    sortBy: Joi.string().valid("ASC", "DESC").default("DESC"),
    searchTerm: Joi.string().allow(null, "").optional(),
  });
}

module.exports = paymentValidator;
