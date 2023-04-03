@RAKCON-10585
Feature: Vault

  Background:
    #@PRECOND_RAKCON-10225
    * url baseURL
    * call read('RequesterAuthenticator.feature@RequesterAccessToken')
    * def getRequesterIDResponse = call read('GetRequesterID.feature')
    * def requesterUserID = getRequesterIDResponse.response.data.id
    * def dataBody = read('classpath:data/data_test.json')
    * def Collections = Java.type('java.util.Collections')

  @ignore @CHECK-VAULT-NAME
  Scenario: Check vault name is existed or not
    #Check vault name is existed or not
    Given path '/core/vault/check-vault-name'
    * def now = function(){ return java.lang.System.currentTimeMillis() }
    * def vaultName = 'AT-RAK-' + now()
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
    * def approvalUserID = karate.jsonPath(result, "$.ADMIN[?(@.username=='"+ approvalUsername +"')].userId")[0]
    * def adminUserID = karate.jsonPath(result, "$.ADMIN[?(@.username=='"+ adminUsername +"')].userId")[0]
    * def vaultMemberList = [#(requesterUserID), #(approvalUserID), #(adminUserID)]
    * print vaultMemberList

  @ignore @BY-PASS-BIOMETRIC
  Scenario: By pass biometric method
    #By pass biometric method
    Given path '/core/biometric/request-challenge'
    * request {}
    When method POST
    Then status 201
    * def statusMsg = response.status
    * match statusMsg == 'success'

  @ignore @VERIFY-PASSCODE
  Scenario: Verify passcode of Requester
    #Verify requesterPasscode
    Given path '/auth/account/verify-passcode'
    * request {"passcode":'#(requesterPasscode)'}
    When method POST
    Then status 201
    * def verifyStatus = response.data.verify
    * match verifyStatus == true

  @RAKCON-10217 @AddNewVaultWithAdminSetup
  Scenario: Create a new vault with admin quorum setup
    * call read('Vault.feature@CHECK-VAULT-NAME')
    * call read('Vault.feature@CHECK-LIST-USER')
    * call read('Vault.feature@BY-PASS-BIOMETRIC')
    #* call read('Vault.feature@VERIFY-PASSCODE')
    #Get variable challengeAnswerRequest
    * call read('GenerateAnswer.feature@FIDO-Requester')
    #Add a new vault with admin quorum setup
    Given path '/core/vault'
    * header challenge-answer = challengeAnswerRequest
    * header passcode = requesterPasscode
    * request {"memberRequiredApprove":[],"name":#(vaultName),"hasRequiredApprover":false,"memberIds":[#(requesterUserID),#(approvalUserID),#(adminUserID)],"type":'#(dataBody.vault.vault_type)',"approverNumber":'#(dataBody.vault.approve_number)',"note":"AT Test"}
    When method POST
    Then status 201
    * def hiddenOnUIResponseWA = response.data.hiddenOnUI
    * match hiddenOnUIResponseWA == false
    * def vaultNameResponseWA = response.data.name
    * match vaultNameResponseWA == vaultName
    * def vaultTypeResponseWA = response.data.type
    * match vaultTypeResponseWA == dataBody.vault.vault_type
    * def vaultIDWA = response.data.id

  @RAKCON-10220 @AddNewVaultWithOutAdminSetup
  Scenario: Create a new vault without admin quorum setup
    * call read('Vault.feature@CHECK-VAULT-NAME')
    * call read('Vault.feature@CHECK-LIST-USER')
    * call read('Vault.feature@BY-PASS-BIOMETRIC')
    #* call read('Vault.feature@VERIFY-PASSCODE')
    #Get variable challengeAnswerRequest
    * call read('GenerateAnswer.feature@FIDO-Requester')
    #Add a new vault without admin quorum setup
    Given path '/core/vault'
    * header challenge-answer = challengeAnswerRequest
    * header passcode = requesterPasscode
    * request {"memberRequiredApprove":[],"name":#(vaultName),"hasRequiredApprover":false,"memberIds":[#(requesterUserID),#(approvalUserID),#(adminUserID)],"type":'#(dataBody.vault.vault_type)',"approverNumber":0,"note":""}
    When method POST
    Then status 201
    * def hiddenOnUIResponseWOA = response.data.hiddenOnUI
    * match hiddenOnUIResponseWOA == false
    * def vaultNameResponseWOA = response.data.name
    * match vaultNameResponseWOA == vaultName
    * def vaultTypeResponseWOA = response.data.type
    * match vaultTypeResponseWOA == dataBody.vault.vault_type
    * def vaultIDWOA = response.data.id

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

  @ignore @GetCrateVaultRequestID
  Scenario: Get request ID of creating vault request
    * callonce read('Vault.feature@AddNewVaultWithAdminSetup')
    Given path '/core/vault/accounts/'+vaultIDWA
    When method GET
    Then status 200
    * def requestCreateVaultID = response.data.requestId

  @RAKCON-10827 @ViewVaultDetailHasAdminSetup
  Scenario: View vault detail that has admin quorum
    # View detail of vault that has admin quorum after approval
    # ---- Approve creating vault request first
    * callonce read('Vault.feature@GetCrateVaultRequestID')
    * def requestID = requestCreateVaultID
    * call read('ApprovalRequest.feature@ApproveRequest')
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
    * match response.data.approverNumber == dataBody.vault.approve_number
    * match response.data.type == vaultTypeResponseWA
    * match response.data.totalTransactionPending == 0
    # ---- After approval, missing policy should be false
    * match response.data.missing == false
    # ---- Check vault members should be same as created
    * def listMembers = karate.callSingle('Vault.feature@CHECK-LIST-USER')
    * match memberIdsWA == vaultMemberList

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
    * match memberIdsWOA == vaultMemberList

  @RAKCON-10954 @SearchVault
  Scenario: Search vaults
    * callonce read('Vault.feature@AddNewVaultWithAdminSetup')
    Given path '/core/vault/accounts'
    * param isHideSmallBalance = false
    * param keyword = vaultNameResponseWA
    * param limit = 10
    * param offset = 0
    * param sort = 'DESC'
    * param sortBy = 'TOTAL_USD'
    When method GET
    Then status 200
    * match response.status == 'success'
    * def listSearchedVault = response.data.vaults
    * def listSearchedVaultName = $listSearchedVault[*].name
    * print listSearchedVaultName
    * match each $listSearchedVaultName == "#regex (?i).*" + vaultNameResponseWA + ".*"

  @RAKCON-10955 @SortVaultA2Z
  Scenario: Sort vaults by name A - Z
    Given path '/core/vault/accounts'
    * param isHideSmallBalance = false
    * param limit = 9999999
    * param offset = 0
    * param sort = 'ASC'
    * param sortBy = 'NAME'
    When method GET
    Then status 200
    * def listVault = response.data.vaults
    * def listVaultNameActual = $listVault[*].name
    * print 'List actual vault after sorting by name A-Z: ', listVaultNameActual
    * def listVaultNameExpected = []
    * eval for(var i = 0; i < listVaultNameActual.length; i++) listVaultNameExpected.push(listVaultNameActual[i])
    * eval Collections.sort(listVaultNameExpected, java.lang.String.CASE_INSENSITIVE_ORDER)
    * match listVaultNameActual == listVaultNameExpected

  @RAKCON-11118 @SortVaultZ2A
  Scenario: Sort vaults by name Z - A
    Given path '/core/vault/accounts'
    * param isHideSmallBalance = false
    * param limit = 9999999
    * param offset = 0
    * param sort = 'DESC'
    * param sortBy = 'NAME'
    When method GET
    Then status 200
    * def listVault = response.data.vaults
    * def listVaultNameActual = $listVault[*].name
    * print 'List actual vault after sorting by name Z-A: ', listVaultNameActual
    * def listVaultNameExpected = []
    * eval for(var i = 0; i < listVaultNameActual.length; i++) listVaultNameExpected.push(listVaultNameActual[i])
    * eval Collections.sort(listVaultNameExpected, Collections.reverseOrder())
    * match listVaultNameActual == listVaultNameExpected

  @RAKCON-11119 @SortVaultHighestValue
  Scenario: Sort vaults by highest value
    Given path '/core/vault/accounts'
    * param isHideSmallBalance = false
    * param limit = 9999999
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
    * def listVaultTotalUSDASC = listVaultTotalUSDExpected.reverse()

  @RAKCON-11120 @SortVaultLowestValue
  Scenario: Sort vaults by lowest value
    Given path '/core/vault/accounts'
    * param isHideSmallBalance = false
    * param limit = 9999999
    * param offset = 0
    * param sort = 'ASC'
    * param sortBy = 'TOTAL_USD'
    When method GET
    Then status 200
    * def listVault = response.data.vaults
    * def listVaultTotalUSDASCActual = $listVault[*].totalUSD
    * print 'List actual vault after sorting by lowest value: ', listVaultTotalUSDASCActual
    * callonce read('Vault.feature@SortVaultHighestValue')
    * match listVaultTotalUSDASCActual == listVaultTotalUSDASC

  @RAKCON-10956 @EditVaultName
  Scenario: Edit vault name
    #Check vault name is existed or not
    * call read('Vault.feature@CHECK-VAULT-NAME')
    * def vaultListing = callonce read('Vault.feature@ViewVaultListing')
    * def listVaultID = $vaultListing.response.data.vaults[*].id
    * print 'Get list vault ID: ', listVaultID
    Given path '/core/vault/account/'+listVaultID[0]
    * request {"name":#(vaultName)}
    When method PUT
    Then status 200
    * match response.data.name == vaultName

  @RAKCON-10957 @EditVaultPolicy
  Scenario: Edit vault policy
    #Get variable challengeAnswerRequest
    * call read('GenerateAnswer.feature@FIDO-Requester')
    #Get list user in organization
    * callonce read('Vault.feature@CHECK-LIST-USER')
    #Get a random vault that has not edit vault pending request
    * def vaultListing = callonce read('Vault.feature@ViewVaultListing')
    * def listVault = vaultListing.response.data.vaults
    * print listVault
    * def VaultWOPendingReq = karate.jsonPath(listVault, "$.[?(@.editVaultPending==false && @.missing==false)].id")[0]
    * print 'List vaults can be edited: ', karate.jsonPath(listVault, "$.[?(@.editVaultPending==false && @.missing==false)].id")
    * print 'Editing vault ID: ', VaultWOPendingReq
    #Edit vault policy
    Given path '/core/vault/account/'+VaultWOPendingReq+'/rules'
    * request { "memberIds" : [ #(requesterUserID),#(approvalUserID) ], "note" : "#(dataBody.vault.editVaultNote)", "approveNumber" : #(dataBody.vault.newApproverNumber), "memberRequireIds" : [ #(approvalUserID) ] }
    * header challenge-answer = challengeAnswerRequest
    * header passcode = requesterPasscode
    When method PUT
    Then status 200
    * match response.data.record.additionalData.data.newApproverNumber == dataBody.vault.newApproverNumber
    * def expectedMemberRequiredApprove = [ #(approvalUserID) ]
    * match response.data.record.additionalData.data.newMemberRequiredApprove == expectedMemberRequiredApprove
    * def expectedListMember = [ #(requesterUserID),#(approvalUserID) ]
    * match $response.data.record.additionalData.data.currentParticipantsWhenInitialRequest[*].userId == expectedListMember
    * match response.data.record.additionalData.data.note == dataBody.vault.editVaultNote