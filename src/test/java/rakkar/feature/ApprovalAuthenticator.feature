@ignore
Feature: Get access token for Approval
  Background: Approval is logged in
    * url baseURL
    * def dataBody = read('classpath:data/data_test.json')
  @ignore @GetSessionForLogin
  Scenario: Approval - Get session for login
    Given path '/auth/authorization/initiate-auth'
    And request { "initiateAuthRequest": { "AuthFlow": "CUSTOM_AUTH", "AuthParameters": { "USERNAME": '#(approvalUsername)' } } }
    When method POST
    Then status 201

  @GetAccessTokenForLogin
  Scenario: Approval - Get token for login
    Given path '/auth/authorization/respond-to-auth-challenge'
    * def responseTest1 = call read('ApprovalAuthenticator.feature@GetSessionForLogin')
    * def Session1 = responseTest1.response.data.Session
    * print 'Session1: ', Session1
    * request { "respondToAuthChallengeRequest": { "ChallengeName": "CUSTOM_CHALLENGE", "ChallengeResponses": { "USERNAME": '#(approvalUsername)', "ANSWER": '#(dataBody.common.challengeAnswerAuth)' }, "Session": '#(Session1)' }, "deviceName": "duncan" }
    When method POST
    Then def APIStatus = response.status
    * assert (APIStatus == "success")