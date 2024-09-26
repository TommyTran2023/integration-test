@RAKCON-10583
Feature: Vault - Member and Approver Validation

  Background:
    #@PRECOND_RAKCON-10225
    * url baseURL
    * call read('this:RequesterAuthenticator.feature@RequesterAccessToken')
    * def getRequesterIDResponse = call read('this:GetUserInfo.feature@GetRequesterInfo')
    * def requesterUserID = getRequesterIDResponse.response.data.id
    * def testData = read('classpath:data/data_test.json')
    * def schemaBody = read('classpath:data/schema.json')
    * def Collections = Java.type('java.util.Collections')
    * def Const = read('classpath:data/enum.json')
    * def testData_v2 = read('classpath:data/data.json')
    # * callonce read(svc + 'ReadData.feature')

  @RAKCON-30547
  Scenario: Create standard vault with 1 member not allow
    * call read('this:Vault.feature@GenerateVaultName')
    * call read('this:Vault.feature@CHECK-LIST-USER')
    #Get variable challengeAnswerRequest
    * call read('this:Common.feature@FIDO-Requester')
    #Add a new vault with admin quorum setup
    * def requestBody = 
    """
      {
        "memberRequiredApprove":[],
        "name":#(vaultName),
        "hasRequiredApprover":false,
        "memberIds":[#(requesterUserID),#(requesterUserID)],
        "type":'#(testData.vault.vault_type)',
        "approverNumber":'1',
        "note":"AT Test"
      }
    """
    * call read('this:Vault.feature@CreateVault-Common')
    Then match responseStatus == 400
    Then match response.errorCode == "MEMBER_REQUIRED"

  @RAKCON-30548
  Scenario: Create standard vault with 1 approver not allow
    * call read('this:Vault.feature@GenerateVaultName')
    * call read('this:Vault.feature@CHECK-LIST-USER')
    #Get variable challengeAnswerRequest
    * call read('this:Common.feature@FIDO-Requester')
    #Add a new vault with admin quorum setup
    * def requestBody = 
    """
      {
        "memberRequiredApprove":[],
        "name":#(vaultName),
        "hasRequiredApprover":false,
        "memberIds":[#(requesterUserID),#(approvalUserID)],
        "type":'#(testData.vault.vault_type)',
        "approverNumber":'1',
        "note":"AT Test"
      }
    """
    * call read('this:Vault.feature@CreateVault-Common')
    Then match responseStatus == 400
    Then match response.errorCode == "MEMBER_REQUIRED"

  @RAKCON-30549
  Scenario: Create standard vault with member < approver not allow
    * call read('this:Vault.feature@GenerateVaultName')
    * call read('this:Vault.feature@CHECK-LIST-USER')
    #Get variable challengeAnswerRequest
    * call read('this:Common.feature@FIDO-Requester')
    #Add a new vault with admin quorum setup
    * def requestBody = 
    """
      {
        "memberRequiredApprove":[],
        "name":#(vaultName),
        "hasRequiredApprover":false,
        "memberIds":[#(requesterUserID),#(approvalUserID)],
        "type":'#(testData.vault.vault_type)',
        "approverNumber":'3',
        "note":"AT Test"
      }
    """
    * call read('this:Vault.feature@CreateVault-Common')
    Then match responseStatus == 400
    Then match response.errorCode == "APPROVER_NUMBER"

  @RAKCON-30550
  Scenario: Create standard vault with 2 member, 2 approver
    * call read('this:Vault.feature@GenerateVaultName')
    * call read('this:Vault.feature@CHECK-LIST-USER')
    #Get variable challengeAnswerRequest
    * call read('this:Common.feature@FIDO-Requester')
    #Add a new vault with admin quorum setup
    * def requestBody = 
    """
      {
        "memberRequiredApprove":[],
        "name":#(vaultName),
        "hasRequiredApprover":false,
        "memberIds":[#(requesterUserID),#(approvalUserID)],
        "type":'#(testData.vault.vault_type)',
        "approverNumber":'2',
        "note":"AT Test"
      }
    """
    * call read('this:Vault.feature@CreateVault-Common')
    Then match responseStatus == 201

  @RAKCON-30551
  Scenario: Create skip vault with 1 member not allow
    * call read('this:Vault.feature@GenerateVaultName')
    * call read('this:Vault.feature@CHECK-LIST-USER')
    #Get variable challengeAnswerRequest
    * call read('this:Common.feature@FIDO-Requester')
    #Add a new vault without admin quorum setup
    * def requestBody = 
    """
    {
      "memberRequiredApprove":[],
      "name":#(vaultName),
      "hasRequiredApprover":false,
      "memberIds":[#(requesterUserID)],
      "type":'#(testData.vault.vault_type)',
      "approverNumber":0,
      "note":""
    }
    """
    * call read('this:Vault.feature@CreateVault-Common')
    Then match responseStatus == 400
    Then match response.errorCode == "MEMBER_REQUIRED"

  @RAKCON-30552
  Scenario: Create skip vault with 2 members
    * call read('this:Vault.feature@GenerateVaultName')
    * call read('this:Vault.feature@CHECK-LIST-USER')
    #Get variable challengeAnswerRequest
    * call read('this:Common.feature@FIDO-Requester')
    #Add a new vault without admin quorum setup
    * def requestBody = 
    """
    {
      "memberRequiredApprove":[],
      "name":#(vaultName),
      "hasRequiredApprover":false,
      "memberIds":[#(requesterUserID),#(approvalUserID)],
      "type":'#(testData.vault.vault_type)',
      "approverNumber":0,
      "note":""
    }
    """
    * call read('this:Vault.feature@CreateVault-Common')
    Then match responseStatus == 201
