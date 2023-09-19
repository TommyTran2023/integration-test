@RAKCON-10583
Feature: HomePage

  Background:
    * url baseURL
    * call read('this:RequesterAuthenticator.feature@RequesterAccessToken')
    * def schemaBody = read('classpath:data/schema.json')
    * def testData = read('classpath:data/data_test.json')

  @RAKCON-11657 @AssetAllocationChart
  Scenario: View chart of Asset Allocation
    Given path 'core/assets/chart'
    * param type = 'ALL'
    When method GET
    Then status 200
    * def assetsSchema = schemaBody.homePage.assetAllocation
    * def responseSchema = {"assets":"#[]assetsSchema", "totalUSD":#number}
    * match response.data.assets == '#[]assetsSchema'
    * match response.data == responseSchema

  @RAKCON-10977 @AssetAllocationDetail
  Scenario: View Asset Allocation detail at Home Page
    Given path '/core/assets/allocation-detail'
    * param offset = 0
    When method GET
    Then status 200
    * def tokenSchema = schemaBody.homePage.assetAllocationDetail
    * def responseSchema = {"total":#number, "tokens":"#[]tokenSchema"}
    * match response.data == responseSchema

  @RAKCON-11655 @SearchAssetsInAssetAllocation
  Scenario: Search assets in Asset Allocation
    #Get random asset for keyword to search
    * call read('this:HomePage.feature@AssetAllocationDetail')
    * def randomAsset = response.data.tokens[0].symbol
    Given path '/core/assets/allocation-detail'
    * param keyword = randomAsset
    * param offset = 0
    When method GET
    Then status 200
    * match response.status == 'success'
    * def listSearchedAssets = response.data.tokens
    * def listSearchedAssetsSymbol = $listSearchedAssets[*].symbol
    * match each listSearchedAssetsSymbol == "#regex (?i).*" + randomAsset + ".*"

  @RAKCON-10978 @PortfolioView
  Scenario: Portfolio view
    Given path '/core/vault/accounts/portfolio-chart'
    * def getDate =
      """
      function(numberOfDays){
        var date = new Date();
        date.setDate(date.getDate() + (numberOfDays));
        return date.toISOString()
      }
      """
    #Default date from and date to is previous 7 days
    * param dateFrom = getDate(-7)
    * param dateTo = getDate(-1)
    When method GET
    Then status 200
    * def chartDataSchema = {"date":#? getDate(_)", "value":#number}
    * def responseSchema = {"chartData":"#[]chartDataSchema", "percentageDifference":#number}

  @RAKCON-10979 @AddShortcut
  Scenario: Add shortcuts at homepage successfully
    * def userId = call read('this:GetUserInfo.feature@GetRequesterInfo')
    * call read('this:HomePage.feature@ViewShortcut')
    * if (shortcutIds != null) karate.call('this:HomePage.feature@DeleteShortcut')
    * def addShortcut = call read('this:HomePage.feature@AddShortcut-Common')
    Then addShortcut.response.code == 200
    * match addShortcut.response.data.userId == userId.requesterID
    * match addShortcut.response.data.externalAssetId == testData.transfer.withdraw.tokenSymbol
    * match addShortcut.response.data.destinationType == "VAULT_ACCOUNT"
    * match addShortcut.response.data.destinationId == destinationId_cold
    * match addShortcut.response.data.sourceId == sourceId_hot
    * match addShortcut.response.data.name == addShortcut.shortCutName

  @RAKCON-11771 @AddDuplicateShortcut
  Scenario: Add shortcut with duplicate information
    # Clear shortcut list on HomePage first
    * call read('this:HomePage.feature@ViewShortcut')
    * if (shortcutIds != null) karate.call('this:HomePage.feature@DeleteShortcut')
    # Add shortcut with duplicate information
    * def func = function(x){return karate.call('this:HomePage.feature@AddShortcut-Common')}
    * def duplicateResult = karate.repeat(2, func)
    * print duplicateResult
    * match duplicateResult[1].responseStatus == 400
    * match duplicateResult[1].response.errorCode == 'SHORTCUT_EXISTED'

  @ignore @AddShortcut-Common
  Scenario: Add shortcut - common
    * call read('this:Transfer.feature@Get_asset_transfer')
    * def now = function(){ return java.lang.System.currentTimeMillis() }
    * def shortCutName = 'AT-SC-' + now()
    Given path '/core/assets/shortcut'
    * request { "destinationType" : "VAULT_ACCOUNT", "destinationId" : "#(destinationId_cold)", "sourceId" : "#(sourceId_hot)", "name" : "#(shortCutName)", "externalAssetId" : "#(testData.transfer.withdraw.tokenSymbol)" }
    When method POST

  @RAKCON-10980 @ViewShortcut
  Scenario: View shortcuts from Home Page
    Given path '/core/assets/shortcuts'
    * param limit = 10
    * param offset = 0
    * param sort = 'ASC'
    When method GET
    Then status 200
    * def shortcutIds = $response.data[*].id
    * match response.status == 'success'

  @RAKCON-10981 @DeleteShortcut
  Scenario: Delete shortcuts from Home Page
    * call read('this:HomePage.feature@ViewShortcut')
    Given path '/core/assets/shortcut'
    * request { "shortcutIds" : "#(shortcutIds)" }
    When method DELETE
    Then status 200
    * match response.status == 'success'
    * match response.data == true

  @RAKCON-10982 @ViewMarketPriceListing
  Scenario: View Market Prices listing
    Given path '/core/assets/price'
    * param favoriteOrder = true
    * param limit = 10
    * param offset = 0
    When method GET
    Then status 200
    * def tokenSchema = schemaBody.homePage.marketPrice
    * match response.data.tokens == '#[]tokenSchema'
    * def firstToken = $response.data.token[0]
    * print firstToken

  @RAKCON-10995 @AddAssetToFavourite
  Scenario: Add asset to favourite
    * def marketPrice = call read('this:HomePage.feature@ViewMarketPriceListing')
    * def tokenId = marketPrice.firstToken.tokenId
    * if (marketPrice.firstToken.interested == true) karate.call('this:HomePage.feature@RemoveAssetToFvourite')
    Given path '/core/assets/interested'
    * request { "unFavourite" : false, "externalAssetIds" : [ "(#tokenId)" ] }
    When method PUT
    Then status 200
    * match response.status == 'success'

  @RAKCON-11850 @RemoveAssetToFavourite
  Scenario: Remove asset to favourite
    * def marketPrice = call read('this:HomePage.feature@ViewMarketPriceListing')
    * def tokenId = marketPrice.firstToken.tokenId
    * if (marketPrice.firstToken.interested == false) karate.call('this:HomePage.feature@AddAssetToFvourite')
    Given path '/core/assets/interested'
    * request { "unFavourite" : true, "externalAssetIds" : [ "(#tokenId)" ] }
    When method PUT
    Then status 200
    * match response.status == 'success'
    
  @RAKCON-10993 @RecentTransactions
  Scenario: Recent transactions
    Given path '/transaction/transactions/v1'
    * request { "limit" : 5, "offset":0, "status" : [ "COMPLETED" ] }
    When method POST
    Then status 201
    * def transactionsCount = response.data.transactions
    * assert transactionsCount.length == 5

  @CheckExistingAsset @ignore
  Scenario: Check Existing Asset
      Given path '/core/assets/check-existing'
      * params params
      When method GET