@RAKCON-10583
Feature: Open API
  Background:
    * url openApiURL

  @RAKCON-15514 @Get_balance_by_assetId
  Scenario: Open API - Get balance by assetId
    * call read('OpenAPI_readSchema.feature@Read_schema_balance')
    * header x-api-key = x-api-key
    * header account-id = client-id
    * def query = { asset_id: 'XRP_TEST'}
    Given path 'v1/balances'
    And params query
    When method GET
    Then status 200
    * karate.match(response.timestamp, expectedSchema.timestamp)
    * karate.match(response.balance_type, expectedSchema.balance_type)
    * karate.match(response.balance, expectedSchema.balance)

  @RAKCON-15515 @Get_balance_by_vaultType
  Scenario: Open API - Get balance by vault type
    * call read('OpenAPI_readSchema.feature@Read_schema_balance')
    * header x-api-key = x-api-key
    * header account-id = client-id
    * def query = { asset_id: 'XRP_TEST', vault_type: 'HOT_WALLET' }
    Given path 'v1/balances'
    And params query
    When method GET
    Then status 200
    * karate.match(response.timestamp, expectedSchema.timestamp)
    * karate.match(response.balance_type, expectedSchema.balance_type)
    * karate.match(response.balance, expectedSchema.balance)

