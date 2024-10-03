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
        * def vaults = call read(svc + 'WalletConnect.feature@VaultWcController_getListVaultSelection')
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
        * def wcInfo = call read('@WalletConnectToFigment')
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
        * def vaults = call read(svc + 'WalletConnect.feature@VaultWcController_getListVaultSelection')
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
        * def wcInfo = call read('@WalletConnectToOpenEden')
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

    @RAKCON-29604 @MOB-3356 @DisconnectWhenInitiatorGotDemoted
    Scenario: Disconnect from Application - User changed to VIEW ONLY in Advanced vault
        # Get vault have 'ETH_TEST6'
        * def figmentVaultName = read('classpath:data/data.json').figmentVault
        * def whereClause = '{\"OR\":[{\"name\":{\"CONTAINS\":\"'+figmentVaultName+'\"}}]}'
        * def getwc = 
        """
        {
            where: '#(whereClause)',
            order: '[{\"sort\":\"name\",\"order\":\"ASC\"}]'
        }
        """
        * def getVault = call read(svc + 'WalletConnect.feature@VaultWcController_getListVaultSelection') getwc
        * def haveETH = 
        """
        function(vaults){
            for (var i = 0; i < vaults.length; i++){
                var wallets = vaults[i].wallets
                for (var j = 0; j < wallets.length; j++) {
                    if (wallets[j].externalAssetId == 'ETH_TEST6'){
                        return vaults[i]
                    }
                }
            }

            throw new Error("Don't have vault to test Wallet Connect.")
        }
        """
        * def vaultETH = haveETH(getVault.response.data.list)

        # Get vault policy detail
        * def vaultETH = call read(svc + 'Vault.feature@GetVaultDetail') { vaultId: '#(vaultETH.id)' }
        * callonce read(svc + 'Auth.feature@GetRequesterInfo')

        # 1. Add current user to quorum
        * def vaultHandle = read('classpath:rakkar/common/VaultHandle.js')
        * vaultHandle().addUserAsMemberToVaultQuorum(userId, vaultETH.response.data)

        # 2. Make connection
        * def qrCode = karate.exec('node figment_wc.js')
        * def cnn = 
        """
        {
            qrCode: '#(qrCode)',
            vaultId: '#(vaultETH.response.data.id)'
        }
        """
        * def wcInfo = call read(svc + 'WalletConnect.feature@WcRequestWeb3ConnectController_validateQRCode') cnn
        * call read(svc + 'Biometric.feature@RequesterDoBiometric')
        * call read(svc + 'WalletConnect.feature@WcRequestWeb3ConnectController_approveRequestWeb3Connect') {id:'#(wcInfo.response.data.id)'}

        # 3. Get connection list and verify connection is created
        * call read(svc + 'WalletConnect.feature@VaultWcController_getListEntity') getwc
        * def compareToNow = 
        """
        function(isoDateString) {
            return (new Date() - new Date(isoDateString))/1000;
        }
        """
        # Validate new connection should be created within 30s
        * assert compareToNow(response.data.list[0].wcItems[0].createdAt) < 30

        # 4. Demote current user to VIEWER in quorum
        * vaultHandle().removeUserFromVaultQuorum(userId, vaultETH.response.data)

        # 5. Get connection list and verify connection is remove
        * def verifyWCDisconnected = 
        """
        function(data){
            var retry = 3
            for (var i = 0; i < retry; i++){
                java.lang.Thread.sleep(3000)
                var res = karate.call(svc + 'WalletConnect.feature@VaultWcController_getListEntity', data)

                if (res.responseStatus == 200 && res.response.data.list.length == 0)
                    return true
            }
            return false
        }
        """
        * assert verifyWCDisconnected(getwc)


    @RAKCON-30427 @checkVaultDappConnected
    Scenario: Get connected vault to connect 
        * def validateConnected  = '{"AND":[{"isDeleted":{"BOOLEAN":false}},{"wcAppId":{"CONTAINS":"'+dataSet.figmentdAppId+'"}},{"status":{"IS":"ACTIVE"}},{"vaultId":{"CONTAINS":"'+dataSet.connecteddAppVaultId+'"}}]}'
        * print validateConnected

        * def data =
        """
        {

            "where": #(validateConnected)
        }
        """
        * call read(svc + 'WalletConnect.feature@WcWeb3ConnectController_getListEntity') data
            * def expectedFbRaw =
            """
            {
                "id": "#string",
          "userId": "#uuid",
          "chainIds": [
            "#string"
          ],
          "feeLevel": "#string",
          "creationDate": "#string",
          "connectionType": "WalletConnect",
          "vaultAccountId": "#number",
          "sessionMetadata": {
            "appUrl": "#string",
            "appIcon": "#string",
            "appName": "#string",
            "appDescription": "#string"
          },
          "connectionMethod": "API"
            }
            """
            * def expectedSchema = 
            """
            {
                "id": "#uuid",
                "wcAppId": "#(dataSet.figmentdAppId)",
                "wcAppEntityId": "#string",
                "vaultId": "#(dataSet.connecteddAppVaultId)",
                "externalId": "#string",
                "externalWorkspaceId":"#uuid",
                "externalVaultId":"#string",
                "externalWalletType":"WalletConnect",
                
                "status":"ACTIVE",
                "isDeleted": false,
                "createdBy":"#uuid"    
            }
            """
    
            Then match responseStatus == 200
            And match each response.data.list contains '#(^expectedSchema)'
            And match each response.data.list[*].fbRaw contains '#(expectedFbRaw)'
            And assert response.data.list.length >0

    @RAKCON-30546 @checkVaultNoDappConnected
    Scenario: Get non-connected vault to connect 
         * def validateConnected  = '{"AND":[{"isDeleted":{"BOOLEAN":false}},{"wcAppId":{"CONTAINS":"'+dataSet.figmentdAppId+'"}},{"status":{"IS":"ACTIVE"}},{"vaultId":{"CONTAINS":"'+dataSet.notConnecteddAppVaultId+'"}}]}'
         
         * def data =
         """
         {
 
             "where": #(validateConnected)
         }
         """
        * call read(svc + 'WalletConnect.feature@WcWeb3ConnectController_getListEntity') data
        Then match responseStatus == 200   
        And assert response.data.list.length == 0
        And assert response.data.total == 0