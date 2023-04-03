@RAKCON-10938 @ignore
Feature: Account admin policy
  Background:
    * url baseURL
    * def requesterAuthResponse = call read('RequesterAuthenticator.feature')
    * def requesterAuthToken = requesterAuthResponse.response.data.AuthenticationResult.AccessToken
    * def accessToken = 'Bearer ' + requesterAuthToken
    * def getRequesterIDResponse = call read('GetRequesterID.feature')
    * def customerId = getRequesterIDResponse.response.data.customerId
    * configure headers = {Authorization: '#(accessToken)'}
    * def dataBody = read('classpath:data/data_test.json')

  @RAKCON-10939
  Scenario: View account policy
    Given path 'core/quorums/account-policy'
    When method GET
    Then status 200
    * def requestId = response.data.pendingRequestId

  @RAKCON-10940
  Scenario: Edit account policy
     #By pass biometric method
    Given path '/core/biometric/request-challenge'
    When method POST
    Then status 201
    * def statusMsg = response.status
    * match statusMsg == 'success'

     #Verify requesterPasscode
    Given path '/auth/account/verify-passcode'
    * request {"passcode":'#(requesterPasscode)'}
    When method POST
    Then status 201
    * def verifyStatus = response.data.verify

     #Edit vault when has not pending request
    Given path '/core/customers/' + customerId
    * def challenge = call read('GenerateAnswer.feature')
    * header challenge-answer = challenge.challengeAnswerRequest
    * header passcode = requesterPasscode
    * request {"note" : "Note",  "memberRequired" : [  ],  "quorumSize" : 2}
    When method PUT
    Then status 200

     #Edit vault when has pending request
    Given path '/core/customers/' + customerId
    * def challenge = call read('GenerateAnswer.feature')
    * header challenge-answer = challenge.challengeAnswerRequest
    * header passcode = requesterPasscode
    * request {"note" : "Note",  "memberRequired" : [  ],  "quorumSize" : 2}
    When method PUT
    Then status 400

     #Verify the request pending on account policy
    * def viewAccountPolicy = call read('Accountpolicy.feature@RAKCON-10939')
    * def requestId = viewAccountPolicy.response.data.pendingRequestId
    Then print requestId

  @ignore
  Scenario: Cancel request account policy
    #Cancel request
    * def viewAccountPolicy = call read('Accountpolicy.feature@RAKCON-10939')
    * def requestId = viewAccountPolicy.response.data.pendingRequestId
    Given path 'core/quorums/cancel/' + requestId
    * def challenge = call read('GenerateAnswer.feature')
    * header challenge-answer = challenge.challengeAnswerRequest
    When method PUT
    Then status 200

    #Verify account policy when cancel request successful
    * def viewAccountPolicy = call read('Accountpolicy.feature@RAKCON-10939')
    * def requestId = viewAccountPolicy.response.data.pendingRequestId
    Then assert requestId == null

  @ignore
  Scenario: Reject request edit account policy
    * call read('Accountpolicy.feature@RAKCON-10940')
    * call read('Accountpolicy.feature@RAKCON-10939')
    * def responseAccountPolicy = call read('Accountpolicy.feature@RAKCON-10939')
    * def requestId = responseAccountPolicy.response.data.pendingRequestId
    * def approvalAuthResponse = call read('ApprovalAuthenticator.feature')
    * def approvalAuthToken = approvalAuthResponse.response.data.AuthenticationResult.AccessToken
    * def accessToken = 'Bearer ' + approvalAuthToken
    * configure headers = {Authorization: '#(accessToken)'}
    Given path '/core/quorums/reject'
    * def challenge = call read('GenerateAnswer.feature')
    * header challenge-answer = challenge.challengeAnswerRequest
    * request {"recordId" : "#(requestId)", "reason" : "Note"}
    When method PUT
    Then status 200

  @ignore
  Scenario: Approve request edit account policy
    * call read('Accountpolicy.feature@RAKCON-10940')
    * call read('Accountpolicy.feature@RAKCON-10939')
    * def responseAccountPolicy = call read('Accountpolicy.feature@RAKCON-10939')
    * def requestId = responseAccountPolicy.response.data.pendingRequestId
    * def approvalAuthResponse = call read('ApprovalAuthenticator.feature')
    * def approvalAuthToken = approvalAuthResponse.response.data.AuthenticationResult.AccessToken
    * def accessApprovalToken = 'Bearer ' + approvalAuthToken
    * configure headers = {Authorization: '#(accessApprovalToken)'}
    Given path 'core/quorums/approval/' + requestId
    * def challenge = call read('GenerateAnswer.feature')
    * header challenge-answer = challenge.challengeAnswerRequest
    * header passcode = approverPasscode
    When method POST
    Then status 201












