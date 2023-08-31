@ignore
Feature: Get access token for User from different customer

  Background:
    * url baseURL
    * def testData = read('classpath:data/data_test.json')

  @GetSessionForLogin_DifferentCompany
  Scenario: Requester - Get session for login
    Given path '/auth/authorization/initiate-auth'
    And request { "initiateAuthRequest": { "AuthFlow": "CUSTOM_AUTH", "AuthParameters": { "USERNAME": '#(userOtherCustomerInfor.userName)' } } }
    When method POST
    Then status 201

  @RequesterAccessToken_DifferentCompany
  Scenario: Requester - Get token for login
    Given path '/auth/authorization/respond-to-auth-challenge'
    * def responseTest1 = call read('DiffCustomerAuthenticator.feature@GetSessionForLogin_DifferentCompany')
    * def Session1 = responseTest1.response.data.Session
    * request { "respondToAuthChallengeRequest": { "ChallengeName": "CUSTOM_CHALLENGE", "ChallengeResponses": { "USERNAME": '#(userOtherCustomerInfor.userName)', "ANSWER": '#(testData.common.challengeAnswerAuth)' }, "Session": '#(Session1)' }, "deviceName": "duncan" }
    When method POST
    Then status 201
    * def requesterAuthToken = response.data.AuthenticationResult.AccessToken
    * def accessToken = 'Bearer ' + requesterAuthToken
    * configure headers = {Authorization: '#(accessToken)'}

