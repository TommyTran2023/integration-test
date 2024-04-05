@RAKCON-10583
Feature: Wallet Connect
    Background:
        * call read('this:RequesterAuthenticator.feature@RequesterAccessToken')

    @GetListWalletConnect
    Scenario: Get list Wallet Connect
        * call read(svc + 'WalletConnect.feature@VaultWcController_getListEntity')
        Then match responseStatus == 200
        * def expectedSchema = 
        """
        {
            "id":"#string",
            "type":"#string",
            "status":"#string",
            "name":"#string",
            "createdAt":"#string",
            "wcTotal":"#number",
            "wallets":"#[]",
            "wcItems":"#[]"
        }
        """
        * match each response.data.list == expectedSchema
        * def expectedWalletSchema = 
        """
        {
            "id":"#uuid",
            "tokenAddress":"#string",
            "name":"#string",
            "symbol":"#string",
            "image":"#string",
            "createdAt":"#string",
            "updatedAt":"#string",
            "externalAssetId":"#string",
            "nativeAsset":"#string",
            "decimals":"#number",
            "type":"#string",
            "blockExplorerUrl":"#string",
            "network":"#string",
            "blockExplorerTxUrl":"#string",
            "minimumAmount":"#number",
            "networkImage":"##string",
            "status":"#string",
            "blockExplorerTokenUrl":"##string",
            "customerId":"#uuid",
            "minRemainingAmount":"#number"
        }
        """
        * match each response.data.list[*].wallets[*] == expectedWalletSchema
        * def expectedwcItems =
        """
        {
            "id":"#uuid",
            "status":"#string",
            "createdAt":"#string",
            "createdBy":"#uuid",
            "app":{
               "id":"#uuid",
               "name":"#string",
               "appIcon":"#string"
            }
        }
        """
        * match each response.data.list[*].wcItems[*] == expectedwcItems
