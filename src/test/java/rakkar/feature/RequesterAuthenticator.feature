@RAKCON-10583
Feature: Get access token for Requester

  Background:
    #@PRECOND_RAKCON-10223
    * url baseURL
    * def dataBody = read('classpath:data/data_test.json')

  @ignore @GetSessionForLogin
  Scenario: Requester - Get session for login
    Given path '/auth/authorization/initiate-auth'
    And request { "initiateAuthRequest": { "AuthFlow": "CUSTOM_AUTH", "AuthParameters": { "USERNAME": '#(requesterInfo.requesterUsername)' } } }
    When method POST
    Then status 201

  @RAKCON-10216 @RequesterAccessToken
  Scenario: Requester - Get token for login
    Given path '/auth/authorization/respond-to-auth-challenge'
    * def responseTest1 = call read('RequesterAuthenticator.feature@GetSessionForLogin')
    * def Session1 = responseTest1.response.data.Session
    * request { "respondToAuthChallengeRequest": { "ChallengeName": "CUSTOM_CHALLENGE", "ChallengeResponses": { "USERNAME": '#(requesterInfo.requesterUsername)', "ANSWER": '#(dataBody.common.challengeAnswerAuth)' }, "Session": '#(Session1)' }, "deviceName": "duncan" }
    When method POST
    Then def APIStatus = response.status
    * assert (APIStatus == "success")
    * def requesterAuthToken = response.data.AuthenticationResult.AccessToken
    * def accessToken = 'Bearer ' + requesterAuthToken
    * configure headers = {Authorization: '#(accessToken)'}
