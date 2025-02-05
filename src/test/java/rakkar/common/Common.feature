Feature: Common Feature

    Background:
        * callonce read(svc + 'ReadData.feature')
        * callonce read(svc + 'Auth.feature@GetRequesterAccessToken')
        * callonce read(svc + 'Auth.feature@GetListUsers')
        * def requestHandle = read('classpath:rakkar/common/RequestHandle.js')

    @CancelAllRequests
    Scenario: Cancel all request
        * requestHandle().cancelAllMyPendingRequest(requesterUserID)

    @RejectAllRequests
    Scenario: Reject all request
        * requestHandle().rejectAllPendingRequest()

    @Deposit
    Scenario: Deposit to test vault
        * call read(svc + 'testnet.feature@DepositXRP') {address:"#(dataSet.address)"}
        * def vaults = call read(svc + 'Vault.feature@GetListVault_v2') {searchText: "#(testData.stdVaultE2E)"}
        * def vaultWallet = vaults.response.data.list[0].wallets.find(x => x.symbol == 'XRP')
        * def wallet = call read(svc + 'Wallet.feature@GetWalletAddress') {vaultId:"#(vaults.response.data.list[0].id)",walletId:"#(vaultWallet.id)"}
        * call read(svc + 'testnet.feature@DepositXRP') {address:"#(wallet.response.data.address[0].address)"}

    @CancelAllTranferRequests
    Scenario: Cancel all request
        * requestHandle().cancelAllMyTransferPendingRequest(requesterUserID)


    @ApproveRequestCommon
    Scenario: Approve request by id
        * requestHandle().approveTransaction('35b32145-df57-4db6-9992-25a3f2e20cf8')

    @UpdateExistingNetworkToPrivate
    Scenario: Update Existing Network To Private
        * def userInfo = call read(svc + 'Auth.feature@GetRequesterInfo')
        * def data = 
        """
        {
            customerId: '#(userInfo.response.data.customerId)'
        }
        """
        * def listNetworks = call read(connectDB + '@SelectDiscoverableNetwork') data
        * print listNetworks.result.length
        * eval for(var i = 0; i<listNetworks.result.length; i++) karate.call(svc + 'Network.feature@SetNetworkProfileSetting', {networkId: listNetworks.result[i].id})

    @DeleteAllTestGroups
    Scenario: Delete all test groups
        * def getGroups = call read(svc + 'Group.feature@GetGroupPolicies') {keyword:'AT-RAK-GR'}
        * def groups = getGroups.response.data.groups
        * print groups.length
        * def groupHandle = read('classpath:rakkar/common/GroupHandle.js')
        * eval for(var i = 0; i<groups.length; i++) groupHandle().deleteGroupById(groups[i].id)

    @ApproveAllRequest
    Scenario: Approve All Request
        * callonce read(svc + 'Auth.feature@GetApproverAccessToken')
        * def getTxn = call read(svc + 'Quorums.feature@Approver_GetApprovalList') { status: ["PENDING"] }
        * eval
        """
        for (var i=0; i<getTxn.response.data.total; i++) 
        { 
            if (i<10) requestHandle().approveTransaction(getTxn.response.data.records[i].id)
        }
        """

    @GetChallengeAnswer
    Scenario: Get Challenge Answer
        * call read(svc + 'Biometric.feature@UserDoBiometric') {userName: 'PASSPORT333333HK'}
        
