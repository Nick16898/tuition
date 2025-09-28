const Sequelize = require("sequelize");
const config = require("../config/db-config.js").development;
const db = {};

const sequelize = new Sequelize(
  config.database,
  config.username,
  config.password,
  config
);

db.admin = require("./admin.js")(sequelize, Sequelize)
db.course = require("./course.js")(sequelize, Sequelize);
db.enrollment = require("./enrollment.js")(sequelize, Sequelize);
db.payment = require("./payment.js")(sequelize, Sequelize);
db.session = require("./session.js")(sequelize, Sequelize);
db.systemsetting = require("./systemsetting.js")(sequelize, Sequelize);
db.user = require("./user.js")(sequelize, Sequelize);

db.sequelize = sequelize;
module.exports = { sequelize, db };
