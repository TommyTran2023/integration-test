@RAKCON-10583
Feature: Approval Request

  Background:
    #@PRECOND_RAKCON-11369
      * callonce read(svc + 'ReadData.feature')
      * callonce read(svc + 'Auth.feature@GetRequesterAccessToken')
      * callonce read(svc + 'Auth.feature@GetListUsers')
      * callonce read(svc + 'Auth.feature@GetApproverAccessToken')
      * def requestHandle = read('classpath:rakkar/common/RequestHandle.js')

  @ApproveNewVaultRequest
  Scenario: Approval - New vault policy request
    # Create new vault and get request ID of creating vault request
    * def vaultHandle = read('classpath:rakkar/common/VaultHandle.js') 
    * def newVault = vaultHandle().createStandardVault(vaultMemberList, Const.VaultType.HOT_WALLET)
    
    # Approver do biometric scan and approve request
    * call read(svc + 'Biometric.feature@ApproverDoBiometric')
    * call read(svc + 'Quorums.feature@ApproveRequest') {requestId:#(newVault.data.requestId)}
  
  @ApproveEditAccountPolicy @parallel=false
  Scenario: Approval - Edit policy
    # Create request edit Account Policy
    * def requestId = requestHandle().createEditAccountPolicyRequest()
    
    # Approver do biometric scan and approve request
    * call read(svc + 'Biometric.feature@ApproverDoBiometric')
    * call read(svc + 'Quorums.feature@ApproveRequest') {requestId:#(requestId)}
  
  @ApprovalNewAddressWhitelist_internal
  Scenario: Approval - Add whitelist address internal
    * call read('this:WhiteListFolder.feature@Create_address_internal')
    * karate.call('this:ApprovalRequest.feature@ApproveRequestCommon')
  