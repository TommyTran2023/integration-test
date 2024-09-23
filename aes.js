const crypto = require('crypto');
const { HmacSHA512 } = require('crypto-js');

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

function decryptAES_GCM(encryptedData, secretKey) {
  // Split the encrypted data into its components
  const [ivHex, ciphertextHex, tagHex] = encryptedData.split(':');

  // Convert hex strings back to Buffers
  const iv = Buffer.from(ivHex, 'hex');
  const ciphertext = Buffer.from(ciphertextHex, 'hex');
  const tag = Buffer.from(tagHex, 'hex');

  // Create a decipher with GCM mode and the authentication tag
  const decipher = crypto.createDecipheriv('aes-256-gcm', Buffer.from(secretKey), iv, {
    authTagLength: 15 // 120 bits = 15 bytes
  });
  decipher.setAuthTag(tag);

  // Decrypt the data
  let decrypted = decipher.update(ciphertext);
  decrypted = Buffer.concat([decrypted, decipher.final()]);

  // Return the decrypted data as a string
  return decrypted.toString();
}

function hmacSHA512(bodyPasscode, salt, passcode){
  console.log(bodyPasscode);
  console.log(salt);
  console.log(passcode);
  console.log(HmacSHA512(bodyPasscode, salt).toString());

  return HmacSHA512(bodyPasscode, salt).toString() === passcode;
}

if (process.argv[2] == 'encrypt'){
  const dataToEncrypt = process.argv[3];
  const secretKey = process.argv[4];
  const iv = process.argv[5];
  
  const encryptedData = encryptAES(dataToEncrypt, secretKey, iv);
  console.log(encryptedData); 
}
else {
  const bodyPasscode = process.argv[3];
  const salt = process.argv[4];
  const passcode = process.argv[5];
  
  hmacSHA512(bodyPasscode, salt, passcode);
}
