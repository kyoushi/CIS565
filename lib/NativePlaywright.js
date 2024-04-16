async function myGoToKeyword(url, page, logger) {
    logger("Going to " + url)
    return await page.goto(url);
}

async function fillTextElement(locator, value, page, logger) {
    logger("Fill up " + locator + " with value " + value)
    await page.locator(locator).fill(value);
}
async function clickElement(locator, page, logger) {
    logger("Click " + locator)
    await page.locator(locator).click();
}
async function getTextElement(locator, page, logger) {
    logger("Get Text " + locator)
    return await page.locator(locator).textContent();
}
myGoToKeyword.rfdoc = "This is my own go to keyword";
exports.__esModule = true;
exports.myGoToKeyword = myGoToKeyword;
exports.fillTextElement = fillTextElement;
exports.clickElement = clickElement;
exports.getTextElement = getTextElement;