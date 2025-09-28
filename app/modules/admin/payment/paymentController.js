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

class paymentController extends BaseController {
  constructor() {
    super(EnrollmentService, "enrollment");
    /** @type {EnrollmentService} */
    this.service;
    this.userService = new UserService();
    this.adminService = new AdminService();
    this.courseService = new CourseService();
  }

}

module.exports = paymentController;
