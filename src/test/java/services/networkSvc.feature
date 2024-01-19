Feature: Networking
    Background:
        * url baseURL

    Scenario: Network
    @GetNetworkList
    Scenario: Get Network List
        Given path 'network/networks'
        * header authorization = authorization
        * params params
        When method GET

    @GetNetworkConnection
    Scenario: Get Network Connection
        Given path 'network/networks/' + networkId + '/connections'
        * header authorization = authorization
        * params params
        When method GET

    @ValidateNetworkName
    Scenario: Validate network name
        Given path 'network/networks/validate/network-name'
        * header authorization = data.authorization
        * param networkName = data.name
        When method GET

    @GetDiscoverableNetwork
    Scenario: Get Discoverable Network
        Given path 'network/networks/discoverable-network-ids'
        * header authorization = authorization
        * params params
        When method GET

    @CreateNetworkProfile
    Scenario: Create Network profile
        Given path 'network/networks'
        * header challenge-answer = challengeAnswer
        * header authorization = authorization
        And request body
        When method POST

    @AddNetworkConnection
    Scenario: Add Network Connection
        Given path 'network/networks/'+ profileId +'/connections'
        * header challenge-answer = challengeAnswer
        * header authorization = authorization
        * header passcode = passcode
        And request body
        When method POST

    @GetCounterPartiesConnection
    Scenario: Get Counter Parties Connection
        Given path 'network/networks/connections/counterparties'
        * header authorization = authorization
        And params params
        When method GET

    @GetNetworkProfile
    Scenario: Get Network Profile
        Given path 'network/networks/' + networkId
        * header authorization = authorization
        When method GET

    @SetNetworkProfileSetting
    Scenario: Set Network Profile Setting
       Given path 'network/networks/setting/' + networkId
       * header authorization = authorization
       * request body
       When method PUT
    
    @SetProfileRouting
    Scenario: Set Profile Routing
       Given path 'network/networks/set-profile-routing'
       * header authorization = authorization
       * request body
       When method POST

    @GetDetailNetworkConnection
    Scenario: Get Detail Network Connection
        Given path 'network/networks/' + networkId + '/connections/' + connectionId
        * header authorization = authorization
        When method GET
        
    @DeleteNetworkConnection
    Scenario: Delete Network Connection
       Given path 'network/networks/' + networkId + '/connections/' + connectionId
       * header authorization = authorization
       * request body
       When method DELETE
    
    @EditNetworkConnectionDepositRouting
    Scenario: Edit Network Connection Deposit Routing
       Given path 'network/networks/' + networkId + '/connections/'+ connectionId +'/deposit-routing'
       * header authorization = authorization
       * request body
       When method PUT
    
       
       
       
