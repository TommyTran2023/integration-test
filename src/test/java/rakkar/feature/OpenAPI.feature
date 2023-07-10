@RAKCON-10583
Feature: Open API
  Background:
    * url openApiURL
    * def schemaBody = read('classpath:data/schema.json')

  @RAKCON-15514 @Get_balance_by_assetId
  Scenario: Open API - Get balance by assetId
    * header x-api-key = x-api-key
    * header account-id = client-id
    * def query = { assetId: 'XRP_Test'}
    Given path 'v1/balances'
    And params query
    When method GET
    Then status 200
    And match response.timestamp == schemaBody.openAPI.getBalanceByAsset.timestamp
    And match response.balance_type == schemaBody.openAPI.getBalanceByAsset.balance_type
    And match response.balance contains schemaBody.openAPI.getBalanceByAsset.balance


  @RAKCON-15515 @Get_balance_by_vaultType
  Scenario: Open API - Get balance by vault type
    * header x-api-key = x-api-key
    * header account-id = client-id
    * def query = { assetId: 'XRP_Test', vault_type: 'HOT_WALLET' }
    Given path 'v1/balances'
    And params query
    When method GET
    Then status 200
    And match response.timestamp == schemaBody.openAPI.getBalanceByAsset.timestamp
    And match response.balance_type == schemaBody.openAPI.getBalanceByAsset.balance_type
    And match response.balance contains schemaBody.openAPI.getBalanceByAsset.balance

