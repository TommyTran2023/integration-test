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
        * call read(coreSvc + 'CreateVault') data

    @RequestCreateAdvVault
    Scenario: Request Create Adv Vault
        * def data = 
        """
        {
            body: '#(requestBody)', 
            authorization: '#(requesterAccessToken)'
        }
        """
        * call read(coreSvc + 'RequestCreateAdvVault') data

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
        * def data =
        """
        {
            vaultId: '#(vaultId)', 
            authorization: '#(requesterAccessToken)'
        }
        """
        * call read(coreSvc + 'GetVaultDetail') data

    @GetAllVaults
    Scenario: Get all vaults
        * def keyword = karate.get('keyword', '')
        * def sort = karate.get('sort', 'DESC')
        * def sortBy = karate.get('sortBy', 'TOTAL_USD')
        * def isHideSmallBalance = karate.get('isHideSmallBalance', false)
        * def data = 
        """
        {
            authorization: '#(requesterAccessToken)',
            params: { 
                isHideSmallBalance: #(isHideSmallBalance),
                keyword: #(keyword),
                limit: 10,
                offset: 0,
                sort: #(sort),
                sortBy: #(sortBy)
            }
        }
        """
        * call read(coreSvc + 'GetAllVaults') data
        Then match responseStatus == 200
        * match response.status == 'success'

      
    @GetDepositRouting
    Scenario: Get Deposit Routing
        * def keyword = karate.get('keyword', '')
        * def data =
        """
            {
                authorization: #(requesterAccessToken),
                params:{
                    keyword: '#(keyword)',
                    limit: 10,
                    offset: 0
                }
            }
        """
        * call read(svc + 'coreSvc.feature@GetDepositRouting') data
        Then match responseStatus == 200
        * match response.status == 'success'  
