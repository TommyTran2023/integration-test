Feature: Network

    @GetNetworkList
    Scenario: Get Network List
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def keyword = karate.get('keyword', '')
        * def data =
        """
            {
                authorization: #(accessToken),
                params:{
                    keyword: '#(keyword)',
                    limit: 10,
                    offset: 0
                }
            }
        """
        * call read(svc + 'networkSvc.feature@GetNetworkList') data
        Then match responseStatus == 200
        * match response.status == 'success'
        * karate.set('keyword', null)

    @GetNetworkConnection
    Scenario: Get Network Connection
        * def connectionName = karate.get('connectionName', '')
        * def data =
        """
            {
                authorization: #(requesterAccessToken),
                networkId: '#(networkId)',
                params:{
                    keyword: '#(connectionName)',
                    limit: 10,
                    offset: 0
                }
            }
        """
        * call read(svc + 'networkSvc.feature@GetNetworkConnection') data
        Then match responseStatus == 200
        * match response.status == 'success'

    @GetDiscoverableNetwork
    Scenario: Get Discoverable Network
        * def keyword = karate.get('keyword', '')
        * def data = 
        """
            {
                authorization: #(requesterAccessToken),
                params:{
                    keyword: '#(keyword)',
                    currentProfileId: '#(profileId)',
                    limit: 10,
                    offset: 0
                }
            }
        """
        * call read(svc + 'networkSvc.feature@GetDiscoverableNetwork') data
        Then match responseStatus == 200
        * match response.status == 'success'

    
    @CreateNetworkProfile
    Scenario: Create Network Profile
        * def isDiscoverable = karate.get('isDiscoverable', false)
        * def data = 
        """
        {
            challengeAnswer: #(challengeAnswerRequest),
            authorization: #(requesterAccessToken),
            body:{
                "isDiscoverable" : #(isDiscoverable),
                "networkName": '#(profileName)', 
                "vaultId": '#(vaultId)'
            }
        }
        """
        * call read(svc + 'networkSvc.feature@CreateNetworkProfile') data
        Then match responseStatus == 201
        * match response.status == "success"

    @AddNetworkConnection
    Scenario: Add Network Connection
        * def note = karate.get('note', '')
        * def hasDefaultRouting = karate.get('hasDefaultRouting', true) 
        * def data =
        """
        {
            challengeAnswer: #(challengeAnswerRequest),
            authorization: #(requesterAccessToken),
            passcode: '#(requesterInfo.requesterPasscode)',
            profileId: '#(profileId)',
            body:{
                "internalNote": '#(note)', 
                "counterpartyId": '#(counterId)',  
                "counterpartyName" : '#(counterName)',
                "hasDefaultRouting": #(hasDefaultRouting),
                "vaultId": '#(vaultId)', 
                "vaultName" : '#(vaultName)'
            }
        }
        """
        * call read(svc + 'networkSvc.feature@AddNetworkConnection') data
        Then match responseStatus == 201
        And match response.status == "success"

    @GetCounterPartiesConnection
    Scenario: Get Counter Parties Connection
        * callonce read(svc + 'ReadData.feature@ReadEnumFile')
        * def keyword = karate.get('keyword', '')
        * def tokenSymbol = karate.get('tokenSymbol',Const.TokenSymbol.XRP)
        * def data = 
        """
        {
            authorization: #(requesterAccessToken),
            params:{
                keyword: #(keyword),
                limit: 10,
                offset: 0
            }
        }
        """
        * call read(svc + 'networkSvc.feature@GetCounterPartiesConnection') data

    @GetNetworkProfile
    Scenario: Get Network Profile
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
        {
            authorization: #(accessToken),
            networkId: #(networkId)
        }
        """
        * call read(svc + 'networkSvc.feature@GetNetworkProfile') data

    @SetNetworkProfileSetting
    Scenario: Set Network Profile Setting
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: '#(accessToken)',
            networkId : '#(networkId)', 
            body:{
                isDiscoverable : false
            }
        }
        """
        * call read(svc + 'networkSvc.feature@SetNetworkProfileSetting') data
     
    @SetProfileRouting
    Scenario: Set Profile Routing
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                networkId : #(networkId), //string
                vaultId : #(vaultId), //string
                internalNote : #(internalNote) //string
            }
        }
        """
        * call read(svc + 'networkSvc.feature@SetProfileRouting') data
     
    @GetDetailNetworkConnection
    Scenario: Get Detail Network Connection
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            networkId : #(networkId), //string
            connectionId : #(connectionId) //string
        }
        """
        * call read(svc + 'networkSvc.feature@GetDetailNetworkConnection') data
    
    @DeleteNetworkConnection
    Scenario: Delete Network Connection
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
             authorization: #(accessToken),
             networkId : #(networkId), //string
             connectionId : #(connectionId), //string
             body: 
             {
                 note : #(note) //string
             }
        }
        """
        * call read(svc + 'networkSvc.feature@DeleteNetworkConnection') data
     
    @EditNetworkConnectionDepositRouting
    Scenario: Edit Network Connection Deposit Routing
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            networkId : #(networkId), //string
            connectionId : #(connectionId), //string
            body: 
            {
                vaultId : #(vaultId), //string
                vaultName : #(vaultName), //string
                hasDefaultRouting : #(hasDefaultRouting), //boolean
                note : #(note), //string
            }
        }
        """
        * call read(svc + 'networkSvc.feature@EditNetworkConnectionDepositRouting') data
     

