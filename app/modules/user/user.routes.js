var routes = require("express").Router();

// Add the modular route
routes.use("/auth/public", require("./authentication/user.public.routes"));

module.exports = routes;
