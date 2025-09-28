const db = require('../models/index');
// const knex = require('knex')({ client: 'pg' });
const {query,knex} = require('./Query')

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
async function checkEmail(data = {}) {
    const email = data["email"] || "";
    const id = data["id"] || "";
    const table = data["table"];

    let sql = knex
    .select("*")
    .from(table)
    .where({ [table+".email"]: email, [table+".delete"]: 0 })
    .modify((query) => {
      if (id > 0) {
        query.whereNot(table+"."+table+"Id", id);
      }
    });
    var data=await query(sql.toString())

    return data.length>0?true:false;
}

async function checkMobileNumber(data = {}) {
  const countryCode = data["countryCode"] || "";
  const mobileNumber = data["mobileNumber"] || "";
  const id = data["id"] || "";
  const table = data["table"];

  let sql = knex
  .select("*")
  .from(table)
  .where({ [table+".countryCode"]: countryCode,[table+".mobileNumber"]: mobileNumber, [table+".delete"]: 0 })
  .modify((query) => {
    if (id > 0) {
      query.whereNot(table+"."+table+"Id", id);
    }
  });
  var data=await query(sql.toString())
  console.log(data)
  return data.length>0?true:false;

}


module.exports = {
  checkAdminToken,
  getAdminByTokenOrEmail,
  checkEmail,
  checkMobileNumber
}
