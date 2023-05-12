@RAKCON-10583 @ignore
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

  @RAKCON-11055 @CancelWhiteListAddress
  Scenario: Cancel request - Add whitelist address
    * def value = call read('WhiteListFolder.feature@Create_address_internal')
    * def requestId = value.response.data.records[0].id
    * call read('CancelRequest.feature@CancelRequestCommon')

  @ignore @CancelRequestCommon
  Scenario: Cancel a request - Common
    Given path '/core/quorums/cancel/'+requestId
    * header challenge-answer = challengeApprover.challengeAnswerRequest
    When method PUT
    Then status 200
    * def statusMsg = response.status
    * match statusMsg == 'success'