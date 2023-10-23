Feature: Advance Quorum Service
Background:
    * url baseURL

#----------------Quorums----------------#
@ApproveRequest
Scenario: Approve request
    Given path 'advance-quorum/quorums/approval', requestId
    * header Authorization = authorization
    * header challenge-answer = challengeAnswer
    * header passcode = passcode
    When method POST

@RejectRequest
Scenario: Reject request
    Given path 'advance-quorum/quorums/reject', requestId
    * header Authorization = authorization
    * header challenge-answer = challengeAnswer
    * header passcode = passcode
    When method POST

@GetApprovalList
Scenario: Get approval list
    Given path 'advance-quorum/quorums'
    * header Authorization = authorization
    * request body
    When method POST

