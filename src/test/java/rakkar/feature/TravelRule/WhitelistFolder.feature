    @TravelRule
Feature: Travel rule whitelist folder for SG entity

  Background:
    * callonce read(svc + 'Auth.feature@GetUserAccessToken') { userName: '#(sg_customer.admin1)' }
    * def accessToken = userAccessToken
    * callonce read(svc + 'ReadData.feature')
    * configure afterFeature = function(){ karate.call('@DeleteWhitelistFolders'); }

    @ignore @CreateWhitelistFolder
  Scenario: Create whitelist folder
    * call read(svc + 'Whitelist.feature@CreateWhitelistFolder')
    Then match responseStatus == 201
    * def folderId = response.data.folderId

    @TravelRule_CreateWhitelistFolder
  Scenario: Create whitelist folder
    * callonce read('@CreateWhitelistFolder')

    @TravelRule_ValidateEntity
  Scenario: Validate Entity
    * call read(svc + 'Whitelist.feature@GET_core_v2_tr_validatorEntity')
    * def expectedSchema = 
    """
    {
        "id" : "#string",
        "validatorId" : "#string",
        "entityId" : "SG"
    }
    """
    * assert response.data.total > 0
    * match each response.data.list[*] == expectedSchema

    @ignore @CheckAddressVASP
  Scenario: TravelRule VASP check-address
    * def data =
    """
    {
        "address": "0x720b43Cb2AD865EAe6c0ADc23898FBf91A0B0A02",
        "asset": "ETH"
    }
    """
    * call read(svc + 'Whitelist.feature@GET_core_v2_TravelRule_VASP_check-address') data

    @TravelRule_VASP_check_address
  Scenario: TravelRule VASP check-address
    * callonce read('@CheckAddressVASP')
    Then match responseStatus == 200
    * def expectedSchema = 
    """
    {
        "type": "HOSTED",
        "vasp": {
            "customerId": "#uuid",
            "isDeleted": "#boolean",
            "status": "#string",
            "createdBy": "#uuid",
            "updatedBy": "#uuid",
            "id": "#uuid",
            "did": "#regex did:ethr:.+",
            "name": "#string",
            "website": "#string",
            "logo": "#string",
            "incorporationCountry": "SG",
            "jurisdictions": "SG",
            "forceFields": "#[]",
            "createdAt": "#string",
            "updatedAt": "#string",
            "isRakkar": "#boolean"
        }
    }
    """
    * match response.data == expectedSchema

    @TravelRule_AddVASPWhitelistAddress
  Scenario: Create VASP whitelist folder address REGISTERED_VASP TRAVEL_RULE
    * def getVasp = callonce read('@CheckAddressVASP')
    * def getFolder = callonce read('@CreateWhitelistFolder')
    * def token = karate.call(svc + 'Wallet.feature@GetWalletTransferTokens', {keyword:'ETH'}).response.data.tokens.find(x => x.nativeAsset == 'ETH_TEST5')
    * def challengeAnswerRequest = karate.call(svc + 'Biometric.feature@UserDoBiometric').userAnswerApprover
    * def body_submit = 
    """
    {
        folderId:"#(getFolder.folderId)",
        tag : '',
        isRequiredTag: false,
        tokenId : "#(token.id)",
        note : 'Note test',
        address : '0x720b43Cb2AD865EAe6c0ADc23898FBf91A0B0A02',
        vaspId: "#(getVasp.response.data.vasp.id)",
        walletHost : '#(Const.WalletHostOptions.REGISTERED_VASP)',
        walletMethod : '#(Const.WalletMethodOptions.TRAVEL_RULE)'
    }
    """
    * call read(svc + 'Whitelist.feature@AddWhitelistAddress') body_submit
    Then match responseStatus == 201 
    * def expectedSchema = 
    """
    {
        "id" : "#uuid",
        "updatedAt" : "#string",
        "network" : "#string",
        "isSanctioned" : false,
        "name" : "Ethereum Testnet",
        "symbol" : "ETH",
        "folderId" : "#(body_submit.folderId)",
        "tag" : "#(body_submit.tag)",
        "address" : "#(body_submit.address)",
        "is_require_tag" : "#(body_submit.isRequiredTag)",
        "walletHost" : "#(body_submit.walletHost)",
        "vaspId" : "#(body_submit.vaspId)",
        "verificationStatus" : "VERIFIED",
        "assetExternalId" : "ETH_TEST5",
        "image" : "#string",
        "createdAt" : "#string",
        "status" : 0,
        "method" : "#(body_submit.walletMethod)"
    }
    """
    Then match response.data == expectedSchema

    @ignore @DeleteWhitelistFolders
  Scenario: Delete test whitelist folder
    * call read(svc + 'Whitelist.feature@GetWhitelistFolders') { keyword: 'Folder - ' }
    * eval 
    """
    if (response.data.folders.length > 0) {
        var folderIds = response.data.folders.map(x => x.id)
        var challengeAnswerRequest = karate.call(svc + 'Biometric.feature@UserDoBiometric').userAnswerApprover
        karate.call(svc + 'Whitelist.feature@DeleteWhitelistFolders', {folderIds: folderIds, challengeAnswerRequest: challengeAnswerRequest})
    }
    """
