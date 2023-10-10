@RAKCON-10583 @ignore
Feature: Open API from another customer
# Open API from another customer

    Background:
        * url openApiURL
        * header x-api-key = crossTenant.apiKey
        * header account-id = crossTenant.accountId

    @RAKCON-20394 @VerifyListTransactionsOfCustomer
    Scenario: User unable to see list transactions from other customer
        * call read('this:ConnectDB.feature@SelectTransactionsOfCustomer') {customerId: #(crossTenant.accountId)}
        Given path 'v1/transactions'
        When method GET
        Then status 200
        And assert response.transactions.length == result.length
        And match response.transactions[*].transaction_id contains karate.jsonPath(result,"$..['transactionId']")

    @RAKCON-20395 @GetAllVaultsOfCustomer
    Scenario: User unable to see list vaults from other customer
        * call read('this:ConnectDB.feature@SelectVaultsOfCustomer') {customerId: #(crossTenant.accountId)}
        Given path 'v1/vaults'
        When method GET
        Then status 200
        And assert response.vaults.length == result.length
        And match each response.vaults[*].vault_id contains karate.jsonPath(result,"$..['id']")

    @RAKCON-20396 @CheckCustomerOfGetBalanceByVaultTypeAndAssetId
    Scenario: User able to see balance of customer by vault type and asset id
        * def assetId = 'XRP_TEST'
        * call read('this:ConnectDB.feature@SelectBalanceOfCustomer') {customerId: #(crossTenant.accountId), type: 'COLD_WALLET', assetId: #(assetId)}
        Given path 'v1/balances/cold'
        * params { limit: 100, offset: 0, asset_id: #(assetId) }
        When method GET
        Then status 200
        And assert response.balance.length == result.length
        And match response.balance[*].asset_id contains karate.jsonPath(result,"$..['assetExternalId']")

    @RAKCON-20397 @GetTransactionDetailsOfOtherCustomer
    Scenario: User unable to see details of transaction from other customer
        * def query = {limit: 10, offset: 0 }
        * call read('this:OpenAPI.feature@Transaction_common')
        Given path 'v1/transaction/' + response.transactions[0].transaction_id
        When method GET
        Then status 404
        And match response.status == 'error'
        And match response.errorCode == 'UNAUTHORIZED'
        And match response.code == 404

    @RAKCON-20398 @GetVaultDetailsOfOtherCustomer
    Scenario: User unable to see details of vault from other customer
        * call read('this:OpenAPI.feature@GetVaultList')
        Given path 'v1/vaults/' + response.vaults[0].vault_id
        When method GET
        Then status 400
        And match response.status == 'error'
        And match response.error_message == 'Vault not found'
        And match response.details == 'Vault id does not match with records'
        And match response.code == 400
    

