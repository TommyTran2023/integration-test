@RAKCON-10583
Feature: Cancel Request

  Background:
    * url baseURL
    * call read('this:RequesterAuthenticator.feature@RequesterAccessToken')
    * def challengeApprover = call read('this:Common.feature@FIDO-Approver')

  @RAKCON-11003 @CancelEditAccountPolicy
  Scenario: Cancel request account policy
    * call read('this:AccountPolicy.feature@EditAccountPolicy')
    * call read('this:CancelRequest.feature@CancelRequestCommon')
    * call read('this:AccountPolicy.feature@ViewAccountPolicy')
    * match requestId == null

  @RAKCON-10997 @CancelNewVaultRequest
  Scenario: Cancel request - New vault policy request
    * callonce read('this:Vault.feature@GetCreateVaultRequestID')
    * call read('this:CancelRequest.feature@CancelRequestCommon')

  @RAKCON-10998 @CancelEditVaultPolicy
  Scenario: Cancel request - Edit Vault policy request
    * call read('this:Vault.feature@EditVaultPolicy')
    * def requestId = editVaultPolicy.response.data.record.id
    * call read('this:CancelRequest.feature@CancelRequestCommon')

  @RAKCON-15492 @CancelEditUser
  Scenario: Cancel request - Cancel edit user
    * call read('UserManagement.feature@Change_role')
    * call read('CancelRequest.feature@CancelRequestEditUserCommon')

  @RAKCON-11051 @Cancel_Remove_Account_Access
  Scenario: Cancel request - Remove Account access
    * call read('this:UserManagement.feature@Remove_account_access')
    * call read('this:CancelRequest.feature@CancelRequestEditUserCommon')

  @RAKCON-11055 @CancelWhiteListAddress
  Scenario: Cancel request - Add whitelist address
    * call read('this:WhiteListFolder.feature@Create_address_internal')
    * call read('this:CancelRequest.feature@CancelRequestCommon')

  @RAKCON-15489 @CancelInternalWithdraw
  Scenario: Cancel request - Cancel internal withdraw
    * def value = call read('this:Transfer.feature@Transfer_value_hot_to_hot')
    * def requestId = value.response.data.requestId
    * call read('this:CancelRequest.feature@CancelRequestCommon')

  @RAKCON-18739 @CancelEditGroupMembers @ignore
  Scenario: Cancel request - Edit group members
  * call read('this:GroupPolicies.feature@EditMembersInGroup')
  * def groupDetails = call read('this:GroupPolicies.feature@ViewGroupDetails')
  * def requestId = groupDetails.response.data.editRequestId
  * call read('this:CancelRequest.feature@CancelRequestCommon')

  @ignore @RAKCON-15490 @CancelExternalWithdraw
  Scenario: Cancel request - Cancel external withdraw
    * def value = call read('this:Transfer.feature@External_Transfer')
    * def requestId = value.response.data.requestId
    * call read('this:CancelRequest.feature@CancelRequestCommon')

  @ignore @RAKCON-15491 @CancelOtherNetwork
  Scenario: Cancel request - Cancel tranfer to other network
    * def value = call read('this:Transfer.feature@Transfer_to_other_network')
    * def requestId = value.response.data.requestId
    * call read('this:CancelRequest.feature@CancelRequestCommon')

  @ignore @CancelRequestEditUserCommon
  Scenario: Cancel a request edit user - Common
    * def value = call read('this:UserManagement.feature@View_user_detail')
    * def requestId = value.response.data.pendingRequestId
    * call read('this:CancelRequest.feature@CancelRequestCommon')

  @ignore @CancelRequestCommon
  Scenario: Cancel a request - Common
    Given path '/advance-quorum/quorums/cancel/'+requestId
    * header challenge-answer = challengeApprover.challengeAnswerRequest
    When method PUT
    Then status 200
    * def statusMsg = response.status
    * match statusMsg == 'success'

  
  @ignore @CancelAdvanceQuorumRequest
  Scenario: Cancel a request - Common
    Given path '/advance-quorum/quorums/cancel/'+requestId
    * header challenge-answer = challengeApprover.challengeAnswerRequest
    When method PUT
    Then status 200
    * def statusMsg = response.status
    * match statusMsg == 'success'

  @RAKCON-19043 @CancelAdvanceQuorums
  Scenario: Cancel create advance quorum request
    * def createdVault = call read('this:Vault.feature@SubmitRequestCreateAdvanceVaultFromMobile')
    * def vaultIDWA = createdVault.response.data.vaultId
    * call read('this:Vault.feature@GetCreateVaultRequestID_NoCreate')
    * karate.call('this:CancelRequest.feature@CancelAdvanceQuorumRequest')

