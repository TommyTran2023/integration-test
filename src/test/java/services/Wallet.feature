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
            params: { 
                limit:'10', 
                offset: '0', 
                sort:'ASC', 
                groupBy: 'ASSET', 
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
        * call read(svc + 'coreSvc.feature@GetWallets') data
        
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

