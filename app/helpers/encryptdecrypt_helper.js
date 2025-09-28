const bcrypt = require('bcrypt');
const md5 = require('md5');
/**
 * CUSTOM ENCRYPTION AND DECRYPTION FUNCTIONS
 * @param {*} password
 * @returns
 */

// Function to encrypt the password first with md5 and then with bcrypt
const encryptPassword = async (password) => {
  // Second encryption with bcrypt
  const saltRounds = 10;
  const bcryptHash = await bcrypt.hash(md5(password), saltRounds);
  return bcryptHash;
};

// Function to verify the password
const verifyPassword = async (password, bcryptHash) => {
  // First, decrypt the bcrypt hash to get the md5 hash
  const isBcryptMatch = await bcrypt.compare(md5(password), bcryptHash);
  if (!isBcryptMatch) {
    return false;
  }
  return true;
};

module.exports = {
  encryptPassword,
  verifyPassword,
}
