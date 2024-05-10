const puppeteer = require('puppeteer');

(async () => {
  // Launch the browser and open a new blank page
  const browser = await puppeteer.launch();
  const page = await browser.newPage();

  // Navigate the page to a URL
  await page.goto('https://dev.openeden.com/?chain=sepolia');

  // Set screen size
  await page.setViewport({width: 1080, height: 1024});

  // Wait and click on first result
  const btnConnect = 'div.hidden > div > div > button.uppercase.grow';
  await page.waitForSelector(btnConnect);
  await page.click(btnConnect);

  // Wait and click Proceed
  const btnProceed = "div[data-headlessui-state='open'] > div > button.text-white"
  await page.waitForSelector(btnProceed);
  await page.click(btnProceed);
  
  // Wait wallet Connect protocol 
  const walletConnect = 'document.querySelector("body > w3m-modal").shadowRoot.querySelector("wui-flex > wui-card > w3m-router").shadowRoot.querySelector("div > w3m-connect-view").shadowRoot.querySelector("wui-flex > wui-list-wallet:nth-child(2)").shadowRoot.querySelector("button > wui-text")'
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
