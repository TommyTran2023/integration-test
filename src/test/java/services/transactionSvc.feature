Feature: Transactions
# including all api calls related to route /transaction
  Background:
    * url baseURL
    * def nameResolver = function(x){ if (x != "") return x; else return null }

    @GetTransactionsList
    Scenario: Get transactions list
      Given path 'transaction/transactions/v1'
      * header authorization = authorization
      And request query
      When method POST

    @ViewTransactionDetail
    Scenario: View transaction detail common
      Given path 'transaction/transactions/' + transactionId
      * header authorization = authorization
      When method GET

    @ExportTransaction
    Scenario: Export transaction
      Given path 'transaction/transactions/export-web'
      * header authorization = authorization
      And request body
      When method POST

    @RebalanceMediumAmount
    Scenario: Rebalance Medium Amount
      Given path 'transaction/transactions'
      * header authorization = authorization
      * header challengeAnswer = challengeAnswer
      * header passcode = passcode
      And request body
      When method POST


