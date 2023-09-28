Feature: Transactions
# including all api calls related to route /transaction

    @GetTransactionsList
    Scenario: Get transactions list
        Given url url + '/transaction/transactions/v1'
        And request query
        When method POST

    @ViewTransactionDetail
    Scenario: View transaction detail common
      Given url url + '/transaction/transactions/' + transactionId
      When method GET

    @ExportTransaction
    Scenario: Export transaction
      Given url url + '/transaction/transactions/export'
      And request body
      When method POST

    