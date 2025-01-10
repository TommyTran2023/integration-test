    @RAKCON-35282 @REP
Feature: Transaction Detail

    Background:
        * callonce read(repSvc + 'Auth.feature@LoginAsOperation')

    @GetNonTravelRuleTransactions @RAKCON-35283
    Scenario: Get non-travel rule transactions should show not applicable badge
        * call read(connectDB + 'SelectTxnNotTravelRule')
        * def data = 
        """
        {
            requesterAccessToken: "#(repAccessToken)",
            transactionId: "#(result[0].id)",
        }
        """
        * call read(svc + 'Transaction.feature@ViewTransactionDetail') data
        * match responseStatus == 200
        Then match response.data.additionalData.rakObj == '#notpresent'
        * def exp = [null, '']
        * assert exp.includes(response.data.vaspId) == true

    @GetTravelRuleTransactionsNotThroughFireblocks @RAKCON-35284
    Scenario: Get travel rule transactions that not pushed to fireblocks shouldn't show not applicable badge
        * call read(connectDB + 'SelectTxnNotScreeningThroughFireblocks') {customerId: #(sg_customer.customerId)}
        * print result
        * def data = 
        """
        {
            requesterAccessToken: "#(repAccessToken)",
            transactionId: "#(result[0].id)",
        }
        """
        * call read(svc + 'Transaction.feature@ViewTransactionDetail') data
        * match responseStatus == 200
        Then match response.data.additionalData.rakObj == '#notpresent'
        Then match response.data.vaspId == "#uuid"

    @GetTravelRuleTransactionsThroughFireblocks @RAKCON-35489
    Scenario: Get travel rule transactions that pushed to fireblocks should show not applicable badge
        * def data = 
        """
        {
            accessToken: "#(repAccessToken)",
            query: {
                page:1,
                offset:0,
                limit:10,
                sortBy:"CREATED_DATE",
                status: ["COMPLETED"],
                transactionType: ["OUTGOING"],
                sort:"DESC",
                createdById: "#(sg_customer.admin1UserId)",
            }
        }
        """
        * call read(svc + 'Transaction.feature@GetTransactionsList') data     
        * print response
        * def data = 
        """
        {
            requesterAccessToken: "#(repAccessToken)",
            transactionId: "#(response.data.transactions[0].id)",
        }
        """    
        * call read(svc + 'Transaction.feature@ViewTransactionDetail') data
        * def expAdditionalData =
        """
        {
            "quorumId": "#uuid",
            "quorumRequestId": "#uuid",
            "rakObj": {
                "key": "#string",
                "path": "#string",
                "stage": "#string",
                "fbStatus": "#string",
                "hookType": "#string",
                "trReason": "##string",
                "trStatus": "#string",
                "REPStatus": "#string",
                "fbSubStatus": "#string",
                "unfreezeByAPI": "##boolean",
            },
        }
        """
        * match responseStatus == 200
        Then match response.data.additionalData contains expAdditionalData
        Then match response.data.vaspId == "#uuid"

    @GetNonTravelRuleDepositTransactions @RAKCON-35526
    Scenario: Get non travel rule deposit transactions
        * call read(connectDB + 'SelectDepositTxnNotTravelRule')
        * print result
        * def data =
        """
        {
            requesterAccessToken: "#(repAccessToken)",
            transactionId: "#(result[0].id)"
        }
        """
        * call read(svc + 'Transaction.feature@ViewTransactionDetail') data
        * match responseStatus == 200
        Then match response.data.additionalData.rakObj == '#notpresent'
        Then match response.data.vaspId == '#null'

        



    @GetTravelRuleTransactionsDeposit @RAKCON-35562
    Scenario: Get travel rule transactions Deposit
        * call read(connectDB + 'SelectDepositTxnTravelRule') {customerId: #(sg_customer.customerId)}
        * print result
        * def data = 
        """
        {
            requesterAccessToken: "#(repAccessToken)",
            transactionId: "#(result[0].id)",
        }
        """
        * call read(svc + 'Transaction.feature@ViewTransactionDetail') data
        * match responseStatus == 200
        Then match response.data.vaspId == null
        * def expAdditionalData =
        """
        {
            "url": "#string",
            "rakObj": {
                "key": "#string",
                "path": "#string",
                "stage": "#string",
                "fbStatus": "#string",
                "hookType": "#string",
                "trReason": "##string",
                "trStatus": "#string",
                "REPStatus": "#string",
                "fbSubStatus": "#string",
                "unfreezeByAPI": "##boolean",
                },
            "verdict": "##string",
            "provider": "##string",
            "quorumId": "##uuid",
            "trStatus": "##string",
            "rakStatus": "##string",
            "trTypeObjKey": "##string",
            "screeningTime": "##number",
            "rakDescription": "##string",
            "quorumRequestId": "##uuid",    
        }
        """
        Then match response.data.additionalData contains expAdditionalData
