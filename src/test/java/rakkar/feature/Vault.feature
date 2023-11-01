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
    * callonce read(svc + 'ReadData.feature')

    @ignore @GenerateVaultName
  Scenario: Generate vault name
    * def now = function(){ return java.lang.System.currentTimeMillis() }
    * def vaultName = 'AT-RAK-' + now()

    @ignore @CheckVaultNameCommon
  Scenario: Check vault name common
    Given path '/core/vault/check-vault-name'
    And params query
    When method GET
    Then status 200

    @RAKCON-12842 @CHECK-VAULT-NAME-EXIST
  Scenario: Check vault name is existed in the company
    * def value = call read('this:Vault.feature@ViewVaultListing')
    * def name = value.response.data.vaults[0].name
    * def query = { name:'#(name)'}
    * call read('this:Vault.feature@CheckVaultNameCommon')
    And match response.data.exist == true

    @RAKCON-16104 @CHECK-VAULT-NAME-NOT-EXIST
  Scenario: Check vault name is Not existed in the company
    * def query = { name:'VaultTestNotExist'}
    * call read('this:Vault.feature@CheckVaultNameCommon')
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
    * header User-Agent = "rakkar/1.0.0 (com.rakkar.digital.mobile; build:312; iOS 16.5.0) Alamofire/5.6.2"
    Given path '/auth/account/list-users'
    * request {"isGetAll":true}
    When method POST
    Then status 201
    * def result = response.data.users
    * def approvalUserID = karate.jsonPath(result, "$.ADMIN[?(@.username=='"+ approverInfo.approvalUsername +"')].userId")[0]
    * def adminUserID = karate.jsonPath(result, "$.ADMIN[?(@.username=='"+ adminUsername +"')].userId")[0]
    * def vaultMemberList = [#(requesterUserID), #(approvalUserID), #(adminUserID)]


    @RAKCON-10217 @AddNewVaultWithAdminSetup
  Scenario: Create a new vault with admin quorum setup
    * call read('this:Vault.feature@GenerateVaultName')
    * call read('this:Vault.feature@CHECK-LIST-USER')
    #Get variable challengeAnswerRequest
    * call read('this:Common.feature@FIDO-Requester')
    #Add a new vault with admin quorum setup
    * def requestBody = {"memberRequiredApprove":[],"name":#(vaultName),"hasRequiredApprover":false,"memberIds":[#(requesterUserID),#(approvalUserID),#(adminUserID)],"type":'#(testData.vault.vault_type)',"approverNumber":'#(testData.vault.approve_number)',"note":"AT Test"}
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
    Given path '/core/vault/accounts'
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

  @ignore @SearchVaultForTransfer
  Scenario: Search vaults for transfer
    Given path 'core/vault/accounts'
    * param fromScreen = screenType
    * param groupBy = 'VAULT'
    * param limit = 10
    * param offset = 0
    * param sort = 'DESC'
    * param sortBy = 'TOTAL_USD'
    * param tokenSymbol = tokenSymbol
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
    #Edit vault policy
    * def requestBody = { "memberIds" : [ #(requesterUserID),#(approvalUserID) ], "note" : "#(testData.vault.editVaultNote)", "approveNumber" : #(testData.vault.newApproverNumber), "memberRequireIds" : [ #(approvalUserID) ] }
    * def editVaultPolicy = call read('Vault.feature@EditVaultPolicy-Common')
    * match editVaultPolicy.response.data.record.additionalData.data.newApproverNumber == testData.vault.newApproverNumber
    * def expectedMemberRequiredApprove = [ #(approvalUserID) ]
    * match editVaultPolicy.response.data.record.additionalData.data.newMemberRequiredApprove == expectedMemberRequiredApprove
    * def expectedListMember = [ #(requesterUserID),#(approvalUserID) ]
    * match $editVaultPolicy.response.data.record.additionalData.data.currentParticipantsWhenInitialRequest[*].userId contains expectedListMember
    * match editVaultPolicy.response.data.record.additionalData.data.note == testData.vault.editVaultNote


    @RAKCON-11350 @EditVaultPolicyHasPending
  Scenario: Edit vault policy when has pending request
    * callonce read('this:Vault.feature@EditVaultPolicy')
    * def requestBody = { "memberIds" : [ #(requesterUserID),#(approvalUserID) ], "note" : "#(testData.vault.editVaultNote)", "approveNumber" : #(testData.vault.newApproverNumber), "memberRequireIds" : [] }
    * call read('this:Vault.feature@EditVaultPolicy-Common')
    Then match response.data.message == 'Exists pending requests'

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
    * match response.data.vaults == '#[]vaultsSchema'
    * match response.data.hasSmallBalance == '#boolean'
    * match response.data.totalUSD == '#number'
    * match response.data.totalUSDYesterday == '#number'
    * match response.data.totalCount == '#number'
    * match response.data.totalBTC == '#number'

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
    * def vaultId = value.response.data.vaults[0].id
    Given path '/core/vault/accounts/'+vaultId+'/unhide'
    When method POST
    Then status 201
    * match response.status == 'success'

    @ignore @ViewHiddenVaultCommon
  Scenario: View hidden listing vault common
    Given path '/core/vault/accounts'
    * param isHideList = true
    * param limit = 10
    * param offset = 0
    * param sort = 'DESC'
    * param sortBy = 'TOTAL_USD'
    When method GET
    Then status 200

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
    * header challenge-answer = challengeAnswerRequest
    * header passcode = requesterInfo.requesterPasscode
    * def requestId = createVaultRequest.response.data.notificationId
    Given url baseMobileURL + '/core/vault/submit-request-create-vault'
    * request { "notificationId" : "#(requestId)" }
    When method POST
    Then status 201
    * match response.code == 200
    * match response.status == 'success'
    * def res = karate.match("response.data == { vaultId : '#uuid' }")
    * match res == { pass: true, message: null }

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
    * def requestBody = 
    """
      { 
        "memberIds" : [ #(requesterUserID),#(approvalUserID) ], 
        "note" : "#(testData.vault.editVaultNote)", 
        "approveNumber" : #(testData.vault.newApproverNumber), 
        "memberRequireIds" : [ #(approvalUserID) ] 
      }
    """
    * def editRequest = call read('this:Vault.feature@EditVaultPolicy-Common')
    * match editRequest.response.status == 'success'
    * match editRequest.response.code == 200
    * match editRequest.response.data.isValid == true

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
    
  @ViewCurrentStandardPolicy
  Scenario: Standard Vault - View Current Policy
    * def creatingVault = callonce read('this:Vault.feature@AddNewVaultWithAdminSetup')
    * def vaultIDWA = creatingVault.vaultIDWA
    * call read('this:Vault.feature@GetCreateVaultRequestID_NoCreate')
    Then match each response.data.users[*].id == "#uuid"
    * match each response.data.users[*].email == "#string"
    * match each response.data.users[*].name == "#string"
    * match each response.data.users[*].enabled == "#boolean"
    * match each response.data.users[*].role == "#string"
    * match each response.data.users[*].roleDisplayName == "#string"
    * match each response.data.users[*].requiredApprover == "#boolean"
    * match each response.data.users[*].isApprover == "#boolean"
    * call read('this:Vault.feature@HideVault_Common')

  @ViewCurrentAdvancedPolicy-Users
    Scenario: Advanced Vault - View Current Policy When Quorums Are Users
    * def vaultId = dataSet.advVaultWithAllUsers
    * call read(svc + 'Vault.feature@GetVaultDetail') {vaultId: '#(vaultId)'}
    Then match response.data.policyType == "ADVANCE"
    * def quorumId = response.data.quorumId
    * call read(svc + 'AdvanceQuorum.feature@GetQuorumPolicy') {quorumId: '#(quorumId)'}
    # * match each response.data.quorums[*].members[*].type == "USER"
    # * match each response.data.quorums[*].members[*].userId == "#uuid"
    # * match each response.data.quorums[*].members[*].groupId == "#uuid"

  @ViewCurrentAdvancedPolicy-Groups
  Scenario: Advanced Vault - View Current Policy When Quorums Are Groups
    * def vaultId = dataSet.advVaultWithAllGroups
    * call read(svc + 'Vault.feature@GetVaultDetail') {vaultId: '#(vaultId)'}
    Then match response.data.policyType == "ADVANCE"
    * def quorumId = response.data.quorumId
    * call read(svc + 'AdvanceQuorum.feature@GetQuorumPolicy') {quorumId: '#(quorumId)'}
    # * match each response.data.quorums[*].members[*].type == "GROUP"
    # * match each response.data.quorums[*].members[*].userId == "#uuid"
    # * match each response.data.quorums[*].members[*].groupId == "#uuid"

  @ViewCurrentAdvancedPolicy-GroupsUsers
  Scenario: Advanced Vault - View Current Policy When Quorums Are Groups and Users
    * def vaultId = dataSet.advVaultWithAllGroupsAndUsers
    * call read(svc + 'Vault.feature@GetVaultDetail') {vaultId: '#(vaultId)'}
    Then match response.data.policyType == "ADVANCE"
    * def quorumId = response.data.quorumId
    * call read(svc + 'AdvanceQuorum.feature@GetQuorumPolicy') {quorumId: '#(quorumId)'}

  @EditVaultWith2QuorumsUsers
  Scenario: Advanced Vault - Create Request Edit Vault With 2 Quorums as Users
    * callonce read(svc + 'Auth.feature@GetListUsers')
    * def vaultId = dataSet.advVaultWithAllUsers
    * def data = 
    """
    {
      "vaultId":"#(vaultId)",
      "clientId": "#(testData.clientId)",
      "quorums": [{
        "members":[
          {
            "userId": "#(requesterUserID)",
            "type": "#(Const.QuorumMemberType.USER)"
          },
          {
            "userId": "#(adminUserID)",
            "type": "#(Const.QuorumMemberType.USER)"
          }
        ],
        "quorumApprovals": 1,
        "isRequired": false
      },{
        "members":[
          {
            "userId": "#(approvalUserID)",
            "type": "#(Const.QuorumMemberType.USER)"
          },
          {
            "userId": "#(adminUserID2)",
            "type": "#(Const.QuorumMemberType.USER)"
          }
        ],
        "quorumApprovals": 1,
        "isRequired": false
      }],
      "policyType": "advanced",
      "viewers": []
    }
    """
    * call read('@SubmitRequestEditVaultAndCancel') data
    * call read('@CancelRequestEditVaultPolicy') {vaultId: '#(vaultId)'}
    
  @EditVaultWith2QuorumsGroups
  Scenario: Advanced Vault - Create Request Edit Vault With 2 Quorums as Groups
    * def groups = callonce read(svc + 'Group.feature@GetGroupPolicies') {keyword: #(testData.group)}
    * def vaultId = dataSet.advVaultWithAllUsers
    * def data = 
    """
    {
      "vaultId":"#(vaultId)",
      "clientId": "#(testData.clientId)",
      "quorums": [{
        "members":[
          {
            "groupId": "#(groups.response.data.groups[0].id)",
            "type": "#(Const.QuorumMemberType.GROUP)"
          }
        ],
        "quorumApprovals": 1,
        "isRequired": false
      },{
        "members":[
          {
            "groupId": "#(groups.response.data.groups[1].id)",
            "type": "#(Const.QuorumMemberType.GROUP)"
          }
        ],
        "quorumApprovals": 1,
        "isRequired": false
      }],
      "policyType": "advanced",
      "viewers": []
    }
    """
    * call read('@SubmitRequestEditVaultAndCancel') data
    * call read('@CancelRequestEditVaultPolicy') {vaultId: '#(vaultId)'}

  
  @EditVaultWith2QuorumsGroupsUsers
  Scenario: Advanced Vault - Create Request Edit Vault With 2 Quorums as Groups and Users
    * callonce read(svc + 'Auth.feature@GetListUsers')
    * def groups = callonce read(svc + 'Group.feature@GetGroupPolicies') {keyword: #(testData.group)}
    * def vaultId = dataSet.advVaultWithAllUsers
    * def data = 
    """
    {
      "vaultId":"#(vaultId)",
      "clientId": "#(testData.clientId)",
      "quorums": [{
        "members":[
          {
            "groupId": "#(groups.response.data.groups[0].id)",
            "type": "#(Const.QuorumMemberType.GROUP)"
          }
        ],
        "quorumApprovals": 1,
        "isRequired": false
      },{
        "members":[
          {
            "userId": "#(adminUserID)",
            "type": "#(Const.QuorumMemberType.USER)"
          },
          {
            "userId": "#(adminUserID2)",
            "type": "#(Const.QuorumMemberType.USER)"
          }
        ],
        "quorumApprovals": 1,
        "isRequired": false
      }],
      "policyType": "advanced",
      "viewers": []
    }
    """
    * call read('@SubmitRequestEditVault') data
    * call read('@CancelRequestEditVaultPolicy') {vaultId: '#(vaultId)'}

  @SubmitRequestEditVault @ignore
  Scenario: Advanced Vault - Submit Request Edit Vault
    * print data
    * call read(svc + 'Vault.feature@GetVaultDetail') {vaultId: '#(vaultId)'}
    * if (response.data.requestId != null) karate.call(svc + 'AdvanceQuorum.feature@CancelRequest', {requestId:response.data.requestId})
    * call read(svc + 'AdvanceQuorum.feature@GetQuorumPolicy') {quorumId: '#(response.data.quorumId)'}

    * call read(svc + 'Vault.feature@RequestUpdateVaultPolicy') data
    * def requestDraftId = response.data.requestDraftId
    * call read(svc + 'Vault.feature@ReadUpdateVaultRequest') {vaultId: '#(vaultId)', requestDraftId: '#(requestDraftId)'}
    
    * call read(svc + 'Biometric.feature@RequesterDoBiometric')
    * call read(svc + 'Vault.feature@SubmitUpdateVaultRequest') {vaultId: '#(vaultId)', requestDraftId: '#(requestDraftId)'}
    
  @CancelRequestEditVaultPolicy @ignore
  Scenario: Advanced Vault - Cancel Request Edit Vault Policy
    # Get request ID from vault detail and cancel request
    * call read(svc + 'Vault.feature@GetVaultDetail') {vaultId: '#(vaultId)'}
    * def requestId = response.data.requestId
    * call read(svc + 'Biometric.feature@RequesterDoBiometric')
    * call read(svc + 'AdvanceQuorum.feature@CancelRequest') {requestId: '#(requestId)'}

  @CheckExpiredOfRequestToSubmit
  Scenario: Check expired of Request before Submit
    * callonce read(svc + 'Auth.feature@GetListUsers')
    * def groups = callonce read(svc + 'Group.feature@GetGroupPolicies') {keyword: #(testData.group)}
    * def vaultId = dataSet.advVaultWithAllUsers
    * def data = 
    """
    {
      "vaultId":"#(vaultId)",
      "clientId": "#(testData.clientId)",
      "quorums": [{
        "members":[
          {
            "groupId": "#(groups.response.data.groups[0].id)",
            "type": "#(Const.QuorumMemberType.GROUP)"
          }
        ],
        "quorumApprovals": 1,
        "isRequired": false
      },{
        "members":[
          {
            "userId": "#(adminUserID)",
            "type": "#(Const.QuorumMemberType.USER)"
          },
          {
            "userId": "#(adminUserID2)",
            "type": "#(Const.QuorumMemberType.USER)"
          }
        ],
        "quorumApprovals": 1,
        "isRequired": false
      }],
      "policyType": "advanced",
      "viewers": []
    }
    """
    * call read('@SubmitRequestEditVault') data 
  
  @HideVault_Common
  Scenario: Hide a vault
    Given path '/core/vault/accounts/'+vaultIDWA+'/hide'
    When method POST
    Then status 201
    * match response.status == 'success'

