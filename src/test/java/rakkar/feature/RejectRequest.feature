@RAKCON-10583
Feature: Reject Request

  Background:
      #@PRECOND_RAKCON-11353
    * url baseURL
    * call read('this:ApprovalAuthenticator.feature@GetAccessTokenForLogin')
    * def challengeApprover = call read('this:Common.feature@FIDO-Approver')
    * def testData = read('classpath:data/data_test.json')

  @RAKCON-11005 @RejectEditPolicy
  Scenario: Reject request - Edit policy
    * call read('this:AccountPolicy.feature@ViewAccountPolicy')
    * if (requestId == null) karate.call('this:AccountPolicy.feature@EditAccountPolicy')
    * call read('this:AccountPolicy.feature@ViewAccountPolicy')
    * call read('this:RejectRequest.feature@RejectRequestCommon')

  @RAKCON-11000 @RejectNewVaultRequest
  Scenario: Reject request - New vault policy request
    * call read('this:Vault.feature@GetCreateVaultRequestID')
    * call read('this:RejectRequest.feature@RejectRequestCommon')

  @RAKCON-11002 @RejectEditVaultRequest
  Scenario: Reject request - Edit Vault policy request
    * call read('this:Vault.feature@EditVaultPolicy')
    * def requestId = editVaultPolicy.response.data.record.id
    * call read('this:RejectRequest.feature@RejectRequestCommon')

  @RAKCON-11063 @RejectAddWhitelistAddress
  Scenario: Reject request - Add whitelist address
    * call read('this:WhiteListFolder.feature@Create_address_internal')
    * call read('this:RejectRequest.feature@RejectRequestCommon')

  @RAKCON-11788 @RejectTransfer_Hot_to_Cold
  Scenario: Reject request - Reject transfer hot to cold
    * def value = call read('this:Transfer.feature@Transfer_value_hot_to_cold')
    * def requestId = value.response.data.requestId
    * call read('this:RejectRequest.feature@RejectRequestCommon')

  @RAKCON-11789 @RejectTransfer_Cold_to_Hot
  Scenario: Reject request - Reject transfer cold to hot
    * def value = call read('this:Transfer.feature@Transfer_value_cold_to_hot')
    * def requestId = value.response.data.requestId
    * call read('this:RejectRequest.feature@RejectRequestCommon')

  @RAKCON-11790 @RejectTransfer_Cold_to_Cold
  Scenario: Reject request - Reject transfer cold to cold
    * def value = call read('this:Transfer.feature@Transfer_value_cold_to_cold')
    * def requestId = value.response.data.requestId
    * call read('this:RejectRequest.feature@RejectRequestCommon')

  @RAKCON-11064 @RejectTransferLow
    Scenario: Reject request - Reject transfer low value
    * def value = call read('this:Transfer.feature@Transfer_value_hot_to_hot')
    * def requestId = value.response.data.requestId
    * call read('this:RejectRequest.feature@RejectRequestCommon')

  @RAKCON-11791 @RejectTransferMediun
  Scenario: Reject request - Reject transfer medium value
    * def value = call read('this:Transfer.feature@Transfer_medium_value')
    * def requestId = value.response.data.requestId
    * call read('this:RejectRequest.feature@RejectRequestCommon')

  @RAKCON-11792 @RejectTransferHigh
  Scenario: Reject request - Reject transfer high value
    * def value = call read('this:Transfer.feature@Transfer_high_value')
    * def requestId = value.response.data.requestId
    * call read('this:RejectRequest.feature@RejectRequestCommon')

  @ignore @RAKCON-11926 @RejectTransferExternal
  Scenario: Reject request - Transfer external
    * def value = call read('this:Transfer.feature@External_Transfer')
    * def requestId = value.response.data.requestId

  @RAKCON-11062 @RejectChangeRole
  Scenario: Reject request - Change role
    * call read('this:UserManagement.feature@Change_role')
    * call read('this:RejectRequest.feature@RejectRequestEditUserCommon')

  @RAKCON-11060 @RejectAddVaultAccess
  Scenario: Reject request - Add vault access
    * call read('this:UserManagement.feature@Add_vault_access')
    * call read('this:RejectRequest.feature@RejectRequestEditUserCommon')

  @RAKCON-11061 @RejectRemoveVaultAccess
  Scenario: Reject request - Remove vault access
    * call read('this:UserManagement.feature@Remove_vault_access')
    * call read('this:RejectRequest.feature@RejectRequestEditUserCommon')

  @RAKCON-11059 @RejectRemoveAccountAccess
  Scenario: Reject request - Remove User access
    * call read('this:UserManagement.feature@Remove_account_access')
    * call read('this:RejectRequest.feature@RejectRequestEditUserCommon')

  @ignore @RAKCON-15105 @RejectEditProfileRouting
  Scenario: Reject request - Reject edit profile routing
    * def value = call read('this:NetworkManagement.feature@Editprofilerouting')
    * def requestId = value.response.data.requestId
    * call read('this:RejectRequest.feature@RejectRequestCommon')

  @ignore @RAKCON-15208 @RejectAddNetworkConnection
  Scenario: Reject request - Reject add network connection
    * def value = call read('this:NetworkManagement.feature@Addnetworkconnection')
    * def requestId = value.response.data.requestId
    * call read('this:RejectRequest.feature@RejectRequestCommon')

  @RAKCON-16709 @RejectCreateStaking
  Scenario: Reject request - Create staking
    * def value = call read('this:Staking.feature@Create_staking')
    * def requestId = value.response.data.requestId
    * call read('this:RejectRequest.feature@RejectRequestCommon')

  @RAKCON-16710 @RejectUnStaking
  Scenario: Reject request - Un staking
    * def value = call read('this:Staking.feature@Un_staking')
    * def requestId = value.response.data.requestId
    * call read('this:RejectRequest.feature@RejectRequestCommon')

  @RAKCON-16711 @RejectChangeStakingPool
  Scenario: Reject request - Change Pool staking
    * def value = call read('this:Staking.feature@ChangeStakingPool')
    * def requestId = value.response.data.requestId
    * call read('this:RejectRequest.feature@RejectRequestCommon')

  @RAKCON-18737 @RejectEditGroupMembersRequest  @ignore
  Scenario: Reject Edit Group Members Request
    * call read('this:GroupPolicies.feature@EditMembersInGroup')
    * def groupDetails = call read('this:GroupPolicies.feature@ViewGroupDetails')
    * def requestId = groupDetails.response.data.editRequestId
    * karate.call('this:RejectRequest.feature@RejectRequestCommon')

  @ignore @RejectRequestEditUserCommon
  Scenario: Reject request edit user - Common
    * def value = call read('this:UserManagement.feature@View_user_detail')
    * def requestId = value.response.data.pendingRequestId
    * call read('this:RejectRequest.feature@RejectRequestCommon')

  @ignore @RejectRequestCommon
  Scenario: Reject pending request - Common
    Given path '/advance-quorum/quorums/reject'
    * header challenge-answer = challengeApprover.challengeAnswerRequest
    * request {"recordId" : "#(requestId)", "reason" : "AT Reject Request Note"}
    When method PUT
    Then status 200
    * match response.status == 'success'

  # Reject Advance Quorums Request
  @ignore @RejectAdvanceQuorumRequest
  Scenario: Reject pending request - Common
    Given path '/advance-quorum/quorums/reject'
    * header challenge-answer = challengeApprover.challengeAnswerRequest
    * request {"recordId" : "#(requestId)", "reason" : "AT Reject Request Note"}
    When method PUT
    Then status 200
    * match response.status == 'success'


  @RAKCON-19042 @RejectAdvanceQuorums
  Scenario: Reject create advance quorum request
    * def createdVault = call read('this:Vault.feature@SubmitRequestCreateAdvanceVaultFromMobile')
    * def vaultIDWA = createdVault.response.data.vaultId
    * call read('this:Vault.feature@GetCreateVaultRequestID_NoCreate')
    * karate.call('this:RejectRequest.feature@RejectAdvanceQuorumRequest')
