Feature: Biometric
    Background:
    * url baseURL
    * def svc = 'classpath:rakkar/services/'
    * callonce read(svc + 'ReadData.feature@ReadDataFile')

    @DoBiometricRequester
    Scenario: Generate challenge answer for Requester
    * def requesterAuthResponse = call read(svc + 'Auth.feature@GetRequesterAccessToken')
    * def requesterAuthToken = requesterAuthResponse.response.data.AuthenticationResult.AccessToken
    * def requesterAccessToken = 'Bearer ' + requesterAuthToken
    * call read(svc + 'coreSvc.feature@RequestChallenge') {authorization: #(requesterAccessToken)}
    Then match responseStatus == 201
    * def challenge = response.data.challenge
    * string command = testData.commandToGenChallengeAnswer + challenge
    * def challengeAnswerRequest = karate.exec(command)
    * print challengeAnswerRequest
