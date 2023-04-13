@RAKCON-10950
Feature: HomePage

  Background:
    * url baseURL
    * call read('RequesterAuthenticator.feature@RequesterAccessToken')

  @RAKCON-11657 @AssetAllocationChart
  Scenario: View chart of Asset Allocation
    Given path 'core/assets/chart'
    * param type = 'ALL'
    When method GET
    Then status 200
    * def assetsSchema = {"id":"#string", "symbol":"#string", "totalUSD":#number, "image":"##string", "network":"#string"}
    * def responseSchema = {"assets":"#[]assetsSchema", "totalUSD":#number}
    * match response.data == responseSchema

  @RAKCON-10977 @AssetAllocationDetail
  Scenario: View Asset Allocation detail at Home Page
    Given path '/core/assets/allocation-detail'
    * param offset = 0
    When method GET
    Then status 200
    * def tokenSchema = {"symbol":"#string", "networkImage":"##string", "id":"#string", "totalUSD":#number, "image":"##string", "type":"#string", "name":"#string"}
    * def responseSchema = {"total":#number, "tokens":"#[]tokenSchema"}
    * match response.data == responseSchema

  @RAKCON-11655 @SearchAssetsInAssetAllocation
  Scenario: Search assets in Asset Allocation
    #Get random asset for keyword to search
    * call read('HomePage.feature@AssetAllocationDetail')
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

  @RAKCON-10979 @AddShortcut
  Scenario: Add shortcuts at homepage successfully
    * call read('HomePage.feature@ViewShortcut')
    * if (shortcutIds != null) karate.call('HomePage.feature@DeleteShortcut')
    * call read('HomePage.feature@AddShortcut-Common')
    Then status 201
    * def userId = call read('GetRequesterID.feature@GetRequesterID')
    * match response.data.userId == userId.requesterID
    * match response.data.externalAssetId == tokenSymbol
    * match response.data.destinationType == "VAULT_ACCOUNT"
    * match response.data.destinationId == destinationId_cold
    * match response.data.sourceId == sourceId_hot
    * match response.data.name == shortCutName

  @RAKCON-11771 @AddDuplicateShortcut
  Scenario: Add shortcut with duplicate information
    # Clear shortcut list on HomePage first
    * call read('HomePage.feature@ViewShortcut')
    * if (shortcutIds != null) karate.call('HomePage.feature@DeleteShortcut')
    # Add shortcut with duplicate information
    * def func = function(x){return karate.call('HomePage.feature@AddShortcut-Common')}
    * def duplicateResult = karate.repeat(2, func)
    * print duplicateResult
    * match duplicateResult[1].responseStatus == 400
    * match duplicateResult[1].response.errorCode == 'SHORTCUT_EXISTED'

  @ignore @AddShortcut-Common
  Scenario: Add shortcut - common
    * call read('Transfer.feature@Get_source_transfer')
    * call read('Transfer.feature@Get_destination_transfer')
    * call read('Transfer.feature@Get_asset_transfer')
    * def now = function(){ return java.lang.System.currentTimeMillis() }
    * def shortCutName = 'AT-SC-' + now()
    Given path '/core/assets/shortcut'
    * request { "destinationType" : "VAULT_ACCOUNT", "destinationId" : "#(destinationId_cold)", "sourceId" : "#(sourceId_hot)", "name" : "#(shortCutName)", "externalAssetId" : "#(tokenSymbol)" }
    When method POST

  @RAKCON-10980 @ViewShortcut
  Scenario: View shortcuts from Home Pag
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
    * call read('HomePage.feature@ViewShortcut')
    Given path '/core/assets/shortcut'
    * request { "shortcutIds" : "#(shortcutIds)" }
    When method DELETE
    Then status 200
    * match response.data == {}