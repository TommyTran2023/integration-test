@RAKCON-10945
Feature: Approval Request

  Background:
    #@PRECOND_RAKCON-11369
    * url baseURL
    * call read('ApprovalAuthenticator.feature@GetAccessTokenForLogin')
    * def challengeApprover = call read('Common.feature@FIDO-Approver')
    * def dataBody = read('classpath:data/data_test.json')

  @RAKCON-10975 @ApproveNewVaultRequest
  Scenario: Approval - New vault policy request
    # Create new vault and get request ID of creating vault request
    * callonce read('Vault.feature@GetCreateVaultRequestID')
    * karate.call('ApprovalRequest.feature@ApproveRequestCommon')


  @RAKCON-11001 @ApproveEditAccountPolicy
  Scenario: Approval - Edit policy
    * call read('AccountPolicy.feature@ViewAccountPolicy')
    * if (requestId == null) karate.call('AccountPolicy.feature@EditAccountPolicy')
    * call read('AccountPolicy.feature@ViewAccountPolicy')
    * karate.call('ApprovalRequest.feature@ApproveRequestCommon')

  @RAKCON-11047 @ApprovalNewAddressWhitelist
  Scenario: Approval - Add whitelist address
    * def value = call read('WhiteListFolder.feature@Create_address_internal')

  @RAKCON-10976 @ApprovalEditVault
  Scenario: Approval - Edit Vault policy request
    * call read('Vault.feature@EditVaultPolicy')
    * def requestId = response.data.record.id
    * karate.call('ApprovalRequest.feature@ApproveRequestCommon')

  @RAKCON-11782 @ApprovalTransfer_Hot_to_cold
  Scenario: Approval - Transfer hot to cold
    * def value = call read('Transfer.feature@Transfer_value_hot_to_cold')
    * def requestId = value.response.data.requestId
    * karate.call('ApprovalRequest.feature@ApproveRequestCommon')

  @RAKCON-11784 @ApprovalTransfer_Cold_to_Hot
  Scenario: Approval - Transfer cold to hot
    * def value = call read('Transfer.feature@Transfer_value_cold_to_hot')
    * def requestId = value.response.data.requestId
    * karate.call('ApprovalRequest.feature@ApproveRequestCommon')

  @RAKCON-11785 @ApprovalTransfer_Cold_to_Cold
  Scenario: Approval - Transfer cold to cold
    * def value = call read('Transfer.feature@Transfer_value_cold_to_cold')
    * def requestId = value.response.data.requestId
    * karate.call('ApprovalRequest.feature@ApproveRequestCommon')

  @RAKCON-11048 @ApprovalTransferLowValue
  Scenario: Approval - Transfer with low value
    * def value = call read('Transfer.feature@Transfer_value_hot_to_hot')
    * def requestId = value.response.data.requestId
    * karate.call('ApprovalRequest.feature@ApproveRequestCommon')

  @RAKCON-11049 @ApprovalTransferMediumValue
    Scenario: Approval - Transfer with medium value
    * def value = call read('Transfer.feature@Transfer_medium_value')
    * def requestId = value.response.data.requestId
    * karate.call('ApprovalRequest.feature@ApproveRequestCommon')

  @RAKCON-11050 @ApprovalTransferHighValue
  Scenario: Approval - Transfer with high value
    * def value = call read('Transfer.feature@Transfer_high_value')
    * def requestId = value.response.data.requestId
    * call read('Common.feature@VIDEO_SPEECH_PROMPT')
    * call read('UploadFile.feature@PUT_VIDEO')
    * def body = { "uploadToken":'#(uploadToken)',"vdoSentence":'#(vdoSentence)'}
    * print 'body', body
    Given path '/core/quorums/approval/'+requestId
    * header challenge-answer = challengeApprover.challengeAnswerRequest
    * header passcode = approverPasscode
    And request body
    When method POST
    Then status 201
    * def statusMsg = response.status
    * match statusMsg == 'success'

     # Common Approve
  @ApproveRequestCommon @ignore
  Scenario: Approve pending request - Common
    Given path '/core/quorums/approval/'+requestId
    * header challenge-answer = challengeApprover.challengeAnswerRequest
    * header passcode = approverPasscode
    When method POST
    Then status 201
    * def statusMsg = response.status
    * match statusMsg == 'success'