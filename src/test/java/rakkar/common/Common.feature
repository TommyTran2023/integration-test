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

    @ApproveTransactionCommon
    Scenario: Approve transaction by id
        * requestHandle().approveTransaction('3c30fa61-9178-4d00-ab3f-51b8bebd2dc5')
