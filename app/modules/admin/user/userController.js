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
const UserService = require("../../../services/UserService.js");
const SessionService = require("../../../services/SessionService.js");

const moment = require("moment");

class userController extends BaseController {
  constructor() {
    super(UserService, "user");
    /** @type {UserService} */
    this.service;
    this.sessionService = new SessionService();
  }

  //add edit user detail
  addEditStudent = async (req, res) => {
    let adminId = req.headers.adminId || "";
    let userId = req.body.userId || 0
    let fullName = req.body.fullName || ""
    let email = (req.body.email || "").toLowerCase()
    let mobileNumber = req.body.mobileNumber || ""
    let address = req.body.address || ""
    let joiningDate = req.body.joiningDate || new Date()
    let gender = req.body.gender || "OTHER"
    let cast = req.body.cast || "OTHER"
    let medium = req.body.medium || ""
    let schooling = req.body.schooling || ""
    
    try {

      if (mobileNumber) {
        // check mobile number
        let mobileExists = await this.service.findAll(qr => {
          qr.where({ mobileNumber, delete: 0 });
          if (userId) {
            qr.whereNot({ userId });
          }
          return qr;
        });

        if (mobileExists.length > 0) {
          return errorResponse(res, "Mobile number already exists");
        }
      }

      if (email) {

        // Check email
        let emailExists = await this.service.findAll(qr => {
          qr.where({ email, delete: 0 });
          if (userId) {
            qr.whereNot({ userId });
          }
          return qr;
        });

        if (emailExists.length > 0) {
          return errorResponse(res, "Email already exists");
        }
      }

      let field = {
        fullName,
        email,
        mobileNumber,
        address,
        joiningDate,
        gender,
        cast,
        medium,
        schooling,
      }
console.log('====================================');
console.log(req.files);
console.log('====================================');
      if (req.file != undefined && req.file["filename"] != undefined && req.file["filename"] != null && req.file["filename"] != "") {
        field["profilePicture"] = "user/profile/" + req.file["filename"];
      }

      if (userId) {
        field["updatedBy"] = adminId
        await this.service.updateById(userId, field)
      } else {
        field["createdBy"] = adminId
        await this.service.create(field)
      }
      return successResponse(res, userId ? "Student details updated successfully" : "Student details saved successfully");

    } catch (error) {
      console.log('====================================');
      console.log(error);
      console.log('====================================');
      // return errorResponse(res, "Something Went Wrong");
    }
  };

  // delete student
  deleteStudent = async (req, res) => {
    let userId = req.body.userId;

    try {
      let userExists = await this.service.findById(userId, qr => qr.where({ delete: 0 }));
      if (!userExists) {
        return errorResponse(res, "Student not found");
      }

      let userDetail = await this.service.updateById(userId, { delete: 1 });
      return successResponse(res, userDetail ? "Student deleted successfully" : "Student Not Found");
    } catch (error) {
      console.log(error);
      return errorResponse(res, "Something Went Wrong");
    }
  };

  // student list
  studentList = async (req, res) => {
    let userId = req.body.userId || "";

    let limit = req.body.limit || 10;
    let offset = req.body.offset || 0;
    let sort = req.body.sort || "userId";
    let sortBy = req.body.sortBy || "DESC";
    let searchTerm = (req.body.searchTerm || "").trim();

    try {

      let column = [
        "userId",
        "fullName",
        "email",
        "mobileNumber",
        "block",
        "address",
        "joiningDate",
        "gender",
        "cast",
        "medium",
        "schooling",
        "profilePicture"
      ];

      let condition = {
        condition: {
          delete: 0,
          ...(userId && { userId })
        },
        column: column,
        limit,
        offset,
        orderBy: [sort, sortBy],
        searchTerm

      }

      let data = await this.service.selectDataWithSearchAndJoin(condition)
      return successResponse(res, "List", data, true);

    } catch (error) {
      console.log(error);
      return errorResponse(res, "Something Went Wrong");
    }
  }


}

module.exports = userController;
