Feature: Open API

Background:
  * url openApiURL
  * headers { x-api-key: #(apiKey), account-id: #(accountId) }

@GetListApiKeyClients
Scenario: Get List Api Key Clients
   Given path 'openApi/api-keys'
   * header authorization = authorization
   * params params
   When method GET

@GenerateApiKey
Scenario: Generate Api Key
   Given path 'openApi/api-keys'
   * header authorization = authorization
   * request body
   When method POST

@ValidateDuplicateName
Scenario: Validate Duplicate Name
   Given path 'openApi/api-keys/validate-duplicate-name'
   * header authorization = authorization
   * param name = name
   When method GET

@DeleteApiKey
Scenario: Delete Api Key
   Given path 'openApi/api-keys/'+ apiKeyId
   * header authorization = authorization
   When method DELETE

@GetCustomURL
Scenario: Get Custom URL
   Given path 'openApi/api-keys/readme-custom-url'
   * header authorization = authorization
   When method GET

   @GetTransactions
Scenario: Get transactions list
  Given path 'v1/transactions'
  And params params
  When method GET

  @GetTransactionById
Scenario: Get transaction detail by tx id
  Given path 'v1/transactions/' + txnId
  When method GET

  @GetVaults
Scenario: Get vaults list
  Given path 'v1/vaults'
  And params params
  When method GET

  @GetVaultById
Scenario: Get vault detail by vault id
  Given path 'v1/vaults/' + vaultId
  When method GET

  @GetBalances
Scenario: Return all balances or by asset id
  Given path 'v1/balances'
  And params params
  When method GET

  @GetBalancesByVaultType
Scenario: Return balances by vault type and asset id
  Given path 'v1/balances/' + vaultType
  And params params
  When method GET

  @GetWhitelisted
Scenario: Get a list of whitelisted destinations
  Given path 'v1/whitelist'
  And params params
  When method GET
