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

  @RAKCON-17448 @Transaction_by_sourceId
  Scenario: Open API - Get transaction by sourceId
    * def query = { source_id: '#(sourceId)', limit: 10, offset: 0 }
    * call read('OpenAPI.feature@Transaction_common')

  @RAKCON-17450 @Transaction_by_destinationId
  Scenario: Open API - Get transaction by destinationId
    * def query = { destination_id: '#(destinationId)', limit: 10, offset: 0 }
    * call read('OpenAPI.feature@Transaction_common')

  @RAKCON-17451 @Transaction_by_type
  Scenario: Open API - Get transaction by transaction type
    * def query = { transaction_type: 'withdraw', limit: 10, offset: 0 }
    * call read('OpenAPI.feature@Transaction_common')

  @RAKCON-17449 @Transaction_by_transactionid
   Scenario: Open API - Get transaction by transaction id
    * def transactionList = call read('OpenAPI.feature@Transaction_by_type')
    * def transactionId = transactionList.response.transactions[0].transaction_id
    * def query = { transaction_id: '#(transactionId)', limit: 10, offset: 0 }
    * call read('OpenAPI.feature@Transaction_common')

  @RAKCON-17452 @Transaction_by_source_address
  Scenario: Open API - Get transaction by source address
    * def transactionList = call read('OpenAPI.feature@Transaction_by_sourceId')
    * def source_address = transactionList.response.transactions[0].transaction.source_address
    * def query = { source_address: '#(source_address)', limit: 10, offset: 0 }
    * call read('OpenAPI.feature@Transaction_common')

  @RAKCON-17453 @Transaction_by_destination_address
  Scenario: Open API - Get transaction by destination address
    * def transactionList = call read('OpenAPI.feature@Transaction_by_destinationId')
    * def source_address = transactionList.response.transactions[0].transaction.destination_address
    * def query = { destination_address: '#(source_address)', limit: 10, offset: 0 }
    * call read('OpenAPI.feature@Transaction_common')

  @RAKCON-17454 @Transaction_by_assetId
  Scenario: Open API - Get transaction by asset id
    * def query = { asset_id: 'XRP_TEST', limit: 10, offset: 0 }
    * call read('OpenAPI.feature@Transaction_common')

  @RAKCON-17455 @Transaction_by_date
  Scenario: Open API - Get transaction by date
    * def getDate =
      """
      function(numberOfDays){
        var date = new Date();
        date.setDate(date.getDate() + (numberOfDays));
        return date.toISOString()
      }
      """
    * def start_date = getDate(-30)
    * def end_date = getDate(-1)
    * def query = { start_date: '#(start_date)', end_date: '#(end_date)', limit: 10, offset: 0 }
    * call read('OpenAPI.feature@Transaction_common')

  @RAKCON-17456 @Transaction_by_status
  Scenario: Open API - Get transaction by status
    * def query = { status: 'rejected', limit: 10, offset: 0 }
    * call read('OpenAPI.feature@Transaction_common')

  @RAKCON-17458 @Transaction_by_networkId
  Scenario: Open API - Get transaction by networkId
    * def query = { network_id: 'ADA_TEST', limit: 10, offset: 0 }
    * call read('OpenAPI.feature@Transaction_common')

  @RAKCON-17457 @Transaction_detail
  Scenario: Open API - Get transaction detail
    * def transactionList = call read('OpenAPI.feature@Transaction_by_type')
    * def transactionId = transactionList.response.transactions[0].transaction_id
    * header x-api-key = x-api-key
    * header account-id = client-id
    Given path 'v1/transactions/'+ transactionId
    When method GET
    Then status 200
    And match karate.keysOf(response) == karate.keysOf(transactionList.response.transactions[0])

  @ignore @Transaction_common
  Scenario: Open API - Transaction listing common
    * call read('OpenAPI_ReadSchema.feature@Read_schema_transaction')
    * header x-api-key = x-api-key
    * header account-id = client-id
    Given path 'v1/transactions'
    And params query
    When method GET
    Then status 200
    And match karate.keysOf(response) == karate.keysOf(expectedSchema.properties)

  @AfterFeature @Delete_api_key
  Scenario: Delete api key
    * call read('GenerateAPIkey.feature@Delete_api_key')



