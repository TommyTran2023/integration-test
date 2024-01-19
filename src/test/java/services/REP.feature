Feature: REP
    # core/v2/rep

    @CurrencyConvert_GetListEntity
    Scenario: Get List Entity Currency Convert
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
            {
                authorization: #(accessToken),
                params:{
                    limit: 10,
                    offset: 0,
                    searchText:'',
                    ids:'',
                    where:''
                }
            }
        """
        * call read(svc + 'coreSvc.feature@CurrencyConvert_GetListEntity') data
    
    @CurrencyConvert_SaveEntity
    Scenario: Save Entity Currency Convert
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
            {
                authorization: #(accessToken),
                body:{
                    id : #(id), //string
                    baseId : #(baseId), //string
                    targetId : #(targetId), //string
                    rate : #(rate) //number
                }
            }
        """
        * call read(svc + 'coreSvc.feature@CurrencyConvert_SaveEntity') data
    
    @CurrencyConvert_FindByUid
    Scenario: Find Currency Convert By Uid
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
            {
                authorization: #(accessToken),
                id: #(id)
            }
        """
        * call read(svc + 'coreSvc.feature@CurrencyConvert_FindByUid') data
    
    @CurrencyConvert_UpdateByUid
    Scenario: Update Currency Convert
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
            {
                authorization: #(accessToken),
                id: #(id),
                body:{
                    id : #(id), //string
                    baseId : #(baseId), //string
                    targetId : #(targetId), //string
                    rate : #(rate), //number
                }
            }
        """
        * call read(svc + 'coreSvc.feature@CurrencyConvert_UpdateByUid') data
        
    @CurrencyConvert_DeleteByUid
    Scenario: Delete Currency Convert By Uid
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
            {
                authorization: #(accessToken),
                id: #(id)
            }
        """
        * call read(svc + 'coreSvc.feature@CurrencyConvert_DeleteByUid') data
        
    @Currency_GetListEntity
    Scenario: Get List Entity Currency
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
            {
                authorization: #(accessToken),
                params:{
                    limit: 10,
                    offset: 0,
                    searchText:'',
                    ids:'#(ids)',
                    where:'#(where)'
                }
            }
        """
        * call read(svc + 'coreSvc.feature@Currency_GetListEntity') data
    
    @Currency_SaveEntity
    Scenario: Save Entity Currency
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
            {
                authorization: #(accessToken),
                body:{
                    id : #(id), //string
                    name : #(name), //string
                    symbol : #(symbol), //string
                }
            }
        """
        * call read(svc + 'coreSvc.feature@Currency_SaveEntity') data
        
    @Currency_FindByUid
    Scenario: Find Currency By Uid
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
            {
                authorization: #(accessToken),
                id: #(id)
            }
        """
        * call read(svc + 'coreSvc.feature@Currency_FindByUid') data

    @Currency_UpdateByUid
    Scenario: Update Currency
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
            {
                authorization: #(accessToken),
                id: #(id),
                body:{
                    id : #(id), //string
                    baseId : #(baseId), //string
                    targetId : #(targetId), //string
                    rate : #(rate), //number
                }
            }
        """
        * call read(svc + 'coreSvc.feature@Currency_UpdateByUid') data
        
    @Currency_DeleteByUid
    Scenario: Delete Currency By Uid
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
            {
                authorization: #(accessToken),
                id: #(id)
            }
        """
        * call read(svc + 'coreSvc.feature@Currency_DeleteByUid') data
            
    @WalletInfo_GetListEntity
    Scenario: Get List Entity WalletInfo
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
            {
                authorization: #(accessToken),
                params:{
                    limit: 10,
                    offset: 0,
                    searchText:'',
                    ids:'#(ids)',
                    where:'#(where)'
                }
            }
        """
        * call read(svc + 'coreSvc.feature@WalletInfo_GetListEntity') data

    @WalletInfo_SaveEntity
    Scenario: Save Entity WalletInfo
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
            {
                authorization: #(accessToken),
                body:{
                    id : #(id), //string
                    externalAssetId : #(externalAssetId), //string
                    type : #(type), //string
                    nativeAsset : #(nativeAsset), //string
                    decimals : #(decimals), //number
                    tokenAddress : #(tokenAddress), //string
                    name : #(name), //string
                    symbol : #(symbol), //string
                    network : #(network), //string
                    image : #(image), //string
                    networkImage : #(networkImage), //string
                    blockExplorerUrl : #(blockExplorerUrl), //string
                    blockExplorerTxUrl : #(blockExplorerTxUrl), //string
                    minimumAmount : #(minimumAmount), //number
                    blockExplorerTokenUrl : #(blockExplorerTokenUrl), //string
                    status : #(status) //string
                }
            }
        """
        * call read(svc + 'coreSvc.feature@WalletInfo_SaveEntity') data
        
    @WalletInfo_FindByUid
    Scenario: Find WalletInfo By Uid
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
            {
                authorization: #(accessToken),
                id: #(id)
            }
        """
        * call read(svc + 'coreSvc.feature@WalletInfo_FindByUid') data
    
    @WalletInfo_DeleteByUid
    Scenario: Delete WalletInfo By Uid
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
            {
                authorization: #(accessToken),
                id: #(id)
            }
        """
        * call read(svc + 'coreSvc.feature@WalletInfo_DeleteByUid') data

    @REP_GetVaults
    Scenario: REP - Get Vaults
        * def data =
        """
        {
            authorization: #(typeof accessToken != 'undefined' ? accessToken: requesterAccessToken),
            params:{
                limit: #(typeof limit != 'undefined' ? limit : 10),
                offset: #(typeof offset != 'undefined' ? offset : 0),
                searchText: #(typeof searchText != 'undefined' ? searchText : 'DESC'),
                ids: #(typeof ids != 'undefined' ? ids : []),
                where: #(typeof where != 'undefined' ? where : '')
            }
        }
        """
        * call read(svc + 'coreSvc.feature@REP_GetVaults') data

    @REP_CreateVault
    Scenario: REP - Create Vault
        * def data =
        """
        {
            authorization: #(typeof accessToken == 'undefined' ? requesterAccessToken : accessToken),
            body:{
                id:#(id),
                vaultExternalId:#(vaultExternalId),
                name:#(name),
                hiddenOnUI:#(hiddenOnUI),
                customerRefId:#(customerRefId),
                autoFuel:#(autoFuel),
                status:#(status),
                customerId:#(customerId),
                type:#(type)
            }
        }
        """
        * call read(svc + 'coreSvc.feature@REP_CreateVault') data

    @REP_GetVaultById
    Scenario: REP - Get Vault By Id
        * def data =
        """
        {
            authorization: #(typeof accessToken == 'undefined' ? requesterAccessToken : accessToken),
            vaultId: #(vaulId)
        }
        """
        * call read(svc + 'coreSvc.feature@REP_GetVaultById') data

        @REP_UpdateVaultDetail
    Scenario: Update vault by id 
        * def data =
        """
        {
            authorization: #(typeof accessToken == 'undefined' ? requesterAccessToken : accessToken),
            vaulId: #(vaulId),
            body:{
                id:#(id),
                vaultExternalId:#(vaultExternalId),
                name:#(name),
                hiddenOnUI:#(hiddenOnUI),
                customerRefId:#(customerRefId),
                autoFuel:#(autoFuel),
                status:#(status),
                customerId:#(customerId),
                type:#(type)
            }
        }
        """
        * call read(svc + 'coreSvc.feature@REP_UpdateVaultDetail') data
        
        @REP_DeleteVault
    Scenario: Delete vault by id 
        * def data =
        """
        {
            authorization: #(typeof accessToken == 'undefined' ? requesterAccessToken : accessToken),
            vaulId: #(vaulId)
        }
        """
        * call read(svc + 'coreSvc.feature@REP_DeleteVault') data

        @REP_GetSnapshotTokenPrice
    Scenario: REP - Get Snapshot Token Price
        * def data =
        """
        {
            authorization: #(typeof accessToken == 'undefined' ? requesterAccessToken : accessToken),
            params:{
                limit: #(typeof limit != 'undefined' ? limit : 10),
                offset: #(typeof offset != 'undefined' ? offset : 0),
                searchText: #(typeof searchText != 'undefined' ? searchText : 'DESC'),
                ids: #(typeof ids != 'undefined' ? ids : []),
                where: #(typeof where != 'undefined' ? where : '')
            }
        }
        """
        * call read(svc + 'coreSvc.feature@REP_GetSnapshotTokenPrice') data

        @REP_CreateSnapshotTokenPrice
    Scenario: REP - Create Snapshot Token Price
        * def data =
        """
        {
            authorization: #(typeof accessToken == 'undefined' ? requesterAccessToken : accessToken),
            body:{
                id: '#(id)',
                externalAssetId:'#(externalAssetId)',
                price: '#(price)',
                week:'#(week)',
                day:'#(day)',
                month:'#(month)',
                year:'#(year)'
            }
        }
        """
        * call read(svc + 'coreSvc.feature@REP_CreateSnapshotTokenPrice') data

         @REP_GetSnapshotTokenPriceById
    Scenario: REP - Get Snapshot Token Price By Id
        * def data =
        """
        {
            authorization: #(typeof accessToken == 'undefined' ? requesterAccessToken : accessToken),
            id: #(id)
        }
        """
        * call read(svc + 'coreSvc.feature@REP_GetSnapshotTokenPriceById') data

        @REP_UpdateSnapshotTokenPrice
    Scenario: Update Snapshot Token Price by id 
        * def data =
        """
        {
            authorization: #(typeof accessToken == 'undefined' ? requesterAccessToken : accessToken),
            vaulId: #(vaulId),
            body:{
                id: '#(id)',
                externalAssetId:'#(externalAssetId)',
                price: '#(price)',
                week:'#(week)',
                day:'#(day)',
                month:'#(month)',
                year:'#(year)'
            }
        }
        """
        * call read(svc + 'coreSvc.feature@REP_UpdateSnapshotTokenPrice') data

        @REP_DeleteSnapshotTokenPrice
    Scenario: Delete Snapshot Token Price by id 
        * def data =
        """
        {
            authorization: #(typeof accessToken == 'undefined' ? requesterAccessToken : accessToken),
            vaultId: #(vaulId)
        }
        """
        * call read(svc + 'coreSvc.feature@REP_DeleteSnapshotTokenPrice') data

        @REP_GetDailyJournalCustomers
    Scenario: REP - Get Daily Journal Customers
        * def data =
        """
        {
            authorization: #(typeof accessToken == 'undefined' ? requesterAccessToken : accessToken),
            params:{
                limit: #(typeof limit != 'undefined' ? limit : 10),
                offset: #(typeof offset != 'undefined' ? offset : 0),
                searchText: #(typeof searchText != 'undefined' ? searchText : 'DESC'),
                ids: #(typeof ids != 'undefined' ? ids : []),
                where: #(typeof where != 'undefined' ? where : '')
            }
        }
        """
        * call read(svc + 'coreSvc.feature@REP_GetDailyJournalCustomers') data

        @REP_CreateDailyJournalCustomers
    Scenario: REP - Create Daily Journal Customers
        * def data =
        """
        {
            authorization: #(typeof accessToken == 'undefined' ? requesterAccessToken : accessToken),
            body:{
                id: '#(id)',
                externalAssetId:'#(externalAssetId)',
                type:'#(type)',
                tokenAmount:'#(tokenAmount)',
                usdRate:'#(usdRate)',
                usdValue:'#(usdValue)',
                depositValue: '#(depositValue)',
                depositValueUsd: '#(depositValueUsd)',
                withdrawValue: '#(withdrawValue)',
                withdrawValueUsd: '#(withdrawValueUsd)',
                week:'#(week)',
                day:'#(day)',
                month:'#(month)',
                year:'#(year)'
            }
        }
        """
        * call read(svc + 'coreSvc.feature@REP_CreateDailyJournalCustomers') data

         @REP_GetDailyJournalCustomersById
    Scenario: REP - Get Daily Journal Customers By Id
        * def data =
        """
        {
            authorization: #(typeof accessToken == 'undefined' ? requesterAccessToken : accessToken),
            id: #(id)
        }
        """
        * call read(svc + 'coreSvc.feature@REP_GetDailyJournalCustomersById') data

        @REP_UpdateDailyJournalCustomers
    Scenario: Update Daily Journal Customers by id 
        * def data =
        """
        {
            authorization: #(typeof accessToken == 'undefined' ? requesterAccessToken : accessToken),
            vaulId: #(vaulId),
            body:{
                id: '#(id)',
                externalAssetId:'#(externalAssetId)',
                type:'#(type)',
                tokenAmount:'#(tokenAmount)',
                usdRate:'#(usdRate)',
                usdValue:'#(usdValue)',
                depositValue: '#(depositValue)',
                depositValueUsd: '#(depositValueUsd)',
                withdrawValue: '#(withdrawValue)',
                withdrawValueUsd: '#(withdrawValueUsd)',
                week:'#(week)',
                day:'#(day)',
                month:'#(month)',
                year:'#(year)'
            }
        }
        """
        * call read(svc + 'coreSvc.feature@REP_UpdateDailyJournalCustomers') data

        @REP_DeleteDailyJournalCustomers
    Scenario: Delete Daily Journal Customers by id 
        * def data =
        """
        {
            authorization: #(typeof accessToken == 'undefined' ? requesterAccessToken : accessToken),
            id: #(id)
        }
        """
        * call read(svc + 'coreSvc.feature@REP_DeleteDailyJournalCustomers') data

