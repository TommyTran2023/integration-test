@RAKCON-10938
Feature: Account admin policy

  Background:
    #@PRECOND_RAKCON-11352
    * url baseURL
    * call read('RequesterAuthenticator.feature@RequesterAccessToken')
    * def getRequesterIDResponse = call read('GetRequesterID.feature')
    * def customerId = getRequesterIDResponse.response.data.customerId
    * def dataBody = read('classpath:data/data_test.json')
    * def schemaBody = read('classpath:data/schema.json')

  @RAKCON-10939 @ViewAccountPolicy
  Scenario: View account policy
    Given path 'core/quorums/account-policy'
    When method GET
    Then status 200
    * match response.status == 'success'
    * match response.data.organizationName == '#string'
    #* def quorumParticipant = {"userId":'#string', "role":'#string', "requiredApprover":#boolean, "picture":'##string', "email":'#string', "name":'#string', "roleDisplayName":'#string'}
    #* match response.data.quorumParticipants == '#[]quorumParticipant'
    * def quorumParticipantSchema = schemaBody.accountPolicy.schema_list
    * match response.data.quorumParticipants contains quorumParticipantSchema
    * def requestId = response.data.pendingRequestId

  @RAKCON-10940 @EditAccountPolicy
  Scenario: Edit account policy
    * callonce read('AccountPolicy.feature@ViewAccountPolicy')
    * if (requestId != null) karate.call('RejectRequest.feature@RejectEditPolicy')
    Given path '/core/customers/' + customerId
    * call read('Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    * header passcode = requesterPasscode
    * request {"note" : "AT Edit Account Policy Note",  "memberRequired" : [],  "quorumSize" : 2}
    When method PUT
    Then status 200
    * match response.status == 'success'
    * call read('AccountPolicy.feature@ViewAccountPolicy')
    * match requestId != null

  @RAKCON-11348 @EditAccountPolicyHasPending
  Scenario: Edit account policy when has pending request
    * callonce read('AccountPolicy.feature@EditAccountPolicy')
    Given path '/core/customers/' + customerId
    * call read('Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    * header passcode = requesterPasscode
    * request {"note" : "AT Edit Account Policy Note",  "memberRequired" : [],  "quorumSize" : 2}
    When method PUT
    Then status 400
    * match response.errorCode == 'EXISTS_PENDING_REQUEST'










