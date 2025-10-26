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
  destination: path.join(__dirname, "../../../media/user/profile"),
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + "-" + Math.round(Math.random() * 1e9);
    const ext = file.originalname.substring(
      file.originalname.lastIndexOf("."),
      file.originalname.length
    );
    cb(null, uniqueSuffix + ext);
  },
});

const fileFilter = (req, file, cb) => {
  const allowedTypes = /jpeg|jpg|png|gif/;
  const ext = path.extname(file.originalname).toLowerCase();
  const mime = file.mimetype;

  if (allowedTypes.test(ext) && allowedTypes.test(mime)) {
    cb(null, true);
  } else {
    cb(new Error("Only images are allowed (jpeg, jpg, png, gif)"), false);
  }
};

const user = multer({
  storage,
  fileFilter,
  limits: { fileSize: 2 * 1024 * 1024 }, // 2 MB max
});



route.use(bodyParser.json());
route.use(apiAdminAuth);
route.use(fn.decryptRequest);

// Routes
route.post(`/addeditstudent`,
  user.single("profilePicture"),
//  fn.validate(authenticationValidator.addEditStudent),
AuthenticationController.addEditStudent);

route.post(`/studentlist`, AuthenticationController.studentList);

route.delete(`/deletestudent`, fn.validate(authenticationValidator.deleteStudent), AuthenticationController.deleteStudent);

module.exports = route;
