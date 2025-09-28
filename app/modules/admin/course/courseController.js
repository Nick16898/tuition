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
const CourseService = require("../../../services/CourseService.js");

const moment = require("moment");

class courseController extends BaseController {
  constructor() {
    super(CourseService, "course");
    /** @type {CourseService} */
    this.service;
  }

  //add edit course detail
  addEditCourse = async (req, res) => {
    let adminId = req.headers.adminId || "";
    let courseId = req.body.courseId || 0
    let courseName = req.body.courseName || ""
    let description = req.body.description || ""
    let fee = req.body.fee || 0
    let duration = req.body.duration || ""
    let durationType = req.body.durationType || ""
    try {
      // get course on course name
      let courseExists = await this.service.findAll(qr => {
        qr.where({ courseName, delete: 0 });
        if (courseId) {
          qr.whereNot({ courseId });
        }
        return qr;
      });

      if (courseExists.length > 0) {
        return errorResponse(res, "Course already exists");
      }
      let courseData = {
        courseName,
        description,
        fee,
        duration,
        durationType,
      }
      if (courseId) {
        courseData["updatedBy"] = adminId
        await this.service.update(courseData, qr =>qr.where({courseId}))
        return successResponse(res, "Course updated successfully")
      } else {
        courseData["createdBy"] = adminId
        await this.service.create(courseData)
        return successResponse(res, "Course added successfully")
      }

    } catch (error) {
      return errorResponse(res, error.message);
    }
  }

  // get course list
  courseList = async (req, res) => {
    let limit = req.body.limit || 10;
    let offset = req.body.offset || 0;
    let sort = req.body.sort || "courseId";
    let sortBy = req.body.sortBy || "DESC";
    let searchTerm = (req.body.searchTerm || "").trim();

    try {

      let column = [
        "courseId",
        "courseName",
        "description",
        "fee",
        "duration",
        "durationType"
      ];

      let condition = {
        condition: {
          delete: 0,
        },
        column: column,
        limit,
        offset,
        orderBy: [sort, sortBy],
        searchTerm: searchTerm,
        searchColumns: column
      }

      let data = await this.service.selectDataWithSearchAndJoin(condition)
      return successResponse(res, "List", data);

    } catch (error) {
      console.log(error);
      return errorResponse(res, "Something Went Wrong");
    }
  }

  // delete course
  deleteCourse = async (req, res) => {
    let courseId = req.body.courseId || 0;

    try {
      let courseExists = await this.service.findById(courseId, qr => qr.where({ delete: 0 }));
      if (!courseExists) {
        return errorResponse(res, "Course not found");
      }

      let courseDetail = await this.service.update({ delete: 1 }, qr => qr.where({ courseId }));
      return successResponse(res, courseDetail ? "Course deleted successfully" : "Course Not Found");
    } catch (error) {
      console.log(error);
      return errorResponse(res, "Something Went Wrong");
    }
  };

}

module.exports = courseController;
