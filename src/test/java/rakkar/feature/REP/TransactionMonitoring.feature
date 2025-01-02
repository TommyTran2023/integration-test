    @RAKCON-31802 @REP
Feature: Transaction Monitoring

    Background:
        * callonce read(repSvc + 'Auth.feature@LoginAsCustomerSuccess')

    @REP_ListAllTransactions @RAKCON-34205
    Scenario: List all transaction
        * def data = 
        """
        {
            accessToken: "#(repAccessToken)",
            query: {
                page:1,
                offset:0,
                limit:10,
                sortBy:"CREATED_DATE",
                sort:"DESC"
            }
        }
        """
        * call read(svc + 'Transaction.feature@GetTransactionsList') data

    @GetSourceDestinationForFolder @RAKCON-34206
    Scenario: Get list source and destination to view 3rd party folder name
        * call read(connectDB + 'SelectTxnByCurrency') {assetToken:'ALGO'}
        * print result
        * def data = 
        """
        {
            externalExchangeAccountId: '#(result[0].externalExchangeAccountId)',
            type: '#(result[0].type)',
            tokenId: '#(result[0].tokenId)',
            workspaceId: '#(result[0].workspaceId)'
        }
        """
        * def expDataSchema = 
        """
        {
            "id": "#uuid",
            "folderExternalId": "#uuid",
            "name": "#string",
            "type": "#string",
            "customerRefId": "##uuid",
            "customerId": "#string",
            "createdBy": "#string",
            "vaultId": "##uuid",
            "folderId": "##uuid",
            "workspaceType": "#string",
            "thirdPartyFolderName": "#string",
            "createdAt": "#string",
            "updatedAt": "#string"
        }
        """
        * def expBusinessInfoSchema = 
        """
        {
            "countryCode": "#string",
            "sourceFunds": "#string",
            "businessName": "#string",
            "relationship": "#string",
            "businessAddress": "#string",
            "purposeTransfer": "#string"
        }
        """
        * def expAddressSchema = 
        """
        {
            "id": "#uuid",
            "folderId": "#uuid",
            "assetExternalId": "#string",
            "address": "#string",
            "tag": "#string",
            "is_require_tag": "#boolean",
            "status": "#number",
            "activedAt": "#string",
            "createdAt": "#string",
            "updatedAt": "#string",
            "isSanctioned": "#boolean",
            "lastYearVerifyColumn": "##string",
            "lastMonthVerifyColumn": "##string",
            "walletHost": "#string",
            "method": "#string",
            "vaspId": "##string"
        }
        """
        * call read(repSvc + 'Transaction.feature@GET_transaction_transactions_source-destination') data
        * match responseStatus == 200
        Then match response.data contains expDataSchema
        Then match response.data.address contains expAddressSchema
        Then match response.data.businessInfo contains expBusinessInfoSchema

    @GetSourceDestinationForVault @RAKCON-34207
    Scenario: Get list source and destination to view 3rd party vault name
        * call read(connectDB + 'SelectTxnByCurrencyAndType') {assetToken:'ALGO'}
        * print result
        * def data = 
        """
        {
            externalExchangeAccountId: '#(result[0].externalExchangeAccountId)',
            type: '#(result[0].type)',
            tokenId: '#(result[0].tokenId)',
            workspaceId: '#(result[0].workspaceId)'
        }
        """
        * def expDataSchema = 
        """
        {
        "id": "#uuid",
            "vaultExternalId": "#string",
            "name": "#string",
            "hiddenOnUI": "#boolean",
            "customerRefId": "#string",
            "thirdPartyVaultName": "#string",
            "workSpaceId": "#uuid",
            "autoFuel": "#boolean",
            "status": "#string",
            "customerId": "#uuid",
            "type": "#string",
            "createdAt": "#string",
            "updatedAt": "#string"
        }
        """
        * call read(repSvc + 'Transaction.feature@GET_transaction_transactions_source-destination') data
        * match responseStatus == 200
        Then match response.data contains expDataSchema



