@RAKCON-10586 @AT
Feature: WhiteList Folder

  Background:
    #@PRECOND_RAKCON-10582
    * url baseURL
    * call read('RequesterAuthenticator.feature@RequesterAccessToken')
    * def user = call read('UserManagement.feature@GetAccountMe')
    * def userId = user.response.data.id
    * def dataBody = read('classpath:data/data_test.json')

  #TCs: CREATE NEW FOLDER
  @RAKCON-10226 @Create_folder
  Scenario: Check create a new folder
    * def now = function(){ return java.lang.System.currentTimeMillis() }
    * def folderName = 'Folder-' + now()
    * def body = {"name" : '#(folderName)',"type": '#(dataBody.whitelist.type_internal)' }
    Given path 'core/folders'
    And request body
    When method POST
    Then status 201
    And match response.status == "success"
    And match response.data.name == "#(folderName)"
    And match response.data.type == "#(dataBody.whitelist.type_internal)"
    * def folderId = response.data.id
    * def folderName = response.data.name

  #TCs: FOLDER LISTING
  @RAKCON-10587 @List_folder
  Scenario: Check view folder listing
     * def query = { limit:'10', offset: '0', sort:'ASC', sortBy: 'NAME'}
     Given path 'core/folders'
     And params query
     When method GET
     Then status 200
     And match response.status == "success"
    * def schema = dataBody.whitelist.schema_list
     And match response.data.folders contains schema


  #TCs: SEARCH FOLDER
  @RAKCON-11163 @Search_folder
  Scenario: Check search folder
    * def newFolder = callonce read('WhiteListFolder.feature@Create_folder')
    * def folderName = newFolder.response.data.name
    * def type = newFolder.response.data.type
    * def query = { limit:'10', offset: '0', sort:'ASC', sortBy: 'NAME',keyword: '#(folderName)'}
    Given path 'core/folders'
    And params query
    When method GET
    Then status 200
    And match response.status == "success"
    And match response.data.folders[0].name == "#(folderName)"
    And match response.data.folders[0].type == "#(type)"
    And match response.data.totalCount == 1


    #Pre-1.Get list vault
  @ignore @Get_listVault
  Scenario: Precondition 1: Get list vault
    * def query = { limit:'10', offset: '0', sort:'DESC', sortBy: 'TOTAL_USD', isHideSmallBalance : 'false'}
    Given path 'core/vault/accounts'
    And params query
    When method GET
    Then status 200
    #Pre-2.Select a vault to get list token
  @ignore @Get_listToken
  Scenario: Precondition 2: Get list token
    * def getVault = call read('WhiteListFolder.feature@Get_listVault')
    * def vaultId = getVault.response.data.vaults[0].id
    Given path 'core/vault/account/'+ vaultId + '/wallets'
    * def query = { limit:'10', offset: '0', sort:'DESC', sortBy: 'TOTAL_USD', isHideSmallBalance : 'false'}
    And params query
    When method GET
    Then status 200
    #Pre-3.Select detail token
  @ignore @Get_detailToken
  Scenario: Precondition 3: Get detail token
    * def getVault = call read('WhiteListFolder.feature@Get_listVault')
    * def vaultId = getVault.response.data.vaults[0].id
    * def getWallet = call read('WhiteListFolder.feature@Get_listToken')
    * def walletId = getWallet.response.data.wallets[0].id
    Given path 'core/wallet/token-details'
    * def query = { vaultId:'#(vaultId)', walletId: '#(walletId)'}
    And params query
    When method GET
    Then status 200
    * def tokenId = response.data.id

    #Pre-4.View deposit and get the address
  @ignore @Get_address
  Scenario: Precondition 4: View deposit and get address
    * def getVault = call read('WhiteListFolder.feature@Get_listVault')
    * def vaultId = getVault.response.data.vaults[0].id
    * def getWallet = call read('WhiteListFolder.feature@Get_listToken')
    * def walletId = getWallet.response.data.wallets[0].id
    Given path 'core/wallet/get-address-wallet'
    * def query = { limit:'10', offset: '0', vaultId:'#(vaultId)', walletId: '#(walletId)'}
    And params query
    When method GET
    Then status 200
    * def address = response.data.address[0].address
    * def nativeAsset = response.data.address[0].nativeAsset

    #Pre-5.Validate to add new address
  @ignore @Validate_add_address
  Scenario:Precondition 5:Validate to add new address
    * def getAddress = call read('WhiteListFolder.feature@Get_address')
    * def address = getAddress.response.data.address[0].address
    * def nativeAsset = getAddress.response.data.address[0].nativeAsset
    * def body_validate = {"address" : '#(address)',"nativeAsset": '#(nativeAsset)' }
    Given path 'core/folders/addresses/validate'
    And request body_validate
    When method POST
    Then status 201
    And match response.data.isValid  == true
    And match response.data.isValidMemo == true
    And match response.data.isValidAddress == true

  #Tcs: CREATE WHITELIST ADDRESS
  @RAKCON-10969 @Create_address
  Scenario:Create new whitelisted address
    * call read('WhiteListFolder.feature@Create_folder')
    * call read('WhiteListFolder.feature@Get_detailToken')
    * call read('WhiteListFolder.feature@Get_address')
    * call read('WhiteListFolder.feature@Validate_add_address')
    #Submit add new address
    * call read('Common.feature@FIDO-Requester')
    * def body_submit = {"tag" : '',"isRequiredTag": true,"tokenId" : '#(tokenId)', "note": 'Note test', "address": '#(address)'}
    Given path 'core/folders/'+ folderId +'/tokens'
    * header challenge-answer = challengeAnswerRequest
    And request body_submit
    When method POST
    Then status 201
    And match response.status == "success"
    And match response.data.address == "#(address)"
    And match response.data.folderId == "#(folderId)"
    # Approve add new address - refer to ApprovalRequest.feature
    * def addressId = response.data.id
    * def folderId = response.data.folderId
    * def address = response.data.address
    * def name = response.data.name
    * def symbol = response.data.symbol
    * def tokenId = response.data.id

    #TCs: VIEW DETAIL FOLDER
  @RAKCON-11164 @View_Detail_Folder
  Scenario: Check view detail a folder
    * callonce read('WhiteListFolder.feature@Create_address')
    Given path 'core/folders/list-address'
    * def query = { limit:'10', offset: '0', sort:'ASC', sortBy: 'SYMBOL',folderId: '#(folderId)'}
    And params query
    When method GET
    Then status 200
    And match response.status == "success"
    And match response.data.listAddress[0].address == "#(address)"
    And match response.data.listAddress[0].id == "#(tokenId)"

   #TCs: VIEW ADDRESS DETAIL
  @RAKCON-10970 @View_Address_Detail
   Scenario: View Whitelist address details
    * callonce read('WhiteListFolder.feature@Create_address')
    Given path 'core/folders/addresses/' + addressId
    When method GET
    Then status 200
    And match response.status == "success"
    And match response.data.address == "#(address)"
    And match response.data.name == "#(name)"
    And match response.data.symbol == "#(symbol)"


   #TCs: VIEW REQUEST ADD NEW ADDRESS
  @RAKCON-11302 @View_My_Request_Whitelist
  Scenario: View my request for type whitelist
    * callonce read('WhiteListFolder.feature@Create_address')
    Given path 'core/quorums'
    * def body = { offset : '0',limit : '10',keyword : '',requestCategories:["WHITELIST"],createdBy: '#(userId)',status : ["PENDING"],isHistory : true }
    And request body
    When method POST
    Then status 201
    And match response.data.records[0].type.value == 'ADD_WHITELIST_ADDRESS'
    And match response.data.records[0].type.nameDisplay == 'Add Whitelisted Address'

    #TCs: DELETE WHITELIST ADDRESS
  @RAKCON-10971 @Delete_Whitelist_Address
  Scenario: Check delete whitelist address
    #create address
    * callonce read('WhiteListFolder.feature@Create_address')
    * call read('Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    #delete address
    Given path 'core/folders/'+ folderId + '/address'
    * def body = { addressIds : ['#(addressId)']}
    And request body
    When method DELETE
    Then status 200
    And match response.status == "success"

    #TCs: DELETE FOLDER
  @RAKCON-10227 @Delete_folder
  Scenario: Check delete a folder
    #Create new folder
     * call read('WhiteListFolder.feature@Create_folder')
    #delete folder
    * call read('Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    Given path 'core/folders/'+ folderId
    When method DELETE
    Then status 200
    And match response.status == "success"




