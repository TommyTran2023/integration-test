@ignore @RAKCON-10583
Feature: Open API
  Background:
    * url openApiURL

  @RAKCON-15514 @Get_balance_by_assetId
  Scenario: Open API - Get balance by assetId
    * header x-api-key = x-api-key
    * header client-id = client-id
    * def query = { assetId: 'XRP_Test'}
    Given path 'openapi/balances'
    And params query
    When method GET
    Then status 200

  @RAKCON-15515 @Get_balance_by_vaultType
  Scenario: Open API - Get balance by vault type
    * header x-api-key = x-api-key
    * header client-id = client-id
    * def query = { assetId: 'XRP_Test', vault_type: 'HOT_WALLET' }
    Given path 'openapi/balances'
    And params query
    When method GET
    Then status 200
