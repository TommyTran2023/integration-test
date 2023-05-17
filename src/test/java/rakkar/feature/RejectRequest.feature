@RAKCON-10583
Feature: Reject Request

  Background:
      #@PRECOND_RAKCON-11353
    * url baseURL
    * call read('ApprovalAuthenticator.feature@GetAccessTokenForLogin')
    * def challengeApprover = call read('Common.feature@FIDO-Approver')
    * def testData = read('classpath:data/data_test.json')

  @RAKCON-11005 @RejectEditPolicy
  Scenario: Reject request - Edit policy
    * call read('AccountPolicy.feature@ViewAccountPolicy')
    * if (requestId == null) karate.call('AccountPolicy.feature@EditAccountPolicy')
    * call read('AccountPolicy.feature@ViewAccountPolicy')
    * call read('RejectRequest.feature@RejectRequestCommon')

  @RAKCON-11000 @RejectNewVaultRequest
  Scenario: Reject request - New vault policy request
    * call read('Vault.feature@GetCreateVaultRequestID')
    * call read('RejectRequest.feature@RejectRequestCommon')

  @RAKCON-11002 @RejectEditVaultRequest
  Scenario: Reject request - Edit Vault policy request
    * call read('Vault.feature@EditVaultPolicy')
    * def requestId = editVaultPolicy.response.data.record.id
    * call read('RejectRequest.feature@RejectRequestCommon')

  @RAKCON-11063 @RejectAddWhitelistAddress
  Scenario: Reject request - Add whitelist address
    * call read('WhiteListFolder.feature@Create_address_internal')
    * call read('RejectRequest.feature@RejectRequestCommon')

  @RAKCON-11788 @RejectTransfer_Hot_to_Cold
  Scenario: Reject request - Reject transfer hot to cold
    * def value = call read('Transfer.feature@Transfer_value_hot_to_cold')
    * def requestId = value.response.data.requestId
    * call read('RejectRequest.feature@RejectRequestCommon')

  @RAKCON-11789 @RejectTransfer_Cold_to_Hot
  Scenario: Reject request - Reject transfer cold to hot
    * def value = call read('Transfer.feature@Transfer_value_cold_to_hot')
    * def requestId = value.response.data.requestId
    * call read('RejectRequest.feature@RejectRequestCommon')

  @RAKCON-11790 @RejectTransfer_Cold_to_Cold
  Scenario: Reject request - Reject transfer cold to cold
    * def value = call read('Transfer.feature@Transfer_value_cold_to_cold')
    * def requestId = value.response.data.requestId
    * call read('RejectRequest.feature@RejectRequestCommon')

  @RAKCON-11064 @RejectTransferLow
    Scenario: Reject request - Reject transfer low value
    * def value = call read('Transfer.feature@Transfer_value_hot_to_hot')
    * def requestId = value.response.data.requestId
    * call read('RejectRequest.feature@RejectRequestCommon')

  @RAKCON-11791 @RejectTransferMediun
  Scenario: Reject request - Reject transfer medium value
    * def value = call read('Transfer.feature@Transfer_medium_value')
    * def requestId = value.response.data.requestId
    * call read('RejectRequest.feature@RejectRequestCommon')

  @RAKCON-11792 @RejectTransferHigh
  Scenario: Reject request - Reject transfer high value
    * def value = call read('Transfer.feature@Transfer_high_value')
    * def requestId = value.response.data.requestId
    * call read('RejectRequest.feature@RejectRequestCommon')

  @RAKCON-11926 @RejectTransferExternal
  Scenario: Reject request - Transfer external
    * def value = call read('Transfer.feature@External_Transfer')
    * def requestId = value.response.data.requestId

  @RAKCON-11062 @RejectChangeRole
  Scenario: Reject request - Change role
    * call read('UserManagement.feature@Change_role')
    * call read('RejectRequest.feature@RejectRequestCommon')

  @RAKCON-11060 @RejectAddVaultAccess
  Scenario: Reject request - Add vault access
    * call read('UserManagement.feature@Add_vault_access')
    * call read('RejectRequest.feature@RejectRequestCommon')

  @RAKCON-11061 @RejectRemoveVaultAccess
  Scenario: Reject request - Remove vault access
    * call read('UserManagement.feature@Remove_vault_access')
    * call read('RejectRequest.feature@RejectRequestCommon')

  @RAKCON-11059 @RejectRemoveVaultAccess
  Scenario: Reject request - Remove User access
    * call read('UserManagement.feature@Remove_account_access')
    * call read('RejectRequest.feature@RejectRequestCommon')


  @ignore @RejectRequestCommon
  Scenario: Reject pending request - Common
    Given path '/core/quorums/reject'
    * header challenge-answer = challengeApprover.challengeAnswerRequest
    * request {"recordId" : "#(requestId)", "reason" : "AT Reject Request Note"}
    When method PUT
    Then status 200
    * match response.status == 'success'