const crypto = require('crypto');

function encryptAES(data, secretKey, iv) {

  // Create a cipher
  const cipher = crypto.createCipheriv('aes-256-gcm', Buffer.from(secretKey), iv, {
    authTagLength: 15 // 120 bits = 15 bytes
  });

  // Encrypt the data
  let encrypted = cipher.update(data);
  encrypted = Buffer.concat([encrypted, cipher.final()]);

  // Get the authentication tag
  const tag = cipher.getAuthTag();

  // Return the encrypted data (IV + ciphertext)
  return encrypted.toString('base64') + tag.toString('base64'); 
}

const dataToEncrypt = process.argv[2];
const secretKey = process.argv[3];
const iv = process.argv[4];

const encryptedData = encryptAES(dataToEncrypt, secretKey, iv);
console.log(encryptedData); 