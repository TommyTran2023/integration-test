Feature: Advance Quorum Service
  Background:
    * url baseURL

#----------------Quorums----------------#
    @ApproveRequest
  Scenario: Approve request
    Given path 'advance-quorum/quorums/approval/' + requestId
    * header Authorization = authorization
    * header challenge-answer = challengeAnswer
    * header passcode = passcode
    * request body
    When method POST

    @RejectRequest
  Scenario: Reject request
    * configure headers = null
    Given path 'advance-quorum/quorums/reject'
    * header Authorization = authorization
    * header challenge-answer = challengeAnswer
    * request {recordId : "#(requestId)", reason : "#(reason)"}
    When method PUT

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
    Given path 'advance-quorum/quorums/' + quorumId
    * header Authorization = authorization
    When method GET

    @GetAccountPolicy
  Scenario: Get Account Policy
    Given path 'advance-quorum/quorums/account-policy'
    * header Authorization = authorization
    When method GET
  
    @ViewAccountPolicyRequest
  Scenario: View account policy request
    Given path 'advance-quorum/quorums/request/'+requestId
    * header Authorization = authorization
    When method GET

    @GetTotalPendingRequest
  Scenario: Get Total Pending Request
      Given path 'advance-quorum/quorums/total-pending'
      * header Authorization = authorization
      When method GET

    @GetListCreatedByUser
  Scenario: Get list creator
      Given path 'advance-quorum/quorums/list-creator'
      * header Authorization = authorization
      * params params
      When method GET

    @CheckRequestImpact
  Scenario: Check Request Impact
    Given path 'advance-quorum/quorums/check-impact/' + quorumRecordId
    * header Authorization = authorization
    When method PUT

    @GetVideoTextSentence
  Scenario: Get video captured sentence
    Given path 'advance-quorum/quorums/video-text-sentence'
    * header Authorization = authorization
    When method GET

    @GetVideoRandomWords
  Scenario: Get video random words speech prompt
    Given path 'advance-quorum/quorums/video-speech-prompt'
    * header Authorization = authorization
    When method GET

    @CountPendingRequest
  Scenario: Get count pending request
    Given path 'advance-quorum/quorums/count-pending-request'
    * header Authorization = authorization
    When method GET

    @ReadPendingRequest
  Scenario: Read pending request
    Given path 'advance-quorum/quorums/read-pending-request'
    * header Authorization = authorization
    * request body
    When method PUT

    @GetQuorumDraftByIdByRequestDraftId
  Scenario: Get Quorum Draft By Id By Request Draft Id
    Given path 'advance-quorum/quorums/draft/' + quorumDraftId
    * header Authorization = authorization
    When method GET

    @ApproveQuorumDraftByIdByRequestDraftId
  Scenario: Approve Quorum Draft By Id By Request Draft Id
    Given path 'advance-quorum/quorums/draft/' + quorumDraftId + '/approve'
    * header Authorization = authorization
    When method PATCH

    @RejectQuorumDraftByIdByRequestDraftId
  Scenario: Reject Quorum Draft By Id By Request Draft Id
    Given path 'advance-quorum/quorums/draft/' + quorumDraftId + '/reject'
    * header Authorization = authorization
    When method PATCH

    @CancelQuorumDraftByIdByRequestDraftId
  Scenario: Cancel Quorum Draft By Id By Request Draft Id
    Given path 'advance-quorum/quorums/draft/' + quorumDraftId + '/cancel'
    * header Authorization = authorization
    When method PATCH

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

  @CreateGroupUsers
  Scenario: Create Group Users
    Given path 'advance-quorum/group-policies'
    And header Authorization = authorization
    * request body
    When method GET

  @ValidateGroupPolicy
  Scenario: Validate group policy
    Given path 'advance-quorum/group-policies/validate-group-policy'
    And header Authorization = authorization
    * request body
    When method POST

  @EditGroupName
  Scenario: Edit group policy name
    Given path 'advance-quorum/group-policies/' + groupId
    And header Authorization = authorization
    * request body
    When method POST

  @EditGroupMember
  Scenario: Update group name or member
    Given path 'advance-quorum/group-policies/' + groupId
    And header Authorization = authorization
    * request body
    When method PUT



