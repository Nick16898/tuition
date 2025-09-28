const { apiAdminAuth } = require("../../../middleware/apiAuth.js");
const controller =
  new (require("./courseController.js"))();
const authenticationValidator = require("./courseValidator.js");
const bodyParser = require("body-parser");
var route = require("express").Router();
const fn = require("../../../helpers/string_helper.js");
const multer = require("multer");
const path = require("path");

const storage = multer.diskStorage({
  destination: path.join(__dirname, "../../../media/admin/profile"),
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now();
    const ext = file.originalname.substring(
      file.originalname.lastIndexOf("."),
      file.originalname.length
    );
    cb(null, uniqueSuffix + ext);
  },
});
const fileFilter = (req, file, cb) => {
  cb(null, true);
};
const admin = multer({
  storage,
  fileFilter,
});

route.use(bodyParser.json());
route.use(apiAdminAuth);
route.use(fn.decryptRequest);

// Routes
route.post(`/addeditcourse`, fn.validate(authenticationValidator.addEditCourse), controller.addEditCourse);

route.post(`/courselist`, controller.courseList);


route.delete(`/deletecourse`, fn.validate(authenticationValidator.deleteCourse), controller.deleteCourse);

module.exports = route;
