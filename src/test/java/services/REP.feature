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
                    ids:''
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
                    ids:'#(ids)'
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
                    ids:'#(ids)'
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
