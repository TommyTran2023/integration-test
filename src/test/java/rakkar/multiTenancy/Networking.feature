@RAKCON-10583 @RAKCON-20140
Feature: Check Multi Tenancy for Networking
    Background:
        * callonce read(svc + 'ReadData.feature')
        * call read(svc + 'Auth.feature@GetUserAccessToken') {userName:#(userOtherCustomerInfor.userName)}
        * def token = 'Bearer ' + response.data.AuthenticationResult.AccessToken

    @RAKCON-21743
    Scenario: Search Networking of Cross Tenant
        * call read(svc + 'Network.feature@GetNetworkList') {accessToken:#(token), keyword:#(testData.networkVault)}
        * assert response.data.networks.length == 0

    @RAKSEC-110 @RAKCON-21745
    Scenario: Get details of Networking of Cross Tenant
        * call read(svc + 'Auth.feature@GetRequesterAccessToken')
        * def getNetworks = call read(svc + 'Network.feature@GetNetworkList')
        * def networkId = getNetworks.response.data.networks[0].id
        * call read(svc + 'Network.feature@GetNetworkProfile') {accessToken:#(token), networkId:#(networkId)}
        * assert responseStatus == 403
        
