const puppeteer = require('puppeteer');

(async () => {
  // Launch the browser and open a new blank page
  const browser = await puppeteer.launch({ headless: false });
  const page = await browser.newPage();

  // Navigate the page to a URL
  await page.goto('https://app.figment.io/');

  // Set screen size
  await page.setViewport({width: 1080, height: 1024});

  // Enter login email, password
  const e = "tommy.tran@rakkardigital.com";
  const p = "Tommy.rakkar.2024";
  const txtE = '#username';
  const txtP = '#password';
  const btnSubmit = "button[type='submit']";
  await page.waitForSelector(btnSubmit);
  await page.type(txtE, e);
  await page.type(txtP, p);
  await page.click(btnSubmit);

  // Select organization
  const btnOrganization = "form > button[type='submit']"
  await page.waitForSelector(btnOrganization);
  await page.click(btnOrganization);

  //Select Test mode
  // Click on Stake
  const btnTestnet = "a[href='/stake']";
  await page.waitForNavigation();
  await page.waitForSelector(btnTestnet);
  await page.click(btnTestnet);

  // Wait Page load
  await page.waitForNavigation({
    waitUntil: 'load',
  });

  // Select testnet
  let ddlNetwork = "document.elementFromPoint(window.innerWidth/2, 100)";
  ddlNetwork = (await page.evaluateHandle(ddlNetwork)).asElement();
  await ddlNetwork?.click();

  let optTestnet = "document.elementFromPoint(window.innerWidth/2, 160)";
  optTestnet = (await page.evaluateHandle(optTestnet)).asElement();
  await optTestnet?.click();

  // Select stake method
  var args = process.argv.slice(2)[0];

  if (args?.includes("liquidStaking"))
    await liquidStaking(page);
  else
    await pureStaking(page);

  // Wait wallet Connect protocol 
  const walletConnect = 'document.querySelector("body > w3m-modal").shadowRoot.querySelector("wui-flex > wui-card > w3m-router").shadowRoot.querySelector("div > w3m-connect-view").shadowRoot.querySelector("wui-flex > wui-list-wallet:nth-child(2)")'
  let btnWalletConnect = (await page.evaluateHandle(walletConnect)).asElement();
  await btnWalletConnect?.click();

  // Wait QR Code appear 
  await new Promise(r => setTimeout(r, 1000));

  // Read QR code
  const qrCodeElement = 'document.querySelector("body > w3m-modal").shadowRoot.querySelector("wui-flex > wui-card > w3m-router").shadowRoot.querySelector("div > w3m-connecting-wc-view").shadowRoot.querySelector("w3m-connecting-wc-qrcode").shadowRoot.querySelector("wui-flex > wui-shimmer > wui-qr-code")'
  let qrCode = (await page.evaluateHandle(qrCodeElement)).asElement();

  const fullQR = await qrCode?.evaluate(el => el.uri);

  await browser.close();

  process.stdout.write(encodeURIComponent(fullQR).replace('%3F', '?'));
})();

async function pureStaking(page){
  // Click Connect Wallet
  const btnConnectWallet = "div > button";
  await page.waitForSelector(btnConnectWallet);
  await page.click(btnConnectWallet);
}

async function liquidStaking(page){
  // Click on Liquid Staking
  const btnTestnet = "a[href='/stake/liquid']";
  await page.waitForSelector(btnTestnet);
  await page.click(btnTestnet);

  // Wait QR Code appear 
  await new Promise(r => setTimeout(r, 1000));

  // Click Connect Wallet button
  let btnConnectWallet = "document.querySelector('w3m-connect-button').shadowRoot.querySelector('wui-connect-button')";
  btnConnectWallet = (await page.evaluateHandle(btnConnectWallet)).asElement();
  await btnConnectWallet?.click();
}
