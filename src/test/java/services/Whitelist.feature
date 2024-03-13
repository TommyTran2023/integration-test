Feature: Whitelist
Background:
    * def svc = 'classpath:services/'

    @CreateWhitelistFolder
    Scenario: Create White list
        * def data = 
        """
            {
                authorization: #(requesterAccessToken),
                name: '#(name)',
                type: '#(type)',
                "businessName" : '#(businessName)',
                "countryCode" : '#(countryCode)',
                "purposeTransfer" : '#(purposeTransfer)',
                "businessAddress" : '#(businessAddress)',
                "relationship" : '#(relationship)',
                "sourceFunds" : '#(sourceFunds)'
            }
        """
        * call read(svc + 'coreSvc.feature@CreateWhitelistFolder') data
    
    @AddWhitelistAddress
    Scenario: Add whitelist address
        * def data = 
        """
            {
                folderId:'#(folderId)',
                authorization: #(requesterAccessToken),
                challengeAnswer: '#(challengeAnswerRequest)',
                body:{
                    "tag" : '',
                    "isRequiredTag": true,
                    "tokenId" : '#(tokenId)', 
                    "note": '#(note)', 
                    "address": '#(address)',
                    "walletHost" : '#(walletHost)',
                    "walletMethod" : '#(walletMethod)'
                }
            }
        """
        * call read(svc + 'coreSvc.feature@AddWhitelistAddress') data

    @GetWhitelistFolders
    Scenario: Get Whitelist
        * def keyword = karate.get('keyword','')
        * def sort = karate.get('sort','ASC')
        * def sortBy = karate.get('sortBy','NAME')
        * def data = 
        """
            {
                authorization: #(requesterAccessToken),
                params: {
                    keyword: '#(keyword)',
                    limit: 10,
                    offset: 0,
                    sort: '#(sort)',
                    sortBy: '#(sortBy)'
                }
            }
        """
        * call read(svc + 'coreSvc.feature@GetWhitelistFolders') data

    
    @GetWhitelistFolders_TransferDestination
    Scenario: Get Whitelist
        * callonce read(svc + 'ReadData.feature@ReadEnumFile')
        * def keyword = karate.get('keyword','')
        * def tokenSymbol = karate.get('tokenSymbol',Const.TokenSymbol.XRP)
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
            {
                authorization: #(accessToken),
                params: {
                    keyword: '#(keyword)',
                    limit: 10,
                    offset: 0,
                    tokenSymbol: #(tokenSymbol)
                }
            }
        """
        * call read(svc + 'coreSvc.feature@GetWhitelistFolders') data
        
    @DeleteWhitelistFolders
    Scenario: Delete Whitelist Folders
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
            {
                authorization: #(accessToken),
                folderIds: #(folderIds)
            }
        """
        * call read(svc + 'coreSvc.feature@DeleteWhitelistFolders') data
    
    @DeleteWhitelistFolderById
    Scenario: Delete Whitelist Folders
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
            {
                authorization: #(accessToken),
                folderId: #(folderId)
            }
        """
        * call read(svc + 'coreSvc.feature@DeleteWhitelistFolderById') data
        
    @DeleteWhitelistAddress
    Scenario: Delete Whitelist Address
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
            {
                authorization: #(accessToken),
                folderId: #(folderId),
                addressIds: #(addressIds)
            }
        """
        * call read(svc + 'coreSvc.feature@DeleteWhitelistAddress') data
        
    @GetWhitelistTokens
    Scenario: Get whitelist Tokens
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
            {
                authorization: #(accessToken),
                folderId: #(folderId),
                body:{
                    keyword: '#(keyword)',
                    limit: 10,
                    offset: 0,
                    tokenSymbol: #(tokenSymbol),
                    isGetAll: true
                }
            }
        """
        * call read(svc + 'coreSvc.feature@GetWhitelistTokens') data
        
    @GetFolderAddressDetail
    Scenario: Get Folder Address Detail
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
            {
                authorization: #(accessToken),
                folderAddressId: #(folderAddressId),
            }
        """
        * call read(svc + 'coreSvc.feature@GetFolderAddressDetail') data
        
    @GetListAddress
    Scenario: Get list address
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
            {
                authorization: #(accessToken),
                body:{
                    keyword: '#(keyword)',
                    limit: 10,
                    offset: 0,
                    sort: 'ASC',
                    sortBy: '#(sortBy)',
                    folderId: '#(folderId)'
                }
            }
        """
        * call read(svc + 'coreSvc.feature@GetListAddress') data
        
    @ValidateAddress
    Scenario: Validate Address
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
            {
                authorization: #(accessToken),
                body:{
                    address: '#(address)',
                    nativeAsset: '#(nativeAsset)',
                    tag: '#(tag)'
                }
            }
        """
        * call read(svc + 'coreSvc.feature@ValidateAddress') data
        
    @GetFormInput
    Scenario: Get Form Input
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * call read(svc + 'coreSvc.feature@GetFormInput') {authorization: #(accessToken)}
        
    @CheckFolderName
    Scenario: Check Folder Name
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
            {
                authorization: #(accessToken),
                name:#(name)
            }
        """
        * call read(svc + 'coreSvc.feature@CheckFolderName') data
    
    @CheckAddressDeactivate
    Scenario: Check Address Deactivate
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
            {
                authorization: #(accessToken),
                address:#(address)
            }
        """
        * call read(svc + 'coreSvc.feature@CheckAddressDeactivate') data
    