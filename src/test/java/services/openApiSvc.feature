Feature:OpenAPI Service

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

@GetListTransaction
Scenario: Get List Transaction
   Given path 'openApi/transactions'
   * header authorization = authorization
   * params params
   When method GET

@GetTransactionDetail
Scenario: Get Transaction Detail
   Given path 'openApi/transactions/' + tx_id
   * header authorization = authorization
   When method GET

@GetListVault
Scenario: Get List Vault
   Given path 'openApi/vaults'
   * header authorization = authorization
   When method GET

@GetVaultDetail
Scenario: Get Vault Detail
   Given path 'openApi/vaults/'+vaultId
   * header authorization = authorization
   When method GET

@GetWhitelist
Scenario: Get Whitelist
   Given path 'openApi/whitelist'
   * header authorization = authorization
   * params params
   When method GET

#----------------------------------
@GetBalances
Scenario: Get Balances
   Given path 'openApi/balances'
   * header authorization = authorization
   * params params
   When method GET

#----------------------------------
@GetBalancesByVaultType
Scenario: Get Balances By Vault Type
   Given path 'openApi/balances/' + vault_type
   * header authorization = authorization
   * params params
   When method GET

