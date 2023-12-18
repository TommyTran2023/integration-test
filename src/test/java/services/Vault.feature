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

    @GetPortfolioValueChart
    Scenario: Get portfolio value chart 
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
        {
            authorization: #(accessToken),
            params:{
                dateFrom:#(dateFrom),
                dateTo:#(dateTo)
            }
        }
        """
        * call read(svc + 'coreSvc.feature@GetPortfolioValueChart') data

    @GetAccountChart
    Scenario: Get account chart
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * call read(svc + 'coreSvc.feature@GetAccountChart') {authorization:#(accessToken)}

    @CancelReqTransactionCreateFromWeb
    Scenario: Cancel request create vault from web
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
        {
            authorization: #(accessToken),
            body:{
                notificationId:#(notificationId),
                requestCancelFrom:#(requestCancelFrom)
            }
        }
        """
        * call read(svc + 'coreSvc.feature@CancelReqTransactionCreateFromWeb') data

    @CheckVaultName
    Scenario: Check Vault Name Exists
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
        {
            authorization: #(accessToken),
            name: #(name)
        }
        """
        * call read(svc + 'coreSvc.feature@CheckVaultName') data
        
    @GetChartOfVault
    Scenario: Get chart of vault
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
        {
            authorization: #(accessToken),
            vaultId: #(vaultId)
        }
        """
        * call read(svc + 'coreSvc.feature@GetChartOfVault') data

    @RenameVault
    Scenario: Rename vault 
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
        {
            authorization: #(accessToken),
            vaultId: #(vaultId),
            name: #(name)
        }
        """
        * call read(svc + 'coreSvc.feature@RenameVault') data
    
    @GetListUserForVaults
    Scenario: Get list user for Vaults
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def keyword = karate.get('keyword', '')
        * def sort = karate.get('sort', 'ASC')
        * def forWeb = karate.get('forWeb', false)
        * def data =
        """
        {
            authorization: #(accessToken),
            body:{
                limit : 10,
                offset : 0,
                sort : '#(sort)',
                keyword : '#(keyword)',
                forWeb : #(forWeb)
            }
        }
        """
        * call read(svc + 'coreSvc.feature@GetListUserForVaults') data
    
    @GetListVaultUnassigned
    Scenario: Get list vault unassigned by user
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def keyword = karate.get('keyword', '')
        * def sort = karate.get('sort', 'ASC')
        * def data =
        """
        {
            authorization: #(accessToken),
            params:{
                limit : 10,
                offset : 0,
                sort : '#(sort)',
                keyword : '#(keyword)',
                userId : #(userId)
            }
        }
        """
        * call read(svc + 'coreSvc.feature@GetListVaultUnassigned') data
        Then match responseStatus == 200
        And match response.status == "success"
        And match response.code == 200
    
    @GetVaultOnlyViewMemberAndQuorum
    Scenario: Detail vault info with info quorum
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * call read(svc + 'coreSvc.feature@GetVaultOnlyViewMemberAndQuorum') {authorization: #(accessToken)}
    
    @ListVaultMissingPolicy
    Scenario: Listing Vault Missing Policy
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def keyword = karate.get('keyword', '')
        * def sort = karate.get('sort', 'ASC')
        * def groupBy = karate.get('groupBy', '')
        * def tokenSymbol = karate.get('tokenSymbol', 'XRP')
        * def onlyVaultType = karate.get('onlyVaultType', '')
        * def data =
        """
        {
            authorization: #(accessToken),
            body:{
                limit : 10,
                offset : 0,
                sort : '#(sort)',
                groupBy : '#(groupBy)',
                keyword : '#(keyword)',
                tokenSymbol : '#(tokenSymbol)',
                onlyVaultType : '#(onlyVaultType)',
                userId : #(userId)
            }
        }
        """
        * call read(svc + 'coreSvc.feature@ListVaultMissingPolicy') data
    
    @GetListVaultStake
    Scenario: Get List Vault Stake
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def keyword = karate.get('keyword', '')
        * def sort = karate.get('sort', 'ASC')
        * def data =
        """
        {
            authorization: #(accessToken),
            body:{
                limit : 10,
                offset : 0,
                sort : '#(sort)',
                keyword : '#(keyword)',
            }
        }
        """
        * call read(svc + 'coreSvc.feature@GetListVaultStake') data
    
    @GetListStakingByToken
    Scenario: Get List Vault Stake
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def keyword = karate.get('keyword', '')
        * def sort = karate.get('sort', 'ASC')
        * def data =
        """
        {
            authorization: #(accessToken),
            tokenId: #(tokenId),
            body:{
                limit : 10,
                offset : 0,
                sort : '#(sort)',
                keyword : '#(keyword)',
            }
        }
        """
        * call read(svc + 'coreSvc.feature@GetListStakingByToken') data
    
    @RequestUpdateVaultPolicy
    Scenario: Request Update Vault Policy
        * def note = karate.get('note', 'test')
        * def expiredAt = karate.get('expiredAt', '')
        * def approverNumber = karate.get('approverNumber', 2)
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
        {
            authorization: #(accessToken),
            vaultId: #(vaultId),
            body:{
                approverNumber : #(approverNumber),
                policyType : #(policyType),
                quorums : #(quorums),
                viewers : #(viewers),
                clientId : #(clientId),
                note : #(note),
                vaultId : #(vaultId),
                expiredAt : #(expiredAt)
            }
        }
        """
        * call read(svc + 'coreSvc.feature@RequestUpdateVaultPolicy') data
        Then match responseStatus == 201
        * match response.status == 'success' 
    
    @GetRequestEditVaultPolicyByRequestDraftId
    Scenario: Get Request Edit Vault Policy By Request Draft Id
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
        {
            authorization: #(accessToken),
            vaultId: #(vaultId),
            requestDraftId: #(requestDraftId)
        }
        """
        * call read(svc + 'coreSvc.feature@GetRequestEditVaultPolicyByRequestDraftId') data
    
    @SubmitRequestEditVaultPolicyByRequestDraftId
    Scenario: Submit Request Edit Vault Policy By Request Draft Id
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
        {
            authorization: #(accessToken),
            vaultId: #(vaultId),
            requestDraftId: #(requestDraftId)
        }
        """
        * call read(svc + 'coreSvc.feature@SubmitRequestEditVaultPolicyByRequestDraftId') data

    @DiscardRequestEditVaultPolicyByRequestDraftId
    Scenario: Discard Request Edit Vault Policy By Request Draft Id
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
        {
            authorization: #(accessToken),
            vaultId: #(vaultId),
            requestDraftId: #(requestDraftId)
        }
        """
        * call read(svc + 'coreSvc.feature@SubmitRequestEditVaultPolicyByRequestDraftId') data
           

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

    @HideVault
    Scenario: Hide a vault
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
        {
            authorization: #(accessToken),
            vaultId: #(vaultId)
        }
        """
        * call read(svc + 'coreSvc.feature@HideVault') data
        Then match responseStatus == 200
        * match response.status == 'success'
        
    @UnhideVault
    Scenario: UnhideVault a vault
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
        {
            authorization: #(accessToken),
            vaultId: #(vaultId)
        }
        """
        * call read(svc + 'coreSvc.feature@UnhideVault') data
        Then match responseStatus == 200
        * match response.status == 'success'
       
    @EditVaultPolicy
    Scenario: UnhideVault a vault
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
        {
            authorization: #(accessToken),
            vaultId: #(vaultId),
            body:{
                "memberIds": #(members), 
                "note" : "#(note)", 
                "approveNumber" : #(members.length), 
                "memberRequireIds" : [ ]
            }
        }
        """
        * call read(svc + 'coreSvc.feature@EditVaultPolicy') data
        Then match responseStatus == 200
        * match response.status == 'success'