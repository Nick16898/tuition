const express = require("express");
const app = express();
const bodyParser = require("body-parser");
app.use(bodyParser.json());
const { accessLog } = require("./app/helpers/logs.js");
const cors = require("cors");
const path = require("path");
const helmet = require("helmet");
// const cron = require("node-cron");

/*global process*/
/*global __dirname*/

// taking global variables from .env file
require("dotenv").config({ path: path.resolve(__dirname + "/.env") });

// Increase the default max listeners to no limit
require("events").EventEmitter.prototype._maxListeners = 0;

/**
 * Taking admin database to sync
 */
const db = require("./app/models/index.js");
db.sequelize
  .sync({ alter: true })
  .then(() => {
    console.log("Synced db.");
  })
  .catch((err) => {
    console.log("Failed to sync admin db: " + err.message);
  });

/**
 * Helmet to help secure Express app with various HTTP headers
 */
app.use(helmet());

/**
 * HTTP request allow from front(react) which only allow HTTPS request
 */
app.use(cors(), function (req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header(
    "Access-Control-Allow-Headers",
    "Origin, X-Requested-With, Content-Type, Accept"
  );
  next();
});

app.set("trust proxy", 1);

/**
 * Calling accessLog Function, That create access file of each day in log/access folder and make access log entry every time api is called
 */

app.use((req, res, next) => {
  const path = req.path;
  // Check if the path does not start with admin or trainee
  if (
    !path.startsWith(process.env.BASE_PATH_ADMIN) &&
    !path.startsWith(process.env.BASE_PATH_CLIENT)
  ) {
    accessLog(app);
    next();
  } else {
    next();
  }
});

app.get("/", (req, res) => {
  res.json({ message: "Welcome to Backend peasant." });
});

app.post("/sss", (req, res) => {
  res.json({ message: "Welcos.", status: "200" });
});

// INDEX ROUTE
require("./app/routes/index.routes.js")(app);

// set port, listen for requests
const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(`⚡️[server]: Server is running at http://localhost:${PORT}`);
});

module.exports = app;
