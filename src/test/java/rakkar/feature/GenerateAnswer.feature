Feature: Generate Challenge Answer for Biometric

  Background:
    * url baseURL
    * def dataBody = read('classpath:data/data_test.json')

  @FIDO-Requester
  Scenario: Generate challenge answer for Requester
    Given path '/core/biometric/request-challenge'
    * def requesterAuthResponse = call read('RequesterAuthenticator.feature')
    * def requesterAuthToken = requesterAuthResponse.response.data.AuthenticationResult.AccessToken
    * def requesterAccessToken = 'Bearer ' + requesterAuthToken
    * header Authorization = requesterAccessToken
    When method POST
    Then status 201
    * def challenge = response.data.challenge
    * string command = dataBody.common.commandToGenChallengeAnswer + challenge
    * def challengeAnswerRequest = karate.exec(command)
    * print challengeAnswerRequest

  @FIDO-Approver
  Scenario: Generate challenge answer for Approver
    Given path '/core/biometric/request-challenge'
    * def approverAuthResponse = call read('ApprovalAuthenticator.feature')
    * def approverAuthToken = approverAuthResponse.response.data.AuthenticationResult.AccessToken
    * def approverAccessToken = 'Bearer ' + approverAuthToken
    * header Authorization = approverAccessToken
    When method POST
    Then status 201
    * def challenge = response.data.challenge
    * string command = dataBody.common.commandToGenChallengeAnswer + challenge
    * def challengeAnswerRequest = karate.exec(command)
    * print challengeAnswerRequest
