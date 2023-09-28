@PT
Feature: Filter transactions
  Background:
    * url baseURL

  Scenario: Filter transaction
    * def query = { offset: '0', limit:'10'}
    * def res = call read('classpath:rakkar/services/Transaction.feature@GetTransactionsList') { url: '#(baseURL)', query: '#(query)' }
    Then status 201
    And match response.status == "success"
