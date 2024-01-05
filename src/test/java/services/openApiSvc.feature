Feature: Open API

  Background:
    * url openApiURL
    * headers { x-api-key: #(apiKey), account-id: #(accountId) }

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

