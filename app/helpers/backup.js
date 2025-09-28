const cron = require("node-cron");
const fs = require("fs");
const path = require("path");
const { exec } = require("child_process");
require("dotenv").config();

// PostgreSQL credentials
const dbConfig = {
  host: process.env.TUITION_DB_HOST,
  user: process.env.TUITION_DB_USER,
  password: process.env.TUITION_DB_PASSWORD,
  database: process.env.TUITION_DB_NAME,
  port: process.env.TUITION_DB_PORT,
};

// Backup directory

const backupDir = path.join(__dirname, "../databasebackup");
console.log(backupDir);

if (!fs.existsSync(backupDir)) {
  fs.mkdirSync(backupDir, { recursive: true });
}

// Function to perform the backup

const backupDatabase = () => {
  const timestamp = new Date().toISOString().replace(/:/g, "-");
  const backupFile = path.join(backupDir, `${timestamp}.sql`);
  const command = `"F:\\Software\\postgrs\\bin\\pg_dump.exe" -h ${dbConfig.host} -p ${dbConfig.port} -U ${dbConfig.user} --column-inserts ${dbConfig.database} > "${backupFile}"`;

  exec(
    command,
    { env: { PGPASSWORD: dbConfig.password } },
    (error, stdout, stderr) => {
      if (error) {
        console.error("Error during backup:", error);
        return;
      }
      if (stderr) {
        console.error("Backup stderr:", stderr);
        return;
      }
      console.log(`Backup successful: ${backupFile}`);
    }
  );
};
// Function to terminate database connections
const terminateConnections = () => {
  return new Promise((resolve, reject) => {
    const command = `"F:\\Software\\postgrs\\bin\\psql.exe" -h ${dbConfig.host} -p ${dbConfig.port} -U ${dbConfig.user} -d postgres -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '${dbConfig.database}' AND pid <> pg_backend_pid();"`;

    exec(
      command,
      { env: { PGPASSWORD: dbConfig.password } },
      (error, stdout, stderr) => {
        if (error) {
          console.error("Error terminating connections:", error);
          reject(error);
          return;
        }
        console.log("Active connections terminated");
        resolve();
      }
    );
  });
};

// Function to restore the database into existing database
const restoreDatabase = (backupFileName) => {
  return new Promise(async (resolve, reject) => {
    const backupFilePath = path.join(backupDir, backupFileName);
    if (!fs.existsSync(backupFilePath)) {
      console.error(`Backup file not found: ${backupFilePath}`);
      reject(new Error(`Backup file ${backupFileName} does not exist`));
      return;
    }

    const restoreCommand = `"F:\\Software\\postgrs\\bin\\psql.exe" -h ${dbConfig.host} -p ${dbConfig.port} -U ${dbConfig.user} ${dbConfig.database} < "${backupFilePath}"`;

    try {
      // Terminate existing connections to ensure clean restore
      await terminateConnections();

      // Restore directly into existing database
      await new Promise((res, rej) => {
        exec(
          restoreCommand,
          { env: { PGPASSWORD: dbConfig.password } },
          (restoreError, stdout, stderr) => {
            if (restoreError) {
              console.error("Error during restore:", restoreError);
              rej(restoreError);
              return;
            }
            if (stderr) {
              console.error("Restore stderr:", stderr);
            }
            console.log(
              `Database restored successfully from: ${backupFilePath}`
            );
            res();
          }
        );
      });

      resolve(`Database restored successfully from: ${backupFileName}`);
    } catch (error) {
      reject(error);
    }
  });
};

// Schedule daily backup at midnight
// cron.schedule("0 0 * * *", () => {
//   console.log("Starting database backup...");
//   backupDatabase();
// });

// Restore database
// restoreDatabase('2025-09-28T08-00-52.361Z.sql')
//   .then((message) => console.log(message))
//   .catch((error) => console.error('Restore failed:', error));

// Export functions
module.exports = {
  backupDatabase,
};
