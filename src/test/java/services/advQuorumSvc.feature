Feature: Advance Quorum Service
Background:
    * url baseURL

#----------------Quorums----------------#
@ApproveRequest
Scenario: Approve request
    Given path 'advance-quorum/quorums/approval', data.requestId
    * header Authorization = data.authorization
    * header challenge-answer = data.challengeAnswer
    * header passcode = data.passcode
    When method POST

@RejectRequest
Scenario: Reject request
    Given path 'advance-quorum/quorums/reject', data.requestId
    * header Authorization = data.authorization
    * header challenge-answer = data.challengeAnswer
    * header passcode = data.passcode
    When method POST
