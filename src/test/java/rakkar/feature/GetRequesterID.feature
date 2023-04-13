@RAKCON-10576 @AT @ignore
Feature: Get user ID of requester

  Background:
    #@PRECOND_RAKCON-10224
    * url baseURL
    * def requesterAuthResponse = call read('RequesterAuthenticator.feature')
    * def requesterAuthToken = requesterAuthResponse.response.data.AuthenticationResult.AccessToken
    * def accessToken = 'Bearer ' + requesterAuthToken
    * configure headers = {Authorization: '#(accessToken)'}

  @RAKCON-10221 @GetRequesterID
  Scenario: Requester - Get ID of requester
    Given path '/auth/account/me'
    When method GET
    Then status 200
    * def requesterID = response.data.id
    * def email = response.data.email
    * print 'requesterID: ', requesterID

