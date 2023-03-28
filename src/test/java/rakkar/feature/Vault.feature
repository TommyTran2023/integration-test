@RAKCON-10585 @AT
Feature: Vault

  Background:
    #@PRECOND_RAKCON-10225
    * url baseURL
    * def requesterAuthResponse = call read('RequesterAuthenticator.feature')
    * def requesterAuthToken = requesterAuthResponse.response.data.AuthenticationResult.AccessToken
    * def accessToken = 'Bearer ' + requesterAuthToken
    * configure headers = {Authorization: '#(accessToken)'}
    * def getRequesterIDResponse = call read('GetRequesterID.feature')
    * def requesterUserID = getRequesterIDResponse.response.data.id
    * def dataBody = read('classpath:data/data_test.json')
    * def Collections = Java.type('java.util.Collections')

  @ignore @CheckBasicInfo
  Scenario: Precondition - Check vault name, get list users, by pass biometric & requesterPasscode
    #Check vault name is existed or not
    Given path '/core/vault/check-vault-name'
    * def now = function(){ return java.lang.System.currentTimeMillis() }
    * def vaultName = 'AT-RAK-' + now()
    * param name = vaultName
    When method GET
    Then status 200
    * def checkExist = response.data.exist
    * eval if (checkExist==true) karate.fail('Vault name is already exist')

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

    #By pass biometric method
    Given path '/core/biometric/request-challenge'
    * request {}
    When method POST
    Then status 201
    * def statusMsg = response.status
    * match statusMsg == 'success'

    #Verify requesterPasscode
    Given path '/auth/account/verify-passcode'
    * request {"passcode":'#(dataBody.common.requesterPasscode)'}
    When method POST
    Then status 201
    * def verifyStatus = response.data.verify
    * match verifyStatus == true

  @RAKCON-10217
  Scenario: Create a new vault with admin quorum setup
    * call read('Vault.feature@CheckBasicInfo')
    #Get variable challengeAnswerRequest
    * callonce read('GenerateAnswer.feature@FIDO-Requester')
    #Add a new vault with admin quorum setup
    Given path '/core/vault'
    * header challenge-answer = challengeAnswerRequest
    * header passcode = dataBody.common.requesterPasscode
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

  @RAKCON-10220
  Scenario: Create a new vault without admin quorum setup
    * call read('Vault.feature@CheckBasicInfo')
    #Get variable challengeAnswerRequest
    * call read('GenerateAnswer.feature@FIDO-Requester')
    #Add a new vault without admin quorum setup
    Given path '/core/vault'
    * header challenge-answer = challengeAnswerRequest
    * header passcode = dataBody.common.requesterPasscode
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

  @RAKCON-10218
  Scenario: View vault listing
    * callonce read('Vault.feature@RAKCON-10217')
    * callonce read('Vault.feature@RAKCON-10220')
    * def addedName = [#(vaultNameResponseWA), #(vaultNameResponseWOA)]
    # View vault listing
    Given path '/core/vault/accounts'
    * param limit = 9999999
    * param offset = 0
    * param sort = 'DESC'
    * param sortBy = 'TOTAL_USD'
    When method GET
    Then status 200
    * print addedName
    * def resp = response.data.vaults
    * print resp
    * def names = []
    * for(var i = 0; i < resp.length; i++) names.push(resp[i].name)
    * print 'List of vault names: ', names
    * match names contains addedName

  @ignore @GetRequestID
  Scenario: Get request ID of creating vault request
    * callonce read('Vault.feature@RAKCON-10217')
    Given path '/core/vault/accounts/'+vaultIDWA
    When method GET
    Then status 200
    * def requestCreateVaultID = response.data.requestId

  @RAKCON-10827
  Scenario: View vault detail
    # View detail of vault that has admin quorum after approval
    * callonce read('Vault.feature@GetRequestID')
    * def approvalAuthResponse = call read('ApprovalAuthenticator.feature')
    * def approvalAuthToken = approvalAuthResponse.response.data.AuthenticationResult.AccessToken
    * def approvalAccessToken = 'Bearer ' + approvalAuthToken
    * configure headers = {Authorization: '#(approvalAccessToken)'}
    # ---- Approve new vault policy request
    Given path '/core/quorums/approval/'+requestCreateVaultID
    * def challengeApprover = call read('GenerateAnswer.feature@FIDO-Approver')
    * header challenge-answer = challengeApprover.challengeAnswerRequest
    * header passcode = dataBody.common.approverPasscode
    When method POST
    Then status 201
    # ---- View detail of vault that has admin quorum after approval
    Given path '/core/vault/accounts/'+vaultIDWA
    When method GET
    Then status 200
    * def vaultUsersResponseWA = response.data.users
    * print vaultUsersResponseWA
    * def memberIdsWA = []
    * for(var i = 0; i < vaultUsersResponseWA.length; i++) memberIdsWA.push(vaultUsersResponseWA[i].userId)
    # ---- Check vault name, vault status, vault type, approver number should be same as created
    * match response.data.name == vaultNameResponseWA
    * match response.data.isPendingRequest == true
    * match response.data.approverNumber == dataBody.vault.approve_number
    * match response.data.type == vaultTypeResponseWA
    * match response.data.totalTransactionPending == 0
    # ---- After approval, missing policy should be false
    * match response.data.missing == false
    # ---- Check vault members should be same as created
    * callonce read('Vault.feature@ignore')
    * match memberIdsWA == vaultMemberList

    #View detail of vault that has not admin quorum after creating
    * callonce read('Vault.feature@RAKCON-10220')
    Given path '/core/vault/accounts/'+vaultIDWOA
    When method GET
    Then status 200
    * def vaultUsersResponseWOA = response.data.users
    * print vaultUsersResponseWOA
    * def memberIdsWOA = []
    * for(var j = 0; j < vaultUsersResponseWOA.length; j++) memberIdsWOA.push(vaultUsersResponseWOA[j].userId)
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

  @RAKCON-10954
  Scenario: Search vaults
    Given path '/core/vault/accounts'
    * param isHideSmallBalance = false
    * param keyword = dataBody.vault.searchVaultKeyword
    * param limit = 9999999
    * param offset = 0
    * param sort = 'DESC'
    * param sortBy = 'TOTAL_USD'
    When method GET
    Then status 200
    * match response.status == 'success'
    * def listSearchedVault = response.data.vaults
    * def listSearchedVaultName = []
    * for(var i = 0; i < listSearchedVault.length; i++) listSearchedVaultName.push(listSearchedVault[i].name)
    * print listSearchedVaultName
    * match each $listSearchedVaultName == "#regex (?i).*" + dataBody.vault.searchVaultKeyword + ".*"

  @RAKCON-10955
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
    * print listVaultNameActual
    * def listVaultNameExpected = []
    * eval for(var i = 0; i < listVaultNameActual.length; i++) listVaultNameExpected.push(listVaultNameActual[i])
    * eval Collections.sort(listVaultNameExpected, java.lang.String.CASE_INSENSITIVE_ORDER)
    * match listVaultNameActual == listVaultNameExpected

    @RAKCON-11118
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
      * print listVaultNameActual
      * def listVaultNameExpected = []
      * eval for(var i = 0; i < listVaultNameActual.length; i++) listVaultNameExpected.push(listVaultNameActual[i])
      * eval Collections.sort(listVaultNameExpected, Collections.reverseOrder())
      * match listVaultNameActual == listVaultNameExpected

      @RAKCON-11119
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
        * print listVaultTotalUSDActual
        * def listVaultTotalUSDExpected = []
        * eval for(var i = 0; i < listVaultTotalUSDActual.length; i++) listVaultTotalUSDExpected.push(listVaultTotalUSDActual[i])
        * print 'listVaultTotalUSDExpected', listVaultTotalUSDExpected
        * karate.sort(listVaultTotalUSDExpected)
        * match listVaultTotalUSDActual == listVaultTotalUSDExpected
        * def listVaultTotalUSDASC = listVaultTotalUSDExpected.reverse()

      @RAKCON-11120
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
        * print listVaultTotalUSDASCActual
        * callonce read('Vault.feature@RAKCON-11119')
        * match listVaultTotalUSDASCActual == listVaultTotalUSDASC