@ignore
Feature: Vault 

    Background:
        * def coreSvc = 'this:coreSvc.feature@'

    @CreateVault
    Scenario: Create a new vault
        * def data = 
        """
            {
                authorization:"#(requesterAccessToken)",
                requestBody: '#(requestBody)', 
                challengeAnswer: '#(challengeAnswerRequest)', 
                passcode: '#(requesterInfo.requesterPasscode)'
            }
        """
        * call read(coreSvc + 'CreateVault') {data: '#(data)'}

    @RequestCreateAdvVault
    Scenario: Request Create Adv Vault
        * call read(coreSvc + 'RequestCreateVault') {requestBody: '#(requestBody)', authorization: '#(requesterAccessToken)'}

    @SubmitCreateAdvVault
    Scenario: Submit Create Advance Vault From Mobile
        * def data = 
        """
            {
                authorization:"#(requesterAccessToken)",
                requestBody: { "notificationId" : "#(notificationId)" }, 
                challengeAnswer: '#(challengeAnswerRequest)', 
                passcode: '#(requesterInfo.requesterPasscode)'
            }
        """
        * call read(coreSvc + 'SubmitRequestCreateVault') {data: '#(data)'}

    @GetVaultDetail
    Scenario: Get Vault Detail by Id
        * call read(coreSvc + 'GetVaultById') {vaultId: '#(vaultId)', authorization: '#(requesterAccessToken)'}