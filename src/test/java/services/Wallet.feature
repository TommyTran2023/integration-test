Feature: Wallet
# including all route call to /core/wallet

    Background:
        * url baseURL

    @GetAvailableAssets
    Scenario: Get all assets available in the wallet
        Given path '/core/wallet/transfer-tokens'    
        And params query
        When method GET
