@RAKCON-10583
Feature: Approval Request

  Background:
    #@PRECOND_RAKCON-11369
      * callonce read(svc + 'ReadData.feature')
      * callonce read(svc + 'Auth.feature@GetRequesterAccessToken')
      * callonce read(svc + 'Auth.feature@GetListUsers')
      * callonce read(svc + 'Auth.feature@GetApproverAccessToken')
      * def requestHandle = read('classpath:rakkar/common/RequestHandle.js')

  @RAKCON-10975 @ApproveNewVaultRequest
  Scenario: Approval - New vault policy request
    # Create new vault and get request ID of creating vault request
    * def vaultHandle = read('classpath:rakkar/common/VaultHandle.js') 
    * def newVault = vaultHandle().createStandardVault(vaultMemberList, Const.VaultType.HOT_WALLET)
    
    # Approver do biometric scan and approve request
    * call read(svc + 'Biometric.feature@ApproverDoBiometric')
    * call read(svc + 'Quorums.feature@ApproveRequest') {requestId:#(newVault.data.requestId)}
  
  @RAKCON-11001 @ApproveEditAccountPolicy @parallel=false
  Scenario: Approval - Edit policy
    # Create request edit Account Policy
    * def requestId = requestHandle().createEditAccountPolicyRequest()
    
    # Approver do biometric scan and approve request
    * call read(svc + 'Biometric.feature@ApproverDoBiometric')
    * call read(svc + 'Quorums.feature@ApproveRequest') {requestId:#(requestId)}
  
  @RAKCON-11047 @ApprovalNewAddressWhitelist_internal
  Scenario: Approval - Add whitelist address internal
    # Create request edit Account Policy
    * def requestId = requestHandle().createNewWhitelistAddressRequest(Const.WhitelistType.INTERNAL)
    
    # Approver do biometric scan and approve request
    * call read(svc + 'Biometric.feature@ApproverDoBiometric')
    * call read(svc + 'Quorums.feature@ApproveRequest') {requestId:#(requestId)}
  
  @RAKCON-12492 @ApprovalNewAddressWhitelist_external
  Scenario: Approval - Add whitelist address external
    # Create request edit Account Policy
    * def requestId = requestHandle().createNewWhitelistAddressRequest(Const.WhitelistType.EXTERNAL)
    
    # Approver do biometric scan and approve request
    * call read(svc + 'Biometric.feature@ApproverDoBiometric')
    * call read(svc + 'Quorums.feature@ApproveRequest') {requestId:#(requestId)}
  
  @RAKCON-10976 @ApprovalEditVault
  Scenario: Approval - Edit Vault policy request
    # Create request edit Vault Policy
    * def requestId = requestHandle().createEditVaultPolicyToStandardRequest(dataSet.standardVaultForEditPolicy2, vaultMemberList)
    
    # Approver do biometric scan and approve request
    * call read(svc + 'Biometric.feature@ApproverDoBiometric')
    * call read(svc + 'Quorums.feature@ApproveRequest') {requestId:#(requestId)}

  @RAKCON-11782 @ApprovalTransfer_Hot_to_cold
  Scenario: Approval - Transfer hot to cold
    * def value = call read('this:Transfer.feature@Transfer_value_hot_to_cold')
    * def requestId = value.response.data.requestId
    * karate.call('this:ApprovalRequest.feature@ApproveRequestCommon')

  @RAKCON-11784 @ApprovalTransfer_Cold_to_Hot
  Scenario: Approval - Transfer cold to hot
    * def value = call read('this:Transfer.feature@Transfer_value_cold_to_hot')
    * def requestId = value.response.data.requestId
    * karate.call('this:ApprovalRequest.feature@ApproveRequestCommon')

  @RAKCON-11785 @ApprovalTransfer_Cold_to_Cold
  Scenario: Approval - Transfer cold to cold
    * def value = call read('this:Transfer.feature@Transfer_value_cold_to_cold')
    * def requestId = value.response.data.requestId
    * karate.call('this:ApprovalRequest.feature@ApproveRequestCommon')

  @RAKCON-11048 @ApprovalTransferLowValue
  Scenario: Approval - Transfer with low value
    * def value = call read('this:Transfer.feature@Transfer_value_hot_to_hot')
    * def requestId = value.response.data.requestId
    * karate.call('this:ApprovalRequest.feature@ApproveRequestCommon')

  @RAKCON-11049 @ApprovalTransferMediumValue
    Scenario: Approval - Transfer with medium value
    * def value = call read('this:Transfer.feature@Transfer_medium_value')
    * def requestId = value.response.data.requestId
    * karate.call('this:ApprovalRequest.feature@ApproveRequestCommon')

  @ignore @RAKCON-11925 @ApprovalTransferExternal
  Scenario: Approval - Transfer external
    * def value = call read('this:Transfer.feature@External_Transfer')
    * def requestId = value.response.data.requestId
    * karate.call('this:ApprovalRequest.feature@ApproveRequestCommon')

  @RAKCON-11050 @ApprovalTransferHighValue
  Scenario: Approval - Transfer with high value
    * def value = call read('this:Transfer.feature@Transfer_high_value')
    * def requestId = value.response.data.requestId
    # * call read('this:GetUserInfo.feature@GetApproverInfo')
    * call read('this:Common.feature@VIDEO_SPEECH_PROMPT')
    * def query_upload_link = { contentType: 'video/mp4', fileName:'video.mp4', userId: '#(userId)', type: 'VIDEO'}
    * call read('this:Common.feature@UPLOAD_LINK')
    * call read('this:ApprovalRequest.feature@PutVideoForApprover')
    * def body = { "uploadToken":'#(uploadToken)',"vdoSentence":'#(vdoSentence)'}
    * call read(svc + 'Quorums.feature@ApproveRequest') {body: body}
    # Given path '/advance-quorum/quorums/approval/'+requestId
    # * header challenge-answer = challengeApprover.challengeAnswerRequest
    # * header passcode = approverInfo.approverPasscode
    # And request body
    # When method POST
    Then status 201
    * def statusMsg = response.status
    * match statusMsg == 'success'

  @ignore @PutVideoForApprover
  Scenario: Put video
    Given url uploadUrl
    * request {}
    And header Content-type = "video/mp4"
    When method PUT
    Then status 200
    And response.status == "success"

  @RAKCON-11046 @ApprovalChangeRole
    Scenario: Approval - Edit role
    * call read('this:UserManagement.feature@Change_role')
    * def value = call read('this:UserManagement.feature@View_user_detail')
    * def requestId = value.response.data.pendingRequestId
    * karate.call('this:ApprovalRequest.feature@ApproveRequestCommon')

  @RAKCON-11044 @ApprovalAddVaultAccess
   Scenario: Approval - Add vault access
    * call read('this:UserManagement.feature@Add_vault_access')
    * def value = call read('this:UserManagement.feature@View_user_detail')
    * def requestId = value.response.data.pendingRequestId
    * karate.call('this:ApprovalRequest.feature@ApproveRequestCommon')

  @RAKCON-18737 @ApproveEditGroupMembersRequest @ignore
  Scenario: Approve Edit Group Members Request
    * call read('this:GroupPolicies.feature@EditMembersInGroup')
    * def groupDetails = call read('this:GroupPolicies.feature@ViewGroupDetails')
    * def requestId = groupDetails.response.data.editRequestId
    * karate.call('this:ApprovalRequest.feature@ApproveRequestCommon')
    
  @ignore @RAKCON-15106 @ApprovalEditProfileRouting
  Scenario: Approval -  Edit profile routing
    * def value = call read('this:NetworkManagement.feature@Editprofilerouting')
    * def requestId = value.response.data.requestId
    * karate.call('this:ApprovalRequest.feature@ApproveRequestCommon')

  @ignore @RAKCON-15207 @ApprovalAddnewconnection
  Scenario: Approval - Add new connection
    * def value = call read('this:NetworkManagement.feature@Addnetworkconnection')
    * def requestId = value.response.data.requestId
    * karate.call('this:ApprovalRequest.feature@ApproveRequestCommon')

     # Common Approve
  @ApproveRequestCommon @ignore
  Scenario: Approve pending request - Common
    Given path '/advance-quorum/quorums/approval/'+requestId
    * header challenge-answer = challengeApprover.challengeAnswerRequest
    * header passcode = approverInfo.approverPasscode
    When method POST
    Then status 201
    * def statusMsg = response.status
    * match statusMsg == 'success'

  @ignore @CreateColdVaultAndApprove
  Scenario: Create Cold Vault And Approve
    * callonce read('this:Vault.feature@CHECK-LIST-USER')
    # Create cold vault
    * def coldVault = callonce read('this:Vault.feature@CreateVaultCold')
    # View vault detail to get request ID
    * def vaultIDWA = coldVault.response.data.id
    * def coldVaultDetails = callonce read('this:Vault.feature@GetCreateVaultRequestID_NoCreate')
    * def requestId = coldVaultDetails.response.data.requestId
    # Approve created vault policy request
    * call read('this:ApprovalRequest.feature@ApproveRequestCommon')

  # Approve Advance Quorums Request
  @ApproveAdvanceQuorumsRequest @ignore
  Scenario: Approve pending request - Common
    Given path '/advance-quorum/quorums/approval/'+requestId
    * header challenge-answer = challengeApprover.challengeAnswerRequest
    * header passcode = approverInfo.approverPasscode
    When method POST
    Then status 201
    * def statusMsg = response.status
    * match statusMsg == 'success'

  @RAKCON-19024 @ApproveAdvanceQuorums
  Scenario: Approve create advance quorum request
    * def createdVault = call read('this:Vault.feature@SubmitRequestCreateAdvanceVaultFromMobile')
    * def vaultIDWA = createdVault.response.data.vaultId
    * call read('this:Vault.feature@GetCreateVaultRequestID_NoCreate')
    * karate.call('this:ApprovalRequest.feature@ApproveAdvanceQuorumsRequest')

  @RAKCON-19663 @ApproveTransferSmallAmountFromHotStandardVaultToHotAdvanceVault
  Scenario: Approval - Tranfer Small Amount From Hot Standard Vault To Hot Advance Vault
    * def destinationId = dataSet.advanceHotVaultId
    * def sourceId = dataSet.destinationId_hot
    * def req = call read('this:Transfer.feature@TransferSmallCommon')
    * def requestId = req.response.data.requestId
    * karate.call('this:ApprovalRequest.feature@ApproveAdvanceQuorumsRequest')
  
  @RAKCON-19664 @ApproveTransferSmallAmountFromHotAdvanceVaultToHotSkipVault
  Scenario: Approval - Tranfer Small Amount From Hot Advance Vault To Hot Skip Vault
    * def destinationId = dataSet.skipHotVaultId
    * def sourceId = dataSet.advanceHotVaultId
    * def req = call read('this:Transfer.feature@TransferSmallCommon')
    * def requestId = req.response.data.requestId
    * karate.call('this:ApprovalRequest.feature@ApproveAdvanceQuorumsRequest')

  @RAKCON-19665 @ApproveTransferSmallAmountFromHotStandardVaultToHotSkipVault
  Scenario: Approval - Tranfer Small Amount From Hot Standard Vault To Hot Skip Vault
    * def destinationId = dataSet.skipHotVaultId
    * def sourceId = dataSet.destinationId_hot
    * def req = call read('this:Transfer.feature@TransferSmallCommon')
    * def requestId = req.response.data.requestId
    * karate.call('this:ApprovalRequest.feature@ApproveAdvanceQuorumsRequest')

  @RAKCON-19666 @ApproveTransferSmallAmountFromHotAdvanceVaultToColdAdvanceVault
  Scenario: Approval - Tranfer Small Amount From Hot Advance Vault To Cold Advance Vault
    * def destinationId = dataSet.advanceColdVaultId
    * def sourceId = dataSet.advanceHotVaultId
    * def req = call read('this:Transfer.feature@TransferSmallCommon')
    * def requestId = req.response.data.requestId
    * karate.call('this:ApprovalRequest.feature@ApproveAdvanceQuorumsRequest')
  
  