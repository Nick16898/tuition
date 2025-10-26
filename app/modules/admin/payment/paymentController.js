const {
  errorResponse,
  successResponse,
} = require("../../../helpers/string_helper.js");
const BaseController = require("../../../core/BaseController.js");
const AdminService = require("../../../services/AdminService.js");
const EnrollmentService = require("../../../services/EnrollmentService.js");
const UserService = require("../../../services/UserService.js");
const CourseService = require("../../../services/CourseService.js");
const PaymentService = require("../../../services/PaymentService.js");
const moment = require("moment");
const { knex } = require("../../../core/Query.js");

class paymentController extends BaseController {
  constructor() {
    super(PaymentService, "payment");
    /** @type {PaymentService} */
    this.service;
    this.userService = new UserService();
    this.adminService = new AdminService();
    this.courseService = new CourseService();
    this.enrollmentService = new EnrollmentService();
  }

  // ✅ Add or Edit Payment
  addEditPayment = async (req, res) => {
    let adminId = req.headers.adminId || "";
    let paymentId = req.body.paymentId || 0;
    let enrollmentId = req.body.enrollmentId || 0;
    let userId = req.body.userId || 0;
    let paidAmount = req.body.paidAmount || null;
    let paymentMode = req.body.paymentMode || "CASE";
    let note = req.body.note || "";
    let startDate = req.body.startDate || new Date();
    let endDate = req.body.endDate || "";

    try {
      // check if user exists
      let userExists = await this.userService.findById(userId, (qr) =>
        qr.where({ delete: 0 })
      );
      if (!userExists) {
        return errorResponse(res, "User not found");
      }

      // check if enrollment exists
      let enrollmentExists = await this.enrollmentService.findById(
        enrollmentId,
        (qr) => qr.where({ delete: 0 })
      );
      if (!enrollmentExists) {
        return errorResponse(res, "Enrollment not found");
      }

      if (!endDate) {
        // enrollmentType acording create end date of payment
        endDate = await this.service.calculateEndDate({ date: startDate, duration: 1, type: enrollmentExists.enrollmentType })
      }

      if (!paymentId) {
        const existingPayment = await this.service.findAll((qr) =>
          qr
            .where({ userId, enrollmentId, delete: 0 })
            .where(function () {
              this.whereBetween('startDate', [startDate, endDate])
                .orWhereBetween('endDate', [startDate, endDate])
                .orWhere(function () {
                  this.where('startDate', '<=', startDate)
                    .andWhere('endDate', '>=', endDate);
                });
            })
        );
        if (existingPayment.length > 0) {
          return errorResponse(res, "Already collected fee for this date range");
        }
      }


      let field = {
        enrollmentId,
        userId,
        amount: enrollmentExists?.amount ?? 0,
        paidAmount,
        paymentMode,
        note,
        startDate,
        endDate,
      };

      if (paymentId) {
        field["updatedBy"] = adminId;
        await this.service.updateById(paymentId, field);
      } else {
        field["createdBy"] = adminId;
        await this.service.create(field);
      }

      return successResponse(
        res,
        paymentId ? "Payment updated successfully" : "Payment added successfully"
      );
    } catch (error) {
      console.log(error);
      return errorResponse(res, "Something Went Wrong");
    }
  };

  // ✅ Delete Payment (Soft Delete)
  deletePayment = async (req, res) => {
    let paymentId = req.body.paymentId;
    try {
      let paymentExists = await this.service.findById(paymentId, (qr) =>
        qr.where({ delete: 0 })
      );
      if (!paymentExists) {
        return errorResponse(res, "Payment not found");
      }

      let updated = await this.service.updateById(paymentId, { delete: 1 });
      return successResponse(
        res,
        updated ? "Payment deleted successfully" : "Payment not found"
      );
    } catch (error) {
      console.log(error);
      return errorResponse(res, "Something Went Wrong");
    }
  };

  // ✅ Payment List
  paymentList = async (req, res) => {
    let paymentId = req.body.paymentId || "";
    let enrollmentId = req.body.enrollmentId || "";
    let userId = req.body.userId || "";
    let limit = req.body.limit || 10;
    let offset = req.body.offset || 0;
    let sort = req.body.sort || "payment.paymentId";
    let sortBy = req.body.sortBy || "DESC";
    let searchTerm = (req.body.searchTerm || "").trim();

    try {
      let column = [
        "payment.paymentId",
        "payment.enrollmentId",
        "payment.userId",
        "payment.amount",
        "payment.paidAmount",
        "payment.paymentMode",
        "payment.note",
        "payment.startDate",
        "payment.endDate",

        // User Information
        "user.userId",
        "user.fullName",
        "user.email",

        // Enrollment Information
        "enrollment.enrollmentId",
        "enrollment.courseId",
        "enrollment.enrollmentType",

        // course
        "course.courseId",
        "course.courseName",
      ];

      let condition = {
        condition: {
          "payment.delete": 0,
          "user.delete": 0,
          "enrollment.delete": 0,
          ...(paymentId && { "payment.paymentId": paymentId }),
          ...(userId && { "payment.userId": userId }),
          ...(enrollmentId && { "payment.enrollmentId": enrollmentId }),
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
            forien: "payment.userId",
          },
          {
            tableName: "enrollment",
            local: "enrollment.enrollmentId",
            forien: "payment.enrollmentId",
          },
          {
            tableName: "course",
            local: "course.courseId",
            forien: "enrollment.courseId",
          }
        ],
        searchColumns: column,
      };

      let data = await this.service.selectDataWithSearchAndJoin(condition);

      return successResponse(res, "Payment list fetched", data);
    } catch (error) {
      console.log(error);
      return errorResponse(res, "Something Went Wrong");
    }
  };


  // studentsWithExpiringPayments = async (req, res) => {
  // studentsWithExpiringPayments = async (req, res) => {
  //   const limit = req.body.limit || 10;
  //   const offset = req.body.offset || 0;

  //   try {
  //     const today = moment().format("YYYY-MM-DD");
  //     const next7Days = moment().add(7, "days").format("YYYY-MM-DD");

  //     // Columns to select
  //     const column = [
  //       "user.userId",
  //       "user.fullName",
  //       "user.email",
  //       knex.raw(`COUNT(DISTINCT enrollment."enrollmentId") as totalEnrollments`),
  //       knex.raw(`MAX(payment."endDate") as lastPaymentEndDate`),
  //       knex.raw(
  //         `DATE_PART('day', MAX(payment."endDate") - ?) as daysLeft`,
  //         [today]
  //       ),
  //       // Determine payment status dynamically
  //       knex.raw(`
  //       CASE
  //         WHEN MAX(payment."endDate") IS NULL THEN 'NOT_PAID'
  //         WHEN MAX(payment."endDate") < ? THEN 'EXPIRED'
  //         WHEN MAX(payment."endDate") BETWEEN ? AND ? THEN 'EXPIRING_SOON'
  //         ELSE 'ACTIVE'
  //       END AS paymentStatus
  //     `, [today, today, next7Days])
  //     ];

  //     // Base query condition
  //     const condition = {
  //       condition: {
  //         "user.delete": 0,
  //         "enrollment.delete": 0,
  //         "enrollment.status": "ACTIVE",
  //       },
  //       column,
  //       limit,
  //       offset,
  //       joinClue: [
  //         { tableName: "enrollment", local: "enrollment.userId", forien: "user.userId" },
  //         { tableName: "course", local: "course.courseId", forien: "enrollment.courseId" },
  //         // Use LEFT JOIN for payments so even unpaid students appear
  //         { tableName: "payment", local: "payment.enrollmentId", forien: "enrollment.enrollmentId", joinType: "left" },
  //       ],
  //       orderBy: [knex.raw(`MAX(payment."endDate")`), "ASC"],
  //       isCount: 0,
  //     };

  //     // Main query
  //     const data = await this.userService.selectDataWithSearchAndJoin(
  //       condition,
  //       (query) => query.groupBy("user.userId")
  //     );

  //     return successResponse(res, "Students with payment status", data);
  //   } catch (error) {
  //     console.error(error);
  //     return errorResponse(res, "Something went wrong");
  //   }
  // };

  studentsWithExpiringPayments = async (req, res) => {
    const limit = req.body.limit || 10;
    const offset = req.body.offset || 0;
    const requestedStatus = req.body.requestedStatus; // Optional: 'NOT_PAID', 'EXPIRED', 'EXPIRING_SOON'

    try {
      const today = moment().format("YYYY-MM-DD");
      const next7Days = moment().add(7, "days").format("YYYY-MM-DD");

      // Define the CASE expression for paymentStatus
      const paymentStatusCase = knex.raw(`
      CASE
        WHEN MAX(payment."endDate") IS NULL THEN 'NOT_PAID'
        WHEN MAX(payment."endDate") < ? THEN 'EXPIRED'
        WHEN MAX(payment."endDate") BETWEEN ? AND ? THEN 'EXPIRING_SOON'
        ELSE 'ACTIVE'
      END
    `, [today, today, next7Days]);

      // Columns to select
      const column = [
        "user.userId",
        "user.fullName",
        "user.email",
        "course.courseId",
        "course.courseName",
        "enrollment.enrollmentId",
        knex.raw(`MAX(payment."endDate") as lastPaymentEndDate`),
        knex.raw(`DATE_PART('day', MAX(payment."endDate") - ?) as daysLeft`, [today]),
        paymentStatusCase
      ];

      // Base query condition
      const condition = {
        condition: {
          "user.delete": 0,
          "enrollment.delete": 0,
          "enrollment.status": "ACTIVE",
          "course.delete": 0,
        },
        column,
        limit,
        offset,
        joinClue: [
          { tableName: "enrollment", local: "enrollment.userId", forien: "user.userId" },
          { tableName: "course", local: "course.courseId", forien: "enrollment.courseId" },
          // LEFT JOIN payment — to include unpaid courses
          { tableName: "payment", local: "payment.enrollmentId", forien: "enrollment.enrollmentId", joinType: "left" },
        ],
        orderBy: [knex.raw(`MAX(payment."endDate")`), "ASC"],
        isCount: 0,
      };

      // Query grouped by both user and course with HAVING for aggregate filter
      const data = await this.userService.selectDataWithSearchAndJoin(
        condition,
        (query) => {
          query.groupBy("user.userId", "course.courseId", "enrollment.enrollmentId");
          if (requestedStatus) {
            query.having(paymentStatusCase, "=", requestedStatus);
          } else {
            query.having(paymentStatusCase, "!=", "ACTIVE");

          }
          return query
        }
      );

      return successResponse(res, "Students with per-course payment status", data);
    } catch (error) {
      console.log(error);
      return errorResponse(res, "Something went wrong");
    }
  };

}

module.exports = paymentController;
