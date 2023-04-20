@RAKCON-10583 @ignore
Feature: Transaction
  Background:
    * url baseURL
    * call read('RequesterAuthenticator.feature@RequesterAccessToken')
    * call read('Common.feature@TIERS_SIGNER')

  @ignore @Filter_transaction_common
  Scenario: Filter transaction
    Given path '/core/transactions'
    And params query
    When method GET
    Then status 200
    And match response.status == "success"

  @RAKCON-10904 @view_transaction_listing
  Scenario: View transaction listing
    # View transaction listing
    * def query = { offset: '0', limit:'10'}
    * call read('Transaction.feature@Filter_transaction_common')
    * def transListResponse = response.data.transactions

    @ignore @Filter_transaction_by_value_low
    Scenario: Filter transaction by value
      * def query = { limit:'10', offset: '0', priceFrom:'0', priceTo: '#(amount_low)', status: 'PENDING'}
      * call read('Transaction.feature@Filter_transaction_common')action

   @ignore @Filter_transaction_by_value_medium
   Scenario: Filter transaction by value
    * def query = { limit:'10', offset: '0', priceFrom:'#(amount_low)', priceTo: '#(amount_medium)', status: 'PENDING'}
    * call read('Transaction.feature@Filter_transaction_common')