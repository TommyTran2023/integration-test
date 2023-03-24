@RAKCON-10937 @ignore
Feature: Transaction

  Background:
    * url baseURL
    * def requesterAuthResponse = call read('RequesterAuthenticator.feature')
    * def requesterAuthToken = requesterAuthResponse.response.data.AuthenticationResult.AccessToken
    * def accessToken = 'Bearer ' + requesterAuthToken
    * configure headers = {Authorization: '#(accessToken)'}

  @RAKCON-10904
  Scenario: View transaction listing
    # View transaction listing
    Given path '/core/transaction'
    * param limit = 9999999
    * param offset = 0
    When method GET
    Then status 200
    * def transListResponse = response.data.transactions