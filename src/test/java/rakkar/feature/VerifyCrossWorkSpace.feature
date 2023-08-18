@ignore @RAKCON-10583
Feature: Verify after transfer cross workspace

  Background:
    * def testData = read('classpath:data/cross_workspace_data.json')
    * def getDate =
      """
      function(numberOfDays){
        var date = new Date();
        date.setDate(date.getDate() + (numberOfDays));
        return date.toISOString()
      }
      """
    * def dateFrom = getDate(-30)
    * def dateTo = getDate(-1)

  @GetBalanceTokenBeforeTransferDev
  Scenario: Get balance token before transfer in Dev workspace
    * call read('CrossWorkSpaceAuthenticator.feature@RequesterAccessTokenDev')
    * def query_detail = { vaultId :'#(testData.dev_workspace.vaultId_Destination)', walletId: '#(testData.dev_workspace.walletId_Destination)'}
    * call read('Wallet.feature@VIEW_TOKEN_DETAIL_COMMON')

  @VerifyBalanceDestinationDev
  Scenario: Verify balance for destination in Dev workspace
    * call read('CrossWorkSpaceAuthenticator.feature@RequesterAccessTokenDev')
#    Verify balance updated correct
    * def query_detail = { vaultId :'#(testData.dev_workspace.vaultId_Destination)', walletId: '#(testData.dev_workspace.walletId_Destination)'}
    * def getDestinationToken = call read('Wallet.feature@VIEW_TOKEN_DETAIL_COMMON')
    * match getDestinationToken.response.data.totalUSD = destinationAmountBefore + '#(Number(amount_low))'
#    Get recent transaction to check destination show in transaction
    * def query = { dateFrom:'#(dateFrom)', assetId: ['#(assetId_destination)'], status : ['COMPLETED'], vaultId: '#(testData.uat_workspace.vaultId_Destination)', offset: 0, dateTo: '#(dateTo)', limit: 10 }
    * def recentTransaction = call read('Transaction.feature@Filter_transaction_common')
    * def dataTransaction =  get[0] recentTransaction.response.data.transactions[?(@.id=='#(transactionId')]

  @GetBalanceTokenBeforeTransferUat
  Scenario: Get balance token before transfer in UAT workspace
    * call read('CrossWorkSpaceAuthenticator.feature@RequesterAccessTokenUat')
    * def query_detail = { vaultId :'#(testData.dev_workspace.vaultId_Destination)', walletId: '#(testData.dev_workspace.walletId_Destination)'}
    * call read('Wallet.feature@VIEW_TOKEN_DETAIL_COMMON')

  @VerifyBalanceDestinationUat
  Scenario: Verify balance for destination in Uat workspace
    * call read('CrossWorkSpaceAuthenticator.feature@RequesterAccessTokenUat')
#    Verify balance updated correct
    * def query_detail = { vaultId :'#(testData.uat_workspace.vaultId_Destination)', walletId: '#(testData.uat_workspace.walletId_Destination)'}
    * call read('Wallet.feature@VIEW_TOKEN_DETAIL_COMMON')
    * match getDestinationToken.response.data.totalUSD = destinationAmountBefore + '#(Number(amount_low))'
#    Get recent transaction to check destination show in transaction
    * def query = { dateFrom:'#(dateFrom)', assetId: ['#(assetId_destination)'], status : ['COMPLETED'], vaultId: '#(testData.uat_workspace.vaultId_Destination)', offset: 0, dateTo: '#(dateTo)', limit: 10 }
    * call read('Transaction.feature@Filter_transaction_common')
    * def dataTransaction =  get[0] recentTransaction.response.data.transactions[?(@.id=='#(transactionId')]


