@ignore @RAKCON-10583
Feature: Transfer cross workspace

  Background:
    * url baseURL
    * def testData = read('classpath:data/data_test.json')
    * call read('RequesterAuthenticator.feature@RequesterAccessToken')
    * call read('GetUserInfo.feature@GetUserInfo')
    * call read('Common.feature@CACULATE_LIMIT_TRANSFER')

  Scenario: Transfer WARM to WARM - Cross workspace
  # 1.Select token for doing transfer
    * def getToken = call read('Transfer.feature@Get_asset_transfer')
    * def tokenId_transfer = getToken.response.data.tokens[0].id
    * def tokenSymbol = getToken.response.data.tokens[0].externalAssetId

  # 2.Select source
    * def screenType = 'SOURCE_TRANSFER'
    * def getSource = call read('Vault.feature@SearchVaultForTransfer')
    * def sourceId_warm = get[0] getSource.response.data.vaults[?(@.type=='HOT_WALLET')].id
    * def sourceName_warm = get[0] getSource.response.data.vaults[?(@.type=='HOT_WALLET')].name
    * def totalUSD = get[0] getSource.response.data.vaults[?(@.type=='HOT_WALLET')].wallets[0].totalUSD
    * def walletId_warm = get[0] getSource.response.data.vaults[?(@.type=='HOT_WALLET')].wallets[0].id

  # 3.Select destination from whitelist. The whitelist contains token from an other workspace
    * def folderName = "WARM_CROSS_WORKSPACE"
    * def getDestination = call read('this:WhiteListFolder.feature@Search_folder_by_keyword_common')
    * def destinationId_warm = get[0] getDestination.response.data.folders[?(@.name=='WARM_CROSS_WORKSPACE')].id
    * def destinationName_warm = get[0] getDestination.response.data.folders[?(@.name=='WARM_CROSS_WORKSPACE')].name

  # 3.1.Get total amount of destination token before doing transfer
    * def getBalanceTokenBeforeTransfer = call read('VerifyCrossWorkSpace.feature@GetBalanceTokenBeforeTransfer')
    * def destinationAmountBefore = getBalanceTokenBeforeTransfer.response.data.totalUSD

  # 4.Get estimated fee
    * def body_estimate_fee = { "assetId":'#(testData.transfer.withdraw.tokenSymbol)', "destinationType": '#(testData.transfer.destinationType)', "sourceType":'#(testData.transfer.source_type)', "sourceId": '#(sourceId_warm)',"amount":#(amount_low),"destinationId":'#(destinationId_warm)'}
    * def getEstimateFee = call read('Transfer.feature@Get_estimate_fee_common')
    * def fee = getEstimateFee.response.data.medium

  # 5.Caculate estimated fee
    * def body_total_estimate = { "assetId":'#(testData.transfer.withdraw.tokenSymbol)', "destinationType": '#(testData.transfer.destinationType)', "sourceType":'#(testData.transfer.source_type)', "sourceId": '#(sourceId_warm)',"amount":#(amount_low),"destinationId":'#(destinationId_warm)', "fee":'#(fee)',"isNetAmount":false}
    * def getCaculateFee = call read('Transfer.feature@Total_estimate_fee_common')
    * def totalEstimatedFee = getCaculateFee.response.data.totalEstimatedFee

  # 6.Submit transfer
    * def body_transfer = { "operation":'#(testData.transfer.operation)',"tokenId":'#(tokenId_transfer)',"feeType":'#(testData.transfer.withdraw.feeType)',"fee":'#(fee)', "treatAsGrossAmount": true, "feeLevel": '#(testData.transfer.feeLevel)', "destination":{"type":'#(testData.transfer.destinationType)',"id":'#(destinationId_warm)'}, "source": {"type":'#(testData.transfer.source_type)',"id":'#(sourceId_warm)'},"amount":#(amount_low),"totalEstimatedFee":'#(totalEstimatedFee)'}
    * call read('Transfer.feature@External_Transfer_Common')
    * match sourceName_warm == response.data.sourceName
    * match destinationName_warm == response.data.destinationName
    * def transactionId = response.data.id
    * def requestId = response.data.requestId

   # 7.View transfer detail after submit
    * def getTransactionDetail = call read('Transaction.feature@View_transaction_detail_common')
    * match sourceName_warm == response.data.sourceName
    * match destinationName_warm == response.data.destinationName

   # 8.Approve Transfer from admin quorum
    * call read('ApprovalRequest.feature@ApproveRequestCommon')

   # 9.1.Verify balance of source
    * def query_detail = { vaultId :'#(sourceId_warm)', walletId: '#(walletId_warm)'}
    * def getDetailTokenSource = call read('Wallet.feature@VIEW_TOKEN_DETAIL_COMMON')
    * match getDetailVaultSource.response.data.totalUSD = totalUSD - '#(Number(amount_low))'

   # 9.2.Verify balance of destination && transaction show in destination
    * call read('VerifyCrossWorkSpace.feature@VerifyBalanceDestinationDev')




