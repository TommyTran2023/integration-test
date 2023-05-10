@ignore
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

  @RAKCON-13164 @VERIFY-PASSCODE
  Scenario: Verify passcode of Requester
    #Verify requesterPasscode
    Given path '/auth/account/verify-passcode'
    * def requesterAuthResponse = call read('RequesterAuthenticator.feature')
    * def requesterAuthToken = requesterAuthResponse.response.data.AuthenticationResult.AccessToken
    * def requesterAccessToken = 'Bearer ' + requesterAuthToken
    * header Authorization = requesterAccessToken
    * request {"passcode":'#(requesterInfo.requesterPasscode)'}
    When method POST
    Then status 201
    * def verifyStatus = response.data.verify
    * match verifyStatus == true

  @ignore @BY-PASS-BIOMETRIC
  Scenario: By pass biometric method
    #By pass biometric method
    Given path '/core/biometric/request-challenge'
    * request {}
    When method POST
    Then status 201
    * def statusMsg = response.status
    * match statusMsg == 'success'

  @ignore @TIERS_SIGNER
  Scenario: Transfer - View asset list for transfer
    Given path 'core/transactions/tiers-signer'
    When method GET
    Then status 200
    * def amount_low = response.data[0].to
    * def amount_medium = response.data[1].to

  @ignore @VIDEO_SPEECH_PROMPT
  Scenario: Video text sentence
    Given path 'core/quorums/video-speech-prompt'
    When method GET
    Then status 200
    And response.status == "success"
    * def vdoSentence = response.data[0] + "," + response.data[1] + "," + response.data[2]

  @ignore @UPLOAD_LINK
  Scenario: Upload link
    Given path 'auth/account/users/upload-link'
    And params query_upload_link
    When method GET
    Then status 200
    And response.status == "success"
    * def uploadUrl = response.data.uploadUrl
    * def uploadToken = response.data.uploadToken



