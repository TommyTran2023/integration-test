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
    #  Pre-condition: Create new vault and get request ID of creating vault request
    * def vaultHandle = read('classpath:rakkar/common/VaultHandle.js') 
    * def newVault = vaultHandle().createStandardVault(vaultMemberList, Const.VaultType.HOT_WALLET)
    
    # Test: Approver do biometric scan and approve request
    * call read(svc + 'Biometric.feature@ApproverDoBiometric')
    * call read(svc + 'Quorums.feature@ApproveRequest') {requestId:#(newVault.data.requestId)}
  
  @RAKCON-11001 @ApproveEditAccountPolicy @parallel=false
  Scenario: Approval - Edit policy
    #  Pre-condition: Create request edit Account Policy
    * def requestId = requestHandle().createEditAccountPolicyRequest()
    
    # Test: Approver do biometric scan and approve request
    * call read(svc + 'Biometric.feature@ApproverDoBiometric')
    * call read(svc + 'Quorums.feature@ApproveRequest') {requestId:#(requestId)}
  
  @RAKCON-11047 @ApprovalNewAddressWhitelist_internal
  Scenario: Approval - Add whitelist address internal
    #  Pre-condition: Create request edit Account Policy
    * def requestId = requestHandle().createNewWhitelistAddressRequest(Const.WhitelistType.INTERNAL)
    
    # Test: Approver do biometric scan and approve request
    * call read(svc + 'Biometric.feature@ApproverDoBiometric')
    * call read(svc + 'Quorums.feature@ApproveRequest') {requestId:#(requestId)}
  
  @RAKCON-12492 @ApprovalNewAddressWhitelist_external
  Scenario: Approval - Add whitelist address external
    #  Pre-condition: Create request edit Account Policy
    * def requestId = requestHandle().createNewWhitelistAddressRequest(Const.WhitelistType.EXTERNAL)
    
    # Test: Approver do biometric scan and approve request
    * call read(svc + 'Biometric.feature@ApproverDoBiometric')
    * call read(svc + 'Quorums.feature@ApproveRequest') {requestId:#(requestId)}
  
  @RAKCON-10976 @ApprovalEditVault
  Scenario: Approval - Edit Vault policy request
    #  Pre-condition:  request edit Vault Policy
    * def requestId = requestHandle().createEditVaultPolicyToStandardRequest(dataSet.standardVaultForEditPolicy2, vaultMemberList)
    
    # Test: Approver do biometric scan and approve request
    * call read(svc + 'Biometric.feature@ApproverDoBiometric')
    * call read(svc + 'Quorums.feature@ApproveRequest') {requestId:#(requestId)}

  @RAKCON-11782 @ApprovalTransfer_Hot_to_cold
  Scenario: Approval - Transfer hot to cold
    # Pre-condition: Create transfer request from hot to cold
    * def txnInfo = 
    """
    {
      sourceId: #(dataSet.sourceId_hot),
      sourceType: #(Const.PeerType.VAULT_ACCOUNT), 
      destinationId: #(dataSet.destinationId_cold), 
      destinationType: #(Const.PeerType.VAULT_ACCOUNT), 
      tokenId: #(dataSet.tokenId),
      tokenSymbol: #(Const.TokenSymbol.XRP),
      fee: #(Number("1.5e-5")),
      tier: 1
    }
    """
    * def transferHandle = read('classpath:rakkar/common/TransferHandle.js')
    * def txnRequest = transferHandle().createTransferRequest(txnInfo)
    * def requestId = txnRequest.data.requestId

    # Test: Approver do biometric scan and approve request
    * call read(svc + 'Biometric.feature@ApproverDoBiometric')
    * call read(svc + 'Quorums.feature@ApproveRequest') {requestId:#(requestId)}

  @RAKCON-11784 @ApprovalTransfer_Cold_to_Hot
  Scenario: Approval - Transfer cold to hot
    # Pre-condition: Create transfer request from cold to hot
    * def txnInfo = 
    """
    {
      sourceId: #(dataSet.sourceId_cold),
      sourceType: #(Const.PeerType.VAULT_ACCOUNT), 
      destinationId: #(dataSet.destinationId_hot), 
      destinationType: #(Const.PeerType.VAULT_ACCOUNT), 
      tokenId: #(dataSet.tokenId),
      tokenSymbol: #(Const.TokenSymbol.XRP),
      fee: #(Number("1.5e-5")),
      tier: 1
    }
    """
    * def transferHandle = read('classpath:rakkar/common/TransferHandle.js')
    * def txnRequest = transferHandle().createTransferRequest(txnInfo)
    * def requestId = txnRequest.data.requestId

    # Test: Approver do biometric scan and approve request
    * call read(svc + 'Biometric.feature@ApproverDoBiometric')
    * call read(svc + 'Quorums.feature@ApproveRequest') {requestId:#(requestId)}

  @RAKCON-11785 @ApprovalTransfer_Cold_to_Cold
  Scenario: Approval - Transfer cold to cold
    # Pre-condition: Create transfer request from cold to cold
    * def txnInfo = 
    """
    {
      sourceId: #(dataSet.sourceId_cold),
      sourceType: #(Const.PeerType.VAULT_ACCOUNT), 
      destinationId: #(dataSet.destinationId_cold), 
      destinationType: #(Const.PeerType.VAULT_ACCOUNT), 
      tokenId: #(dataSet.tokenId),
      tokenSymbol: #(Const.TokenSymbol.XRP),
      fee: #(Number("1.5e-5")),
      tier: 1
    }
    """
    * def transferHandle = read('classpath:rakkar/common/TransferHandle.js')
    * def txnRequest = transferHandle().createTransferRequest(txnInfo)
    * def requestId = txnRequest.data.requestId

    # Test: Approver do biometric scan and approve request
    * call read(svc + 'Biometric.feature@ApproverDoBiometric')
    * call read(svc + 'Quorums.feature@ApproveRequest') {requestId:#(requestId)}

  @RAKCON-11048 @ApprovalTransferLowValue
  Scenario: Approval - Transfer with low value
    # Pre-condition: Create transfer request from hot to hot with small value (tier = 1)
    * def txnInfo = 
    """
    {
      sourceId: #(dataSet.sourceId_hot),
      sourceType: #(Const.PeerType.VAULT_ACCOUNT), 
      destinationId: #(dataSet.destinationId_hot), 
      destinationType: #(Const.PeerType.VAULT_ACCOUNT), 
      tokenId: #(dataSet.tokenId),
      tokenSymbol: #(Const.TokenSymbol.XRP),
      fee: #(Number("1.5e-5")),
      tier: 1
    }
    """
    * def transferHandle = read('classpath:rakkar/common/TransferHandle.js')
    * def txnRequest = transferHandle().createTransferRequest(txnInfo)
    * def requestId = txnRequest.data.requestId

    # Test: Approver do biometric scan and approve request
    * call read(svc + 'Biometric.feature@ApproverDoBiometric')
    * call read(svc + 'Quorums.feature@ApproveRequest') {requestId:#(requestId)}

  @RAKCON-11049 @ApprovalTransferMediumValue
  Scenario: Approval - Transfer with medium value
    # Pre-condition: Create transfer request from hot to hot with small value (tier = 2)
    * def txnInfo = 
    """
    {
      sourceId: #(dataSet.sourceId_hot),
      sourceType: #(Const.PeerType.VAULT_ACCOUNT), 
      destinationId: #(dataSet.destinationId_hot), 
      destinationType: #(Const.PeerType.VAULT_ACCOUNT), 
      tokenId: #(dataSet.tokenId),
      tokenSymbol: #(Const.TokenSymbol.XRP),
      fee: #(Number("1.5e-5")),
      tier: 2,
      passcode: #(requesterInfo.requesterPasscode)
    }
    """
    * def transferHandle = read('classpath:rakkar/common/TransferHandle.js')
    * def txnRequest = transferHandle().createTransferRequest(txnInfo)
    * def requestId = txnRequest.data.requestId

    # Test: Approver do biometric scan and approve request
    * call read(svc + 'Biometric.feature@ApproverDoBiometric')
    * call read(svc + 'Quorums.feature@ApproveRequest') {requestId:#(requestId)}

  @RAKCON-11925 @ApprovalTransferExternal
  Scenario: Approval - Transfer external
    # Pre-condition: Create transfer request whitelist
    * def txnInfo = 
    """
    {
      sourceId: #(dataSet.sourceId_hot),
      sourceType: #(Const.PeerType.VAULT_ACCOUNT), 
      destinationId: #(dataSet.externalId), 
      destinationType: #(Const.PeerType.EXTERNAL_WALLET), 
      tokenId: #(dataSet.tokenId),
      tokenSymbol: #(Const.TokenSymbol.XRP),
      fee: #(Number("1.5e-5"))
    }
    """
    * def transferHandle = read('classpath:rakkar/common/TransferHandle.js')
    * def txnRequest = transferHandle().createTransferRequest(txnInfo)
    * def requestId = txnRequest.data.requestId

    # Test: Approver do biometric scan and approve request
    * call read(svc + 'Biometric.feature@ApproverDoBiometric')
    * call read(svc + 'Quorums.feature@ApproveRequest') {requestId:#(requestId)}

  @RAKCON-11050 @ApprovalTransferHighValue
  Scenario: Approval - Transfer with high value
    # Pre-condition: Create transfer request with high value
    * def txnInfo = 
    """
    {
      sourceId: #(dataSet.sourceId_hot),
      sourceType: #(Const.PeerType.VAULT_ACCOUNT), 
      destinationId: #(dataSet.externalId), 
      destinationType: #(Const.PeerType.EXTERNAL_WALLET), 
      tokenId: #(dataSet.tokenId),
      tokenSymbol: #(Const.TokenSymbol.XRP),
      fee: #(Number("1.5e-5")),
      tier: 3,
      userId: #(requesterUserID),
      passcode: #(requesterInfo.requesterPasscode)
    }
    """
    * def transferHandle = read('classpath:rakkar/common/TransferHandle.js')
    * def txnRequest = transferHandle().createTransferRequest(txnInfo)
    * def requestId = txnRequest.data.requestId

    # Test: Approver do biometric scan and, upload video to approve request
    * def uploadVideo = read('classpath:rakkar/common/UploadFileHandle.js')
    * def video = uploadVideo().uploadFileForTransfer(approvalAccessToken)
    
    * call read(svc + 'Biometric.feature@ApproverDoBiometric')
    * def approveBody = 
    """
    {
      requestId:#(requestId),
      body:{
        uploadToken: #(video.uploadToken),
        vdoSentence: #(video.vdoSentence)
      }
    }
    """
    * print approveBody
    * call read(svc + 'Quorums.feature@ApproveRequest') approveBody

  @RAKCON-11046 @ApprovalChangeRole
  Scenario: Approval - Edit role
    # Pre-condition: Create transfer request with high value
    * def userHandle = read('classpath:rakkar/common/UserHandle.js')
    * def requestId = userHandle().createChangeRoleRequest(adminUserID2)

    # Test: Approver do biometric scan to approve request
    * call read(svc + 'Biometric.feature@ApproverDoBiometric')
    * call read(svc + 'Quorums.feature@ApproveRequest') {requestId:#(requestId)}

  @RAKCON-11044 @ApprovalAddVaultAccess
  Scenario: Approval - Add vault access
    # Pre-condition: Create transfer request with high value
    * def userHandle = read('classpath:rakkar/common/UserHandle.js')
    * def requestId = userHandle().createAddVaultAccessRequest(adminUserID2)

    # Test: Approver do biometric scan to approve request
    * call read(svc + 'Biometric.feature@ApproverDoBiometric')
    * call read(svc + 'Quorums.feature@ApproveRequest') {requestId:#(requestId)}

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
  
  