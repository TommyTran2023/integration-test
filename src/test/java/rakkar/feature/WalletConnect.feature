@RAKCON-10583
Feature: Wallet Connect
    Background:
        * call read('this:RequesterAuthenticator.feature@RequesterAccessToken')

    @GetListWalletConnect
    Scenario: Get list Wallet Connect
        * call read(svc + 'WalletConnect.feature@VaultWcController_getListEntity')
        Then match responseStatus == 200
