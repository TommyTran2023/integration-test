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
        * call read(svc + 'coreSvc.feature@CreateWhitelistFolder') {data: '#(data)'}
    
    @AddWhitelistAddress
    Scenario: Add whitelist address
        * def data = 
        """
            {
                authorization: #(requesterAccessToken),
                body:{
                    "tag" : '',
                    "isRequiredTag": true,
                    "tokenId" : '#(tokenId)', 
                    "note": '#(note)', 
                    "address": '#(address)'
                }
            }
        """
        * call read(svc + 'coreSvc.feature@AddWhitelistAddress') {folderId:'#(folderId)', data: '#(data)'}

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
        * call read(svc + 'coreSvc.feature@GetWhitelistFolders') {data: '#(data)'}
