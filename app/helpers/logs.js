const morgan = require('morgan');
const fs = require('fs');
const path = require('path');

/*global __dirname*/

// Function to sanitize sensitive data
const sanitize = (data, seen = new WeakSet()) => {
  // Check if the data is an object and not null
  if (typeof data === 'object' && data !== null) {
    // Check for circular references
    if (seen.has(data)) {
      return '[CIRCULAR REFERENCE]'; // Handle circular reference
    }
    // Add the object to the set of seen objects
    seen.add(data);
    const sanitizedData = Array.isArray(data) ? [] : {};
    Object.keys(data).forEach((key) => {
      const value = data[key];
      if (value instanceof Date) {
        sanitizedData[key] = value.toISOString(); // Convert Date to string
      } else if (typeof value === 'object') {
        sanitizedData[key] = sanitize(value, seen); // Recursively sanitize nested objects
      } else {
        sanitizedData[key] = value; // Copy other values
      }
    });
    // Filter the password field
    if (sanitizedData.password) {
      sanitizedData.password = '[FILTERED]';
    }
    return sanitizedData; // Return the sanitized data
  }
  return data; // Return non-object data as is
};

const accessLog = () => {
  // Function to create the logs directory if it doesn't exist
  const createLogsDirectory = () => {
    const logsDir = path.join(__dirname, '../../logs/');
    if (!fs.existsSync(logsDir)) {
      fs.mkdirSync(logsDir);
    }
    const accessLogsDir = path.join(logsDir, 'access/');
    if (!fs.existsSync(accessLogsDir)) {
      fs.mkdirSync(accessLogsDir);
    }
    return accessLogsDir;
  };

  // Function to create a write stream for the log file within the logs directory
  const createAccessLogStream = () => {
    const logsDir = createLogsDirectory();
    const logFileName = getLogFileName();
    return fs.createWriteStream(path.join(logsDir, logFileName), { flags: 'a' });
  };

  const getLogFileName = () => {
    const now = new Date();
    const options = {
      timeZone: 'Asia/Kolkata',
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
    };

    const formatter = new Intl.DateTimeFormat('en-US', options);
    const formattedDate = formatter.format(now);
    const [month, day, year] = formattedDate.split('/');

    return `Access_${day}-${month}-${year}.log`;
  };

  // Middleware to capture the response body
  const captureResponseBody = (req, res, next) => {
    const originalSend = res.send;
    let responseBody = '';

    res.send = function (body) {
      responseBody = body;
      res.locals.responseBody = body; // Store the response body in res.locals
      return originalSend.call(this, body);
    };

    res.on('finish', () => {
      res.locals.responseBody = responseBody;
    });
    next();
  };

  const setupMorganLogger = () => {
    const accessLogStream = createAccessLogStream();
    morgan.token('timestamp', () => new Date().toISOString());
    morgan.token('req-params', (req) => JSON.stringify(req.params));
    morgan.token('req-body', (req) => JSON.stringify(sanitize(req.body)));
    morgan.token('req-query', (req) => JSON.stringify(req.query));
    morgan.token('res-body', (req, res) => JSON.stringify(res.locals.responseBody));
    // morgan.token('log-data', (req, res) => getAllLogData(req, res));
    morgan.token('ip', (req, res) => req.headers['x-forwarded-for'] || req.socket.remoteAddress);

    const customFormat = '[:timestamp] :ip :method :url :status :response-time ms - res-content-length :res[content-length] res-params :req-body';
    return morgan(customFormat, { stream: accessLogStream });
  };

  // Return the middleware functions to be used in app.use
  return [
    captureResponseBody,
    setupMorganLogger()
  ];
};

// Function to setup the error logger
const errorLog = (res, error, message, status) => {
  // Function to create the logs directory if it doesn't exist
  const createLogsDirectory = () => {
    const logsDir = path.join(__dirname, '../../logs/');
    if (!fs.existsSync(logsDir)) {
      fs.mkdirSync(logsDir);
    }
    const errorLogsDir = path.join(logsDir, 'error/');
    if (!fs.existsSync(errorLogsDir)) {
      fs.mkdirSync(errorLogsDir);
    }
    return errorLogsDir;
  };

  // Function to create a write stream for the log file within the logs directory
  const createErrorLogStream = () => {
    const logsDir = createLogsDirectory();
    const logFileName = getLogFileName();
    return fs.createWriteStream(path.join(logsDir, logFileName), { flags: 'a' });
  };

  const getLogFileName = () => {
    const now = new Date();
    const options = {
      timeZone: 'Asia/Kolkata',
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
    };

    const formatter = new Intl.DateTimeFormat('en-US', options);
    const formattedDate = formatter.format(now);
    const [month, day, year] = formattedDate.split('/');

    return `Error_${day}-${month}-${year}.log`;
  };

  // Setup the error logger middleware
  const errorLogStream = createErrorLogStream();

  // Extracting information from res
  // const ip = res.socket.remoteAddress;
  var ip;
  if (res.req != undefined) {
    var method = res.req.method;
    ip = res.req.headers['x-forwarded-for'] || res.req.socket.remoteAddress
  } else {
    var method = res.method;
  }
  if (res.req != undefined) {
    var body = JSON.stringify(sanitize(res.req.body));
  } else {
    var body = JSON.stringify({});
  }

  // Constructing the log message
  const errorLogMessage = `[${new Date().toISOString()}] IP: ${ip} - Method: ${method} - Body: ${body} - Message: ${message} - Status: ${status} - Error: ${error.stack}\n`;

  // Writing log message to the error log file
  errorLogStream.write(errorLogMessage);
  return true;
};

module.exports = {
  accessLog,
  errorLog
};
