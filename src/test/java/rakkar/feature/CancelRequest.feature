@RAKCON-10946 @ignore
  Feature: Cancel Request
    Background:
      * url baseURL
      * call read('RequesterAuthenticator.feature@RequesterAccessToken')
    @RAKCON-11003 @CancelEditAccountPolicy
    Scenario: Cancel request account policy
      * call read('AccountPolicy.feature@EditAccountPolicy')
      Given path '/core/quorums/cancel/'+requestId
      * call read('Common.feature@FIDO-Requester')
      * header challenge-answer = challengeAnswerRequest
      When method PUT
      Then status 200
      * match response.status == 'success'
      * call read('AccountPolicy.feature@ViewAccountPolicy')
      * match requestId == null