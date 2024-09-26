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

function decryptAES_GCM(encryptedData, userId, secretKey) {
  // if (isEmpty(encryptedData) || isEmpty(secretKey) || isEmpty(userId)) {
  //   throw new Error('Invalid inputs');
  // }
  let result = '';
  // console.log(`MOB-99 ${encryptedData} \t userId: ${userId}\t secretKey: ${secretKey}`);
  // AES 256 with GCM mode
  const algorithm = 'aes-256-gcm';
  const ivString = extractIvStringFromUserId(userId);
  const extractResult = aesGcmExtractCiphertextAuthTag(encryptedData);
  // console.log(`MOB-99 ivString: ${ivString}\t extractREsult: ${JSON.stringify(extractResult, null, 2)}`);
  const keyBuffer = Buffer.from(secretKey, 'utf-8');
  const ivBuffer = Buffer.from(ivString, 'utf-8');
  const decipher = crypto.createDecipheriv(algorithm, keyBuffer, ivBuffer, {
    authTagLength: 16,
  });
  decipher.setAuthTag(Buffer.from(extractResult.authTag, 'hex'));
  result = decipher.update(
    Buffer.from(extractResult.ciphertext, 'base64'),
    undefined,
    'utf-8',
  );
  // console.log(`MOB-99 result: ${result}`);
  return result;
} 

function aesGcmExtractCiphertextAuthTag(encryptedString) {
  const authTagLength = 16;
  const encryptedBuffer = Buffer.from(encryptedString, 'base64');
  const ciphertextBuffer = encryptedBuffer.subarray(
    0,
    encryptedBuffer.length - authTagLength + 1,
  );
  const authTagBuffer = encryptedBuffer.subarray(encryptedBuffer.length - 16);

  const ciphertext = ciphertextBuffer.toString('base64');
  const authTag = authTagBuffer.toString('hex');

  return { ciphertext, authTag };
}

function extractIvStringFromUserId(userId) {
  const ivString = userId.replace(/-/g, '').substring(0, 16) || '';
  return ivString;
}

function hmacSHA512(bodyPasscode, salt, passcode){
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
  // const bodyPasscode = process.argv[3];
  // const salt = process.argv[4];
  // const passcode = process.argv[5];
  
  // const sHA512 = hmacSHA512(bodyPasscode, salt, passcode);
  // console.log(sHA512);
  // sol0Pr/IWM7nHS3zO725esIFrBBx
  const encryptedData = 'ttsJ70UxH5FZPLbA3yvThDAO25V5';
  const userId = '8a229e6e-f688-4d8a-9ba4-c359d95772cd';
  const secretKey = 'MIIBCgKCAQEAniN5htNE5JBVkA5M3Tfi';
  var bodyPasscode = decryptAES_GCM(encryptedData, userId, secretKey );

  console.log(bodyPasscode);
}
