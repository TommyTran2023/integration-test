Feature: Transactions
# including all api calls related to route /transaction
  Background:
    * url baseURL
    * def nameResolver = function(x){ if (x != "") return x; else return null }

    @GetTransactionsList
    Scenario: Get transactions list
      Given path 'transaction/transactions/v1'
      And request query
      When method POST

    @ViewTransactionDetail
    Scenario: View transaction detail common
      Given path 'transaction/transactions/' + transactionId
      When method GET

    @ExportTransaction
    Scenario: Export transaction
      Given path 'transaction/transactions/export-web'
      And request body
      When method POST


