const { apiAdminAuth } = require("../../../middleware/apiAuth.js");
const AuthenticationController =
  new (require("./userController.js"))();
const authenticationValidator = require("./userValidator.js");
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
// route.post(`/resetpassword`, fn.validate(authenticationValidator.resetPassword), AuthenticationController.resetPassword);

// route.post(`/changepassword`, fn.validate(authenticationValidator.changePassword), AuthenticationController.changePassword);

// route.get(`/getprofile`, AuthenticationController.getProfile);

// route.patch(`/editprofile`, admin.single("profilePicture"), fn.validate(authenticationValidator.editProfile), AuthenticationController.editProfile);

route.post(`/addeditstudent`, fn.validate(authenticationValidator.addEditStudent), AuthenticationController.addEditStudent);

route.post(`/studentlist`, AuthenticationController.studentList);

route.delete(`/deletestudent`, fn.validate(authenticationValidator.deleteStudent), AuthenticationController.deleteStudent);

module.exports = route;
