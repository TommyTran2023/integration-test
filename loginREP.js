const puppeteer = require("puppeteer");

(async () => {
    var repUrl = process.argv[2];
    var email = process.argv[3];
    var password = process.argv[4];
    
    try {
        var accessToken = await loginREP(repUrl, email, password);
        console.log(accessToken);
    } catch (error) {
        console.log(error.message);
    }

    process.exit();
})();

async function loginREP(repUrl, email, password) {
    // Launch the browser and open a new blank page
    const browser = await puppeteer.launch({
        args: ["--no-sandbox", "--disable-setuid-sandbox"]
    });
    const page = await browser.newPage();

    // Navigate the page to a URL
    await page.goto(repUrl);

    // Set screen size
    await page.setViewport({ width: 1080, height: 1024 });

    // Login screen
    const btnLogin = "[data-testid='btn-login']";
    const txtEmail = "input[type=email]";
    const txtPassword = "input[type=password]";
    const btnSubmit = "input[type=submit]";
    const chkStaySignIn = "div.text-title";

    // Login
    await page.waitForSelector(btnLogin);
    await page.click(btnLogin);

    await page.waitForSelector(txtEmail);
    await page.type(txtEmail, email);
    await page.keyboard.press('Enter');

    await page.waitForSelector(txtPassword);
    await page.type(txtPassword, password);
    await page.waitForNavigation({
        waitUntil: 'networkidle0',
    });
    await page.keyboard.press('Enter');
    
    await page.waitForSelector(chkStaySignIn);
    await page.keyboard.press('Enter');
    await page.waitForNavigation({
        waitUntil: 'networkidle0',
    });
    
    const localStorageData = await page.evaluate(() => {
        let json = {};
        for (let i = 0; i < localStorage.length; i++) {
          const key = localStorage.key(i);
          json[key] = localStorage.getItem(key);
        }
        return json;
    });

    await browser.close();

    var authInfo = JSON.parse(localStorageData['persist:auth']).authInfo;
    var accessToken = JSON.parse(authInfo).data.AccessToken;
    return accessToken;
}
