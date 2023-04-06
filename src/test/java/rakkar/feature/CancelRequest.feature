@RAKCON-10946 @ignore
  Feature: Cancel Request
    Background:
      * url baseURL
      * call read('RequesterAuthenticator.feature@RequesterAccessToken')
    @ignore
    Scenario: Cancel request account policy
    #Cancel request
      * def viewAccountPolicy = call read('Accountpolicy.feature@RAKCON-10939')
      * def requestId = viewAccountPolicy.response.data.pendingRequestId
      Given path 'core/quorums/cancel/' + requestId
      * def challenge = call read('Common.feature')
      * header challenge-answer = challenge.challengeAnswerRequest
      When method PUT
      Then status 200

    #Verify account policy when cancel request successful
      * def viewAccountPolicy = call read('Accountpolicy.feature@RAKCON-10939')
      * def requestId = viewAccountPolicy.response.data.pendingRequestId
      Then assert requestId == null