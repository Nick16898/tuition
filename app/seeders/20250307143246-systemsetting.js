'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    await queryInterface.bulkInsert('systemsetting', [
      { key: 'sessionTime', value: "120" },
      { key: 'blockTime', value: "20" },
    ], {});
  },

  async down (queryInterface, Sequelize) {
    await queryInterface.bulkDelete('systemsetting', [
      { key: "sessionTime" },
      { key: "blockTime" },
    ], {});
  }
};
