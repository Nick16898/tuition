const BaseService = require("../core/BaseService");

class SessionService extends BaseService {
  constructor() {
    super("session")
  }

  /**
   * Saves or updates a user session in the database.
   *
   * If a session already exists for the given `userId` and `type`, it updates the session token and expiration time.
   * Otherwise, it creates a new session with the provided details.
   *
   * @param {Object} data - The session data.
   * @param {number} [data.userId=0] - The ID of the user for whom the session is being created or updated.
   * @param {string} [data.type="ADMIN"] - The type of session (e.g., "ADMIN", Etc..).
   * @param {number} [data.extendMinute=120] - The number of minutes to extend the session expiry time.
   * @param {string} data.token - The authentication token for the session.
   * @returns {Promise<void>} - A promise that resolves when the operation is complete.
   */
  async save({ userId = 0, type = "ADMIN", extendMinute = 120, token }) {
    var check = await this.findAll((qb) => qb.select("sessionId").where({ userId: userId, type: type }));
    if (check.length > 0) {
      await this.update({}, qb =>
        qb.update({ token: token, expireTime: qb.client.raw(`NOW() + INTERVAL '${extendMinute} minutes'`) })
          .where({ userId: userId, type: type })
      )
    } else {
      await this.executeQuery(qb =>
        qb.from(this.table).insert({
          token: token,
          userId: userId,
          type: type,
          expireTime: qb.client.raw(`NOW() + INTERVAL '${extendMinute} minutes'`)
        })
      )
    }
  }
}

module.exports = SessionService;
