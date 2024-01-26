@RAKCON-10583
Feature: Vault

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

    @ignore @GenerateVaultName
  Scenario: Generate vault name
    * def now = function(){ return java.lang.System.currentTimeMillis() }
    * def vaultName = 'AT-RAK-' + now()

    @RAKCON-12842 @CHECK-VAULT-NAME-EXIST
  Scenario: Check vault name is existed in the company
    * def value = call read('this:Vault.feature@ViewVaultListing')
    * def name = value.response.data.vaults[0].name
    # * def query = { name:'#(name)'}
    * call read(svc + 'Vault.feature@CheckVaultName') { name: #(name)}
    And match response.data.exist == true

    @RAKCON-16104 @CHECK-VAULT-NAME-NOT-EXIST
  Scenario: Check vault name is Not existed in the company
    # * def query = { name:'VaultTestNotExist'}
    * call read(svc + 'Vault.feature@CheckVaultName') { name: 'VaultTestNotExist'}
    And match response.data.exist == false

    @RAKCON-16175 @GET-LIST-USER
  Scenario: Check user list of organization for add vault
    #Check correct user list from company
    * def listUsers = call read('this:UserManagement.feature@ListUsers')
    * def JSONpath = "$..users[?(@.role=='ADMIN')]"
    * def totalUserToAddvault = karate.jsonPath(listUsers.response.data,JSONpath).length
    * def dataFromPolicy = call read('this:AccountPolicy.feature@ViewAccountPolicy')
    * def totalUserInPolicy = dataFromPolicy.response.data.quorumParticipants.length
    And match totalUserToAddvault == totalUserInPolicy

    @ignore @CHECK-LIST-USER
  Scenario: Get user list to add vault
    #Get user list of organization
    Given path '/auth/account/list-users'
    * request {"isGetAll":true}
    When method POST
    Then status 201
    * def result = response.data.users
    * def approvalUserID = karate.jsonPath(result, "[?(@.username=='"+ approverInfo.approvalUsername +"')].userId")[0]
    * def adminUserID = karate.jsonPath(result, "[?(@.username=='"+ adminUsername +"')].userId")[0]
    * def vaultMemberList = [#(requesterUserID), #(approvalUserID), #(adminUserID)]


    @RAKCON-10217 @AddNewVaultWithAdminSetup
  Scenario: Create a new vault with admin quorum setup
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
        "memberIds":[#(requesterUserID),#(approvalUserID),#(adminUserID)],
        "type":'#(testData.vault.vault_type)',
        "approverNumber":'#(testData.vault.approve_number)',
        "note":"AT Test"
      }
    """
    * call read('this:Vault.feature@CreateVault-Common')
    * def hiddenOnUIResponseWA = response.data.hiddenOnUI
    * match hiddenOnUIResponseWA == false
    * def vaultNameResponseWA = response.data.name
    * match vaultNameResponseWA == vaultName
    * def vaultTypeResponseWA = response.data.type
    * match vaultTypeResponseWA == testData.vault.vault_type
    * def vaultIDWA = response.data.id

    @RAKCON-10220 @AddNewVaultWithOutAdminSetup
  Scenario: Create a new vault without admin quorum setup
    * call read('this:Vault.feature@GenerateVaultName')
    * call read('this:Vault.feature@CHECK-LIST-USER')
    #Get variable challengeAnswerRequest
    * call read('this:Common.feature@FIDO-Requester')
    #Add a new vault without admin quorum setup
    * def requestBody = {"memberRequiredApprove":[],"name":#(vaultName),"hasRequiredApprover":false,"memberIds":[#(requesterUserID),#(approvalUserID),#(adminUserID)],"type":'#(testData.vault.vault_type)',"approverNumber":0,"note":""}
    * call read('this:Vault.feature@CreateVault-Common')
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
    Given path '/core/vault/v2/accounts'
    * param limit = 10
    * param offset = 0
    * param sort = 'DESC'
    * param sortBy = 'TOTAL_USD'
    When method GET
    Then status 200
    #* print addedName
    * def resp = response.data.vaults
    * def totalCount = response.data.totalCount
    * match response.status == 'success'

    @ignore @GetCreateVaultRequestID
  Scenario: Get request ID of creating vault request
    * callonce read('this:Vault.feature@AddNewVaultWithAdminSetup')
    Given path '/core/vault/accounts/'+vaultIDWA
    When method GET
    Then status 200
    * def requestId = response.data.requestId

    @RAKCON-10827 @ViewVaultDetailHasAdminSetup
  Scenario: View vault detail that has admin quorum
    # View detail of vault that has admin quorum after approval
    # ---- Approve creating vault request first
    * callonce read('this:Vault.feature@GetCreateVaultRequestID')
    * call read('this:ApprovalRequest.feature@ApproveRequestCommon')
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
    * def listMembers = karate.callSingle('this:Vault.feature@CHECK-LIST-USER')
    * match memberIdsWA contains only vaultMemberList

    @RAKCON-11146 @ViewVaultDetailHasNotAdminSetup
  Scenario: View vault detail that has not admin quorum
    #View detail of vault that has not admin quorum after creating
    * callonce read('this:Vault.feature@AddNewVaultWithOutAdminSetup')
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
    * callonce read('this:Vault.feature@AddNewVaultWithAdminSetup')
    * def keyword = vaultNameResponseWA
    * call read('this:Vault.feature@SearchVaultCommon')
    * match response.status == 'success'
    * def listSearchedVault = response.data.vaults
    * def listSearchedVaultName = $listSearchedVault[*].name
    * match each $listSearchedVaultName == "#regex (?i).*" + vaultNameResponseWA + ".*"

    @SearchVaultCommon @ignore
  Scenario: Search vaults - Common
    Given path '/core/vault/v2/accounts'
    * param isHideSmallBalance = false
    * param keyword = keyword
    * param limit = 10
    * param offset = 0
    * param sort = 'DESC'
    * param sortBy = 'TOTAL_USD'
    When method GET
    Then status 200
    * match response.status == 'success'

  @ignore @SearchVaultForTransfer
  Scenario: Search vaults for transfer
    Given path 'core/vault/v2/accounts'
    * param fromScreen = screenType
    * param groupBy = 'VAULT'
    * param limit = 10
    * param offset = 0
    * param sort = 'DESC'
    * param sortBy = 'TOTAL_USD'
    * param tokenSymbol = tokenSymbol
    * param keyword = typeof keyword != 'undefined'? keyword : ''
    When method GET
    Then status 200
    * match response.status == 'success'

    @RAKCON-10955 @SortVaultA2Z
  Scenario: Sort vaults by name A - Z
    * def sortType = 'ASC'
    * call read('this:Vault.feature@SortVaultByName-Common')
    * eval Collections.sort(listVaultNameExpected.map(toUpper), java.lang.String.CASE_INSENSITIVE_ORDER)
    * def expected = listVaultNameExpected.map(toUpper)
    * def actual = listVaultNameActual.map(toUpper)
    * match actual.toString() == expected.toString()

    @RAKCON-11118 @SortVaultZ2A
  Scenario: Sort vaults by name Z - A
    * def sortType = 'DESC'
    * call read('this:Vault.feature@SortVaultByName-Common')
    * eval Collections.sort(listVaultNameExpected.map(toUpper), Collections.reverseOrder())
    * def expected = listVaultNameExpected.map(toUpper)
    * def actual = listVaultNameActual.map(toUpper)
    * match actual.toString() == expected.toString()

    @ignore @SortVaultByName-Common
  Scenario: Sort vault by name - Common
    Given path '/core/vault/v2/accounts'
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
    * call read(svc + 'Vault.feature@GetAllVaults')
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
    * call read(svc + 'Vault.feature@GetAllVaults') {sort:'ASC'}
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
    * call read('this:Vault.feature@GenerateVaultName')
    * def creatingVault = callonce read('this:Vault.feature@AddNewVaultWithAdminSetup')
    Given path '/core/vault/account/'+creatingVault.vaultIDWA
    * request {"name":#(vaultName)}
    When method PUT
    Then status 200
    * match response.data.name == vaultName

    @RAKCON-10957 @EditVaultPolicy
  Scenario: Edit vault policy
    #Get list user in organization
    * callonce read('this:Vault.feature@CHECK-LIST-USER')
    #Get a vault that has not edit vault pending request
    * call read('this:ApprovalRequest.feature@ApproveNewVaultRequest')
    * def members = [ #(requesterUserID),#(approvalUserID) ]
    #Edit vault policy
    * def requestBody = { "memberIds": #(members), "note" : "#(testData.vault.editVaultNote)", "approveNumber" : #(members.length), "memberRequireIds" : [ #(approvalUserID) ] }
    * def editVaultPolicy = call read('Vault.feature@EditVaultPolicy-Common')
    * match editVaultPolicy.response.data.data.record.additionalData.data.newApproverNumber == members.length
    * def expectedMemberRequiredApprove = [ #(approvalUserID) ]
    * match editVaultPolicy.response.data.data.record.additionalData.data.newMemberRequiredApprove == expectedMemberRequiredApprove
    * def expectedListMember = [ #(requesterUserID),#(approvalUserID) ]
    * match $editVaultPolicy.response.data.data.record.additionalData.data.currentParticipantsWhenInitialRequest[*].userId contains expectedListMember
    * match editVaultPolicy.response.data.data.record.additionalData.data.note == testData.vault.editVaultNote

    @RAKCON-11350 @EditVaultPolicyHasPending
  Scenario: Edit vault policy when has pending request
    * callonce read('this:Vault.feature@EditVaultPolicy')
    * def requestBody = { "memberIds" : [ #(requesterUserID),#(approvalUserID) ], "note" : "#(testData.vault.editVaultNote)", "approveNumber" : #(members.length), "memberRequireIds" : [] }
    * call read('this:Vault.feature@EditVaultPolicy-Common')
    Then match response.data.data.message == 'Exists pending requests'

    @ignore @EditVaultPolicy-Common
  Scenario: Edit vault policy - Common
    Given path '/core/vault/account/'+vaultIDWA+'/rules'
    * request requestBody
    * call read('this:Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    * header passcode = requesterInfo.requesterPasscode
    When method PUT

    @RAKCON-11286 @HideVault
  Scenario: Hide a vault
    * callonce read('this:Vault.feature@AddNewVaultWithAdminSetup')
    * call read('this:Vault.feature@HideVault_Common')

    @RAKCON-11287 @ViewHiddenVaultList
  Scenario: View hidden listing vault
    * call read('this:Vault.feature@ViewHiddenVaultCommon')
    * def vaultsSchema = schemaBody.vault.schema_list
    * match response.data.list == '#[]vaultsSchema'
    * match response.data.total == '#number'

    @RAKCON-11370 @SearchHiddenVault
  Scenario: Search hidden vault
    * callonce read('this:Vault.feature@HideVault')
    * def keyword = vaultNameResponseWA
    * call read('this:Vault.feature@SearchVaultCommon')
    * match response.status == 'success'
    * def listSearchedVault = response.data.vaults
    * def listSearchedVaultName = $listSearchedVault[*].name
    * match each $listSearchedVaultName == "#regex (?i).*" + vaultNameResponseWA + ".*"

    @RAKCON-16523 @Unhidevault
  Scenario: Unhide a vault
    * def value = call read('this:Vault.feature@ViewHiddenVaultCommon')
    * def vaultId = value.response.data.list[0].id
    * call read(svc + 'Vault.feature@UnarchiveVault') { vaultId: #(vaultId) }
    Then match responseStatus == 200
    * match response.status == 'success'

    @ignore @ViewHiddenVaultCommon
  Scenario: View hidden listing vault common
    * def params = 
    """
    {
      isArchived: true,
      limit: 10,
      offset: 0,
      sort: 'DESC',
      sortBy: 'PRICE'
    }
    """
    * call read(svc + 'Vault.feature@GetListVault_v2') params
    Then match responseStatus == 200
    * match response.status == 'success'
    * match response.message == 'OK'

    @RAKCON-17772 @CreateVaultCold
  Scenario: Create vault - cold
    Given path '/core/vault'
    * call read('this:Vault.feature@GenerateVaultName')
    * call read('this:Common.feature@FIDO-Requester')
    * call read('this:Vault.feature@CHECK-LIST-USER')
    * header challenge-answer = challengeAnswerRequest
    * header passcode = requesterInfo.requesterPasscode
    * def requestBody = {"memberRequiredApprove":[],"name":#(vaultName),"hasRequiredApprover":false,"memberIds":[#(requesterUserID),#(approvalUserID),#(adminUserID)],"type":'COLD_WALLET',"approverNumber":'#(testData.vault.approve_number)',"note":"AT Test"}
    * request requestBody
    When method POST
    Then status 201

    @ignore @RequestCreateNewVaultFromWeb
    Scenario: Request create new vault from web
    * call read('this:Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    * header passcode = requesterInfo.requesterPasscode
    Given path '/core/vault/request-create-vault'
    * request requestBody
    When method POST
    Then status 201

    @ignore @ReadNotificationCreateVaultFromWeb
  Scenario: Read Create Vault From Web Notifiation
    * def notificationId = createVaultRequest.response.data.notificationId
    * call read('this:Notification.feature@ReadNotificationById')
    * match response.data.template.body == 'Vault creation for ' + vaultName + ' needs authentication'
    * match response.data.module.notificationId == notificationId

    @ignore @SubmitRequestFromMobile
  Scenario: Submit request from mobile
    * call read('this:Common.feature@FIDO-Requester')
    * call read(svc + 'Vault.feature@SubmitRequestCreateVault') {notificationId: #(createVaultRequest.response.data.notificationId)}
    * match response.code == 200
    * match response.status == 'success'

    @RAKCON-18141 @SubmitRequestCreateAdvanceVaultFromMobile
  Scenario: Submit request create advance vault from mobile
    * def policyType = 'advanced'
    * call read('this:Vault.feature@GenerateVaultName')
    * call read('this:UserManagement.feature@ListUsers')
    * def viewer1 = listUsers[0]
    * def viewer2 = listUsers[1]
    * def viewer3 = listUsers[2]
    * def viewer4 = listUsers[3]
    * def requestBody = 
    """
      {
        "name":"#(vaultName)",
        "approverNumber":2,
        "type":"#(testData.vault.vault_type)",
        "clientId": #(testData.clientId),
        "quorums":[
          {
            "members":["#(viewer1)","#(viewer2)"],
            "quorumApprovals":1,
            "isRequired":false
          },
          {
            "members":["#(viewer3)","#(viewer4)"],
            "quorumApprovals":1,
            "isRequired":false
          }
        ],
        "policyType":"#(policyType)",
      }
    """
    * def createVaultRequest = call read('this:Vault.feature@RequestCreateNewVaultFromWeb')
    * call read('this:Vault.feature@ReadNotificationCreateVaultFromWeb')
    * call read('this:Vault.feature@SubmitRequestFromMobile')
    * def res = karate.match("response.data == { vaultId : '#uuid' , isMasked:'#boolean'}")
    * match res == { pass: true, message: null }

    @RAKCON-18213 @SubmitRequestCreateSkipPolicyVaultFromMobile
  Scenario: Submit request create skip policy vault from mobile
    * def policyType = null
    * call read('this:Vault.feature@GenerateVaultName')
    * call read('this:Vault.feature@CHECK-LIST-USER')
    * def requestBody = 
    """
      {
        "name":"#(vaultName)",
        "approverNumber":0,
        "type":"#(testData.vault.vault_type)",
        "clientId": #(clientId),
        "memberIds":"#(vaultMemberList)"
      }
    """
    * def createVaultRequest = call read('this:Vault.feature@RequestCreateNewVaultFromWeb')
    * call read('this:Vault.feature@ReadNotificationCreateVaultFromWeb')
    * call read('this:Vault.feature@SubmitRequestFromMobile')

    
  @RAKCON-19626 @EditStandardColdVaultPolicy
  Scenario: Edit Standard Cold Vault Policy
    * call read('this:ApprovalRequest.feature@CreateColdVaultAndApprove')
    # Edit vault policy
    * def members = [ #(requesterUserID),#(approvalUserID) ]
    * def requestBody = 
    """
      { 
        "memberIds" : #(members), 
        "note" : "#(testData.vault.editVaultNote)", 
        "approveNumber" : #(members.length), 
        "memberRequireIds" : [ #(approvalUserID) ] 
      }
    """
    * def editRequest = call read('this:Vault.feature@EditVaultPolicy-Common')
    * match editRequest.response.status == 'success'
    * match editRequest.response.code == 200
    * match editRequest.response.data.data.isValid == true

  @ignore @GetCreateVaultRequestID_NoCreate
  Scenario: Get request ID of creating vault request
    Given path '/core/vault/accounts/'+vaultIDWA
    When method GET
    Then status 200
    * def requestId = response.data.requestId

	@RAKCON-19627 @ViewStandardColdVaultDetails
	Scenario: View Standard Cold Vault Details
		* call read('this:ApprovalRequest.feature@CreateColdVaultAndApprove')
		Then coldVault.response.data.isPendingRequest == false
		And coldVault.response.data.type == "COLD_WALLET"
		And coldVault.response.data.policyType == "STANDARD"
		And coldVault.response.data.totalBTC == "0"
		And coldVault.response.data.totalUSDYesterday == 0
		And coldVault.response.data.totalUSD == 0
		And coldVault.response.data.totalTransactionPending == 0

  @RAKCON-20193 @SearchForOtherCustomerVault
  Scenario: User not able to search other customer vault
    * call read('this:Vault.feature@SearchVaultCommon') { keyword: 'Cross Tenant Vault' }
    * def noOfVault = response.data.vaults.length
    Then match noOfVault == 0

  @RAKCON-20194 @ViewVaultDetailOfOtherCustomer
  Scenario: User not able to view vault details of other customer
    Given path '/core/vault/accounts/'+crossTenant.vaultId
    When method GET
    Then status 404
    And match response.status == "error"
    And match response.errorCode == "VAULT_NOT_FOUND"
    And match response.code == 404
    
  @RAKCON-21137 @ViewCurrentStandardPolicy
  Scenario: Standard Vault - View Current Policy
    * def creatingVault = call read('this:ApprovalRequest.feature@ApproveNewVaultRequest')
    * def vaultIDWA = creatingVault.vaultIDWA
    * call read(svc + 'Vault.feature@GetVaultDetail') {vaultId: '#(vaultIDWA)'}
    Then match response.data.id == vaultIDWA
    * match response.data.name == creatingVault.response.data.name
    * match response.data.createdAt == creatingVault.response.data.createdAt
    * match response.data.type == creatingVault.response.data.type
    * match response.data.totalUSDYesterday == creatingVault.response.data.totalUSDYesterday
    * match response.data.isArchived == creatingVault.response.data.isArchived
    * match response.data.policyType == Const.VaultPolicyType.STANDARD
    * match response.data == schemaBody.vault.details

    * call read('this:Vault.feature@HideVault_Common')

  @RAKCON-21138 @ViewCurrentAdvancedPolicy-Users
    Scenario: Advanced Vault - View Current Policy When Quorums Are Users
    * def vaultId = dataSet.advVaultWithAllUsers
    * call read(svc + 'Vault.feature@GetVaultDetail') {vaultId: '#(vaultId)'}
    Then match response.data.id == vaultId
    * match response.data.name contains testData_v2.advVaultWithAllUsers 
    * match response.data.type == Const.VaultType.HOT_WALLET
    * match response.data.isArchived == false
    * match response.data.policyType == Const.VaultPolicyType.ADVANCED
    * match response.data == schemaBody.vault.details

    * def quorumId = response.data.quorumId
    * call read(svc + 'Quorums.feature@GetQuorumPolicy') {quorumId: '#(quorumId)'}
    * match response.data.objectType == Const.QuorumType.VAULT_LVL
    * match response.data.policyType == Const.VaultPolicyType.ADVANCED
    * match response.data == schemaBody.quorumDetails

    * def commonHandle = read('classpath:rakkar/common/CommonHandle.js')
    * match commonHandle().checkQuorumsValid(response.data.quorums) == true

  @RAKCON-21139 @ViewCurrentAdvancedPolicy-Groups
  Scenario: Advanced Vault - View Current Policy When Quorums Are Groups
    * def vaultId = dataSet.advVaultWithAllGroups
    * call read(svc + 'Vault.feature@GetVaultDetail') {vaultId: '#(vaultId)'}
    Then match response.data.id == vaultId
    * match response.data.name contains testData_v2.advVaultWithAllGroups
    * match response.data.type == Const.VaultType.HOT_WALLET
    * match response.data.isArchived == false
    * match response.data.policyType == Const.VaultPolicyType.ADVANCED
    * match response.data == schemaBody.vault.details

    * def quorumId = response.data.quorumId
    * call read(svc + 'Quorums.feature@GetQuorumPolicy') {quorumId: '#(quorumId)'}
    * match response.data.objectType == Const.QuorumType.VAULT_LVL
    * match response.data.policyType == Const.VaultPolicyType.ADVANCED
    * match response.data == schemaBody.quorumDetails

    * def commonHandle = read('classpath:rakkar/common/CommonHandle.js')
    * match commonHandle().checkQuorumsValid(response.data.quorums) == true

  @RAKCON-21140 @ViewCurrentAdvancedPolicy-GroupsUsers
  Scenario: Advanced Vault - View Current Policy When Quorums Are Groups and Users
    * def vaultId = dataSet.advVaultWithAllGroupsAndUsers
    * call read(svc + 'Vault.feature@GetVaultDetail') {vaultId: '#(vaultId)'}
    Then match response.data.id == vaultId
    * match response.data.name contains testData_v2.advVaultWithAllGroupsAndUsers 
    * match response.data.type == Const.VaultType.HOT_WALLET
    * match response.data.isArchived == false
    * match response.data.policyType == Const.VaultPolicyType.ADVANCED
    * match response.data == schemaBody.vault.details

    * def quorumId = response.data.quorumId
    * call read(svc + 'Quorums.feature@GetQuorumPolicy') {quorumId: '#(quorumId)'}
    * match response.data.objectType == Const.QuorumType.VAULT_LVL
    * match response.data.policyType == Const.VaultPolicyType.ADVANCED
    * match response.data == schemaBody.quorumDetails

    * def commonHandle = read('classpath:rakkar/common/CommonHandle.js')
    * match commonHandle().checkQuorumsValid(response.data.quorums) == true

  @RAKCON-23085 @GetVaultMemberDetails
  Scenario: Get Vault Member Details (Groups, Users)
    * call read(svc + 'Vault.feature@GetVaultDetail') {vaultId: '#(dataSet.advVaultWithAllGroupsAndUsers)'}
    * def quorumId = response.data.quorumId
    * call read(svc + 'Quorums.feature@GetQuorumPolicy') {quorumId: '#(quorumId)'}
    
    * def groupIds = karate.jsonPath(response.data,"$..['groupId']").join(",")
    * def userIds = karate.jsonPath(response.data,"$..['userId']").join(",")
    * call read(svc + 'Auth.feature@GetUserDetails') {userIds: #(userIds)}
    * call read(svc + 'Group.feature@GetGroupsWithDetailsByIds') {ids: #(groupIds)}

  @RAKCON-21141 @EditVaultWith2QuorumsUsers
  Scenario: Advanced to Advanced - Create Request Edit Vault With 2 Quorums as Users
    * def vaultId = dataSet.advVaultWithAllUsers
    * def getQuorums = callonce read('@PreparePolicyForQuorumsOfUsers')
    * def data = 
    """
    {
      "vaultId":"#(vaultId)",
      "clientId": "#(testData.clientId)",
      "quorums": #(getQuorums.quorums),
      "policyType": "advanced",
      "viewers": []
    }
    """
    * call read('@SubmitRequestEditVault') data
    * call read('@CancelRequestEditVaultPolicy') {vaultId: '#(vaultId)'}

  @RAKCON-21146 @EditStandard2AdvanceVaultWith2QuorumsUsers
  Scenario: Standard to Advance - Create Request Edit Vault With 2 Quorums as Users
    * def vaultId = dataSet.standardVaultForEditPolicy
    * def getQuorums = callonce read('@PreparePolicyForQuorumsOfUsers')
    * def data = 
    """
    {
      "vaultId":"#(vaultId)",
      "clientId": "#(testData.clientId)",
      "quorums": #(getQuorums.quorums),
      "policyType": "advanced",
      "viewers": []
    }
    """
    * call read('@SubmitRequestEditVault') data
    * call read('@CancelRequestEditVaultPolicy') {vaultId: '#(vaultId)'}

  @RAKCON-21147 @Skip2Adv_AllUsers
  Scenario: Skip to Advance - Add 2 Quorums as Users
    * def vaultId = dataSet.skipVaultForAddPolicy
    * def getQuorums = callonce read('@PreparePolicyForQuorumsOfUsers')
    * def data = 
    """
    {
      "vaultId":"#(vaultId)",
      "clientId": "#(testData.clientId)",
      "quorums": #(getQuorums.quorums),
      "policyType": "advanced",
      "viewers": []
    }
    """
    * call read(svc + 'Vault.feature@RequestUpdateVaultPolicy') data
    * def requestDraftId = response.data.requestDraftId
    * call read(svc + 'Vault.feature@ReadUpdateVaultRequest') {vaultId: '#(vaultId)', requestDraftId: '#(requestDraftId)'}
    
    * call read(svc + 'Biometric.feature@RequesterDoBiometric')
    * call read(svc + 'Vault.feature@SubmitUpdateVaultRequest') {vaultId: '#(vaultId)', requestDraftId: '#(requestDraftId)'}
    Then match responseStatus == 200 
    And match response.status == "success" 
    * call read('@CancelRequestEditVaultPolicy') {vaultId: '#(vaultId)'}

  @PreparePolicyForQuorumsOfUsers @ignore
  Scenario: Prepare quorums for update vault policy to Advance with some users
    * callonce read(svc + 'Auth.feature@GetListUsers')
    * def quorums = 
    """
      [{
        "members":[
          {
            "userId": "#(requesterUserID)",
            "type": "USER"
          },
          {
            "userId": "#(adminUserID)",
            "type": "USER"
          }
        ],
        "quorumApprovals": 1,
        "isRequired": false
        },{
        "members":[
          {
            "userId": "#(approvalUserID)",
            "type": "USER"
          },
          {
            "userId": "#(adminUserID2)",
            "type": "USER"
          }
        ],
        "quorumApprovals": 1,
        "isRequired": false
      }]
    """

  @RAKCON-21142 @EditVaultWith2QuorumsGroups
  Scenario: Advanced To Advanced - Create Request Edit Vault With 2 Quorums as Groups
    * def vaultId = dataSet.advVaultWithAllUsers
    * def getQuorums = callonce read('@PreparePolicyForQuorumsOfGroups')
    * def data = 
    """
    {
      "vaultId":"#(vaultId)",
      "clientId": "#(testData.clientId)",
      "quorums": #(getQuorums.quorums),
      "policyType": "advanced",
      "viewers": []
    }
    """
    * call read('@SubmitRequestEditVault') data
    * call read('@CancelRequestEditVaultPolicy') {vaultId: '#(vaultId)'}

  @RAKCON-21148 @EditStandard2AdvanceVaultWith2QuorumsGroups
  Scenario: Standard to Advanced - Create Request Edit Vault With 2 Quorums as Groups
    * def vaultId = dataSet.standardVaultForEditPolicy
    * def getQuorums = callonce read('@PreparePolicyForQuorumsOfGroups')
    * def data = 
    """
    {
      "vaultId":"#(vaultId)",
      "clientId": "#(testData.clientId)",
      "quorums": #(getQuorums.quorums),
      "policyType": "advanced",
      "viewers": []
    }
    """
    * call read('@SubmitRequestEditVault') data
    * call read('@CancelRequestEditVaultPolicy') {vaultId: '#(vaultId)'}

  @RAKCON-21149 @Skip2Adv_AllGroups
  Scenario: Skip to Advance - Add 2 Quorums as Groups
    * def vaultId = dataSet.skipVaultForAddPolicy
    * def getQuorums = callonce read('@PreparePolicyForQuorumsOfGroups')
    * def data = 
    """
    {
      "vaultId":"#(vaultId)",
      "clientId": "#(testData.clientId)",
      "quorums": #(getQuorums.quorums),
      "policyType": "advanced",
      "viewers": []
    }
    """
    * call read(svc + 'Vault.feature@RequestUpdateVaultPolicy') data
    * def requestDraftId = response.data.requestDraftId
    * call read(svc + 'Vault.feature@ReadUpdateVaultRequest') {vaultId: '#(vaultId)', requestDraftId: '#(requestDraftId)'}
    
    * call read(svc + 'Biometric.feature@RequesterDoBiometric')
    * call read(svc + 'Vault.feature@SubmitUpdateVaultRequest') {vaultId: '#(vaultId)', requestDraftId: '#(requestDraftId)'}
    Then match responseStatus == 200 
    And match response.status == "success" 
    * call read('@CancelRequestEditVaultPolicy') {vaultId: '#(vaultId)'}
  
  @PreparePolicyForQuorumsOfGroups @ignore
  Scenario: Prepare quorums for update vault policy to Advance with some groups
    * def groups = callonce read(svc + 'Group.feature@GetGroupPolicies') {keyword: #(testData.group)}
    * def quorums = 
    """
      [{
        "members":[
          {
            "groupId": "#(groups.response.data.groups[0].id)",
            "type": "GROUP"
          }
        ],
        "quorumApprovals": 1,
        "isRequired": false
      },{
        "members":[
          {
            "groupId": "#(groups.response.data.groups[1].id)",
            "type": "GROUP"
          }
        ],
        "quorumApprovals": 1,
        "isRequired": false
      }]
    """
  
  @RAKCON-21143 @EditVaultWith2QuorumsGroupsUsers
  Scenario: Advanced To Advanced - Create Request Edit Vault With 2 Quorums as Groups and Users
    * def vaultId = dataSet.advVaultWithAllUsers
    * def getQuorums = callonce read('@PreparePolicyForQuorumsOfGroupsUsers')
    * def data = 
    """
    {
      "vaultId":"#(vaultId)",
      "clientId": "#(testData.clientId)",
      "quorums": #(getQuorums.quorums),
      "policyType": "advanced",
      "viewers": []
    }
    """
    * call read('@SubmitRequestEditVault') data
    * call read('@CancelRequestEditVaultPolicy') {vaultId: '#(vaultId)'}
  
  @RAKCON-21150 @EditStandardToAdvanceWith2QuorumsGroupsUsers
  Scenario: Standard To Advance - Create Request Edit Vault With 2 Quorums as Groups and Users
    * def vaultId = dataSet.standardVaultForEditPolicy
    * def getQuorums = callonce read('@PreparePolicyForQuorumsOfGroupsUsers')
    * def data = 
    """
    {
      "vaultId":"#(vaultId)",
      "clientId": "#(testData.clientId)",
      "quorums": #(getQuorums.quorums),
      "policyType": "advanced",
      "viewers": []
    }
    """
    * call read('@SubmitRequestEditVault') data
    * call read('@CancelRequestEditVaultPolicy') {vaultId: '#(vaultId)'}

  @RAKCON-21151 @Skip2Adv_AllGroupsUsers
  Scenario: Skip to Advance - Add 2 Quorums as Groups and Users
    * def vaultId = dataSet.skipVaultForAddPolicy
    * def getQuorums = callonce read('@PreparePolicyForQuorumsOfGroupsUsers')
    * def data = 
    """
    {
      "vaultId":"#(vaultId)",
      "clientId": "#(testData.clientId)",
      "quorums": #(getQuorums.quorums),
      "policyType": "advanced",
      "viewers": []
    }
    """
    * call read(svc + 'Vault.feature@RequestUpdateVaultPolicy') data
    * def requestDraftId = response.data.requestDraftId
    * call read(svc + 'Vault.feature@ReadUpdateVaultRequest') {vaultId: '#(vaultId)', requestDraftId: '#(requestDraftId)'}
    
    * call read(svc + 'Biometric.feature@RequesterDoBiometric')
    * call read(svc + 'Vault.feature@SubmitUpdateVaultRequest') {vaultId: '#(vaultId)', requestDraftId: '#(requestDraftId)'}
    Then match responseStatus == 200 
    And match response.status == "success" 
    * call read('@CancelRequestEditVaultPolicy') {vaultId: '#(vaultId)'}

  @PreparePolicyForQuorumsOfGroupsUsers @ignore
  Scenario: Prepare quorums for update vault policy to Advance with some groups and users
    * callonce read(svc + 'Auth.feature@GetListUsers')
    * def groups = callonce read(svc + 'Group.feature@GetGroupPolicies') {keyword: #(testData.group)}
    * def quorums =
    """
      [{
        "members":[
          {
            "groupId": "#(groups.response.data.groups[0].id)",
            "type": "GROUP"
          }
        ],
        "quorumApprovals": 1,
        "isRequired": false
      },{
        "members":[
          {
            "userId": "#(adminUserID)",
            "type": "USER"
          },
          {
            "userId": "#(adminUserID2)",
            "type": "USER"
          }
        ],
        "quorumApprovals": 1,
        "isRequired": false
      }]
    """

  @RAKCON-21152 @EditPolicyAdvanceToStandard
  Scenario: Advance To Standard - Create edit advance policy to standard
    * def vaultIDWA = dataSet.advVaultWithAllUsers
    * callonce read(svc + 'Auth.feature@GetListUsers')

    # cancel pending request
    * def requestHandle = read('classpath:rakkar/common/RequestHandle.js')
    * requestHandle().cancelPendingRequestOnVault(vaultIDWA)

    * def members = vaultMemberList
    * print members
    * def requestBody = 
    """
      { 
        "memberIds" : #(members), 
        "note" : "#(testData.vault.editVaultNote)", 
        "approveNumber" : #(members.length), 
        "memberRequireIds" : [ #(approvalUserID) ] 
      }
    """
    * call read('this:Vault.feature@EditVaultPolicy-Common')
    * match response.status == 'success'
    * match response.code == 200
    * match response.data.data.isValid == true

  @SubmitRequestEditVault @ignore
  Scenario: Advanced Vault - Submit Request Edit Vault
    * call read(svc + 'Vault.feature@GetVaultDetail') {vaultId: '#(vaultId)'}
    
    # cancel pending request
    * def requestHandle = read('classpath:rakkar/common/RequestHandle.js')
    * requestHandle().cancelPendingRequest(response.data.requestId)

    * call read(svc + 'Quorums.feature@GetQuorumPolicy') {quorumId: '#(response.data.quorumId)'}

    * call read(svc + 'Vault.feature@RequestUpdateVaultPolicy') data
    * def requestDraftId = response.data.requestDraftId
    * call read(svc + 'Vault.feature@ReadUpdateVaultRequest') {vaultId: '#(vaultId)', requestDraftId: '#(requestDraftId)'}
    
    * call read(svc + 'Biometric.feature@RequesterDoBiometric')
    * call read(svc + 'Vault.feature@SubmitUpdateVaultRequest') {vaultId: '#(vaultId)', requestDraftId: '#(requestDraftId)'}
    Then match responseStatus == 200 
    And match response.status == "success" 
    
  @RAKCON-21144 @CancelRequestEditVaultPolicy @ignore
  Scenario: Advanced Vault - Cancel Request Edit Vault Policy
    # Get request ID from vault detail and cancel request
    * call read(svc + 'Vault.feature@GetVaultDetail') {vaultId: '#(vaultId)'}
    * def requestId = response.data.requestId
    * call read(svc + 'Biometric.feature@RequesterDoBiometric')
    * call read(svc + 'Quorums.feature@CancelRequest') {requestId: '#(requestId)'}

  @RAKCON-21145 @CheckExpiredOfRequestToSubmit
  Scenario: Edit Vault Policy - Check expired of Request before Submit
    * def testData = read('classpath:data/data_test.json')
    * callonce read(svc + 'Auth.feature@GetListUsers')
    * def groups = callonce read(svc + 'Group.feature@GetGroupPolicies') {keyword: #(testData.group)}
    * def vaultId = dataSet.advVaultWithAllUsers
    * def bodyData = 
    """
    {
      "vaultId":"#(vaultId)",
      "clientId": "#(testData.clientId)",
      "quorums": [{
        "members":[
          {
            "groupId": "#(groups.response.data.groups[0].id)",
            "type": "GROUP"
          }
        ],
        "quorumApprovals": 1,
        "isRequired": false
      },{
        "members":[
          {
            "userId": "#(approvalUserID)",
            "type": "USER"
          },
          {
            "userId": "#(adminUserID2)",
            "type": "USER"
          }
        ],
        "quorumApprovals": 1,
        "isRequired": false
      }],
      "policyType": "advanced",
      "viewers": []
    }
    """
    * call read(svc + 'Vault.feature@GetVaultDetail') {vaultId: '#(vaultId)'}

    # cancel pending request
    * def requestHandle = read('classpath:rakkar/common/RequestHandle.js')
    * requestHandle().cancelPendingRequest(response.data.requestId)

    * call read(svc + 'Quorums.feature@GetQuorumPolicy') {quorumId: '#(response.data.quorumId)'}
    * call read(svc + 'Vault.feature@RequestUpdateVaultPolicy') bodyData
    * def requestDraftId = response.data.requestDraftId
    * call read(svc + 'Vault.feature@ReadUpdateVaultRequest') {vaultId: '#(vaultId)', requestDraftId: '#(requestDraftId)'}
    # wait 1.5 mins to have edit vault request expired  
    * eval java.lang.Thread.sleep(150000)
    # Submit from mobile app. It should return error
    * call read(svc + 'Biometric.feature@RequesterDoBiometric')
    * call read(svc + 'Vault.feature@SubmitUpdateVaultRequest') {vaultId: '#(vaultId)', requestDraftId: '#(requestDraftId)'}
    Then match responseStatus == 400
    And match response.status == "error" 
    And match response.errorCode == "REQUEST_EDIT_VAULT_EXPIRED" 
    And match response.message == "REQUEST_EDIT_VAULT_EXPIRED" 
  
  @HideVault_Common @ignore 
  Scenario: Hide a vault
    * call read(svc + 'Vault.feature@ArchiveVault') { vaultId: #(vaultIDWA) }

  @RAKCON-23651 @GetListVault_v2_SortByPriceDesc
  Scenario: Get List Vault v2 from Vault Listing screen, sortBy: 'PRICE', sort: 'DESC'
    * def params = 
    """
    {
      sort: 'DESC',
      sortBy: 'PRICE',
      limit: 100
    }
    """
    * call read(svc + 'Vault.feature@GetListVault_v2') params
    * assert response.data.total > 0
    * assert response.data.list.length > 0
    * match each response.data.list[*].isArchived == false
    # Validate vault item data
    * def expectedVaultSchema = 
    """
    {
      id: "#uuid",
      name: "#string",
      status: "#string",
      type: "#string",
      totalUSD: "#number",
      totalUSDYesterday: "#number",
      isMasked: "#boolean",
      isArchived: "#boolean",
      createdAt: "#string",
      wallets: "#[]"
    }
    """
    * def expectedWalletSchema = 
    """
    {
      "id": "#uuid",
      "name": "#string",
      "total": "#number",
      "symbol": "#string",
      "totalUSD": "#number",
      "externalAssetId": "#string"
    }
    """
    * match each response.data.list[*] == expectedVaultSchema
    * match each response.data.list[*].wallets[*] == expectedWalletSchema
    * def actual = $response.data.list[*].totalUSD
    * def expected = $response.data.list[*].totalUSD
    * eval expected.sort((a,b) => b-a)
    * print "actual Vault Total USD", actual
    * print "expected Vault Total USD", expected
    * match actual.toString() == expected.toString()

  @RAKCON-23652 @GetListVault_v2_SortByPriceAsc
  Scenario: Get List Vault v2 from Vault Listing screen, sortBy: 'PRICE', sort: 'ASC'
    * def params = 
    """
    {
      sort: 'ASC',
      sortBy: 'PRICE',
      limit: 100
    }
    """
    * call read(svc + 'Vault.feature@GetListVault_v2') params
    * def actual = $response.data.list[*].totalUSD
    * def expected = $response.data.list[*].totalUSD
    * eval expected.sort((a,b) => a-b)
    * print "actual Vault Total USD", actual
    * print "expected Vault Total USD", expected
    * match actual.toString() == expected.toString()
    
  @RAKCON-23653 @GetListVault_v2_SortByVaultNameAsc
  Scenario: Get List Vault v2 from Vault Listing screen, sortBy: 'VAULT_NAME', sort: 'ASC'
    * def params = 
    """
    {
      sort: 'ASC',
      sortBy: 'VAULT_NAME',
      limit: 100
    }
    """
    * call read(svc + 'Vault.feature@GetListVault_v2') params
    * def actual = $response.data.list[*].name
    * def expected = $response.data.list[*].name
    * eval expected.map((l) => l.toUpperCase()).sort()
    * print "actual Vault Name", actual
    * print "expected Vault Name", expected
    * match actual.toString() == expected.toString()

  @RAKCON-23654 @GetListVault_v2_SortByVaultNameDesc
  Scenario: Get List Vault v2 from Vault Listing screen, sortBy: 'VAULT_NAME', sort: 'DESC'
    * def params = 
    """
    {
      sort: 'DESC',
      sortBy: 'VAULT_NAME',
      limit: 100
    }
    """
    * call read(svc + 'Vault.feature@GetListVault_v2') params
    * def actual = $response.data.list[*].name
    * def expected = $response.data.list[*].name
    * eval expected.map(l => l.toUpperCase()).sort().reverse()
    * print "actual Vault Name", actual
    * print "expected Vault Name", expected
    * match actual.toString() == expected.toString()

  @RAKCON-23655 @GetListVault_v2_SearchByVaultName
  Scenario: Get List Vault v2 from Vault Listing screen, search by vault name
    * def params = 
    """
    {
      searchText: "#(testData_v2.standardWarmVault_1)"
    }
    """
    * call read(svc + 'Vault.feature@GetListVault_v2') params
    * match each response.data.list[*].name contains testData_v2.standardWarmVault_1
  
  @RAKCON-23656 @GetListVault_v2_SearchBySymbol @ignore
  Scenario: Get List Vault v2 from Vault Listing screen, search by token symbol in vault
    # Improvement @MOB-2286
    * def params = 
    """
    {
      searchText: 'XRP'
    }
    """
    * call read(svc + 'Vault.feature@GetListVault_v2') params
    * match each response.data.list[*].wallets != null
    * match each response.data.list[*].wallets[*] contains { symbol: 'XRP'}

  @RAKCON-23657 @GetListVault_v2_ListArchivedVault
  Scenario: Get List Vault v2 from Vault Listing screen, able to search masked archived vault
    * def params = 
    """
    {
      isArchived: true,
      searchText: '#(testData_v2.maskedVault)'
    }
    """
    * call read(svc + 'Vault.feature@GetListVault_v2') params
    * def maskedVault = response.data.list.filter((v) => v.isMasked).map(v => v.name.toLowerCase())
    * match each maskedVault[*].isArchived == true
    * match each maskedVault[*].name contains testData_v2.maskedVault
    * match each maskedVault[*].isMasked == true
    * match each maskedVault[*].totalUSD == null
    * match each maskedVault[*].totalUSDYesterday == null

  @RAKCON-23658 @GetListVault_v2_SearchMaskedVaultShowSignificanceOnly
  Scenario: Get List Vault v2 from Vault Listing screen, unable to search masked Vault when isShowSignificanceOnly = true
    # Bug MOB-3552
    * def params = 
    """
    {
      searchText: #(testData_v2.maskedVault),
      isShowSignificanceOnly: true
    }
    """
    * call read(svc + 'Vault.feature@GetListVault_v2') params
    * def maskedVault = response.data.list.filter((v) => v.isMasked)
    * assert maskedVault.length == 0

  @RAKCON-23659 @GetListVault_v2_SearchMaskedVaultUncheckShowSignificanceOnly
  Scenario: Get List Vault v2 from Vault Listing screen, able to search masked Vault when isShowSignificanceOnly = false
    * def params = 
    """
    {
      searchText: #(testData_v2.maskedVault),
      isShowSignificanceOnly: false
    }
    """
    * call read(svc + 'Vault.feature@GetListVault_v2') params
    * def maskedVault = response.data.list.filter((v) => v.isMasked).map(v => v.name.toLowerCase())
    * match each maskedVault[*].name contains testData_v2.maskedVault.toLowerCase()
    * match each maskedVault[*].totalUSD == null

  @RAKCON-23660 @GetVaultSummary
  Scenario: Get Vault Summary from Vault Listing screen
    * call read(svc + 'Vault.feature@GetVaultsSummary')
    * def expectedSchema = 
    """
    {
      total: '#number? _ > 0',
      totalByDate: '#number? _ > 0',
      date: '#string'
    }
    """
    Then response.data == expectedSchema



