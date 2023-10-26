    @ignore
Feature: Biometric
    Background:
        * callonce read(svc + 'ReadData.feature@ReadDataFile')

    @DoBiometric
    Scenario: Generate challenge answer
        * def authToken = authResponse.response.data.AuthenticationResult.AccessToken
        * def accessToken = 'Bearer ' + authToken
        * call read(svc + 'coreSvc.feature@RequestChallenge') {authorization: #(accessToken)}
        Then match responseStatus == 201
        And match response.status == 'success'

    @RequesterDoBiometric
    Scenario: Generate challenge answer for Requester
        * def authResponse = call read(svc + 'Auth.feature@GetRequesterAccessToken')
        * call read(svc + 'Biometric.feature@DoBiometric')
        * def challenge = response.data.challenge
        * string command = testData.commandToGenChallengeAnswer + challenge
        * def challengeAnswerRequest = karate.exec(command)
        * def requesterAccessToken = 'Bearer ' + authResponse.response.data.AuthenticationResult.AccessToken
        * print challengeAnswerRequest

    @ApproverDoBiometric
    Scenario: Generate challenge answer for Approver
        * def authResponse = call read(svc + 'Auth.feature@GetApproverAccessToken')
        * call read(svc + 'Biometric.feature@DoBiometric')
        * def challenge = response.data.challenge
        * string command = testData.commandToGenChallengeAnswer + challenge
        * def challengeAnswerApprover = karate.exec(command)
        * def approvalAccessToken = 'Bearer ' + authResponse.response.data.AuthenticationResult.AccessToken
        * print challengeAnswerApprover
