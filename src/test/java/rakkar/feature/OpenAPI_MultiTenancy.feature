@RAKCON-10583 
Feature: Open API from another customer
# Open API from another customer

    @RAKCON-20394 @VerifyListTransactionsOfCustomer
    Scenario: User unable to see list transactions from other customer
        * call read('classpath:rakkar/feature/ConnectDB.feature@SelectTransactionsOfCustomer') {customerId: #(crossTenant.accountId)}
        * call read(svc + 'OpenAPI.feature@GetTransactions') { apiKey: #(crossTenant.apiKey), accountId: #(crossTenant.accountId) }
        Then match responseStatus == 200
        And assert response.transactions.length == result.length
        And match response.transactions[*].transaction_id contains karate.jsonPath(result,"$..['transactionId']")

    @RAKCON-20395 @GetAllVaultsOfCustomer
    Scenario: User unable to see list vaults from other customer
        * call read(svc + 'OpenAPI.feature@GetVaults') { apiKey: #(crossTenant.apiKey), accountId: #(crossTenant.accountId) }
        Then match responseStatus == 200
        * def actualVaultId = karate.jsonPath(response.vaults,"$..['vault_id']").map(v => {return  "'" + v + "'" }).join(",")
        * call read('classpath:rakkar/feature/ConnectDB.feature@SelectVaultsOfCustomer') {customerId: #(crossTenant.accountId), vaultIds: #(actualVaultId)}
        * def result = karate.jsonPath(result,"$..['customerId']").map(v => {return  v.toString().replaceAll("-","") })
        And assert response.vaults.length == result.length
        And match each result == crossTenant.accountId

    @RAKCON-20396 @CheckCustomerOfGetBalanceByVaultTypeAndAssetId @ignore
    Scenario: User able to see balance of customer by vault type and asset id
        # BUG @RAKSEC-110
        * def assetId = 'XRP_TEST'
        * call read('classpath:rakkar/feature/ConnectDB.feature@SelectBalanceOfCustomer') {customerId: #(crossTenant.accountId), type: 'COLD_WALLET', assetId: #(assetId)}
        * def data =
        """
        { 
            limit: 100, 
            offset: 0, 
            asset_id: #(assetId) ,
            apiKey: #(crossTenant.apiKey), 
            accountId: #(crossTenant.accountId)
        }
        """
        * call read(svc + 'OpenAPI.feature@GetBalances') data
        Then match responseStatus == 200
        And assert response.balance.length == result.length
        And match response.balance[*].asset_id contains karate.jsonPath(result,"$..['assetExternalId']")

    @RAKCON-20397 @GetTransactionDetailsOfOtherCustomer
    Scenario: User unable to see details of transaction from other customer
        * def query = {limit: 10, offset: 0 }
        * call read('this:OpenAPI.feature@Transaction_common')
        * def data = 
        """
        {
            txnId: #(response.transactions[0].transaction_id),
            apiKey: #(crossTenant.apiKey), 
            accountId: #(crossTenant.accountId)
        }
        """
        * call read(svc + 'OpenAPI.feature@GetTransactionById') data
        Then match responseStatus == 400
        And match response.status == 'error'
        And match response.details == "Transaction not found in records"
        And match response.code == 400

    @RAKCON-20398 @GetVaultDetailsOfOtherCustomer
    Scenario: User unable to see details of vault from other customer
        * call read('this:OpenAPI.feature@GetVaultList')
        * def data = 
        """
        {
            vaultId: #(response.vaults[0].vault_id),
            apiKey: #(crossTenant.apiKey), 
            accountId: #(crossTenant.accountId)
        }
        """
        * call read(svc + 'OpenAPI.feature@GetVaultById') data
        Then match responseStatus == 400
        And match response.status == 'error'
        And match response.error_message == 'Vault not found'
        And match response.details == 'Vault id does not match with records'
        And match response.code == 400
    

