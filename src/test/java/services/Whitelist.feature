Feature: Whitelist
Background:
    * def svc = 'classpath:services/'

    @CreateWhitelist
    Scenario: Create White list
        * def data = 
        """
            {
                authorization: #(requesterAccessToken),
                name: '#(name)',
                type: '#(type)'
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
                    "address": '#(address)'
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
