const { exec } = require("child_process");
const path = require("path");
const fs = require("fs-extra");
/*global process*/

const pgDumpPath =
  process.env.IS_LIVE == 1
    ? "/usr/bin/pg_dump"
    : '"C:\\Program Files\\PostgreSQL\\16\\bin\\pg_dump"';

// Function to perform a database backup with a year/month/day folder structure
async function backupDatabase() {
  const tablesToExclude = ["accesshistory", "actionhistory"];
  try {
    const currentDate = new Date();
    const year = currentDate.getFullYear();
    const month = String(currentDate.getMonth() + 1).padStart(2, "0"); // Add leading zero for month
    const day = String(currentDate.getDate()).padStart(2, "0"); // Add leading zero for day
    // Create the backup directory structure (e.g., backup/2024/11)
    const projectRoot = process.cwd();
    const backupDir = path.join(projectRoot, "backup", year.toString(), month);
    await fs.ensureDir(backupDir); // Ensure the directory exists or create it

    // Define the backup file name with the day (e.g., "01-11-2024.sql" for 1st day)
    const backupFile = path.join(
      backupDir,
      `${day}-${month}-${year}_ADMIN.sql`
    );

    // Build the pg_dump command with exclusions for each table
    const excludeTablesCommand = tablesToExclude
      .map((table) => `--exclude-table=${table}`)
      .join(" ");

    // Create the `pg_dump` command to execute
    const backupCommand = `${pgDumpPath} -U ${process.env.NAGILWAR_DB_USER} -h ${process.env.NAGILWAR_DB_HOST} -p ${process.env.NAGILWAR_DB_PORT} --inserts ${excludeTablesCommand} -f "${backupFile}" ${process.env.NAGILWAR_DB_NAME}`;

    // Execute the command
    exec(
      backupCommand,
      { env: { PGPASSWORD: process.env.NAGILWAR_DB_PASSWORD } },
      (error, stdout, stderr) => {
        if (error) {
          console.error(`Error during backup: ${error.message}`);
          return;
        }

        if (stderr) {
          console.error(`Backup stderr: ${stderr}`);
          return;
        }
        console.log("Admin Database backup completed successfully!");
      }
    );
  } catch (error) {
    console.error(`Failed to create backup: ${error.message}`);
  }
}

module.exports = {
  backupDatabase,
};
