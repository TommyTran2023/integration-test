@RAKCON-10583
Feature: Get access token for Requester

  @RAKCON-10216 @GetSessionForLogin
  Scenario: Requester - Get session for login
    * call read(svc + 'Auth.feature@GetRequesterAccessToken')

  @RAKCON-10091 @RequesterAccessToken
  Scenario: Requester - Get token for login
    * call read(svc + 'Auth.feature@GetRequesterAccessToken')
    * def requesterAuthToken = response.data.AuthenticationResult.AccessToken
    * def accessToken = 'Bearer ' + requesterAuthToken
    * configure headers = {Authorization: '#(accessToken)'}

