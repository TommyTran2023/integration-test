    @ignore 
Feature: REP transaction svc

  Background:
    Given url typeof customUrl != 'undefined' ? customUrl : baseURL

    @GET_transaction_transactions_source-destination
  Scenario: GET transaction transactions source-destination
   	Given path '/transaction/transactions/source-destination'
   	* headers headers 
   	And params params
   	When method GET
