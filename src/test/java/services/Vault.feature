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

    @GetAllVaults_TransferScreen
    Scenario: Get Source vaults
        * callonce read(svc + 'ReadData.feature@ReadEnumFile')
        * def keyword = karate.get('keyword', '')
        * def sort = karate.get('sort', 'DESC')
        * def tokenSymbol = karate.get('tokenSymbol', Const.TokenSymbol.XRP)
        * def isHideSmallBalance = karate.get('isHideSmallBalance', false)
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: '#(accessToken)',
            params: { 
                fromScreen: #(fromScreen),
                groupBy: #(Const.Transfer.GroupBy.VAULT),
                keyword: #(keyword),
                limit: 10,
                offset: 0,
                sort: #(sort),
                tokenSymbol: #(tokenSymbol)
            }
        }
        """
        * print data
        * call read(coreSvc + 'GetAllVaults') data
        Then match responseStatus == 200
        * match response.status == 'success'
        * karate.set('keyword', null)
        * karate.set('accessToken',null)
      
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
    
    @RequestUpdateVaultPolicy
    Scenario: Request update vault policy
        * def note = karate.get('note', 'test')
        * def approverNumber = karate.get('approverNumber', 2)
        * def data = 
        """
        {
            authorization: #(requesterAccessToken),
            vaultId: #(vaultId),
            "requestBody":{
                "approverNumber": #(approverNumber),
                "note": "#(note)",
                "clientId": "#(clientId)",
                "quorums": #(quorums),
                "policyType": "#(policyType)",
                "viewers": #(viewers)
            }
        }
        """
        * call read(svc + 'coreSvc.feature@RequestUpdateVaultPolicy') data
        Then match responseStatus == 201
        * match response.status == 'success'  

    @ReadUpdateVaultRequest
    Scenario: Read Update Vault Request
        * def data = 
        """
        {
            authorization: #(requesterAccessToken),
            vaultId: #(vaultId),
            requestDraftId: #(requestDraftId)
        }
        """
        * call read(svc + 'coreSvc.feature@ReadUpdateVaultRequest') data
        Then match responseStatus == 200
        * match response.status == 'success'

    @SubmitUpdateVaultRequest
    Scenario: Submit Update Vault Request
        * def data = 
        """
        {
            authorization: #(requesterAccessToken),
            vaultId: #(vaultId),
            requestDraftId: #(requestDraftId),
            challengeAnswer: '#(challengeAnswerRequest)',
            passcode: '#(requesterInfo.requesterPasscode)'
        }
        """
        * call read(svc + 'coreSvc.feature@SubmitUpdateVaultRequest') data
        Then match responseStatus == 200
        * match response.status == 'success'

    @CancelUpdateVaultRequest
    Scenario: Submit Update Vault Request
        * def data = 
        """
        {
            authorization: #(requesterAccessToken),
            vaultId: #(vaultId),
            requestDraftId: #(requestDraftId),
            challengeAnswer: '#(challengeAnswerRequest)'
        }
        """
        * call read(svc + 'coreSvc.feature@CancelUpdateVaultRequest') data
        Then match responseStatus == 200
        * match response.status == 'success'

    @GetListVault_v2
    Scenario: Get List Vault v2
        * def data =
        """
        {
            authorization: #(typeof accessToken != 'undefined' ? accessToken: requesterAccessToken),
            params:{
                limit: #(typeof limit != 'undefined' ? limit : 10),
                offset: #(typeof offset != 'undefined' ? offset : 0),
                sort: #(typeof sort != 'undefined' ? sort : 'DESC'),
                sortBy: #(typeof sortBy != 'undefined' ? sortBy : 'VAULT_NAME'),
                searchText: #(typeof searchText != 'undefined' ? searchText : ''),
                isShowSignificanceOnly: #(typeof isShowSignificanceOnly != 'undefined' ? isShowSignificanceOnly :false),
                isArchived: #(typeof isArchived != 'undefined' ? isArchived : false)
            }
        }
        """
        * call read(svc + 'coreSvc.feature@GetListVault_v2') data
        Then match responseStatus == 200
        * match response.status == 'success'
        * match response.message == 'OK'

    @GetVaultsSummary
    Scenario: Get Vaults Summary
        * def data =
        """
        {
            authorization: #(typeof accessToken != 'undefined' ? accessToken: requesterAccessToken)
        }
        """
        * call read(svc + 'coreSvc.feature@GetVaultsSummary') data
        Then match responseStatus == 200
        * match response.status == 'success'
        * match response.message == 'OK'

