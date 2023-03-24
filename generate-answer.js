const { createHash, createSign } = require('crypto');
const {EOL} = require('os');

const toArrayBuffer = (buf, name) => {
  if (!name) {
    throw new TypeError('name not specified');
  }

  if (typeof buf === 'string') {
    buf = buf.replace(/-/g, '+').replace(/_/g, '/');
    buf = Buffer.from(buf, 'base64');
  }

  if (buf instanceof Buffer || Array.isArray(buf)) {
    buf = new Uint8Array(buf);
  }

  if (buf instanceof Uint8Array) {
    buf = buf.buffer;
  }

  if (!(buf instanceof ArrayBuffer)) {
    throw new TypeError(`could not convert '${name}' to ArrayBuffer`);
  }

  return buf;
};

const privateKey = process.argv[2].replaceAll("\\n", EOL);
const challenge = process.argv[3];

const challengeBase64 = Buffer.from(challenge, 'utf8').toString('base64');
const clientDataJSON =  Buffer.from(`{"type":"webauthn.get","challenge":"${challengeBase64}","origin":"https:\/\/rakkar.com"}`, 'utf8').toString('base64');

const challengeAnswerJSON = {
  response: {
    signature: '',
    authenticatorData: '',
    clientDataJSON,
  }
};

const rawAuthnrData = toArrayBuffer(
  challengeAnswerJSON.response.authenticatorData,
  'authenticatorData',
);
const rawClientData = toArrayBuffer(
  challengeAnswerJSON.response.clientDataJSON,
  'clientDataJSON',
);
const hash = createHash('SHA256');
hash.update(Buffer.from(new Uint8Array(rawClientData)));
const clientDataHashBuf = hash.digest();
const clientDataHash = new Uint8Array(clientDataHashBuf).buffer;

const sign = createSign('SHA256');
sign.write(Buffer.from(new Uint8Array(rawAuthnrData)));
sign.write(Buffer.from(new Uint8Array(clientDataHash)));
challengeAnswerJSON.response.signature = sign.sign(privateKey).toString('base64');

const result = JSON.stringify(challengeAnswerJSON);

// JMETER receive data from console output
console.log(result);