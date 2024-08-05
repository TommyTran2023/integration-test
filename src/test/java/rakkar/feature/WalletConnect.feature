@RAKCON-10583
Feature: Wallet Connect
    Background:
        * call read('this:RequesterAuthenticator.feature@RequesterAccessToken')

    @RAKCON-29143 @GetListWalletConnect
    Scenario: Get list Wallet Connect
        * call read(svc + 'WalletConnect.feature@VaultWcController_getListEntity')
        Then match responseStatus == 200
        * def expectedWalletSchema = 
        """
        {
            "id":"#uuid",
            "tokenAddress":"#string",
            "name":"#string",
            "symbol":"#string",
            "image":"##string",
            "createdAt":"#string",
            "updatedAt":"#string",
            "externalAssetId":"#string",
            "nativeAsset":"#string",
            "decimals":"##number",
            "type":"#string",
            "blockExplorerUrl":"##string",
            "network":"##string",
            "blockExplorerTxUrl":"##string",
            "minimumAmount":"##number",
            "networkImage":"##string",
            "status":"#string",
            "blockExplorerTokenUrl":"##string",
            "customerId":"##uuid",
            "minRemainingAmount":"#number"
        }
        """
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
        * def expectedSchema = 
        """
        {
            "id":"#string",
            "type":"#string",
            "status":"#string",
            "name":"#string",
            "createdAt":"#string",
            "wcTotal":"#number",
            "wallets":"#[] expectedWalletSchema",
            "wcItems":"#[] expectedwcItems"
        }
        """
        * match each response.data.list == expectedSchema

    @RAKCON-29144 @GetVaultToConnect
    Scenario: Get vault to connect
        * call read(svc + 'WalletConnect.feature@VaultWcController_getListVaultSelection')
        Then match responseStatus == 200
        * def expectedWalletSchema = 
        """
        {
            "id": "#uuid",
            "name": "#string",
            "symbol": "#string",
            "externalAssetId": "#string"
        }
        """
        * def expectedSchema = 
        """
        {
            "id": "#uuid",
            "name": "#string",
            "status": "#string",
            "type": "#string",
            "wallets": "#[]expectedWalletSchema",
            "isMasked": "#boolean",
            "isArchived": "#boolean",
            "createdAt": "#string",
            "disableType": "#string"
        }
        """
        * match each response.data.list == expectedSchema

    @RAKCON-29145 @WalletConnectToFigment
    Scenario: Validate Wallet Connect Figment QR Code
        * def vaults = callonce read(svc + 'WalletConnect.feature@VaultWcController_getListVaultSelection')
        * def qrCode = karate.exec('node figment_wc.js')
        * def data = 
        """
        {
            qrCode: "#(qrCode)",
            vaultId: "#(vaults.response.data.list.find(x => x.disableType != 'NOT-ETH').id)"
        }
        """
        * call read(svc + 'WalletConnect.feature@WcRequestWeb3ConnectController_validateQRCode') data
        Then match responseStatus == 201

    @RAKCON-29146 @GetFigmentAppInfomation
    Scenario: Get dApp Figment Information
        * def wcInfo = callonce read('@WalletConnectToFigment')
        * call read(svc + 'WalletConnect.feature@WcApplicationController_findOneByUId') { id: '#(wcInfo.response.data.appId)' }
        Then match responseStatus == 200
        * def expectedSchema =
        """
        {
            "id":"#uuid",
            "name":"#string",
            "externalId":"8f3b9e890a63e147986c7c4d06ccd49c483abb39c10e65df91688c380431421c",
            "url":"https://app.figment.io",
            "destinationNote":"#string",
            "logo":"https://static.fireblocks.io/wcs/dappIcon/8f3b9e890a63e147986c7c4d06ccd49c483abb39c10e65df91688c380431421c"
        }
        """
        And match response.data == expectedSchema

    @RAKCON-29147 @WalletConnectToOpenEden @ignore
    Scenario: Validate Wallet Connect Open Eden QR Code
        # ignore because don't have Open Eden in UAT
        * def vaults = callonce read(svc + 'WalletConnect.feature@VaultWcController_getListVaultSelection')
        * def qrCode = karate.exec('node openEden_wc.js')
        * def data = 
        """
        {
            qrCode: "#(qrCode)",
            vaultId: "#(vaults.response.data.list.find(x => x.disableType != 'NOT-ETH').id)"
        }
        """
        * call read(svc + 'WalletConnect.feature@WcRequestWeb3ConnectController_validateQRCode') data
        Then match responseStatus == 201

    @RAKCON-29148 @GetOpenEdenAppInfomation @ignore
    Scenario: Get dApp Open Eden Information
        # ignore because don't have Open Eden in UAT
        * def wcInfo = callonce read('@WalletConnectToOpenEden')
        * call read(svc + 'WalletConnect.feature@WcApplicationController_findOneByUId') { id: '#(wcInfo.response.data.appId)' }
        Then match responseStatus == 200
        * def expectedSchema =
        """
        {
            "id":"#uuid",
            "name":"#string",
            "externalId":"1412ecdfc5ad591bd39044157fdbd6545895b5d93eee87861bb7e1095629cfa4",
            "url":"#regex https://(.*).openeden.com",
            "destinationNote": "#string",
            "logo":"https://static.fireblocks.io/wcs/dappIcon/1412ecdfc5ad591bd39044157fdbd6545895b5d93eee87861bb7e1095629cfa4"
        }
        """
        And match response.data == expectedSchema

    @RAKCON-29149 @GetDAppInDestinationList
    Scenario: Filter Transaction - Get DApp In Destination list
        * call read(svc + 'WalletConnect.feature@WcApplicationController_getListEntity')
        Then match responseStatus == 200 
        * def expectedSchema = 
        """
        {
            "id": "#uuid",
            "name": "#string",
            "externalId": "#string",
            "url": "#string",
            "destinationNote": "#string",
            "logo": "#string"
        }
        """
        And match each response.data.list contains '#(^expectedSchema)'


