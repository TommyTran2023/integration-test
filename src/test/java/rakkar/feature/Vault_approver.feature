@RAKCON-10583
Feature: Vault - Member and Approver Validation

  Background:
    #@PRECOND_RAKCON-10225
    * url baseURL
    * callonce read(svc + 'Auth.feature@GetRequesterAccessToken')
    * callonce read(svc + 'Auth.feature@GetRequesterInfo')
    * callonce read(svc + 'Auth.feature@GetListUsers')
    * def Const = read('classpath:data/enum.json')

  @RAKCON-30547
  Scenario: Create standard vault with 1 member not allow
    * call read(svc + 'Vault.feature@GenerateVaultName')
    #Get variable challengeAnswerRequest
    * call read(svc + 'Biometric.feature@RequesterDoBiometric')
    #Add a new vault with admin quorum setup
    * def requestBody = 
    """
      {
        "memberRequiredApprove":[],
        "name":#(vaultName),
        "hasRequiredApprover":false,
        "memberIds":[#(requesterUserID)],
        "type":'#(Const.VaultType.HOT_WALLET)',
        "approverNumber":'2',
        "note":"AT Test"
      }
    """
    * call read(svc + 'Vault.feature@CreateVault') {requestBody: '#(requestBody)', challengeAnswerRequest: '#(challengeAnswerRequest)', passcode: '#(requesterInfo.requesterPasscode)'}
    Then match responseStatus == 400
    Then match response.errorCode == "MEMBER_REQUIRED"

  @RAKCON-30548
  Scenario: Create standard vault with 1 approver not allow
    * call read(svc + 'Vault.feature@GenerateVaultName')
    #Get variable challengeAnswerRequest
    * call read(svc + 'Biometric.feature@RequesterDoBiometric')
    #Add a new vault with admin quorum setup
    * def requestBody = 
    """
      {
        "memberRequiredApprove":[],
        "name":#(vaultName),
        "hasRequiredApprover":false,
        "memberIds":[#(requesterUserID),#(approvalUserID)],
        "type":'#(Const.VaultType.COLD_WALLET)',
        "approverNumber":'1',
        "note":"AT Test"
      }
    """
    * call read(svc + 'Vault.feature@CreateVault') {requestBody: '#(requestBody)', challengeAnswerRequest: '#(challengeAnswerRequest)', passcode: '#(requesterInfo.requesterPasscode)'}
    Then match responseStatus == 400
    Then match response.errorCode == "MEMBER_REQUIRED"

  @RAKCON-30811
  Scenario: Create standard vault with 2 duplicated member not allow
    * call read(svc + 'Vault.feature@GenerateVaultName')
    #Get variable challengeAnswerRequest
    * call read(svc + 'Biometric.feature@RequesterDoBiometric')
    #Add a new vault with admin quorum setup
    * def requestBody = 
    """
      {
        "memberRequiredApprove":[],
        "name":#(vaultName),
        "hasRequiredApprover":false,
        "memberIds":[#(requesterUserID),#(requesterUserID)],
        "type":'#(Const.VaultType.HOT_WALLET)',
        "approverNumber":'2',
        "note":"AT Test"
      }
    """
    * call read(svc + 'Vault.feature@CreateVault') {requestBody: '#(requestBody)', challengeAnswerRequest: '#(challengeAnswerRequest)', passcode: '#(requesterInfo.requesterPasscode)'}
    Then match responseStatus == 400
    Then match response.errorCode == "MEMBER_REQUIRED"

  @RAKCON-30549
  Scenario: Create standard vault with member < approver not allow
    * call read(svc + 'Vault.feature@GenerateVaultName')
    #Get variable challengeAnswerRequest
    * call read(svc + 'Biometric.feature@RequesterDoBiometric')
    #Add a new vault with admin quorum setup
    * def requestBody = 
    """
      {
        "memberRequiredApprove":[],
        "name":#(vaultName),
        "hasRequiredApprover":false,
        "memberIds":[#(requesterUserID),#(approvalUserID)],
        "type":'#(Const.VaultType.COLD_WALLET)',
        "approverNumber":'3',
        "note":"AT Test"
      }
    """
    * call read(svc + 'Vault.feature@CreateVault') {requestBody: '#(requestBody)', challengeAnswerRequest: '#(challengeAnswerRequest)', passcode: '#(requesterInfo.requesterPasscode)'}
    Then match responseStatus == 400
    Then match response.errorCode == "APPROVER_NUMBER"

  @RAKCON-30550
  Scenario: Create standard vault with 2 member, 2 approver
    * call read(svc + 'Vault.feature@GenerateVaultName')
    #Get variable challengeAnswerRequest
    * call read(svc + 'Biometric.feature@RequesterDoBiometric')
    #Add a new vault with admin quorum setup
    * def requestBody = 
    """
      {
        "memberRequiredApprove":[],
        "name":#(vaultName),
        "hasRequiredApprover":false,
        "memberIds":[#(requesterUserID),#(approvalUserID)],
        "type":'#(Const.VaultType.COLD_WALLET)',
        "approverNumber":'2',
        "note":"AT Test"
      }
    """
    * call read(svc + 'Vault.feature@CreateVault') {requestBody: '#(requestBody)', challengeAnswerRequest: '#(challengeAnswerRequest)', passcode: '#(requesterInfo.requesterPasscode)'}
    Then match responseStatus == 201

  @RAKCON-30551
  Scenario: Create skip vault with 1 member not allow
    * call read(svc + 'Vault.feature@GenerateVaultName')
    #Get variable challengeAnswerRequest
    * call read(svc + 'Biometric.feature@RequesterDoBiometric')
    #Add a new vault without admin quorum setup
    * def requestBody = 
    """
    {
      "memberRequiredApprove":[],
      "name":#(vaultName),
      "hasRequiredApprover":false,
      "memberIds":[#(requesterUserID)],
      "type":'#(Const.VaultType.COLD_WALLET)',
      "approverNumber":0,
      "note":""
    }
    """
    * call read(svc + 'Vault.feature@CreateVault') {requestBody: '#(requestBody)', challengeAnswerRequest: '#(challengeAnswerRequest)', passcode: '#(requesterInfo.requesterPasscode)'}
    Then match responseStatus == 400
    Then match response.errorCode == "MEMBER_REQUIRED"

  @RAKCON-30552
  Scenario: Create skip vault with 2 members
    * call read(svc + 'Vault.feature@GenerateVaultName')
    #Get variable challengeAnswerRequest
    * call read(svc + 'Biometric.feature@RequesterDoBiometric')
    #Add a new vault without admin quorum setup
    * def requestBody = 
    """
    {
      "memberRequiredApprove":[],
      "name":#(vaultName),
      "hasRequiredApprover":false,
      "memberIds":[#(requesterUserID),#(approvalUserID)],
      "type":'#(Const.VaultType.HOT_WALLET)',
      "approverNumber":0,
      "note":""
    }
    """
    * call read(svc + 'Vault.feature@CreateVault') {requestBody: '#(requestBody)', challengeAnswerRequest: '#(challengeAnswerRequest)', passcode: '#(requesterInfo.requesterPasscode)'}
    Then match responseStatus == 201
