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
    * configure headers = null
    Given path 'advance-quorum/quorums/reject'
    * header Authorization = authorization
    * header challenge-answer = challengeAnswer
    * request {recordId : "#(requestId)", reason : "#(reason)"}
    When method POST

    @CancelRequest
  Scenario: Cancel a request
    Given path '/advance-quorum/quorums/cancel/'+requestId
    * header Authorization = authorization
    * header challenge-answer = challengeAnswer
    When method PUT

    @GetApprovalList
  Scenario: Get approval list
    Given path 'advance-quorum/quorums'
    * header Authorization = authorization
    * request body
    When method POST

    @GetQuorumPolicy
  Scenario: Get quorum policy
    Given path 'advance-quorum/quorums', quorumId
    * header Authorization = authorization
    When method GET

    @GetAccountPolicy
  Scenario: Get Account Policy
    Given path 'advance-quorum/quorums/account-policy'
    * header Authorization = authorization
    When method GET

    #----------------Group----------------#
    @GetGroupPolicies
  Scenario: Get Group Policies
    Given path 'advance-quorum/group-policies'
    And header Authorization = authorization
    * params params
    When method GET

@GetGroupDetails
Scenario: Get Group Details
    Given path 'advance-quorum/group-policies/' + groupId
    And header Authorization = authorization
    When method GET
