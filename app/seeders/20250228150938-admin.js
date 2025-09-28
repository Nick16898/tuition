"use strict";
const eh = require("../helpers/encryptdecrypt_helper");

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.bulkInsert(
      "admin",
      [
        {
          fullName: "admin",
          password: await eh.encryptPassword("Admin@123"),
          email: "admin@gmail.com",
          mobileNumber: "9929988288",
        },
      ],
      {}
    );
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete(
      "admin",
      {
        email: "admin@gmail.com",
      },
      {}
    );
  },
};
