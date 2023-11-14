@RAKCON-10583 @RAKCON-20140
Feature: Check Multi Tenancy for Transfer Flows
    Background:
        * callonce read(svc + 'ReadData.feature')
        * call read(svc + 'Auth.feature@GetUserAccessToken') {userName:#(userOtherCustomerInfor.userName)}
        * def token = 'Bearer ' + response.data.AuthenticationResult.AccessToken   
        * call read(svc + 'Auth.feature@GetRequesterAccessToken')

    @SearchOtherCustomerSourceVault
    Scenario: Search for Cross Tenant SIT vault in Source Transfer Screen 
        * call read(svc + 'Vault.feature@GetAllVaults_TransferScreen') { accessToken:#(token), keyword:#(testData.standardWarmVault_1), fromScreen:#(Const.Transfer.FromScreen.SOURCE) }
        * assert response.data.vaults.length == 0

    @SearchOtherCustomerDestinationVault
    Scenario: Search for Cross Tenant SIT vault in Destination Transfer Screen 
        * call read(svc + 'Vault.feature@GetAllVaults_TransferScreen') { accessToken:#(token), keyword:#(testData.standardWarmVault_2), fromScreen:#(Const.Transfer.FromScreen.DESTINATION)}
        * assert response.data.vaults.length == 0

    @SearchOtherCustomerDestinationWhitelist
    Scenario: Search for Cross Tenant SIT Whitelist Folder in Destination Screen
        * call read(svc + 'Whitelist.feature@GetWhitelistFolders_TransferDestination') {accessToken:#(token), keyword:#(testData.externalWhitelist)}
        * assert response.data.folders.length == 0



