@RAKCON-10583
Feature: Open API from another customer
# Open API from another customer

    Background:
        * url openApiURL
        * header x-api-key = crossTenant.apiKey
        * header account-id = crossTenant.accountId

    @VerifyListTransactionsOfCustomer
    Scenario: User unable to see list transactions from other customer
        * call read('this:connectDB.feature@SelectTransactionsOfCustomer') {customerId: #(crossTenant.accountId)}
        Given path 'v1/transactions'
        And params { limit: 100, offset: 0 }
        When method GET
        Then status 200
        Then response.transactions.length == result.length
        Then match each response.transactions[*].transaction_id contains any karate.jsonPath(result,"$..['transactionId']")

    @GetAllVaultsOfCustomer
    Scenario: User unable to see list vaults from other customer
        * call read('this:connectDB.feature@SelectVaultsOfCustomer') {customerId: #(crossTenant.accountId)}
        Given path 'v1/vaults'
        And params { limit: 100, offset: 0 }
        When method GET
        Then status 200
        Then response.vaults.length == result.length
        Then match each response.vaults[*].id contains any karate.jsonPath(result,"$..['id']")
        * print karate.jsonPath(result,"$..['id']")
        * print response.vaults[*].id
        

    

