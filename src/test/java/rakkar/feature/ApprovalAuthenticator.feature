@ignore
Feature: Get access token for Approval
  Background: Approval is logged in
    * url baseURL
    * def testData = read('classpath:data/data_test.json')
  @ignore @GetSessionForLogin
  Scenario: Approval - Get session for login
    Given path '/auth/authorization/initiate-auth'
    And request { "initiateAuthRequest": { "AuthFlow": "CUSTOM_AUTH", "AuthParameters": { "USERNAME": '#(approverInfo.approvalUsername)' } } }
    When method POST
    Then status 201

  @GetAccessTokenForLogin
  Scenario: Approval - Get token for login
    Given path '/auth/authorization/respond-to-auth-challenge'
    * def responseTest1 = call read('this:ApprovalAuthenticator.feature@GetSessionForLogin')
    * def Session1 = responseTest1.response.data.Session
    * request { "respondToAuthChallengeRequest": { "ChallengeName": "CUSTOM_CHALLENGE", "ChallengeResponses": { "USERNAME": '#(approverInfo.approvalUsername)', "ANSWER": '#(privateKey.challengeAnswerAuth)' }, "Session": '#(Session1)' }, "deviceName": "duncan" }
    When method POST
    Then def APIStatus = response.status
    * assert (APIStatus == "success")
    * def approvalAuthToken = response.data.AuthenticationResult.AccessToken
    * def approvalAccessToken = 'Bearer ' + approvalAuthToken
    * configure headers = {Authorization: '#(approvalAccessToken)'}
