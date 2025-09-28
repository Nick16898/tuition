require("dotenv").config();
/*global process*/
module.exports = {
  development: {
    host: process.env.TUITION_DB_HOST,
    username: process.env.TUITION_DB_USER,
    password: process.env.TUITION_DB_PASSWORD,
    database: process.env.TUITION_DB_NAME,
    port: process.env.TUITION_DB_PORT,
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
