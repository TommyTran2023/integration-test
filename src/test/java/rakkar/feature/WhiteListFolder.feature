@RAKCON-10583
Feature: WhiteList Folder

  Background:
    #@PRECOND_RAKCON-10582
    * url baseURL
    * call read('this:RequesterAuthenticator.feature@RequesterAccessToken')
    * call read('this:GetUserInfo.feature@GetUserInfo')
#    * def userId = user.response.data.id
    * def testData = read('classpath:data/data_test.json')
    * def schemaJson = read('classpath:data/schema.json')
    * def Const = read('classpath:data/enum.json')

  #TCs: CREATE NEW FOLDER - INTERNAL
  @RAKCON-10226 @Create_folder_internal
  Scenario: Check create a new folder - internal
    * def customerId = response.data.customerId
    * call read(svc + 'Customers.feature@Customer_GetCustomerDetail') {customerId:'#(customerId)'}
    * print response 
    * def oragnization = response.data.customerName
    * def countryCode = response.data.registrationAddress.country
    * def organization_addr = response.data.registrationAddress.address
    * def transferOption = Const.TransactionOptions.COMPANY_EXPENSE
    * def relationOptions = "Self"
    * def sourceFundsOptions = Const.SourceOfFund.BUSINESS_OPERATIONS
    * def now = function(){ return java.lang.System.currentTimeMillis() }
    * def folderName = 'Folder-' + now()
    * def data = 
    """
    {
        "businessName" : '#(oragnization)',
        "countryCode" : '#(countryCode)',
        "purposeTransfer" : '#(transferOption)',
        "businessAddress" : '#(organization_addr)',
        "relationship" : '#(relationOptions)',
        "sourceFunds" : '#(sourceFundsOptions)',
        "name" : '#(folderName)',
        "type": '#(testData.whitelist.type_internal)' 
    }
    """
    * call read(svc + 'Whitelist.feature@CreateWhitelistFolder') data
    Then match responseStatus == 201
    And match response.data.businessName == "#(oragnization)"
    And match response.data.countryCode == "#(countryCode)"
    And match response.data.purposeTransfer == "#(transferOption)"
    And match response.data.businessAddress == "#(organization_addr)"
    And match response.data.relationship == "#(relationOptions)"
    And match response.data.sourceFunds == "#(sourceFundsOptions)"
    And match response.status == "success"
    And match response.data.name == "#(folderName)"
    And match response.data.type == "#(testData.whitelist.type_internal)"
    * def folderId = response.data.id
    * def folderName = response.data.name
    * def type = response.data.type

      #TCs: CREATE NEW FOLDER - EXTERNAL
  @RAKCON-11756 @Create_folder_external
    Scenario: Check create new folder - external
      * def now = function(){ return java.lang.System.currentTimeMillis() }
      * def folderName = 'External_Folder-' + now()
      * def buinessAddress = now() + ' - Building, ' + now() +  ' street'
      * def businessName = 'Company' + now()
      * def sourceFunds = Const.SourceOfFund.BUSINESS_OPERATIONS
      * def relationship = "Service Provider"
      * def countryCode = "Hong Kong S.A.R."
      * def purposeTransfer = Const.TransactionOptions.COMPANY_EXPENSE
      * def data = 
      """
      {
        "businessAddress" : '#(buinessAddress)',
        "businessName" : '#(businessName)',
        "sourceFunds" : '#(sourceFunds)',
        "relationship" : '#(relationship)',
        "countryCode" : '#(countryCode)',
        "purposeTransfer" : '#(purposeTransfer)',
        "name" : '#(folderName)',
        "type": '#(testData.whitelist.type_external)'
        
      }
      """
      * call read(svc + 'Whitelist.feature@CreateWhitelistFolder') data
      Then match responseStatus == 201
      And match response.status == "success"
      And match response.data.name == "#(folderName)"
      And match response.data.type == "#(testData.whitelist.type_external)"
      And match response.data.businessAddress == "#(buinessAddress)"
      And match response.data.businessName == "#(businessName)"
      And match response.data.sourceFunds == "#(sourceFunds)"
      And match response.data.relationship == '#(relationship)'
      And match response.data.countryCode == '#(countryCode)'
      And match response.data.purposeTransfer == '#(purposeTransfer)'
      * def folderId = response.data.id
      * def folderName = response.data.name
      * def type = response.data.type

  #TCs: FOLDER LISTING
  @RAKCON-10587 @List_folder
  Scenario: Check view folder listing
    * call read(svc + 'Whitelist.feature@GetWhitelistFolders')
    Then match responseStatus == 200
    And match response.status == "success"
    * def schema = schemaJson.whitelist.schema_list
    * def tokenSchema = 
    """
    {
      "name": "#string",
      "symbol": "#string",
      "address": "#string",
      "network": "#string",
      "isSanctioned": "#boolean",
      "externalAssetId": "#string"
    }
    """
    And match response.data.folders contains schema

  #TCs: SEARCH FOLDER
  @RAKCON-11163 @Search_folder_by_keyword
  Scenario: Check search folder by keyword
    * call read('this:WhiteListFolder.feature@Create_folder_internal')
    * call read('this:WhiteListFolder.feature@Search_folder_by_keyword_common')
    And match response.data.folders[0].name == "#(folderName)"
    And match response.data.folders[0].type == "#(type)"

     #TCs: SEARCH FOLDER COMON
  @ignore @Search_folder_by_keyword_common
  Scenario: Check search folder by keyword common
    * def query = { limit:'10', offset: '0', sort:'ASC', sortBy: 'NAME',keyword: '#(folderName)'}
    Given path 'core/folders'
    And params query
    When method GET
    Then status 200
    And match response.status == "success"

  @RAKCON-11766 @Search_folder_by_type
  Scenario: Check search folder by type
    * call read('this:WhiteListFolder.feature@Create_folder_external')
    * def query = { limit:'10', offset: '0', sort:'ASC', sortBy: 'NAME',type: '#(testData.whitelist.type_external)'}
    Given path 'core/folders'
    And params query
    When method GET
    Then status 200
    And match response.status == "success"
    And match response.data.folders[0].type == "#(testData.whitelist.type_external)"
    * def externalId = ""
    * def externalName = ""
    And for(var i = 0; i < response.data.folders.length; i++) if (response.data.folders[i].tokens.length > 0) { externalId = response.data.folders[i].id ; externalName = response.data.folders[i].name }
    * def externalId = externalId
    * def externalName = externalName

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
    * def getVault = call read('this:WhiteListFolder.feature@Get_listVault')
    * def vaultId = getVault.response.data.vaults[0].id
    Given path 'core/vault/account/'+ vaultId + '/wallets'
    * def query = { limit:'10', offset: '0', sort:'DESC', sortBy: 'TOTAL_USD', isHideSmallBalance : 'false'}
    And params query
    When method GET
    Then status 200
    #Pre-3.Select detail token
  @ignore @Get_detailToken
  Scenario: Precondition 3: Get detail token
    * def getVault = call read('this:WhiteListFolder.feature@Get_listVault')
    * def vaultId = getVault.response.data.vaults[0].id
    * def getWallet = call read('this:WhiteListFolder.feature@Get_listToken')
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
    * def getVault = call read('this:WhiteListFolder.feature@Get_listVault')
    * def vaultId = getVault.response.data.vaults[0].id
    * def getWallet = call read('this:WhiteListFolder.feature@Get_listToken')
    * def walletId = getWallet.response.data.wallets[0].id
    Given path 'core/wallet/get-address-wallet'
    * def query = { limit:'10', offset: '0', vaultId:'#(vaultId)', walletId: '#(walletId)'}
    And params query
    When method GET
    Then status 200
    * def address = response.data.address[0].address
    * def nativeAsset = response.data.address[0].nativeAsset

    #Pre-5.Validate to add new address
  @RAKCON-13207 @Validate_add_address
  Scenario:Validate to add new address
    * def body_validate = {"address" : '#(dataSet.whitelistAddress)',"nativeAsset": '#(Const.TokenSymbol.BTC)' }
    Given path 'core/folders/addresses/validate'
    And request body_validate
    When method POST
    Then status 201
    And match response.data.isValid  == true
    And match response.data.isValidMemo == true
    And match response.data.isValidAddress == true

  #Tcs: CREATE WHITELIST ADDRESS
  @ignore @Create_address_common
Scenario:Create whitelisted address common - Internal
  * def hostOptions = Const.WalletHostOptions.SELF_HOSTED
  * def methodOptions = Const.WalletMethodOptions.SELF_ATTESTATION
  * def body_submit = 
  """
  {
    "tag" : '',
    "isRequiredTag": true,
    "tokenId" : '#(dataSet.whitelistTokenId)',
    "note" : 'Note test',
    "address" : '#(dataSet.whitelistAddress)',
    "walletHost" : '#(hostOptions)',
    "walletMethod" : '#(methodOptions)'
  }
  """
  * call read(svc + 'Whitelist.feature@ViewDetailFolder') { folderId: '#(folderId)'}
  * call read(svc + 'Biometric.feature@RequesterDoBiometric')
  * call read(svc + 'Whitelist.feature@AddWhitelistAddress') body_submit
  Then match responseStatus == 201
  And match response.status == "success"
  And match response.data.address == "#(dataSet.whitelistAddress)"
  And match response.data.folderId == "#(folderId)"
  * def addressId = response.data.id
  * def folderId = response.data.folderId
  * def address = response.data.address
  * def name = response.data.name
  * def symbol = response.data.symbol
  * def tokenID = response.data.id


  @RAKCON-10969 @Create_address_internal
  Scenario:Create internal whitelisted address
    * call read('this:WhiteListFolder.feature@Create_folder_internal')
    * call read('this:WhiteListFolder.feature@Create_address_common')
    * call read('this:WhiteListFolder.feature@View_My_Request_Whitelist')

  @RAKCON-11768 @Create_address_external
  Scenario:Create external whitelisted address
    * call read('this:WhiteListFolder.feature@Create_folder_external')
    * call read('this:WhiteListFolder.feature@Create_address_common')
    * call read('this:WhiteListFolder.feature@View_My_Request_Whitelist')

    #TCs: VIEW DETAIL FOLDER
  @RAKCON-11164 @View_Detail_Folder
  Scenario: Check view detail a folder
    * callonce read('this:WhiteListFolder.feature@Create_address_internal')
    * call read('this:WhiteListFolder.feature@ViewDetailFolder') { folderId: '#(folderId)'}
    Then match responseStatus == 200
    And match response.status == "success"
    And match response.data.listAddress[0].address == "#(address)"
    And match response.data.listAddress[0].id == "#(tokenID)"

   #TCs: VIEW ADDRESS DETAIL
  @RAKCON-10970 @View_Address_Detail
   Scenario: View Whitelist address details
    * callonce read('this:WhiteListFolder.feature@Create_address_internal')
    Given path 'core/folders/addresses/' + addressId
    When method GET
    Then status 200
    And match response.status == "success"
    And match response.data.address == "#(address)"
    And match response.data.name == "#(name)"
    And match response.data.symbol == "#(symbol)"

   #TCs: VIEW REQUEST ADD NEW ADDRESS
  @ignore @View_My_Request_Whitelist
  Scenario: View my request for type whitelist
    * def body =
    """
    { 
      "offset" : '0',
      "limit" : '10',
      "keyword" : '',
      "requestCategories":["WHITELIST"],
      "createdBy": '#(userId)',
      "status" : ["PENDING"],
      "isHistory" : true 
    }
    """
    * call read(svc + 'Quorums.feature@GetMyRequests') body
    Then match responseStatus == 201
    And match response.data.records[0].type.value == "#(testData.whitelist.request_value)"
    And match response.data.records[0].type.nameDisplay == "#(testData.whitelist.request_nameDisplay)"
    * def requestId = response.data.records[0].id

    #TCs: DELETE WHITELIST ADDRESS
  @RAKCON-10971 @Delete_Whitelist_Address
  Scenario: Check delete whitelist address
    #create address
    * callonce read('this:WhiteListFolder.feature@Create_address_internal')
    * call read('this:Common.feature@FIDO-Requester')
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
     * call read('this:WhiteListFolder.feature@Create_folder_internal')
    #delete folder
    * call read('this:Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    Given path 'core/folders/'+ folderId
    When method DELETE
    Then status 200
    And match response.status == "success"

  @RAKCON-20319 @SearchWhitelistFromOtherCustomer
  Scenario: User unable to search whitelist folder belongs to other customer
    * call read('this:WhiteListFolder.feature@Search_folder_by_keyword_common') {keyword: '#(crossTenant.whitelistExternalName)'}
    Then match response.data.folders == []
    * call read('this:WhiteListFolder.feature@Search_folder_by_keyword_common') {keyword: '#(crossTenant.whitelistInternalName)'}
    Then match response.data.folders == []

  @ignore @RAKCON-20320 @GetDetailsWhitelistFromOtherCustomer
  Scenario: User unable to get details of whitelist folder belongs to other customer
    * call read('this:WhiteListFolder.feature@ViewDetailFolder') { folderId: '#(crossTenant.whitelistExternalId)'}
    Then match responseStatus == 403
    * call read('this:WhiteListFolder.feature@ViewDetailFolder') { folderId: '#(crossTenant.whitelistInternalId)'}
    Then match responseStatus == 403
    
  @ignore @ViewDetailFolder
  Scenario: Check view detail a folder
    Given path 'core/folders/list-address'
    And params { limit:'10', offset: '0', sort:'ASC', sortBy: 'SYMBOL',folderId: '#(folderId)'}
    When method GET


