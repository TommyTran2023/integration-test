@ignore
Feature: Get access token for Requester

  Background:
    * def testData = read('classpath:data/cross_workspace_data.json')

  # Authen for user in cross workspace - DEV env
  @GetSessionForLoginDev
  Scenario: Requester - Get session for login - Dev env
    Given url 'https://mobile-dev-api.thailaksa.net/auth/authorization/initiate-auth'
    And request { "initiateAuthRequest": { "AuthFlow": "CUSTOM_AUTH", "AuthParameters": { "USERNAME": '#(dev_workspace.userInfo.requesterUsername)' } } }
    When method POST
    Then status 201

  @RequesterAccessTokenDev
  Scenario: Requester - Get token for login - Dev env
    Given url 'https://mobile-dev-api.thailaksa.net/auth/authorization/respond-to-auth-challenge'
    * def responseTest1 = call read('RequesterAuthenticator.feature@GetSessionForLoginDev')
    * def Session1 = responseTest1.response.data.Session
    * request { "respondToAuthChallengeRequest": { "ChallengeName": "CUSTOM_CHALLENGE", "ChallengeResponses": { "USERNAME": '#(dev_workspace.userInfo.requesterUsername)', "ANSWER": '#(testData.common.challengeAnswerAuth)' }, "Session": '#(Session1)' }, "deviceName": "duncan" }
    When method POST
    Then def APIStatus = response.status
    * assert (APIStatus == "success")
    * def requesterAuthToken = response.data.AuthenticationResult.AccessToken
    * def accessToken = 'Bearer ' + requesterAuthToken
    * configure headers = {Authorization: '#(accessToken)'}

  #Authen for user in cros workspace - UAT env
  @GetSessionForLoginUat
  Scenario: Requester - Get session for login - Uat env
    Given url 'https://mobile-uat-api.rakkardigital.com/auth/authorization/initiate-auth'
    And request { "initiateAuthRequest": { "AuthFlow": "CUSTOM_AUTH", "AuthParameters": { "USERNAME": '#(uat_workspace.userInfo.requesterUsername)' } } }
    When method POST
    Then status 201

  @RequesterAccessTokenUat
  Scenario: Requester - Get token for login - Uat env
    Given url 'https://mobile-uat-api.rakkardigital.com/auth/authorization/respond-to-auth-challenge'
    * def responseTest1 = call read('RequesterAuthenticator.feature@GetSessionForLoginUat')
    * def Session1 = responseTest1.response.data.Session
    * request { "respondToAuthChallengeRequest": { "ChallengeName": "CUSTOM_CHALLENGE", "ChallengeResponses": { "USERNAME": '#(uat_workspace.userInfo.requesterUsername)', "ANSWER": '#(testData.common.challengeAnswerAuth)' }, "Session": '#(Session1)' }, "deviceName": "duncan" }
    When method POST
    Then def APIStatus = response.status
    * assert (APIStatus == "success")
    * def requesterAuthToken = response.data.AuthenticationResult.AccessToken
    * def accessToken = 'Bearer ' + requesterAuthToken
    * configure headers = {Authorization: '#(accessToken)'}