const bcrypt = require("bcrypt");
const md5 = require("md5");
require("dotenv").config();
const { errorLog } = require("./logs");
const CryptoJS = require("crypto-js");
const fs = require("fs");
const path = require("path");
const axios = require("axios");
/*global process*/

const baseUrl = process.env.TUITION_MEDIA_URL || "";
/**
 * SUCCESS HANDLING FUNCTION
 * Sends a success response with HTTP status code 200.
 * @param {*} res - Express response object
 * @param {string} message - Success message (default: "Success")
 * @param {Array} data - Data to send along with the response (default: [])
 */
const successResponse = (
  res,
  message = "Success",
  data = [],
  url = false,
  elevel = 0
) => {
  cleanArrayObjectv2(data, false);

  var code = 200;
  if (typeof data === "object" && data !== null) {
    data = Array.isArray(data) ? cleanArrayOfObjects(data) : cleanObject(data);
  }
  if (elevel != "0" && typeof data === "object" && data !== null) {
    data = Array.isArray(data)
      ? encryptArrayOfObjects(data, eLevel(elevel))
      : encryptObject(data, eLevel(elevel));
  }
  let obj = {
    status: code,
    success: true,
    elevel: elevel,
    message,
    data,
  };
  url == true ? (obj["baseUrl"] = baseUrl) : "";
  res.send(obj);
};

const successResponsev2 = (
  res,
  message = "Success",
  data = [],
  url = false,
  urlConcat = ""
) => {
  cleanArrayObjectv2(data);
  var code = 200;
  var arr = {
    status: code,
    success: true,
    message,
    data,
    url: "",
  };
  if (url == true) {
    if (urlConcat) {
      arr["url"] =
        process.env.TUITION_MEDIA_URL + `${urlConcat}/` || "";
    } else {
      arr["url"] = process.env.TUITION_MEDIA_URL;
    }
  }

  res.send(arr);
};

/**
 * ERROR HANDLING FUNCTION
 * Sends an error response with HTTP status code 400.
 * Logs the error and sends a response with an error message.
 * @param {*} res - Express response object
 * @param {*} errorMessage - Error message to send (default: 'Something went wrong')
 * @param {*} error - Error object or additional error details (default: {})
 */
const errorResponse = (
  res,
  errorMessage = "Something went wrong",
  error = {}
) => {
  console.log(error);
  var message = errorMessage;
  var code = 400;

  errorLog(res, error, errorMessage, 400);
  res.send({
    status: code,
    message,
    success: false,
  });
};

/**
 * CLEAN STRING FUNCTION
 * Returns a cleaned version of the input string or an empty string if input is falsy.
 * @param {string} str - Input string to clean
 * @returns {string} - Cleaned string
 */
function cleanString(str) {
  if (typeof str === "string") return str.trim() || "";
  if (typeof str === "boolean" || typeof str === "number") return str;
  return str || "";
}

/**
 * REPLACE ALL FUNCTION
 * Replaces all occurrences of a substring in a string with another substring.
 * @param {string} str - Input string where replacement is performed
 * @param {string} search - Substring to search for
 * @param {string} replacement - Substring to replace with
 * @returns {string} - String after replacements
 */
function replaceAll(str, search, replacement) {
  return str.split(search).join(replacement);
}

/**
 * GET MEDIA URL FUNCTION
 * Returns the full URL of an image based on the given media name.
 * @param {string} media - Media name or identifier
 * @returns {string} - Full URL of the media
 */
const getBlobUrl = (media) => {
  return media != undefined && media != null && media.trim() != ""
    ? process.env.NAGILWAR_MEDIA_URL + media
    : "";
};

/**
 * VALIDATE DATA FUNCTION
 * Checks if the provided data is valid (not null, undefined, or empty).
 * @param {*} data2 - Data to validate
 * @returns {boolean} - true if data is invalid, false if data is valid
 */
const validateData = (data2) => {
  const data = cleanString(data2);
  if (data == null || data == undefined || data == "") {
    return true;
  } else {
    return false;
  }
};

/**
 * UPPERCASE FIRST CHARACTER FUNCTION
 * Converts the first character of a string to uppercase.
 * @param {string} string - Input string
 * @returns {string} - String with first character converted to uppercase
 */
const ucFirst = (string) => {
  if (typeof string === "string" && string.length > 0) {
    return string.charAt(0).toUpperCase() + string.slice(1);
  } else {
    // Handle the case where string is undefined or empty
    return string;
  }
};

/**
 * UPPERCASE FIRST CHARACTER FUNCTION
 * Converts the first character of each word in a string to uppercase.
 * @param {string} string - Input string
 * @returns {string} - String with first character of each word converted to uppercase
 */
function capitalize(str) {
  str = str.toLowerCase();
  return str.replace(/\b\w/g, function (char) {
    return char.toUpperCase();
  });
}

/**
 * CLEAN OBJECT FUNCTION
 * Cleans an object by replacing null values with empty strings and cleaning string values.
 * @param {object} myObject - Input object to clean
 * @returns {object} - Cleaned object with null values replaced by empty strings
 */
const cleanObject = (myObject) => {
  Object.keys(myObject).map(function (key) {
    if (Array.isArray(myObject[key])) {
      myObject[key] = cleanArrayOfObjects(myObject[key]);
    } else if (myObject[key] == null) {
      myObject[key] = "";
    } else {
      myObject[key] = cleanString(myObject[key]);
    }
  });
  return myObject;
};

/**
 * Function to clean array of objects by removing properties with null, undefined, or empty values.
 * @param {array} arr - Array of objects to clean
 * @returns {array} - Cleaned array of objects
 */
const cleanArrayOfObjects = (arr) => {
  return arr.map((obj) => {
    const cleanedObj = {};

    Object.keys(obj).forEach((key) => {
      const value = obj[key];
      if (value !== null && value !== undefined && value !== "") {
        cleanedObj[key] = value;
      } else {
        cleanedObj[key] = "";
      }
    });

    return cleanedObj;
  });
};

/**
 * Writes data to a file synchronously.
 * @param {string} filePath - The directory path where the file will be saved. p.s. give relative path from project ex. ./app/helper/
 * @param {string} fileName - The name of the file.
 * @param {string} data - The data to write to the file.
 * @returns {boolean} - Returns true if the write operation was successful, false otherwise.
 */
function writeFile(filePath, fileName, data) {
  try {
    const fullPath = path.join(filePath, fileName);
    fs.writeFileSync(fullPath, data);
    return true;
  } catch (err) {
    console.error("Error writing to file:", err);
    return false;
  }
}

/**
 * Function to get encryption level object with encryption level key
 * @param {integer} level - Encryption level indicator (0, 1, 2, or 3)
 * @returns {object} - Encryption level object containing 'key' and 'value' properties
 */
const eLevel = (level) => {
  let eLevelObj = {
    0: {
      key: false,
      value: false,
    },
    1: {
      key: false,
      value: true,
    },
    2: {
      key: true,
      value: true,
    },
    3: {
      key: true,
      value: false,
    },
  };
  return eLevelObj[level];
};

/**
 * Initialization vector for AES encryption.
 * Should be set to a specific value.
 */
const initVector = CryptoJS.enc.Utf8.parse("vOVH6sdmpNWjRRIq");

/**
 * Security key for AES encryption.
 * Should be set to a specific value.
 */
const Securitykey = CryptoJS.enc.Utf8.parse("vOVH6sdmpNWjRRIqCc7rdxs01lwHzfr3");

/**
 * Encrypts text using XOR + Base64.
 * @param {string} text - The plaintext to encrypt.
 * @returns {string} - Encrypted text (Base64 format).
 */
const encrypt = (text) => {
  let encrypted = "";
  for (let i = 0; i < text.length; i++) {
    encrypted += String.fromCharCode(
      text.charCodeAt(i) ^
      process.env.ENCRYPT_SECURITY_KEY.charCodeAt(
        i % process.env.ENCRYPT_SECURITY_KEY.length
      )
    );
  }
  return CryptoJS.enc.Base64.stringify(CryptoJS.enc.Latin1.parse(encrypted));
};

/**
 * Decrypts Base64 + XOR encrypted text.
 * @param {string} encryptedText - The encrypted text in Base64 format.
 * @returns {string} - Decrypted plaintext.
 */
const decrypt = (encryptedText) => {
  const decoded = CryptoJS.enc.Base64.parse(encryptedText).toString(
    CryptoJS.enc.Latin1
  );
  let decrypted = "";
  for (let i = 0; i < decoded.length; i++) {
    decrypted += String.fromCharCode(
      decoded.charCodeAt(i) ^
      process.env.ENCRYPT_SECURITY_KEY.charCodeAt(
        i % process.env.ENCRYPT_SECURITY_KEY.length
      )
    );
  }
  return decrypted;
};

/**
 * Encrypts an object or array based on provided encryption levels.
 * @param {object|Array} data - The object or array to encrypt
 * @param {object} keyLevel - Encryption level object with 'key' and 'value' properties
 * @returns {object|Array} - Encrypted result
 */
const encryptObject = (data, keyLevel) => {
  // If data is not an object/array, return as is.
  if (data === null || typeof data !== "object") return data;

  const { key: isKeyEncrypted, value: isValueEncrypted } = keyLevel;

  // Create the root container depending on data type.
  const root = Array.isArray(data) ? [] : {};
  // Stack items: { orig: original data, copy: new container }
  const stack = [{ orig: data, copy: root }];

  while (stack.length) {
    const { orig, copy } = stack.pop();

    if (Array.isArray(orig)) {
      // Process array elements.
      for (let i = 0; i < orig.length; i++) {
        const item = orig[i];
        if (Array.isArray(item)) {
          const newArr = [];
          copy[i] = newArr;
          stack.push({ orig: item, copy: newArr });
        } else if (item instanceof Date) {
          copy[i] = isValueEncrypted
            ? encrypt(item.toISOString())
            : item.toISOString();
        } else if (item !== null && typeof item === "object") {
          const newObj = {};
          copy[i] = newObj;
          stack.push({ orig: item, copy: newObj });
        } else if (typeof item === "string") {
          copy[i] = isValueEncrypted ? encrypt(item) : item;
        } else {
          copy[i] = item;
        }
      }
    } else {
      // Process object properties.
      for (const origKey in orig) {
        if (Object.prototype.hasOwnProperty.call(orig, origKey)) {
          // Encrypt the key if required.
          const newKey = isKeyEncrypted ? encrypt(String(origKey)) : origKey;
          const val = orig[origKey];

          if (Array.isArray(val)) {
            const newArr = [];
            copy[newKey] = newArr;
            stack.push({ orig: val, copy: newArr });
          } else if (val instanceof Date) {
            copy[newKey] = isValueEncrypted
              ? encrypt(val.toISOString())
              : val.toISOString();
          } else if (val !== null && typeof val === "object") {
            const newObj = {};
            copy[newKey] = newObj;
            stack.push({ orig: val, copy: newObj });
          } else if (typeof val === "string") {
            copy[newKey] = isValueEncrypted ? encrypt(val) : val;
          } else {
            copy[newKey] = val;
          }
        }
      }
    }
  }

  return root;
};

/**
 * Function to encrypt an array recursively based on encryption level.
 * @param {Array} arr - Array to encrypt
 * @param {object} keyLevel - Encryption level object with 'key' and 'value' properties
 * @returns {Array} - Encrypted array
 */
const encryptArrayOfObjects = (arr, keyLevel) => {
  return arr.map((item) => {
    if (Array.isArray(item)) {
      // Recursively encrypt nested arrays
      return encryptArrayOfObjects(item, keyLevel);
    } else if (typeof item === "object" && item !== null) {
      // Encrypt objects in the array
      return encryptObject(item, keyLevel);
    } else if (typeof item === "string" && keyLevel["value"]) {
      // Encrypt string items
      return encrypt(item);
    } else {
      // Leave other values unchanged
      return item;
    }
  });
};

/**
 * Function to decrypt an object recursively based on encryption level.
 * @param {object} obj - Encrypted object to decrypt
 * @param {{key: boolean, value: boolean}} keyLevel - Encryption level object with 'key' and 'value' properties
 * @returns {object} - Decrypted object
 */
const decryptObject = (obj, keyLevel) => {
  const decryptedObject = {};
  const isKeyEncrypted = keyLevel["key"];
  const isValueEncrypted = keyLevel["value"];

  for (const [key, value] of Object.entries(obj)) {
    const decryptedKey = isKeyEncrypted ? decrypt(key) : key;

    if (Array.isArray(value)) {
      // Decrypt array elements
      decryptedObject[decryptedKey] = decryptArrayOfObjects(value, keyLevel);
    } else if (typeof value === "object" && value !== null) {
      // Recursively decrypt nested objects
      decryptedObject[decryptedKey] = decryptObject(value, keyLevel);
    } else if (typeof value === "string") {
      // Decrypt string values
      decryptedObject[decryptedKey] = isValueEncrypted ? decrypt(value) : value;
    } else {
      // Leave other values unchanged
      decryptedObject[decryptedKey] = value;
    }
  }

  return decryptedObject;
};

/**
 * Function to decrypt an array recursively based on encryption level.
 * @param {Array} arr - Encrypted array to decrypt
 * @param {{key: boolean, value: boolean}} keyLevel - Encryption level object with 'key' and 'value' properties
 * @returns {Array} - Decrypted array
 */
const decryptArrayOfObjects = (arr, keyLevel) => {

  return arr.map((item) => {
    if (Array.isArray(item)) {
      // Recursively decrypt nested arrays
      return decryptArrayOfObjects(item, keyLevel);
    } else if (typeof item === "object" && item !== null) {
      // Decrypt objects in the array
      return decryptObject(item, keyLevel);
    } else if (typeof item === "string" && keyLevel["value"]) {
      // Decrypt string items
      return decrypt(item);
    } else {
      // Leave other values unchanged
      return item;
    }
  });
};

/**
 * Function to encrypt a password first with md5 and then with bcrypt.
 * @param {*} password - Password to encrypt
 * @returns {Promise<string>} - Encrypted password hash
 */
const encryptPassword = async (password) => {
  // First encryption with md5 then Second encryption with bcrypt
  const saltRounds = 10;
  const bcryptHash = await bcrypt.hash(md5(password), saltRounds);
  return bcryptHash;
};

/**
 * Function to verify a password against a bcrypt hash.
 * @param {*} password - Password to verify
 * @param {*} bcryptHash - Hashed password stored in bcrypt
 * @returns {boolean} - true if password matches bcryptHash, false otherwise
 */
const verifyPassword = async (password, bcryptHash) => {
  // Encrypt the password with md5 and compare it with the stored bcrypt hash
  const isBcryptMatch = await bcrypt.compare(md5(password), bcryptHash);
  return isBcryptMatch;
};

/**
 *
 * @param {*} sizeInBytes
 * @returns Formeted file size
 */
function formatFileSize(sizeInBytes) {
  if (sizeInBytes === 0) return "-";

  const sizes = ["Bytes", "KB", "MB", "GB"];
  let i = 0;
  let size = sizeInBytes;

  while (size >= 1024 && i < sizes.length - 1) {
    size /= 1024;
    i++;
  }

  return `${size.toFixed(2)} ${sizes[i]}`;
}

/**
 * Makes an API call using Axios.
 *
 * @param {Object} data - The input data object containing API request details.
 * @param {string} data.url - The URL to make the API request to.
 * @param {string} [data.method='GET'] - The HTTP method (GET, POST, PUT, DELETE, etc.). Defaults to 'GET'.
 * @param {Object} [data.body=null] - The request body, typically used for POST, PUT requests.
 * @param {Object} [data.headers={'Content-Type': 'application/json'}] - The headers to include in the request. Defaults to JSON content type if not provided.
 *
 * @returns {Promise<Object>} - The response data from the API.
 *
 * @throws {Error} - Throws an error if the API request fails.
 */
async function callApi(data) {
  const {
    url,
    method = "GET",
    body = null,
    headers = { "Content-Type": "application/json" },
  } = data;

  try {
    const options = {
      url: url,
      method: method,
      headers: headers,
      data: body,
    };
    const response = await axios(options);
    return response.data;
  } catch (error) {
    console.error("Error calling API:", error.message);
    throw error;
  }
}

/**
 * Converts a comma-separated string into an array,
 * filters out null, undefined, or empty string elements.
 *
 * @param {string} strings - The input string containing comma-separated values.
 * @returns {Array} - The filtered array of non-empty values.
 */
const commToArr = (strings) => {
  var array = (strings || "").trim().split(",");
  var filtered = array.filter(function (el) {
    return el !== null && el !== undefined && el !== "";
  });
  return filtered;
};

/**
 * Converts an array into a comma-separated string.
 * If the input is not a valid array or is empty, returns a default value (empty string).
 *
 * @param {Array} arr - The input array.
 * @returns {string} - The comma-separated string or empty string if invalid.
 */
const arrToComma = (arr) => {
  try {
    // Check if the input is a valid array
    if (!Array.isArray(arr)) {
      return "";
    }

    // Return the comma-separated string or default empty string if the array is empty
    return arr.length > 0 ? arr.toString() : "";
  } catch (error) {
    console.error(error); // Optionally log the error
    return ""; // Return an empty string if an error occurs
  }
};

/**
 * Adds increments of days, months, or years to a given date.
 *
 * @param {Object} data - An object containing the date and increments.
 * @param {string} data.date - The date in the format 'YYYY-MM-DD'.
 * @param {Array} data.increments - An array of increments where each increment is an array
 *                                   containing the count and the type (day, month, or year).
 *                                   The type can be in any case and may or may not end with 's'.
 *
 * @returns {string} - The resulting date in the format 'YYYY-MM-DD'.
 */
function addDateIncrement(data) {
  let date = new Date(data.date);

  // Iterate over each increment
  data.increments.forEach((increment) => {
    let [count, type] = increment;

    if (typeof count !== "number" || isNaN(count) || count < 0) {
      return;
    }

    // Normalize the type: convert to lowercase and remove 's'
    type = type.toLowerCase().replace(/s$/, "");

    // Apply increments based on normalized type
    switch (type) {
      case "day":
        date.setDate(date.getDate() + count);
        break;
      case "month":
        date.setMonth(date.getMonth() + count);
        break;
      case "year":
        date.setFullYear(date.getFullYear() + count);
        break;
      default:
        console.log("Unknown increment type:", type);
    }
  });

  // Format the result back to YYYY-MM-DD
  const year = date.getFullYear();
  const month = ("0" + (date.getMonth() + 1)).slice(-2);
  const day = ("0" + date.getDate()).slice(-2);

  return `${year}-${month}-${day}`; // Return in YYYY-MM-DD format
}

/**
 * decryptRequest middleware function to decrypt the request body based on the eLevel header.
 * - Checks if the `eLevel` header is present.
 * - If the `eLevel` header is missing, returns an error response.
 * - Decrypts the request body using a decryption function based on the provided `eLevel`.
 * - Passes the decrypted body to the next middleware or route handler.
 * - If an error occurs during decryption, returns an error response.
 *
 * @param {Object} req - The HTTP request object.
 * @param {Object} res - The HTTP response object.
 * @param {Function} next - The next middleware function to pass control to.
 */
const decryptRequest = (req, res, next) => {
  const elevel = req.headers.elevel || "0";
  if (!elevel) {
    return errorResponse(res, "eLevel required");
  }

  if (req.url == "/login" || req.url == "/auth/login") {
    return next();
  }

  try {

    // ✅ Only decrypt if body exists and has keys
    if (req.body && Object.keys(req.body).length > 0) {
      const decryptedBody = decryptObject(req.body, eLevel(elevel));
      req.body = decryptedBody;
    }

    next();
  } catch (error) {
    errorResponse(res, "Something Went Wrong", error);
  }
};

/**
 * validate middleware function to validate the request body against a provided schema.
 * - Validates the request body using the provided Joi schema.
 * - If validation fails, returns an error response with the validation error message.
 * - If validation passes, calls the next middleware function.
 *
 * @param {Object} schema - The Joi schema to validate the request body.
 * @returns {Function} Middleware function that validates the request body.
 */
const validate = (schema) => (req, res, next) => {
  const { error } = schema.validate(req.body);
  if (error) {
    const message = error.details.map((i) => i.message).join(",");
    console.log("error", message);
    errorResponse(res, message);
  } else {
    next();
  }
};

/**
 * Function to print all routes of project
 * @param {*} app
 */
function printPaths(app) {
  const split = (thing) => {
    if (typeof thing === "string") {
      return thing.split("/");
    } else if (thing.fast_slash) {
      return "";
    } else {
      const match = thing
        .toString()
        .replace("\\/?", "")
        .replace("(?=\\/|$)", "$")
        .match(/^\/\^((?:\\[.*+?^${}()|[\]\\]|[^.*+?^${}()|[\]\\])*)\$\//);
      return match
        ? match[1].replace(/\\(.)/g, "$1").split("/")
        : `<complex:${thing.toString()}>`;
    }
  };

  const print = (path, layer) => {
    if (layer.route) {
      layer.route.stack.forEach((subLayer) =>
        print(path.concat(split(layer.route.path)), subLayer)
      );
    } else if (layer.name === "router" && layer.handle.stack) {
      layer.handle.stack.forEach((subLayer) =>
        print(path.concat(split(layer.regexp)), subLayer)
      );
    } else if (layer.method) {
      console.log(
        "%s /%s",
        layer.method.toUpperCase(),
        path.concat(split(layer.regexp)).filter(Boolean).join("/")
      );
    }
  };

  app._router.stack.forEach((layer) => print([], layer));
}

/**
 * Loop through all dates between a start and end date.
 *
 * @param {Date} startDate - The start date.
 * @param {Date} endDate - The end date.
 * @param {Function} callback - A function to execute for each date.
 *
 * @example
 * const startDate = new Date('2024-12-01');
 * const endDate = new Date('2024-12-05');
 *
 * loopThroughDates(startDate, endDate, (date) => {
 *   console.log(date.toISOString().split('T')[0]); // Logs each date in 'YYYY-MM-DD' format
 * });
 */
function loopThroughDates(startDate, endDate, callback) {
  let currentDate = new Date(startDate);

  while (currentDate <= endDate) {
    callback(new Date(currentDate)); // Pass the current date to the callback
    currentDate.setDate(currentDate.getDate() + 1); // Increment by one day
  }
}

/**
 * This function removes specified keys from an object.
 *
 * @param {Object} obj - The object to remove keys from.
 * @param {Array<string>} keysToRemove - The array of keys to remove from the object.
 * @returns {Object} - A new object with the specified keys removed.
 */
function removeKeysFromObject(obj, keysToRemove) {
  if (typeof obj !== "object" || obj === null) {
    throw new TypeError("First argument must be a non-null object.");
  }

  if (!Array.isArray(keysToRemove)) {
    throw new TypeError("Second argument must be an array of keys.");
  }

  // Create a shallow copy of the object
  const newObj = { ...obj };

  // Remove specified keys
  keysToRemove.forEach((key) => {
    delete newObj[key];
  });

  return newObj;
}

/**
 * Builds a Map-like object with a specified key from the input items.
 * Each key corresponds to a single object from the input array.
 *
 * @param {Array} items - Array of objects to process.
 * @param {string} key - The key in each object used to group the data.
 * @returns {Object} An object where each key is derived from the specified key
 *                   in the items, and its value is the corresponding object.
 *
 * @example
 * const items = [{ date: '2023-01-01', value: 1 }, { date: '2023-01-02', value: 2 }];
 * const result = buildObjectMap(items, 'date');
 * // Output: { '2023-01-01': { date: '2023-01-01', value: 1 }, '2023-01-02': { date: '2023-01-02', value: 2 } }
 */
const buildObjectMap = (items, key) =>
  items.reduce((acc, item) => {
    const k = item[key];
    if (k !== undefined) {
      acc[k] = acc[k] || [];
      acc[k] = item;
    }
    return acc;
  }, {});

/**
 * Builds a Map-like object with a specified key from the input items.
 * Each key corresponds to an array of objects that share the same key value.
 *
 * @param {Array} items - Array of objects to process.
 * @param {string} key - The key in each object used to group the data.
 * @returns {Object} An object where each key is derived from the specified key
 *                   in the items, and its value is an array of matching objects.
 *
 * @example
 * const items = [{ date: '2023-01-01', value: 1 }, { date: '2023-01-01', value: 2 }];
 * const result = buildArrayMap(items, 'date');
 * // Output: { '2023-01-01': [{ date: '2023-01-01', value: 1 }, { date: '2023-01-01', value: 2 }] }
 */
const buildArrayMap = (items, key) =>
  items.reduce((acc, item) => {
    const k = item[key];
    if (k !== undefined) {
      acc[k] = acc[k] || [];
      acc[k].push(item);
    }
    return acc;
  }, {});

/**
 * Filters an object based on the allowed keys array.
 * @param {Object} obj - The object to be filtered.
 * @param {Array} allowedKeys - An array of allowed keys that should be included in the filtered object.
 * @param {Object} [defaultValue={}] - The default value to return in case of an error or if no allowed keys are found.
 * @returns {Object} - The filtered object containing only the allowed keys.
 */
function filterObject(obj, allowedKeys, defaultValue = {}) {
  try {
    // If no object or allowedKeys array is provided, return the default value
    if (!obj || !Array.isArray(allowedKeys)) {
      return defaultValue;
    }

    // Filter the object based on allowed keys
    return Object.keys(obj)
      .filter((key) => allowedKeys.includes(key)) // Only keep keys that are in the allowedKeys array
      .reduce((filteredObj, key) => {
        filteredObj[key] = obj[key];
        return filteredObj;
      }, {});
  } catch {
    // In case of any error, return the default value
    return defaultValue;
  }
}

/**
 * -for generate otp
 * @param {Number} length -which length of otp to generate
 * @returns {String} -return string that contain otp
 */
function generateOTP(length = 6) {
  var digits = "0123456789";
  let OTP = "";
  for (let i = 0; i < length; i++) {
    OTP += digits[Math.floor(Math.random() * 10)];
  }
  return OTP;
}

/**
 * Cleans an array or object by replacing `null`, `undefined`, and optionally `0` with an empty string.
 * @param {any} input - The input object or array to clean.
 * @param {boolean} changeZero - Whether to replace `0` with an empty string. Default is true.
 * @returns {any} - The cleaned object or array.
 */

const cleanArrayObjectv2 = (input, changeZero = true) => {
  if (Array.isArray(input)) {
    return input.map((item) => cleanArrayObjectv2(item, changeZero));
  } else if (typeof input === "object" && input !== null) {
    Object.keys(input).forEach((key) => {
      if (changeZero && input[key] === 0) {
        input[key] = ""; // Change only 0 to "" when changeZero is true
      } else if (input[key] == null) {
        input[key] = ""; // Convert null/undefined to ""
      } else if (typeof input[key] === "string") {
        input[key] = cleanString(input[key]);
      } else if (typeof input[key] === "object") {
        input[key] = cleanArrayObjectv2(input[key], changeZero); // Recursively clean nested objects/arrays
      }
    });
  }
  return input;
};

module.exports = {
  successResponse,
  successResponsev2,
  errorResponse,
  cleanString,
  replaceAll,
  getBlobUrl,
  validateData,
  ucFirst,
  capitalize,
  cleanObject,
  encryptPassword,
  verifyPassword,
  decrypt,
  encrypt,
  encryptObject,
  encryptArrayOfObjects,
  decryptObject,
  decryptArrayOfObjects,
  eLevel,
  writeFile,
  cleanArrayOfObjects,
  formatFileSize,
  printPaths,
  callApi,
  commToArr,
  arrToComma,
  addDateIncrement,
  decryptRequest,
  validate,
  loopThroughDates,
  removeKeysFromObject,
  buildObjectMap,
  buildArrayMap,
  filterObject,
  generateOTP,
  cleanArrayObjectv2,
};
