const db = require('../models/index');
const knex = require('knex')({ client: 'pg' });

const query = async (query) => {
  const [field, metadata] = await db.sequelize.query(query);
  return field;
}

/**
 * Check if a record with specific conditions exists in a given table.
 * @param {object} data - The conditions and table name.
 * @param {string} [data.tableName] - The name of the table. Required.
 * @param {object} [data.where] - The conditions to check. Required.
 * @param {object} [data.whereNot] - Optional "not equal" conditions.
 * @param {object} [data.orWhere] - Optional conditions to be applied with OR.
 * @param {object} [data.whereBetween] - Optional "between" conditions.
 * @param {object} [data.greaterThan] - Optional "greater than" conditions.
 * @param {object} [data.lessThan] - Optional "less than" conditions.
 * @param {object} [data.likeWhere] - Optional "like" conditions.
 * @param {object} [data.greaterThanOrEqual] - Optional "greater than or equal" conditions.
 * @param {object} [data.lessThanOrEqual] - Optional "less than or equal" conditions.
 * @param {object} [data.notLikeWhere] - Optional "not like" conditions.
 * @param {object} [data.inWhere] - Optional "in" conditions.
 * @param {object} [data.notInWhere] - Optional "not in" conditions.
 * @returns {Promise<boolean>} - True if the record exists, false otherwise.
 */
async function checkExistData(data = {}, knexQueryBuilder) {
  const {
    tableName,
    where = {},
    whereNot = {},
    orWhere = {},
    whereBetween = {},
    greaterThan = {},
    lessThan = {},
    likeWhere = {},
    greaterThanOrEqual = {},
    lessThanOrEqual = {},
    notLikeWhere = {},
    inWhere = {},
    notInWhere = {}
  } = data;

  if (!tableName || !where) {
    throw new Error('tableName and where are required parameters.');
  }

  try {
    // Initialize the query builder
    let queryBuilder = knex(tableName).first();

    // Apply 'where' conditions
    for (const [column, value] of Object.entries(where)) {
      queryBuilder = queryBuilder.where(column, value);
    }

    // Apply 'whereNot' conditions
    for (const [column, value] of Object.entries(whereNot)) {
      queryBuilder = queryBuilder.whereNot(column, value);
    }

    // Apply 'orWhere' conditions
    for (const [column, value] of Object.entries(orWhere)) {
      queryBuilder = queryBuilder.orWhere(column, value);
    }

    // Apply 'whereBetween' conditions
    for (const [column, range] of Object.entries(whereBetween)) {
      queryBuilder = queryBuilder.whereBetween(column, range);
    }

    // Apply 'greaterThan' conditions
    for (const [column, value] of Object.entries(greaterThan)) {
      queryBuilder = queryBuilder.where(column, '>', value);
    }

    // Apply 'lessThan' conditions
    for (const [column, value] of Object.entries(lessThan)) {
      queryBuilder = queryBuilder.where(column, '<', value);
    }

    // Apply 'greaterThanOrEqual' conditions
    for (const [column, value] of Object.entries(greaterThanOrEqual)) {
      queryBuilder = queryBuilder.where(column, '>=', value);
    }

    // Apply 'lessThanOrEqual' conditions
    for (const [column, value] of Object.entries(lessThanOrEqual)) {
      queryBuilder = queryBuilder.where(column, '<=', value);
    }

    // Apply 'likeWhere' conditions
    for (const [column, pattern] of Object.entries(likeWhere)) {
      queryBuilder = queryBuilder.where(column, 'like', pattern);
    }

    // Apply 'notLikeWhere' conditions
    for (const [column, pattern] of Object.entries(notLikeWhere)) {
      queryBuilder = queryBuilder.whereNot(column, 'like', pattern);
    }

    // Apply 'inWhere' conditions
    for (const [column, values] of Object.entries(inWhere)) {
      queryBuilder = queryBuilder.whereIn(column, values);
    }

    // Apply 'notInWhere' conditions
    for (const [column, values] of Object.entries(notInWhere)) {
      queryBuilder = queryBuilder.whereNotIn(column, values);
    }

    if (knexQueryBuilder) {
      knexQueryBuilder(queryBuilder);
    }

    // Get the raw query string
    const sql = queryBuilder.toString();
    // console.log(sql,"=======================")
    // Execute the raw query string
    const result = await query(sql);

    // Return true if the record exists, false otherwise
    return result.length > 0;
  } catch (error) {
    console.error('Error checking data existence:', error);
    return false;
  }
}

async function checkToken(data = {}) {
  const token = data["token"] || "";

  if (token) {
    let sql = knex.select("*")
      .leftJoin("admin", "session.userId", "admin.adminId")
      .from("session")
      .where({ "session.token": token, type: "ADMIN", "admin.delete": 0, "admin.isActive": 1 })
      .where("session.expireTime", ">", knex.raw("NOW()"));

    let data = await query(sql.toString());
    if (data.length > 0) {
      let sessionTime = await query(knex('systemsetting').where({ systemsettingId: 1 }).select("value").toString())
      await query(knex("session").update({ expireTime: knex.raw(`NOW() + INTERVAL '${sessionTime[0]["value"]} minutes'`) }).where({ token: token }).toString());
    }
    return data;
  }
  return [];
}


async function getAdminByTokenOrEmail(data = {}) {
  const token = data["token"] || "";
  const email = data["email"] || "";
  const adminId = data["adminId"] || "";

  if (token) {
    let sql = knex.select("*")
      .leftJoin("admin", "session.userId", "admin.adminId")
      .from("session")
      .where({ "session.token": token, "session.type" : "ADMIN", "admin.delete": 0 });

    return await query(sql.toString());
  }
  else if (email) {
    let sql = knex.select("*")
    .leftJoin("admin", "session.userId", "admin.adminId")
    .from("session")
    .where({ "admin.email": email, "session.type" : "ADMIN", "admin.delete": 0 });

    return await query(sql.toString());
  }
  else if (adminId) {
    let sql = knex.select("*")
      .from("admin")
      .where({ "admin.adminId": adminId, "admin.delete": 0 });

    return await query(sql.toString());
  }
  return [];
}

async function checkAdminToken(data = {}) {
  const token = data["token"] || "";

  if (token) {
    let sql = knex.select("*")
      .leftJoin("admin", "session.userId", "admin.adminId")
      .from("session")
      .where({ "session.token": token, type: "ADMIN", "admin.delete": 0, "admin.block": 0 })
      .where("session.expireTime", ">", knex.raw("NOW()"));

    let data = await query(sql.toString());
    if (data.length > 0) {
      let sessionTime = await query(knex('systemsetting').where({ systemsettingId: 1 }).select("value").toString())
      await query(knex("session").update({ expireTime: knex.raw(`NOW() + INTERVAL '${sessionTime[0]["value"]} minutes'`) }).where({ token: token }).toString());
    }
    return data;
  }
  return [];
}


module.exports = {
  query,
  knex,
  checkExistData,
  checkToken,
  getAdminByTokenOrEmail,
  checkAdminToken
}
