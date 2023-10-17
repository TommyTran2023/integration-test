Feature: Wallet
# including all route call to /core/wallet

    Background:
        * url baseURL
        * def svc = 'classpath:services/'

    @GetAvailableAssets
    Scenario: Get all assets available in the wallet
        Given path '/core/wallet/transfer-tokens'    
        And params query
        When method GET

    @GetAvailableTokens
    Scenario: Get all tokens available in the wallet
        * def data = 
        """
        {
            authorization: #(requesterAccessToken),
            vaultId: '#(vaultId)',
            params: {keyword: '#(keyword)', limit:10, offset:0}
        }
        """
        * call read(svc + 'coreSvc.feature@GetTokens') {data: '#(data)'}

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
        * call read(svc + 'coreSvc.feature@AddAsset') {data: '#(data)'}

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
        * call read(svc + 'coreSvc.feature@GetWalletAddress') {data: '#(data)'}

    @GetWalletTransferTokens
    Scenario: Get Wallet Transfer Token
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
        * call read(svc + 'coreSvc.feature@GetWalletTransferTokens') {data: '#(data)'}
    
    
