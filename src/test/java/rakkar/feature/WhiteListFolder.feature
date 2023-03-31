@RAKCON-10586 @AT
Feature: WhiteList Folder

  Background:
    * url baseURL
    * def requesterAuthResponse = call read('RequesterAuthenticator.feature')
    * def requesterAuthToken = requesterAuthResponse.response.data.AuthenticationResult.AccessToken
    * def accessToken = 'Bearer ' + requesterAuthToken
    * configure headers = { Authorization: '#(accessToken)'}
    * def dataBody = read('classpath:data/data_test.json')

  #Create new folder
  @RAKCON-10226 @Create_folder
  Scenario: Check create a new folder
    * def now = function(){ return java.lang.System.currentTimeMillis() }
    * def folderName = 'Folder-' + now()
    * def body = {"name" : '#(folderName)',"type": '#(dataBody.whitelist.type_internal)' }
    Given path 'core/folders'
    And request body
    When method POST
    Then status 201
    And print response
    And match response.data.name == "#(folderName)"
    And match response.data.type == "#(dataBody.whitelist.type_internal)"

  #Folder Listing
  @RAKCON-10587 @List_folder
  Scenario: Check view folder listing
     * def query = { limit:'10', offset: '0', sort:'ASC', sortBy: 'NAME'}
     Given path 'core/folders'
     And params query
     When method GET
     Then status 200

  #Search folder
  @RAKCON-11163
  Scenario: Check search folder
    * def newFolder = call read('WhiteListFolder.feature@Create_folder')
    * def folderName = newFolder.response.data.name
    * def type = newFolder.response.data.type
    * def query = { limit:'10', offset: '0', sort:'ASC', sortBy: 'NAME',keyword: '#(folderName)'}
    Given path 'core/folders'
    And params query
    When method GET
    Then status 200
    And match response.data.folders[0].name == "#(folderName)"
    And match response.data.folders[0].type == "#(type)"
    And match response.data.totalCount == 1


    #1.Get list vault
  @ignore @Get_listVault
  Scenario: Precondition 1: Get list vault
    * def query = { limit:'10', offset: '0', sort:'DESC', sortBy: 'TOTAL_USD', isHideSmallBalance : 'false'}
    Given path 'core/vault/accounts'
    And params query
    When method GET
    Then status 200
    #2.Select a vault to get list token
  @ignore @Get_listToken
  Scenario: Precondition 2: Get list token
    * def getVault = call read('WhiteListFolder.feature@Get_listVault')
    * def vaultId = getVault.response.data.vaults[0].id
    Given path 'core/vault/account/'+ vaultId + '/wallets'
    * def query = { limit:'10', offset: '0', sort:'DESC', sortBy: 'TOTAL_USD', isHideSmallBalance : 'false'}
    And params query
    When method GET
    Then status 200
    #3.Select detail token
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
    #4.View deposit and get the address
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
    #5.Validate to add new address
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
  # Create whitelist address
  @RAKCON-10969 @Create_address
  Scenario:Create new whitelisted address
    * def newFolder = call read('WhiteListFolder.feature@Create_folder')
    * def folderId = newFolder.response.data.id
    * def tokenDetail = call read('WhiteListFolder.feature@Get_detailToken')
    * def tokenId = tokenDetail.response.data.id
    * def getAddress = call read('WhiteListFolder.feature@Get_address')
    * def address = getAddress.response.data.address[0].address
    * def nativeAsset = getAddress.response.data.address[0].nativeAsset
    * call read('WhiteListFolder.feature@Validate_add_address')
    #Submit add new address
    * callonce read('GenerateAnswer.feature@FIDO-Requester')
    * def body_submit = {"tag" : '',"isRequiredTag": true,"tokenId" : '#(tokenId)', "note": 'Note test', "address": '#(address)'}
    Given path 'core/folders/'+ folderId +'/tokens'
    * header challenge-answer = challengeAnswerRequest
    And request body_submit
    When method POST
    Then status 201
    And match response.data.address == "#(address)"
    And match response.data.folderId == "#(folderId)"
    #View detail a folder
  @RAKCON-11164
  Scenario: Check view detail a folder
    * def create_address = call read('WhiteListFolder.feature@Create_address')
    * def tokenId = create_address.response.data.id
    * def folderId = create_address.response.data.folderId
    * def address = create_address.response.data.address
    Given path 'core/folders/list-address'
    * def query = { limit:'10', offset: '0', sort:'ASC', sortBy: 'SYMBOL',folderId: '#(folderId)'}
    And params query
    When method GET
    Then status 200
    And match response.data.listAddress[0].address == "#(address)"
    And match response.data.listAddress[0].id == "#(tokenId)"
    # Delete folder
  @RAKCON-10227
  Scenario: Check delete a folder
    #Get list folder
    * def listFolder = call read('WhiteListFolder.feature@List_folder')
    * def folderId = listFolder.response.data.folders[0].id
    * def folderName = listFolder.response.data.folders[0].name
    #Select a folder then delete
    Given path 'core/folders/'+ folderId
    When method DELETE
    Then status 200
    #Verify delete success
    * def query = { limit:'10', offset: '0', sort:'ASC', sortBy: 'NAME',keyword: '#(folderName)'}
    Given path 'core/folders'
    And params query
    When method GET
    Then status 200
    And match response.data.totalCount == 0




