@ignore
Feature: Get Data from Cross Tenant
    Background:
        * callonce read(svc + 'Auth.feature@GetUserAccessToken') {userName:#(userOtherCustomerInfor.userName)}
        * def token = 'Bearer ' + response.data.AuthenticationResult.AccessToken    

    @GetUsers
    Scenario: Get Users
        * call read(svc + 'Auth.feature@GetUsers') {accessToken:#(token)}

    @GetVaults
    Scenario: Get Vaults
        * def data = 
        """
        {
            accessToken:#(token),
            fromScreen:#(fromScreen),
            keyword:#(keyword)
        }
        """
        * call read(svc + 'Vault.feature@GetAllVaults_TransferScreen') data

    @GetWhitelistFolders
    Scenario: Get Whitelist Folders
        * def data = 
        """
        {
            accessToken:#(token),
            fromScreen:#(fromScreen),
            keyword:#(keyword)
        }
        """
        * call read(svc + 'Vault.feature@GetAllVaults_TransferScreen') data


