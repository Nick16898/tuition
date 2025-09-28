const BaseService = require("../core/BaseService.js");
const crypto = require("crypto")
const { checkExistData, knex } = require('../core/Query.js');


class UserService extends BaseService {
  constructor() {
    super("user")
    this.systemSettingService = new (require("./SystemSettingService.js"))();
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
          'admin.adminId',
          'admin.password',
          'admin.email',
          'admin.countryCode',
          'admin.mobileNumber',
          'admin.profilePicture',
          'admin.block',
          'admin.roleId',
          'session.token',
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

}



module.exports = UserService;
