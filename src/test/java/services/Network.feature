Feature: Network
Background:
    * def svc = 'classpath:services/'

    @GetNetworkList
    Scenario: Get Network List
        * def keyword = karate.get('keyword', '')
        * def data =
        """
            {
                authorization: #(requesterAccessToken),
                keyword: '#(keyword)',
                limit: 10,
                offset: 0
            }
        """
        * call read(svc + 'networkSvc.feature@GetNetworkList') {data: '#(data)'}
        Then match responseStatus == 200
        * match response.status == 'success'

    @GetNetworkConnection
    Scenario: Get Network Connection
        * def keyword = karate.get('keyword', '')
        * def data =
        """
            {
                authorization: #(requesterAccessToken),
                networkId: '#(networkId)',
                keyword: '#(keyword)',
                limit: 10,
                offset: 0
            }
        """
        * call read(svc + 'networkSvc.feature@GetNetworkConnection') {data: '#(data)'}
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
        * call read(svc + 'networkSvc.feature@GetDiscoverableNetwork') {data: '#(data)'}
        Then match responseStatus == 200
        * match response.status == 'success'

    @GetDepositRouting
    Scenario: Get Deposit Routing
        * def keyword = karate.get('keyword', '')
        * def data =
        """
            {
                authorization: #(requesterAccessToken),
                params:{
                    keyword: '#(keyword)',
                    limit: 10,
                    offset: 0
                }
            }
        """
        * print data
        * call read(svc + 'coreSvc.feature@GetDepositRouting') {data: '#(data)'}
        Then match responseStatus == 200
        * match response.status == 'success'
    
    @CreateNetworkProfile
    Scenario: Create Network Profile
        * def isDiscoverable = karate.get('isDiscoverable', true)
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
        * call read(svc + 'networkSvc.feature@CreateNetworkProfile') {data: '#(data)'}
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
        * call read(svc + 'networkSvc.feature@AddNetworkConnection') {data:'#(data)'}
        Then match responseStatus == 201
        And match response.status == "success"
