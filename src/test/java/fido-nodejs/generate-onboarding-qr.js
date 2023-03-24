const { AES } = require('crypto-js');

const secret = '053f23c4d560fb8f9229f686dd328824df2b634db9eb748f44c9ccc36ec2f1980a78fcfada738e4bf6ce6be782864745';
const userId = process.argv[2];
const data = {
  userId,
  expireAt: '2024-02-07T01:11:29.426Z',
  type: 'ON_BOARDING',
};

const encryptedData = AES.encrypt(
  JSON.stringify(data),
  secret,
).toString();

console.log(encryptedData);
