@RAKCON-10583 @RAKCON-20140
Feature: Check Multi Tenancy for Transfer Flows
    Background:
        * callonce read(svc + 'ReadData.feature')
        * call read(svc + 'Auth.feature@GetUserAccessToken') {userName:#(userOtherCustomerInfor.userName)}
        * def token = 'Bearer ' + response.data.AuthenticationResult.AccessToken   
        * call read(svc + 'Auth.feature@GetRequesterAccessToken')

    @RAKCON-21748 @SearchOtherCustomerSourceVault
    Scenario: Search for Cross Tenant SIT vault in Source Transfer Screen 
        # * call read(svc + 'Vault.feature@GetAllVaults_TransferScreen') { accessToken:#(token), keyword:#(testData.standardWarmVault_1), fromScreen:#(Const.Transfer.FromScreen.SOURCE) }
        * call read(svc + 'Vault.feature@GetVaultFromSourceScreen') { accessToken:#(token), searchText:#(testData.standardWarmVault_1) }
        * assert response.data.list.length == 0

    @RAKCON-21749 @SearchOtherCustomerDestinationVault
    Scenario: Search for Cross Tenant SIT vault in Destination Transfer Screen 
        # * call read(svc + 'Vault.feature@GetAllVaults_TransferScreen') { accessToken:#(token), keyword:#(testData.standardWarmVault_2), fromScreen:#(Const.Transfer.FromScreen.DESTINATION)}
        * call read(svc + 'Vault.feature@GetVaultFromSourceScreen') { accessToken:#(token) }
        * call read(svc + 'Vault.feature@GetVaultFromDestinationScreen') { accessToken:#(token), searchText:#(testData.standardWarmVault_2), sourceVaultId:#(response.data.list[0].id) }
        * assert response.data.list.length == 0

    @RAKCON-21750 @SearchOtherCustomerDestinationWhitelist
    Scenario: Search for Cross Tenant SIT Whitelist Folder in Destination Screen
        * call read(svc + 'Whitelist.feature@GetWhitelistFolders_TransferDestination') {accessToken:#(token), keyword:#(testData.externalWhitelist)}
        * assert response.data.folders.length == 0



