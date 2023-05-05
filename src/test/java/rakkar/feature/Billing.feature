@RAKCON-10583
Feature: Billing
  Background:
    * url baseURL
    * call read('RequesterAuthenticator.feature@RequesterAccessToken')

  @RAKCON-12805 @View_billing_list
  Scenario: View billing list
    * def query = { offset: '0', limit:'10'}
    Given path 'core/customers/billings'
    And params query
    When method GET
    Then status 200
    And match response.status == "success"