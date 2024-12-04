@RAKCON-10583
Feature: Account admin policy

  Background:
    #@PRECOND_RAKCON-11352
    * url baseURL
    * call read('this:RequesterAuthenticator.feature@RequesterAccessToken')
    * def getRequesterIDResponse = call read('this:GetUserInfo.feature@GetUserInfo')
    * def customerId = getRequesterIDResponse.response.data.customerId
    * def testData = read('classpath:data/dataTest.json')
    * def schemaBody = read('classpath:data/schema.json')

  @RAKCON-10939 @ViewAccountPolicy
  Scenario: View account policy
    Given path 'core/quorums/account-policy'
    When method GET
    Then status 200
    * match response.status == 'success'
    * match response.data.organizationName == '#string'
    * def quorumParticipantSchema = schemaBody.accountPolicy.schema_list
    * match response.data.quorumParticipants contains quorumParticipantSchema
    * def requestId = response.data.pendingRequestId

  @RAKCON-10940 @EditAccountPolicy
  Scenario: Edit account policy
    * callonce read('this:AccountPolicy.feature@ViewAccountPolicy')
    * if (requestId != null) karate.call('this:RejectRequest.feature@RejectEditPolicy')
    Given path '/core/customers/' + customerId
    * call read('this:Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    * header passcode = requesterPasscode
    * request {"note" : "AT Edit Account Policy Note",  "memberRequired" : [],  "quorumSize" : 2}
    When method PUT
    Then status 200
    * match response.status == 'success'
    * call read('this:AccountPolicy.feature@ViewAccountPolicy')
    * match requestId != null

  @RAKCON-11348 @EditAccountPolicyHasPending
  Scenario: Edit account policy when has pending request
    * callonce read('this:AccountPolicy.feature@EditAccountPolicy')
    Given path '/core/customers/' + customerId
    * call read('this:Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    * header passcode = requesterPasscode
    * request {"note" : "AT Edit Account Policy Note",  "memberRequired" : [],  "quorumSize" : 2}
    When method PUT
    Then status 400
    * match response.errorCode == 'EXISTS_PENDING_REQUEST'

  @RAKCON-13612 @ViewAccountPolicyRequest
  Scenario: View account policy request
    * call read('this:AccountPolicy.feature@EditAccountPolicy')
    Given path 'core/quorums/request/'+requestId
    When method GET
    Then status 200
    * match response.status == 'success'
    * match response.data.id == requestId
    * match response.data.action == testData.account_policy.action
    * def approvalLogs = response.data.approvalLogs
    * def initiator = karate.jsonPath(approvalLogs,"$.[?(@.status=='INITIATED')].userId")









