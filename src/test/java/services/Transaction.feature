Feature: Transactions

@RebalanceMediumAmount
Scenario: Rebalance Medium Amount
    * def data =
    """
    {
        authorization: #(requesterAccessToken),
        challengeAnswer: "#(challengeAnswerRequest)",
        passcode: "#(requesterInfo.requesterPasscode)",
        body: #(body)
    }
    """
    * call read(svc + 'transactionSvc.feature@RebalanceMediumAmount') data
    Then match responseStatus == 201

@GetTransactionsList
Scenario: Get transactions list
    * call read(svc + 'transactionSvc.feature@GetTransactionsList') {authorization: #(requesterAccessToken)}
    Then match responseStatus == 201

@ViewTransactionDetail
Scenario: View transaction detail common
    * call read(svc + 'transactionSvc.feature@ViewTransactionDetail') {authorization: #(requesterAccessToken)}
    Then match responseStatus == 200

@ExportTransaction
Scenario: Export transaction
    * call read(svc + 'transactionSvc.feature@ExportTransaction') {authorization: #(requesterAccessToken)}
    Then match responseStatus == 201
