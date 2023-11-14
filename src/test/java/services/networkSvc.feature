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
        Given path 'network/networks', networkId ,'connections'
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
