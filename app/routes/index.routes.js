const { accessLog } = require("../helpers/logs.js");
const { decryptRequest } = require("../helpers/string_helper.js");
require("dotenv").config();
/*global process*/

/**
 * GROUPING ALL ADMIN APIs AND GIVING THEM SAME PREFIX  AND APPYING MIDDLEWARE TO THIS ADMIN API GROUP
 */

/**
 * MAKING ARRAY OF ALL ADMIN APIs AND GIVING THEN PATH
 */
const routes = [
  { path: "admin/", route: require("../modules/admin/admin.routes.js") },
  { path: "user/", route: require("../modules/user/user.routes.js") },
];

module.exports = (app) => {
  /**
   * add decrypter
   */

  app.use(`${process.env.TUITION_BASE_PATH}`, decryptRequest);

  /**
   * Running through all routes and applying them to app
   */
  routes.forEach(({ path, route }) => {
    /**
     * GIVING PREFIX OF API WITH THEIR OWN PATH
     */
    app.use(`${process.env.TUITION_BASE_PATH}${path}`, route);
  });
};
