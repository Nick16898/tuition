require("dotenv").config();

let TUITION_DB_NAME="tuition"
let TUITION_DB_USER="postgres"
let TUITION_DB_PASSWORD="l02Xu7b28dmlfyZW"
let TUITION_DB_HOST="db.rmbmwtlpavdhkhnuatea.supabase.co"
let TUITION_DB_PORT="5432"

/*global process*/
module.exports = {
  development: {
    host: TUITION_DB_HOST,
    username: TUITION_DB_USER,
    password: TUITION_DB_PASSWORD,
    database: TUITION_DB_NAME,
    port: TUITION_DB_PORT,
    dialect: "postgres",
    logging: false,
    pool: {
      max: 5,
      min: 0,
      acquire: 30000,
      idle: 10000,
    },
    define: {
      timestamps: false,
    },
    timezone: "+05:30",
  },
};
