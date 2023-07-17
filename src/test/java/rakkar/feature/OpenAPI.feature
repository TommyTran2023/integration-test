@RAKCON-10583
Feature: Open API
  Background:
    * url openApiURL

  @RAKCON-15514 @Get_balance_by_assetId
  Scenario: Open API - Get balance by assetId
    * def readSchema = call read('OpenAPI_readSchema.feature@Get_schema_structure')
    * def expectedSchema = readSchema.response.paths['/balances'].get.responses['200'].content['application/json'].examples['Example-1'].value
    * header x-api-key = x-api-key
    * header account-id = client-id
    * def query = { assetId: 'XRP_Test'}
    Given path 'v1/balances'
    And params query
    When method GET
    Then status 200
    * karate.match(response.timestamp, expectedSchema.timestamp)
    * karate.match(response.balance_type, expectedSchema.balance_type)
    * karate.match(response.balance, expectedSchema.balance)

  @RAKCON-15515 @Get_balance_by_vaultType
  Scenario: Open API - Get balance by vault type
    * def readSchema = call read('OpenAPI_readSchema.feature@Get_schema_structure')
    * def expectedSchema = readSchema.response.paths['/balances'].get.responses['200'].content['application/json'].examples['Example-1'].value
    * header x-api-key = x-api-key
    * header account-id = client-id
    * def query = { assetId: 'XRP_Test', vault_type: 'HOT_WALLET' }
    Given path 'v1/balances'
    And params query
    When method GET
    Then status 200
    * karate.match(response.timestamp, expectedSchema.timestamp)
    * karate.match(response.balance_type, expectedSchema.balance_type)
    * karate.match(response.balance, expectedSchema.balance)

