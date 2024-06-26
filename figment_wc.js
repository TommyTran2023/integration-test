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

  // Click on Stake
  const swtTestnet = "a[href='/stake']";
  await page.waitForSelector(swtTestnet);

  // Select testnet
  let isTestnetMode = await page.$eval(swtTestnet, element=> element.getAttribute("aria-checked"));
  if (isTestnetMode == 'false')
    await page.click(swtTestnet);

  // Click Stake hETH
  const btnStake = "div.mt-2 > div > button";
  await page.waitForSelector(btnStake);
  await page.click(btnStake);
  
  // Wait wallet Connect protocol 
  const walletConnect = 'document.querySelector("body > w3m-modal").shadowRoot.querySelector("wui-flex > wui-card > w3m-router").shadowRoot.querySelector("div > w3m-connect-view").shadowRoot.querySelector("wui-flex > wui-list-wallet:nth-child(2)")'
  let btnWalletConnect = (await page.evaluateHandle(walletConnect)).asElement();
  await btnWalletConnect?.click();

  // Wait QR Code appear 
  await new Promise(r => setTimeout(r, 2000));

  // Read QR code
  const qrCodeElement = 'document.querySelector("body > w3m-modal").shadowRoot.querySelector("wui-flex > wui-card > w3m-router").shadowRoot.querySelector("div > w3m-connecting-wc-view").shadowRoot.querySelector("w3m-connecting-wc-qrcode").shadowRoot.querySelector("wui-flex > wui-shimmer > wui-qr-code")'
  let qrCode = (await page.evaluateHandle(qrCodeElement)).asElement();

  const fullQR = await qrCode?.evaluate(el => el.uri);

  await browser.close();

  process.stdout.write(encodeURIComponent(fullQR).replace('%3F', '?'));
})();
