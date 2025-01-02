    @RAKCON-35282 @REP
Feature: Transaction Monitoring

    Background:
        * callonce read(repSvc + 'Auth.feature@LoginAsCustomerSuccess')

    @GetNonTravelRuleTransactions @RAKCON-35283
    Scenario: Get non-travel rule transactions to view not applicable badge
        * call read(connectDB + 'SelectTxnNotTravelRule')
        * def expDataSchema =
        """
        {
            "totalEstimatedFee": "#number",
            "transactionVdoPath": "##string",
            "transactionVdoSentence": "##string",
            "nativeSymbol": "#string",
            "treatAsGrossAmount": "#boolean",
            "createdByName": "#string",
            "requestId": "#uuid",
            "logPolicyType": "#string",
            "logApproverNumber": "#number",
            "remainingApproversNumber": "#number",
            "remainingRequiredApprovers": "#[]",
            "remainingNonRequiredApprovers": "#[]",
            "id": "#uuid",
            "transactionId": "#uuid",
            "type": "#string",
            "status": "#string",
            "operation": "#string",
            "amount": "#number",
            "feetype": "#string",
            "note": "##string",
        }
        """
        * def expAdditionalData =
        """
        {
            "quorumId": "#uuid",
            "quorumRequestId": "#uuid"
        }
        """
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
        Then match response.data contains expDataSchema
        Then match response.data.additionalData contains expAdditionalData

    @GetTravelRuleTransactions @RAKCON-35284
    Scenario: Get travel rule transactions not showing not applicable badge
        * call read(connectDB + 'SelectTxnNotScreeningThroughFireblocks')
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

        