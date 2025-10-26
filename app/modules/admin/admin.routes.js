var routes = require("express").Router();

// call decryptRequest

routes.use("/auth/public", require("./authentication/authentication.public.routes.js"));
routes.use("/auth/", require("./authentication/authentication.private.routes.js"));

routes.use("/user/", require("./user/user.routes.js"));
routes.use("/course/", require("./course/course.routes.js"));
routes.use("/enrollment/", require("./enrollment/enrollment.routes.js"));
routes.use("/payment/", require("./payment/payment.routes.js"));

module.exports = routes;
