const BaseService = require("../core/BaseService.js");
const SystemSettingService = require("./SystemSettingService.js");
const crypto = require("crypto")
const { checkExistData, knex } = require('../core/Query');


class AdminService extends BaseService {
  constructor() {
    super("admin")

    this.systemSettingService = new SystemSettingService();
  }

  /**
   *
   * @param {string} email - email you want to search in table
   * @returns {Object | null} - return object if found username else return null
  */
  async findByemail(email) {
    try {
      const admin = await this.findAll(qb =>
        qb.select(
          'session.token',
          "admin.adminId",
          "admin.fullName",
          "admin.email",
          "admin.mobileNumber",
          "admin.countryCode",
          "admin.password",
          "admin.block",
          "admin.profilePicture",
          "admin.otp",
        )
          .where('admin.email', '=', email)
          // .where('admin.isVerify', '=', 1)
          .where('admin.delete', '=', 0)
          .leftJoin("session", (session) => {
            session.on("session.userId", "admin.adminId").andOn(knex.raw(`"session"."type"='ADMIN'`))
          })
      )

      return (admin.length > 0) ? admin[0] : null;
    } catch {
      return;
    }
  }


  /**
 * -generate the unique token for
 * @returns {String} -return the token
 */
  async uniqueId() {
    var id = crypto.randomBytes(15).toString('hex')
    var check = await this.checktoken(id)
    while (check) {
      id = await this.uniqueId()
    }
    return id
  }
  /**
   * -for unique token to check in table that token is exist or not
   * @param {String} id-get the token generate by unqueId function
   * @returns -return the token if this token is exist
   */
  async checktoken(id) {
    let query = {
      tableName: 'admin',
      where: {
        adminId: id,
        delete: 0
      }
    }

    let checktoken = await checkExistData(query)
    return checktoken
  }
  async save(table, column) {

    let data = await this.executeQuery(qb =>
      qb.from(table).insert(column)
    )
    return data

  }

  async update(table, column, condition) {

    await this.executeQuery(qb =>
      qb.from(table).where(condition).update(column)
    );

  }
}



module.exports = AdminService;
