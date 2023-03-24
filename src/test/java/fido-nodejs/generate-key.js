const { generateKeyPairSync } = require("crypto");

const { publicKey, privateKey } = generateKeyPairSync("rsa", {
  modulusLength: 2048,
});

const exportedPrivateKeyBuffer = privateKey.export({ type: 'pkcs1', format: 'pem' });
const exportedPublicKeyBuffer = publicKey.export({ type: 'pkcs1', format: 'pem' });

const result = {
  privateKey: exportedPrivateKeyBuffer.toString(),
  publicKey: exportedPublicKeyBuffer.toString(),
};
console.log(JSON.stringify(result));

return result;
