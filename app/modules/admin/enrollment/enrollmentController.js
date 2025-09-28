const {
  errorResponse,
  successResponse,
} = require("../../../helpers/string_helper.js");
const BaseController = require("../../../core/BaseController.js");
const AdminService = require("../../../services/AdminService.js");
const EnrollmentService = require("../../../services/EnrollmentService.js");
const UserService = require("../../../services/UserService.js");
const CourseService = require("../../../services/CourseService.js");
const moment = require("moment");

class enrollmentController extends BaseController {
  constructor() {
    super(EnrollmentService, "enrollment");
    /** @type {EnrollmentService} */
    this.service;
    this.userService = new UserService();
    this.adminService = new AdminService();
    this.courseService = new CourseService();
  }

  // ✅ Add or Edit Enrollment
  addEditEnrollment = async (req, res) => {
    let adminId = req.headers.adminId || "";
    let enrollmentId = req.body.enrollmentId || 0;
    let courseId = req.body.courseId || 0;
    let userId = req.body.userId || 0;
    let enrollmentDate = req.body.enrollmentDate || new Date();
    let status = req.body.status || "ACTIVE";
    let enrollmentType = req.body.enrollmentType || "MONTHLY";
    let amount = req.body.amount || null;

    try {
      // check if user exists
      let userExists = await this.userService.findById(userId, qr => qr.where({ delete: 0 }));
      if (!userExists) {
        return errorResponse(res, "User not found");
      }

      // check if course exists
      let courseExists = await this.courseService.findById(courseId, qr => qr.where({ delete: 0 }));
      if (!courseExists) {
        return errorResponse(res, "Course not found");
      }

      let checkUserInEnrollment = await this.service.findAll(qr => {
        qr.where({ userId, courseId, delete: 0 });
        if (enrollmentId) {
          qr.whereNot({ enrollmentId });
        }
        return qr;
      });

      if (checkUserInEnrollment.length > 0) {
        return errorResponse(res, "User already enrolled in this course");
      }

      let field = {
        courseId,
        userId,
        enrollmentDate,
        status,
        enrollmentType,
        amount,
      };

      if (enrollmentId) {
        field["updatedBy"] = adminId;
        await this.service.updateById(enrollmentId, field);
      } else {
        field["createdBy"] = adminId;
        await this.service.create(field);
      }

      return successResponse(
        res,
        enrollmentId ? "Enrollment updated successfully" : "Enrollment added successfully"
      );
    } catch (error) {
      console.log(error);
      return errorResponse(res, "Something Went Wrong");
    }
  };

  // ✅ Delete Enrollment (Soft Delete)
  deleteEnrollment = async (req, res) => {
    let enrollmentId = req.body.enrollmentId;

    try {
      let enrollmentExists = await this.service.findById(enrollmentId, qr =>
        qr.where({ delete: 0 })
      );
      if (!enrollmentExists) {
        return errorResponse(res, "Enrollment not found");
      }

      let updated = await this.service.updateById(enrollmentId, { delete: 1 });
      return successResponse(res, updated ? "Enrollment deleted successfully" : "Enrollment not found");
    } catch (error) {
      console.log(error);
      return errorResponse(res, "Something Went Wrong");
    }
  };

  // ✅ Enrollment List
  enrollmentList = async (req, res) => {
    let enrollmentId = req.body.enrollmentId || "";
    let userId = req.body.userId || "";
    let courseId = req.body.courseId || "";
    let limit = req.body.limit || 10;
    let offset = req.body.offset || 0;
    let sort = req.body.sort || "enrollment.enrollmentId";
    let sortBy = req.body.sortBy || "DESC";
    let searchTerm = (req.body.searchTerm || "").trim();

    try {
      let column = [
        "enrollment.enrollmentId",
        "enrollment.courseId",
        "enrollment.userId",
        "enrollment.enrollmentDate",
        "enrollment.status",
        "enrollment.enrollmentType",
        "enrollment.amount",

        // User Information
        "user.userId",
        "user.fullName",
        "user.email",

        // Course Information
        "course.courseId",
        "course.courseName",
        "course.description"
      ];

      let condition = {
        condition: {
          "enrollment.delete": 0,
          "user.delete": 0,
          "course.delete": 0,
          ...(enrollmentId && { "enrollment.enrollmentId": enrollmentId }),
          ...(userId && { "enrollment.userId": userId }),
          ...(courseId && { "enrollment.courseId": courseId }),
        },
        column,
        limit,
        offset,
        orderBy: [sort, sortBy],
        searchTerm,
        joinClue: [
          {
            tableName: "user",
            local: "user.userId",
            forien: "enrollment.userId",
          },
          {
            tableName: "course",
            local: "course.courseId",
            forien: "enrollment.courseId",
          }
        ],
        searchColumns: column
      };

      let data = await this.service.selectDataWithSearchAndJoin(condition);

      return successResponse(res, "Enrollment list fetched", data);
    } catch (error) {
      console.log(error);
      return errorResponse(res, "Something Went Wrong");
    }
  };
}

module.exports = enrollmentController;
