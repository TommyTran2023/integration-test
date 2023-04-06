  @RAKCON-10947
  Feature: Reject Request
    Background:
      #@PRECOND_RAKCON-11353
      * url baseURL
      * call read('ApprovalAuthenticator.feature@GetAccessTokenForLogin')
      * def challengeApprover = call read('GenerateAnswer.feature@FIDO-Approver')
      * def dataBody = read('classpath:data/data_test.json')
    @RAKCON-11005 @RejectEditPolicy
    Scenario: Reject request - Edit policy
      * call read('AccountPolicy.feature@ViewAccountPolicy')
      * if (requestId == null) karate.call('AccountPolicy.feature@EditAccountPolicy')
      * call read('AccountPolicy.feature@ViewAccountPolicy')
      * call read('ApprovalAuthenticator.feature@GetAccessTokenForLogin')
      Given path '/core/quorums/reject'
      * header challenge-answer = challengeApprover.challengeAnswerRequest
      * request {"recordId" : "#(requestId)", "reason" : "AT Reject Edit Account Policy Note"}
      When method PUT
      Then status 200