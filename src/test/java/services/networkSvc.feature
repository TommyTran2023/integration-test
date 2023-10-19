Feature: Networking
Background:
    * url baseURL

    Scenario: Network
    @GetNetworkList
    Scenario: Get Network List
        Given path 'network/networks'
        * header authorization = #(data.authorization)
        * params data.params
        When method GET

    @GetNetworkConnection
    Scenario: Get Network Connection
        Given path 'network/networks' + data.networkId + 'connections'
        * header authorization = #(data.authorization)
        * params data.params
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
        * header authorization = data.authorization
        * params data.params
        When method GET

    @CreateNetworkProfile
    Scenario: Create Network profile
        Given path 'network/networks'
        * header challenge-answer = data.challengeAnswer
        * header authorization = data.authorization
        And request data.body
        When method POST

    @AddNetworkConnection
    Scenario: Add Network Connection
        Given path 'network/networks/'+ data.profileId +'/connections'
        * header challenge-answer = data.challengeAnswer
        * header authorization = data.authorization
        * header passcode = data.passcode
        And request data.body
        When method POST

