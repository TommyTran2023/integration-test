Feature: Wallet
    # including all route call to /core/wallet

    @GetTokens
    Scenario: Get all tokens available in the wallet
        * def keyword = karate.get('keyword','')
        * def data = 
        """
        {
            authorization: #(requesterAccessToken),
            vaultId: '#(vaultId)',
            params: {
                keyword: '#(keyword)', 
                limit:10, 
                offset:0
            }
        }
        """
        * call read(svc + 'coreSvc.feature@GetTokens') data

    @AddAssets
    Scenario: Add Asset to Vault / Create wallet
        * def data =
        """
        {
            authorization: #(requesterAccessToken),
            tokenIds:['#(tokenIds)'],
            vaultId: '#(vaultId)'
        }
        """
        * call read(svc + 'coreSvc.feature@AddAssets') data

    @GetWalletAddress
    Scenario: Get Wallet Address
        * def data =
        """
        {
            authorization: #(requesterAccessToken),
            vaultId: '#(vaultId)',
            walletId: '#(walletId)'
        }
        """
        * call read(svc + 'coreSvc.feature@GetWalletAddress') data

    @GetWalletTransferTokens
    Scenario: Get Wallet Transfer Token
        * def keyword = karate.get('keyword','')
        * def data =
        """
        {
            authorization: #(requesterAccessToken),
            params: { 
                limit:'10', 
                offset: '0', 
                sort:'ASC', 
                groupBy: 'ASSET', 
                keyword:'#(keyword)'
            }
        }
        """
        * call read(svc + 'coreSvc.feature@GetWalletTransferTokens') data
    
    @GetWallets
    Scenario: Get Wallets on Vault
        * def data =
        """
        {
            authorization: #(requesterAccessToken),
            vaultId: #(vaultId),
            params: { 
                limit:'10', 
                offset: '0', 
                sort:'ASC', 
                sortBy:'NAME',
                groupBy: 'ASSET', 
                isHideList: false,
                keyword:'#(tokenSymbol)'
            }
        }
        """
        * call read(svc + 'coreSvc.feature@GetWallets') data
        Then match responseStatus == 200
        Then match response.status == 'success'

    @GetListToken
    Scenario: Get List Token
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def sort = karate.get('sort','ASC')
        * def platform = karate.get('platform','iOS')
        * def data =
        """
        {
            authorization: #(accessToken),
            params: { 
                limit:'10', 
                offset: '0', 
                sort:'#(sort)', 
                platform: '#(platform)', 
                keyword:'#(tokenSymbol)'
            }
        }
        """
        * call read(svc + 'coreSvc.feature@GetListToken') data
        
    @GetTokenDetails
    Scenario: Get Token Details
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
        {
            authorization: #(accessToken),
            params: { 
                vaultId:'#(vaultId)', 
                walletId: '#(walletId)'
            }
        }
        """
        * call read(svc + 'coreSvc.feature@GetTokenDetails') data

    @HideAsset
    Scenario: Hide Asset
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
        {
            authorization: #(accessToken),
            walletId: '#(walletId)'
        }
        """
        * call read(svc + 'coreSvc.feature@HideAsset') data
    
    @UnhideAsset
    Scenario: Unhide Asset
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
        {
            authorization: #(accessToken),
            walletId: '#(walletId)'
        }
        """
        * call read(svc + 'coreSvc.feature@UnhideAsset') data
    
    @CheckAssetPreRequisite
    Scenario: Check Asset Pre Requisite
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
        {
            authorization: #(accessToken),
            vaultId: #(vaultId),
            tokenIds: '#(tokenIds)'
        }
        """
        * call read(svc + 'coreSvc.feature@CheckAssetPreRequisite') data
    
    @GetListTokenStake
    Scenario: Get List Token Stake
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
        {
            authorization: #(accessToken),
            body: { 
                limit:'10', 
                offset: '0', 
                sort:'ASC', 
                platform: 'iOS', 
                keyword:'#(tokenSymbol)'
            }
        }
        """
        * call read(svc + 'coreSvc.feature@GetListTokenStake') data
    
    @GetListTokenStakeSubscription
    Scenario: Get List Token Stake Subscription
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
        {
            authorization: #(accessToken),
            params: { 
                limit:'10', 
                offset: '0', 
                sort:'ASC'
            }
        }
        """
        * call read(svc + 'coreSvc.feature@GetListTokenStakeSubscription') data
    
    @GetCustomerWalletPrice
    Scenario: Get Customer Wallet Price
        * def data =
        """
        {
            headers:{
                Authorization: "#(typeof accessToken == 'undefined' ? requesterAccessToken : accessToken)"
            },
            params: {
                limit: "#(typeof limit != 'undefined' ? limit : null)",
                offset: "#(typeof offset != 'undefined' ? offset : null)",
                where: "#(typeof where != 'undefined' ? where : null)"
            }
        }
        """
        * call read(svc + 'coreSvc.feature@GetCustomerWalletPrice') data

