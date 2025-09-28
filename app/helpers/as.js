/**
 * Encrypts text using XOR + Base64.
 * @param {string} text - The plaintext to encrypt.
 * @returns {string} - Encrypted text (Base64 format).
 */
const encrypt = text => {
  let encrypted = '';
  for (let i = 0; i < text.length; i++) {
    encrypted += String.fromCharCode(
      text.charCodeAt(i) ^ process.env.ENCRYPT_SECURITY_KEY.charCodeAt(i % process.env.ENCRYPT_SECURITY_KEY.length),
    );
  }
  return CryptoJS.enc.Base64.stringify(CryptoJS.enc.Latin1.parse(encrypted));
};

/**
 * Decrypts Base64 + XOR encrypted text.
 * @param {string} encryptedText - The encrypted text in Base64 format.
 * @returns {string} - Decrypted plaintext.
 */
const decrypt = encryptedText => {
  const decoded = CryptoJS.enc.Base64.parse(encryptedText).toString(CryptoJS.enc.Latin1);
  let decrypted = '';
  for (let i = 0; i < decoded.length; i++) {
    decrypted += String.fromCharCode(
      decoded.charCodeAt(i) ^ process.env.ENCRYPT_SECURITY_KEY.charCodeAt(i % process.env.ENCRYPT_SECURITY_KEY.length),
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
const encryptData = (data, keyLevel) => {
  // If data is not an object/array, return as is.
  if (data === null || typeof data !== 'object') return data;

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
          copy[i] = isValueEncrypted ? encrypt(item.toISOString()) : item.toISOString();
        } else if (item !== null && typeof item === 'object') {
          const newObj = {};
          copy[i] = newObj;
          stack.push({ orig: item, copy: newObj });
        } else if (typeof item === 'string') {
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
            copy[newKey] = isValueEncrypted ? encrypt(val.toISOString()) : val.toISOString();
          } else if (val !== null && typeof val === 'object') {
            const newObj = {};
            copy[newKey] = newObj;
            stack.push({ orig: val, copy: newObj });
          } else if (typeof val === 'string') {
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
 * Decrypts an object or array based on provided decryption levels.
 * @param {object|Array} data - The encrypted object or array to decrypt
 * @param {object} keyLevel - Decryption level object with 'key' and 'value' properties
 * @returns {object|Array} - Decrypted result
 */
const decryptData = (data, keyLevel) => {
  // If data is not an object/array, return as is.
  if (data === null || typeof data !== 'object') return data;

  const { key: isKeyEncrypted, value: isValueEncrypted } = keyLevel;

  // Create the root container depending on data type.
  const root = Array.isArray(data) ? [] : {};
  // Stack items: { orig: encrypted data, copy: new container }
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
        } else if (typeof item === 'string') {
          copy[i] = isValueEncrypted ? decrypt(item) : item;
        } else if (item !== null && typeof item === 'object') {
          const newObj = {};
          copy[i] = newObj;
          stack.push({ orig: item, copy: newObj });
        } else {
          copy[i] = item;
        }
      }
    } else {
      // Process object properties.
      for (const origKey in orig) {
        if (Object.prototype.hasOwnProperty.call(orig, origKey)) {
          // Decrypt the key if required.
          const newKey = isKeyEncrypted ? decrypt(String(origKey)) : origKey;
          const val = orig[origKey];

          if (Array.isArray(val)) {
            const newArr = [];
            copy[newKey] = newArr;
            stack.push({ orig: val, copy: newArr });
          } else if (typeof val === 'string') {
            copy[newKey] = isValueEncrypted ? decrypt(val) : val;
          } else if (val !== null && typeof val === 'object') {
            const newObj = {};
            copy[newKey] = newObj;
            stack.push({ orig: val, copy: newObj });
          } else {
            copy[newKey] = val;
          }
        }
      }
    }
  }

  return root;
};
