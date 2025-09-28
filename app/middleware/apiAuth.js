const { errorResponse } = require("../helpers/string_helper.js");
const { checkToken, checkAdminToken } = require("../core/Query.js");
/*global process*/

const apiAuth = async (req, res, next) => {
  if (!(req.headers && req.headers["x-token"])) {
    return errorResponse(res, "Token is not provided");
  }
  const token = req.headers["x-token"];
  try {
    let admin = await checkToken({ token: token });
    if (admin.length == 0) {
      return res.send({
        status: 401,
        message: "Session expired. Please log in again.",
        success: false,
      });
    } else {
      req.headers["adminId"] = admin[0]["adminId"];
      return next();
    }
  } catch (error) {
    return errorResponse(
      res,
      "Incorrect token is provided, try re-login",
      error
    );
  }
};

const accessAuth = async (req, res, next) => {
  if (!(req.headers && req.headers["x-authorization"])) {
    return errorResponse(res, "Token is not provided");
  }
  const token = req.headers["x-authorization"];
  try {
    if (token == process.env.TUITION_PUBLIC_API_TOKEN) {
      return next();
    }
    return errorResponse(res, "Access denied");
  } catch (error) {
    return errorResponse(
      res,
      "Incorrect token is provided, try re-login",
      error
    );
  }
};

const adminAccessAuth = async (req, res, next) => {
  if (!(req.headers && req.headers["x-authorization"])) {
    return errorResponse(res, "Token is not provided");
  }
  const token = req.headers["x-authorization"];
  try {
    if (token == process.env.TUITION_PUBLIC_API_TOKEN) {
      return next();
    }
    return errorResponse(res, "Access denied");
  } catch (error) {
    return errorResponse(
      res,
      "Incorrect token is provided, try re-login",
      error
    );
  }
};

const apiAdminAuth = async (req, res, next) => {
  if (!(req.headers && req.headers["x-token"])) {
    return errorResponse(res, "Token is not provided");
  }

  const token = req.headers["x-token"];
  try {
    let admin = await checkAdminToken({ token: token });
    if (admin.length == 0) {
      return res.send({
        status: 401,
        message: "Session expired. Please log in again.",
        success: false,
      });
    } else {
      req.headers["adminId"] = admin[0]["adminId"];
      return next();
    }
  } catch (error) {
    return errorResponse(
      res,
      "Incorrect token is provided, try re-login",
      error
    );
  }
};

module.exports = {
  apiAuth,
  accessAuth,
  apiAdminAuth,
  adminAccessAuth,
};
