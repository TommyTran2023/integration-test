@RAKCON-10583
Feature: Vault

  Background:
    #@PRECOND_RAKCON-10225
    * url baseURL
    * call read('RequesterAuthenticator.feature@RequesterAccessToken')
    * def getRequesterIDResponse = call read('GetUserInfo.feature@GetRequesterInfo')
    * def requesterUserID = getRequesterIDResponse.response.data.id
    * def testData = read('classpath:data/data_test.json')
    * def schemaBody = read('classpath:data/schema.json')
    * def Collections = Java.type('java.util.Collections')

  @ignore @GenerateVaultName
  Scenario: Generate vault name
    * def now = function(){ return java.lang.System.currentTimeMillis() }
    * def vaultName = 'AT-RAK-' + now()

  @RAKCON-12842 @CHECK-VAULT-NAME
  Scenario: Check vault name is existed or not
    #Check vault name is existed or not
    Given path '/core/vault/check-vault-name'
    * call read('Vault.feature@GenerateVaultName')
    * param name = vaultName
    When method GET
    Then status 200
    * def checkExist = response.data.exist
    * eval if (checkExist==true) karate.fail('Vault name should not exist')

  @ignore @CHECK-LIST-USER
  Scenario: Get user list of organization
    #Get user list of organization
    Given path '/auth/account/list-users'
    * request {"isGetAll":true}
    When method POST
    Then status 201
    * def result = response.data.users
    * def approvalUserID = karate.jsonPath(result, "$.ADMIN[?(@.username=='"+ approverInfo.approvalUsername +"')].userId")[0]
    * def adminUserID = karate.jsonPath(result, "$.ADMIN[?(@.username=='"+ adminUsername +"')].userId")[0]
    * def vaultMemberList = [#(requesterUserID), #(approvalUserID), #(adminUserID)]
    * print vaultMemberList

  @RAKCON-10217 @AddNewVaultWithAdminSetup
  Scenario: Create a new vault with admin quorum setup
    * call read('Vault.feature@GenerateVaultName')
    * call read('Vault.feature@CHECK-LIST-USER')
    #Get variable challengeAnswerRequest
    * call read('Common.feature@FIDO-Requester')
    #Add a new vault with admin quorum setup
    * def requestBody = {"memberRequiredApprove":[],"name":#(vaultName),"hasRequiredApprover":false,"memberIds":[#(requesterUserID),#(approvalUserID),#(adminUserID)],"type":'#(testData.vault.vault_type)',"approverNumber":'#(testData.vault.approve_number)',"note":"AT Test"}
    * call read('Vault.feature@CreateVault-Common')
    * def hiddenOnUIResponseWA = response.data.hiddenOnUI
    * match hiddenOnUIResponseWA == false
    * def vaultNameResponseWA = response.data.name
    * match vaultNameResponseWA == vaultName
    * def vaultTypeResponseWA = response.data.type
    * match vaultTypeResponseWA == testData.vault.vault_type
    * def vaultIDWA = response.data.id

  @RAKCON-10220 @AddNewVaultWithOutAdminSetup
  Scenario: Create a new vault without admin quorum setup
    * call read('Vault.feature@GenerateVaultName')
    * call read('Vault.feature@CHECK-LIST-USER')
    #Get variable challengeAnswerRequest
    * call read('Common.feature@FIDO-Requester')
    #Add a new vault without admin quorum setup
    * def requestBody = {"memberRequiredApprove":[],"name":#(vaultName),"hasRequiredApprover":false,"memberIds":[#(requesterUserID),#(approvalUserID),#(adminUserID)],"type":'#(testData.vault.vault_type)',"approverNumber":0,"note":""}
    * call read('Vault.feature@CreateVault-Common')
    * def hiddenOnUIResponseWOA = response.data.hiddenOnUI
    * match hiddenOnUIResponseWOA == false
    * def vaultNameResponseWOA = response.data.name
    * match vaultNameResponseWOA == vaultName
    * def vaultTypeResponseWOA = response.data.type
    * match vaultTypeResponseWOA == testData.vault.vault_type
    * def vaultIDWOA = response.data.id

  @ignore @CreateVault-Common
  Scenario: Create new vault - Common
    Given path '/core/vault'
    * header challenge-answer = challengeAnswerRequest
    * header passcode = requesterInfo.requesterPasscode
    * request requestBody
    When method POST
    Then status 201

  @RAKCON-10218 @ViewVaultListing
  Scenario: View vault listing
    # View vault listing
    Given path '/core/vault/accounts'
    * param limit = 10
    * param offset = 0
    * param sort = 'DESC'
    * param sortBy = 'TOTAL_USD'
    When method GET
    Then status 200
    #* print addedName
    * def resp = response.data.vaults
    * print resp
    * def totalCount = response.data.totalCount
    * print 'Total number of vaults: ', totalCount
    * match response.status == 'success'

  @ignore @GetCreateVaultRequestID
  Scenario: Get request ID of creating vault request
    * callonce read('Vault.feature@AddNewVaultWithAdminSetup')
    Given path '/core/vault/accounts/'+vaultIDWA
    When method GET
    Then status 200
    * def requestId = response.data.requestId

  @RAKCON-10827 @ViewVaultDetailHasAdminSetup
  Scenario: View vault detail that has admin quorum
    # View detail of vault that has admin quorum after approval
    # ---- Approve creating vault request first
    * callonce read('Vault.feature@GetCreateVaultRequestID')
    * call read('ApprovalRequest.feature@ApproveRequestCommon')
    # ---- View detail of vault that has admin quorum after approval
    Given path '/core/vault/accounts/'+vaultIDWA
    * configure headers = {Authorization: '#(accessToken)'}
    When method GET
    Then status 200
    * def vaultUsersResponseWA = response.data.users
    * print vaultUsersResponseWA
    * def memberIdsWA = $vaultUsersResponseWA[*].userId
    # ---- Check vault name, vault status, vault type, approver number should be same as created
    * match response.data.name == vaultNameResponseWA
    * match response.data.isPendingRequest == false
    * match response.data.approverNumber == testData.vault.approve_number
    * match response.data.type == vaultTypeResponseWA
    * match response.data.totalTransactionPending == 0
    # ---- After approval, missing policy should be false
    * match response.data.missing == false
    # ---- Check vault members should be same as created
    * def listMembers = karate.callSingle('Vault.feature@CHECK-LIST-USER')
    * match memberIdsWA contains only vaultMemberList

  @RAKCON-11146 @ViewVaultDetailHasNotAdminSetup
  Scenario: View vault detail that has not admin quorum
    #View detail of vault that has not admin quorum after creating
    * callonce read('Vault.feature@AddNewVaultWithOutAdminSetup')
    Given path '/core/vault/accounts/'+vaultIDWOA
    When method GET
    Then status 200
    * def vaultUsersResponseWOA = response.data.users
    * print vaultUsersResponseWOA
    * def memberIdsWOA = $vaultUsersResponseWOA[*].userId
    # ---- Check vault name, vault status, vault type, approver number should be same as created
    * match response.data.name == vaultNameResponseWOA
    * match response.data.isPendingRequest == false
    * match response.data.approverNumber == 0
    * match response.data.type == vaultTypeResponseWOA
    * match response.data.totalTransactionPending == 0
    # ---- Missing policy should be true for vault that has not admin quorum
    * match response.data.missing == true
    # ---- Check vault members should be same as created
    * match memberIdsWOA contains only vaultMemberList

  @RAKCON-10954 @SearchVault
  Scenario: Search vaults
    * callonce read('Vault.feature@AddNewVaultWithAdminSetup')
    * def keyword = vaultNameResponseWA
    * call read('Vault.feature@SearchVaultCommon')
    * match response.status == 'success'
    * def listSearchedVault = response.data.vaults
    * def listSearchedVaultName = $listSearchedVault[*].name
    * match each $listSearchedVaultName == "#regex (?i).*" + vaultNameResponseWA + ".*"

  @SearchVaultCommon @ignore
  Scenario: Search vaults - Common
    Given path '/core/vault/accounts'
    * param isHideSmallBalance = false
    * param keyword = keyword
    * param limit = 10
    * param offset = 0
    * param sort = 'DESC'
    * param sortBy = 'TOTAL_USD'
    When method GET
    Then status 200
    * match response.status == 'success'

  @RAKCON-10955 @SortVaultA2Z
  Scenario: Sort vaults by name A - Z
    * def sortType = 'ASC'
    * call read('Vault.feature@SortVaultByName-Common')
    * eval Collections.sort(listVaultNameExpected.map(toUpper), java.lang.String.CASE_INSENSITIVE_ORDER)
    * def expected = listVaultNameExpected.map(toUpper)
    * def actual = listVaultNameActual.map(toUpper)
    * match actual.toString() == expected.toString()

  @RAKCON-11118 @SortVaultZ2A
  Scenario: Sort vaults by name Z - A
    * def sortType = 'DESC'
    * call read('Vault.feature@SortVaultByName-Common')
    * eval Collections.sort(listVaultNameExpected.map(toUpper), Collections.reverseOrder())
    * def expected = listVaultNameExpected.map(toUpper)
    * def actual = listVaultNameActual.map(toUpper)
    * match actual.toString() == expected.toString()

  @ignore @SortVaultByName-Common
  Scenario: Sort vault by name - Common
    Given path '/core/vault/accounts'
    * param isHideSmallBalance = false
    * param limit = 10
    * param offset = 0
    * param sort = sortType
    * param sortBy = 'NAME'
    When method GET
    Then status 200
    * def listVault = response.data.vaults
    * def listVaultNameActual = $listVault[*].name
    * print 'List actual vault after sorting by name Z-A: ', listVaultNameActual
    * copy listVaultNameExpected = listVaultNameActual
    * def toUpper =
    """
    function(x){
    return x.toUpperCase();
    }
    """

  @RAKCON-11119 @SortVaultHighestValue
  Scenario: Sort vaults by highest value
    Given path '/core/vault/accounts'
    * param isHideSmallBalance = false
    * param limit = 10
    * param offset = 0
    * param sort = 'DESC'
    * param sortBy = 'TOTAL_USD'
    When method GET
    Then status 200
    * def listVault = response.data.vaults
    * def listVaultTotalUSDActual = $listVault[*].totalUSD
    * print 'List actual vault after sorting by highest value: ', listVaultTotalUSDActual
    * def listVaultTotalUSDExpected = []
    * eval for(var i = 0; i < listVaultTotalUSDActual.length; i++) listVaultTotalUSDExpected.push(listVaultTotalUSDActual[i])
    * print 'List expected vault  after sorting by highest value: ', listVaultTotalUSDExpected
    * karate.sort(listVaultTotalUSDExpected)
    * match listVaultTotalUSDActual == listVaultTotalUSDExpected

  @RAKCON-11120 @SortVaultLowestValue
  Scenario: Sort vaults by lowest value
    Given path '/core/vault/accounts'
    * param isHideSmallBalance = false
    * param limit = 10
    * param offset = 0
    * param sort = 'ASC'
    * param sortBy = 'TOTAL_USD'
    When method GET
    Then status 200
    * def listVault = response.data.vaults
    * def listVaultTotalUSDActual = $listVault[*].totalUSD
    * print 'List actual vault after sorting by lowest value: ', listVaultTotalUSDActual
    * def listVaultTotalUSDExpected = []
    * eval for(var i = 0; i < listVaultTotalUSDActual.length; i++) listVaultTotalUSDExpected.push(listVaultTotalUSDActual[i])
    * print 'List expected vault  after sorting by lowest value: ', listVaultTotalUSDExpected
    * karate.sort(listVaultTotalUSDExpected)
    * match listVaultTotalUSDActual == listVaultTotalUSDExpected

  @RAKCON-10956 @EditVaultName
  Scenario: Edit vault name
    #Check vault name is existed or not
    * call read('Vault.feature@GenerateVaultName')
    * def creatingVault = callonce read('Vault.feature@AddNewVaultWithAdminSetup')
    Given path '/core/vault/account/'+creatingVault.vaultIDWA
    * request {"name":#(vaultName)}
    When method PUT
    Then status 200
    * match response.data.name == vaultName

  @RAKCON-10957 @EditVaultPolicy
  Scenario: Edit vault policy
    #Get list user in organization
    * callonce read('Vault.feature@CHECK-LIST-USER')
    #Get a vault that has not edit vault pending request
    * call read('ApprovalRequest.feature@ApproveNewVaultRequest')
    #Edit vault policy
    * def requestBody = { "memberIds" : [ #(requesterUserID),#(approvalUserID) ], "note" : "#(testData.vault.editVaultNote)", "approveNumber" : #(testData.vault.newApproverNumber), "memberRequireIds" : [ #(approvalUserID) ] }
    * def editVaultPolicy = call read('Vault.feature@EditVaultPolicy-Common')
    * match editVaultPolicy.response.data.record.additionalData.data.newApproverNumber == testData.vault.newApproverNumber
    * def expectedMemberRequiredApprove = [ #(approvalUserID) ]
    * match editVaultPolicy.response.data.record.additionalData.data.newMemberRequiredApprove == expectedMemberRequiredApprove
    * def expectedListMember = [ #(requesterUserID),#(approvalUserID) ]
    * match $editVaultPolicy.response.data.record.additionalData.data.currentParticipantsWhenInitialRequest[*].userId contains expectedListMember
    * match editVaultPolicy.response.data.record.additionalData.data.note == testData.vault.editVaultNote

  @RAKCON-12799 @EditVaultPolicyWithNotChangedInfo
  Scenario: Edit vault with not changed information
    # Create a new vault then approve it
    * call read('ApprovalRequest.feature@ApproveNewVaultRequest')
    # Use the same requestBody to edit vault
    * def editVaultPolicyCommon = call read('Vault.feature@EditVaultPolicy-Common')
    # Should not allow user to edit vault with not changed information
    Then match editVaultPolicyCommon.response.status != "success"

  @RAKCON-11350 @EditVaultPolicyHasPending
  Scenario: Edit vault policy when has pending request
    * callonce read('Vault.feature@EditVaultPolicy')
    * def requestBody = { "memberIds" : [ #(requesterUserID),#(approvalUserID) ], "note" : "#(testData.vault.editVaultNote)", "approveNumber" : #(testData.vault.newApproverNumber), "memberRequireIds" : [] }
    * call read('Vault.feature@EditVaultPolicy-Common')
    Then match response.data.message == 'Exists pending requests'

  @ignore @EditVaultPolicy-Common
  Scenario: Edit vault policy - Common
    Given path '/core/vault/account/'+vaultIDWA+'/rules'
    * request requestBody
    * call read('Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    * header passcode = requesterInfo.requesterPasscode
    When method PUT

  @RAKCON-11286 @HideVault
  Scenario: Hide a vault
    * callonce read('Vault.feature@AddNewVaultWithAdminSetup')
    Given path '/core/vault/accounts/'+vaultIDWA+'/hide'
    When method POST
    Then status 201
    * match response.status == 'success'

  @RAKCON-11287 @ViewHiddenVaultList
  Scenario: View hidden listing vault
    Given path '/core/vault/accounts'
    * param isHideList = true
    * param limit = 10
    * param offset = 0
    * param sort = 'DESC'
    * param sortBy = 'TOTAL_USD'
    When method GET
    Then status 200
    * def vaultsSchema = schemaBody.vault.schema_list
    * match response.data.vaults == '#[]vaultsSchema'
    * match response.data.hasSmallBalance == '#boolean'
    * match response.data.totalUSD == '#number'
    * match response.data.totalUSDYesterday == '#number'
    * match response.data.totalCount == '#number'
    * match response.data.totalBTC == '#number'

  @RAKCON-11370 @SearchHiddenVault
  Scenario: Search hidden vault
    * callonce read('Vault.feature@HideVault')
    * def keyword = vaultNameResponseWA
    * call read('Vault.feature@SearchVaultCommon')
    * match response.status == 'success'
    * def listSearchedVault = response.data.vaults
    * def listSearchedVaultName = $listSearchedVault[*].name
    * match each $listSearchedVaultName == "#regex (?i).*" + vaultNameResponseWA + ".*"