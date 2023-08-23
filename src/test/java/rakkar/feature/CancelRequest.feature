@RAKCON-10583
Feature: Cancel Request

  Background:
    * url baseURL
    * call read('RequesterAuthenticator.feature@RequesterAccessToken')
    * def challengeApprover = call read('Common.feature@FIDO-Approver')

  @RAKCON-11003 @CancelEditAccountPolicy
  Scenario: Cancel request account policy
    * call read('AccountPolicy.feature@EditAccountPolicy')
    * call read('CancelRequest.feature@CancelRequestCommon')
    * call read('AccountPolicy.feature@ViewAccountPolicy')
    * match requestId == null

  @RAKCON-10997 @CancelNewVaultRequest
  Scenario: Cancel request - New vault policy request
    * callonce read('Vault.feature@GetCreateVaultRequestID')
    * call read('CancelRequest.feature@CancelRequestCommon')

  @RAKCON-10998 @CancelEditVaultPolicy
  Scenario: Cancel request - Edit Vault policy request
    * call read('Vault.feature@EditVaultPolicy')
    * def requestId = editVaultPolicy.response.data.record.id
    * call read('CancelRequest.feature@CancelRequestCommon')

  @RAKCON-15492 @CancelEditUser
  Scenario: Cancel request - Cancel edit user
    * call read('UserManagement.feature@Change_role')
    * call read('CancelRequest.feature@CancelRequestEditUserCommon')

  @RAKCON-11051 @Cancel_Remove_Account_Access
  Scenario: Cancel request - Remove Account access
    * call read('UserManagement.feature@Remove_account_access')
    * call read('CancelRequest.feature@CancelRequestEditUserCommon')

  @RAKCON-11055 @CancelWhiteListAddress
  Scenario: Cancel request - Add whitelist address
    * call read('WhiteListFolder.feature@Create_address_internal')
    * call read('CancelRequest.feature@CancelRequestCommon')

  @RAKCON-15489 @CancelInternalWithdraw
  Scenario: Cancel request - Cancel internal withdraw
    * def value = call read('Transfer.feature@Transfer_value_hot_to_hot')
    * def requestId = value.response.data.requestId
    * call read('CancelRequest.feature@CancelRequestCommon')

  @ignore @RAKCON-15490 @CancelExternalWithdraw
  Scenario: Cancel request - Cancel external withdraw
    * def value = call read('Transfer.feature@External_Transfer')
    * def requestId = value.response.data.requestId
    * call read('CancelRequest.feature@CancelRequestCommon')

  @ignore @RAKCON-15491 @CancelOtherNetwork
  Scenario: Cancel request - Cancel tranfer to other network
    * def value = call read('Transfer.feature@Transfer_to_other_network')
    * def requestId = value.response.data.requestId
    * call read('CancelRequest.feature@CancelRequestCommon')

  @ignore @CancelRequestEditUserCommon
  Scenario: Cancel a request edit user - Common
    * def value = call read('UserManagement.feature@View_user_detail')
    * def requestId = value.response.data.pendingRequestId
    * call read('CancelRequest.feature@CancelRequestCommon')

  @ignore @CancelRequestCommon
  Scenario: Cancel a request - Common
    Given path '/core/quorums/cancel/'+requestId
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
    * def createdVault = call read('Vault.feature@SubmitRequestCreateAdvanceVaultFromMobile')
    * def vaultIDWA = createdVault.response.data.vaultId
    * call read('Vault.feature@GetCreateVaultRequestID_NoCreate')
    * karate.call('CancelRequest.feature@CancelAdvanceQuorumRequest')