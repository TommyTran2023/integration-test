@ignore
Feature: Get access token for Requester

  Background:
    * def testData = read('classpath:data/cross_workspace_data.json')
    * def challengeData = read('classpath:data/data_test.json')

  # Authen for user in cross workspace - DEV env
  @GetSessionForLoginDev
  Scenario: Requester - Get session for login - Dev env
    Given url testData.dev_workspace.url_dev + '/auth/authorization/initiate-auth'
    And request { "initiateAuthRequest": { "AuthFlow": "CUSTOM_AUTH", "AuthParameters": { "USERNAME": '#(testData.dev_workspace.userInfo.requesterUsername)' } } }
    When method POST
    Then status 201

  @RequesterAccessTokenDev
  Scenario: Requester - Get token for login - Dev env
    Given url testData.dev_workspace.url_dev + '/auth/authorization/respond-to-auth-challenge'
    * def responseTest1 = call read('CrossWorkSpaceAuthenticator.feature@GetSessionForLoginDev')
    * def Session1 = responseTest1.response.data.Session
    * request { "respondToAuthChallengeRequest": { "ChallengeName": "CUSTOM_CHALLENGE", "ChallengeResponses": { "USERNAME": '#(testData.dev_workspace.userInfo.requesterUsername)', "ANSWER": '#(challengeData.common.challengeAnswerAuth)' }, "Session": '#(Session1)' }, "deviceName": "duncan" }
    When method POST
    Then status 201
    * def requesterAuthToken = response.data.AuthenticationResult.AccessToken
    * def accessToken = 'Bearer ' + requesterAuthToken
    * configure headers = {Authorization: '#(accessToken)'}

  #Authen for user in cross workspace - UAT env
  @GetSessionForLoginUat
  Scenario: Requester - Get session for login - Uat env
    Given url testData.uat_workspace.url_uat + '/auth/authorization/initiate-auth'
    And request { "initiateAuthRequest": { "AuthFlow": "CUSTOM_AUTH", "AuthParameters": { "USERNAME": '#(testData.uat_workspace.userInfo.requesterUsername)' } } }
    When method POST
    Then status 201

  @RequesterAccessTokenUat
  Scenario: Requester - Get token for login - Uat env
    Given url testData.uat_workspace.url_uat + '/auth/authorization/respond-to-auth-challenge'
    * def responseTest2 = call read('CrossWorkSpaceAuthenticator.feature@GetSessionForLoginUat')
    * def Session2 = responseTest2.response.data.Session
    * request { "respondToAuthChallengeRequest": { "ChallengeName": "CUSTOM_CHALLENGE", "ChallengeResponses": { "USERNAME": '#(testData.uat_workspace.userInfo.requesterUsername)', "ANSWER": '#(challengeData.common.challengeAnswerAuth)' }, "Session": '#(Session2)' }, "deviceName": "duncan" }
    When method POST
    Then def APIStatus = response.status
    * assert (APIStatus == "success")
    * def requesterAuthToken = response.data.AuthenticationResult.AccessToken
    * def accessToken = 'Bearer ' + requesterAuthToken
    * configure headers = {Authorization: '#(accessToken)'}