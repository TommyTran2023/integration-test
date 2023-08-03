@RAKCON-10583
Feature: Open API
  Background:
    * url openApiURL
    * def apiKey = call read('GenerateAPIkey.feature@Generate_api_key')
    * print apiKey.response.data.key
    * def key = apiKey.response.data.key
    * def accountId = apiKey.response.data.accountId
    * def idDeleted = apiKey.response.data.id


  @RAKCON-15514 @Get_balance_by_assetId
  Scenario: Open API - Get balance by assetId
    * call read('OpenAPI_ReadSchema.feature@Read_schema_balance')
    * header x-api-key = key
    * header account-id = accountId
    * def query = { asset_id: 'XRP_TEST'}
    Given path 'v1/balances'
    And params query
    When method GET
    Then status 200
    And match karate.keysOf(response) == karate.keysOf(expectedSchema.properties)

  @RAKCON-15515 @Get_balance_by_vaultType
  Scenario: Open API - Get balance by vault type
    * call read('OpenAPI_ReadSchema.feature@Read_schema_balance')
    * header x-api-key = key
    * header account-id = accountId
    * def query = { asset_id: 'XRP_TEST', vault_type: 'HOT_WALLET' }
    Given path 'v1/balances'
    And params query
    When method GET
    Then status 200
    And match karate.keysOf(response) == karate.keysOf(expectedSchema.properties)

  @RAKCON-17445 @GetVaultList
    Scenario: Open API - Get Vault List
      * call read('OpenAPI_ReadSchema.feature@Read_schema_vault')
    * header x-api-key = key
    * header account-id = accountId
      * def query = { asset_id: 'XRP_TEST', vault_type: 'warm', limit: 10, offset: 0 }
      Given path 'v1/vaults'
      And params query
      When method GET
      Then status 200
      And match karate.keysOf(response) == karate.keysOf(expectedSchema.properties)

  @RAKCON-17446 @GetVaultDetail
  Scenario: Open API - Get Vault Details
    * call read('OpenAPI_ReadSchema.feature@Read_schema_vault')
    * def vaultList = call read('OpenAPI.feature@GetVaultList')
    * def vaultId = vaultList.response.vaults[0].vault_id
    * header x-api-key = key
    * header account-id = accountId
    Given path 'v1/vaults/'+ vaultId
    When method GET
    Then status 200
    And match karate.keysOf(response) == karate.keysOf(expectedSchema.properties)


  @RAKCON-17447 @Get_whitelist
  Scenario: Open API - Get whitelist
    * call read('OpenAPI_ReadSchema.feature@Read_schema_whitelist')
    * header x-api-key = key
    * header account-id = accountId
    * def query = { asset_id: 'XRP_TEST', whitelist_type: 'my_organization', limit: 10, offset: 0 }
    Given path 'v1/whitelist'
    And params query
    When method GET
    Then status 200
    And match karate.keysOf(response) == karate.keysOf(expectedSchema.properties)

  @AfterFeature @Delete_api_key
  Scenario: Delete api key
    * call read('GenerateAPIkey.feature@Delete_api_key')


