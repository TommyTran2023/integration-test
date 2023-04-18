@RAKCON-10576 @AT @ignore
Feature: Get user ID of requester

  Background:
    #@PRECOND_RAKCON-10224
    * url baseURL
    * def requesterAuthResponse = call read('RequesterAuthenticator.feature@RequesterAccessToken')

  @RAKCON-10221 @GetRequesterInfo
  Scenario: Requester - Get ID of requester
    Given path '/auth/account/me'
    When method GET
    Then status 200
    * def requesterID = response.data.id
    * def requesterEmail = response.data.email
    * def requesterName = response.data.name

