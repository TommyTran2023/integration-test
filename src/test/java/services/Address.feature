Feature: Address
# core/address

    @CreateAddress
    Scenario: Create Deposit Address
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
        {
            authorization: #(accessToken),
            body: { 
                vaultId:'#(vaultId)', 
                walletId: '#(walletId)', 
                addressName:'#(addressName)'
            }
        }
        """
        * call read(svc + 'coreSvc.feature@CreateAddress') data
    
    @UpdateAddress
    Scenario: Update Deposit Address
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
        {
            authorization: #(accessToken),
            body: { 
                vaultId:'#(vaultId)', 
                walletId: '#(walletId)', 
                addressName:'#(addressName)'
            }
        }
        """
        * call read(svc + 'coreSvc.feature@UpdateAddress') data
    
