const Joi = require("joi");

class BaseValidator {
  static delete = Joi.object({
    id: Joi.alternatives().required().try(Joi.string(), Joi.number().integer()),
  });

  static list = Joi.object({
    offset: Joi.alternatives().try(Joi.string(), Joi.number().integer()),
    limit: Joi.alternatives().try(Joi.string(), Joi.number().integer()),
    term: Joi.string().allow("", null),
    sort: Joi.string().allow("", null),
    sortBy: Joi.string().allow("", null),
  });

  static intAlternativeOptional = Joi.alternatives()
    .try(Joi.string(), Joi.number().integer())
    .allow("", null);

  static intAlternativeRequired = Joi.alternatives()
    .try(Joi.string(), Joi.number().integer())
    .required();

  static strOptional = Joi.string().allow("", null);
  static strRequired = Joi.string().required();

  static strWithMax = (maxLength = 10, isRequired = false) => {
    let schema = Joi.string().max(maxLength);
    schema = isRequired ? schema.required() : schema.allow("", null);
    return schema;
  };

  static optional = Joi.optional().allow("");

  static floatRequired = Joi.number().required();
  static intOptional = Joi.number().allow("", null);
  static intRequired = Joi.number().required();
}

module.exports = BaseValidator;
