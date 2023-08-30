@RAKCON-10583
Feature: Withdraw from WARM vault - Same and cross workspace

  Background:
    * url baseURL
    * def testData = read('classpath:data/data_test.json')
    * call read('RequesterAuthenticator.feature@RequesterAccessToken')
    * call read('Common.feature@CACULATE_LIMIT_TRANSFER')
    * def BigDecimal = Java.type('java.math.BigDecimal')

  @RAKCON-19300
  Scenario: WITHDRAW - Transfer WARM to WARM - CROSS workspace
  # 1.Select token for doing transfer
    * def getToken = call read('Transfer.feature@Get_asset_transfer')
    * def tokenId_transfer = getToken.response.data.tokens[0].id
    * def tokenSymbol = getToken.response.data.tokens[0].externalAssetId

  # 2.Select source
    * def screenType = 'SOURCE_TRANSFER'
    * def getSource = call read('Vault.feature@SearchVaultForTransfer')
    * def sourceId_warm = get[0] getSource.response.data.vaults[?(@.type=='HOT_WALLET')].id
    * def sourceName_warm = get[0] getSource.response.data.vaults[?(@.type=='HOT_WALLET')].name
    * def total = get[0] getSource.response.data.vaults[?(@.type=='HOT_WALLET')].wallets[0].total
    * def walletId_warm = get[0] getSource.response.data.vaults[?(@.type=='HOT_WALLET')].wallets[0].id

  # 3.Select destination from whitelist. The whitelist contains token from an other workspace
    * def folderName = "WARM_CROSS_WORKSPACE"
    * def getDestination = call read('this:WhiteListFolder.feature@Search_folder_by_keyword_common')
    * def destinationId_warm = get[0] getDestination.response.data.folders[?(@.name=='WARM_CROSS_WORKSPACE')].id
    * def destinationName_warm = get[0] getDestination.response.data.folders[?(@.name=='WARM_CROSS_WORKSPACE')].name

  # 3.1.Get total amount of destination token before doing transfer
    * def getBalanceTokenBeforeTransfer = call read('VerifyCrossWorkSpace.feature@GetBalanceTokenBeforeTransferDev')
    * def destinationAmountBefore = parseFloat(getBalanceTokenBeforeTransfer.response.data.total)

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

   # 7.Approve Transfer from admin quorum
    * call read('ApprovalRequest.feature@ApproveRequestCommon')

   # 8.Waiting to auto approve in fireblock
    * def sleep = function(millis) { java.lang.Thread.sleep(millis); }
    * eval sleep(120000)

   # 9.View transfer detail after complete
    * def getTransactionDetail = call read('Transaction.feature@View_transaction_detail_common')
    * def sourceAdress_from_sourceTransfer = getTransactionDetail.response.data.sourceAddress
    * def destinationAdress_from_sourceTransfer = getTransactionDetail.response.data.destinationAddress
   # --- Verify sourceName, destinationName
    * match sourceName_warm == getTransactionDetail.response.data.sourceName
    * match destinationName_warm == getTransactionDetail.response.data.destinationName
   # --- Verify Txn Type
    * match getTransactionDetail.response.data.status == "COMPLETED"

   # 9.1.Get the balance of source
    * def query_detail = { vaultId :'#(sourceId_warm)', walletId: '#(walletId_warm)'}
    * def getDetailTokenSource = call read('Wallet.feature@VIEW_TOKEN_DETAIL_COMMON')
    * def total_source_afterTransfer = parseFloat(getDetailTokenSource.response.data.total)
    # --- Verify the balance of source is updated correctly
    * match total_source_afterTransfer == total - amount_low

   # 9.2.Verify balance of destination && transaction show in destination
    * call read('VerifyCrossWorkSpace.feature@VerifyBalanceDestinationDev')

  @RAKCON-19301
  Scenario: WITHDRAW - Transfer WARM to COLD - CROSS workspace
  # 1.Select token for doing transfer
    * def getToken = call read('Transfer.feature@Get_asset_transfer')
    * def tokenId_transfer = getToken.response.data.tokens[0].id
    * def tokenSymbol = getToken.response.data.tokens[0].externalAssetId

  # 2.Select source
    * def screenType = 'SOURCE_TRANSFER'
    * def getSource = call read('Vault.feature@SearchVaultForTransfer')
    * def sourceId_warm = get[0] getSource.response.data.vaults[?(@.type=='HOT_WALLET')].id
    * def sourceName_warm = get[0] getSource.response.data.vaults[?(@.type=='HOT_WALLET')].name
    * def total = get[0] getSource.response.data.vaults[?(@.type=='HOT_WALLET')].wallets[0].total
    * def walletId_warm = get[0] getSource.response.data.vaults[?(@.type=='HOT_WALLET')].wallets[0].id

  # 3.Select destination from whitelist. The whitelist contains token from an other workspace
    * def folderName = "COLD_CROSS_WORKSPACE"
    * def getDestination = call read('this:WhiteListFolder.feature@Search_folder_by_keyword_common')
    * def destinationId_cold = get[0] getDestination.response.data.folders[?(@.name=='COLD_CROSS_WORKSPACE')].id
    * def destinationName_cold = get[0] getDestination.response.data.folders[?(@.name=='COLD_CROSS_WORKSPACE')].name

  # 3.1.Get total amount of destination token before doing transfer
    * def getBalanceTokenBeforeTransfer = call read('VerifyCrossWorkSpace.feature@GetBalanceTokenBeforeTransferUat')
    * def destinationAmountBefore = parseFloat(getBalanceTokenBeforeTransfer.response.data.total)

  # 4.Get estimated fee
    * def body_estimate_fee = { "assetId":'#(testData.transfer.withdraw.tokenSymbol)', "destinationType": '#(testData.transfer.destinationType)', "sourceType":'#(testData.transfer.source_type)', "sourceId": '#(sourceId_warm)',"amount":#(amount_low),"destinationId":'#(destinationId_cold)'}
    * def getEstimateFee = call read('Transfer.feature@Get_estimate_fee_common')
    * def fee = getEstimateFee.response.data.medium

  # 5.Caculate estimated fee
    * def body_total_estimate = { "assetId":'#(testData.transfer.withdraw.tokenSymbol)', "destinationType": '#(testData.transfer.destinationType)', "sourceType":'#(testData.transfer.source_type)', "sourceId": '#(sourceId_warm)',"amount":#(amount_low),"destinationId":'#(destinationId_cold)', "fee":'#(fee)',"isNetAmount":false}
    * def getCaculateFee = call read('Transfer.feature@Total_estimate_fee_common')
    * def totalEstimatedFee = getCaculateFee.response.data.totalEstimatedFee

  # 6.Submit transfer
    * def body_transfer = { "operation":'#(testData.transfer.operation)',"tokenId":'#(tokenId_transfer)',"feeType":'#(testData.transfer.withdraw.feeType)',"fee":'#(fee)', "treatAsGrossAmount": true, "feeLevel": '#(testData.transfer.feeLevel)', "destination":{"type":'#(testData.transfer.destinationType)',"id":'#(destinationId_cold)'}, "source": {"type":'#(testData.transfer.source_type)',"id":'#(sourceId_warm)'},"amount":#(amount_low),"totalEstimatedFee":'#(totalEstimatedFee)'}
    * call read('Transfer.feature@External_Transfer_Common')
    * match sourceName_warm == response.data.sourceName
    * match destinationName_cold == response.data.destinationName
    * def transactionId = response.data.id
    * def requestId = response.data.requestId

   # 7.Approve Transfer from admin quorum
    * call read('ApprovalRequest.feature@ApproveRequestCommon')

   # 8.Waiting to auto approve in fireblock
    * def sleep = function(millis) { java.lang.Thread.sleep(millis); }
    * eval sleep(120000)

   # 9.View transfer detail after complete
    * def getTransactionDetail = call read('Transaction.feature@View_transaction_detail_common')
    * def sourceAdress_from_sourceTransfer = getTransactionDetail.response.data.sourceAddress
    * def destinationAdress_from_sourceTransfer = getTransactionDetail.response.data.destinationAddress
   # --- Verify sourceName, destinationName
    * match sourceName_warm == getTransactionDetail.response.data.sourceName
    * match destinationName_cold == getTransactionDetail.response.data.destinationName
   # --- Verify Txn Type
    * match getTransactionDetail.response.data.status == "COMPLETED"

   # 9.1.Verify balance of source
    * def query_detail = { vaultId :'#(sourceId_warm)', walletId: '#(walletId_warm)'}
    * def getDetailTokenSource = call read('Wallet.feature@VIEW_TOKEN_DETAIL_COMMON')
    * def total_source_afterTransfer = parseFloat(getDetailTokenSource.response.data.total)
    # --- Verify the balance of source is updated correctly
    * match total_source_afterTransfer == total - amount_low

   # 9.2.Verify balance of destination && transaction show in destination
    * call read('VerifyCrossWorkSpace.feature@VerifyBalanceDestinationUat')

  @RAKCON-19302
  Scenario: WITHDRAW - Transfer WARM to WARM - SAME workspace (Different company)
  # 1.Select token for doing transfer
    * def getToken = call read('Transfer.feature@Get_asset_transfer')
    * def tokenId_transfer = getToken.response.data.tokens[0].id
    * def tokenSymbol = getToken.response.data.tokens[0].externalAssetId

  # 2.Select source
    * def screenType = 'SOURCE_TRANSFER'
    * def getSource = call read('Vault.feature@SearchVaultForTransfer')
    * def sourceId_warm = get[0] getSource.response.data.vaults[?(@.type=='HOT_WALLET')].id
    * def sourceName_warm = get[0] getSource.response.data.vaults[?(@.type=='HOT_WALLET')].name
    * def total = get[0] getSource.response.data.vaults[?(@.type=='HOT_WALLET')].wallets[0].total
    * def walletId_warm = get[0] getSource.response.data.vaults[?(@.type=='HOT_WALLET')].wallets[0].id

  # 3.Select destination from whitelist. The whitelist contains token from an other workspace
    * def folderName = "WARM_SAME_WORKSPACE"
    * def getDestination = call read('this:WhiteListFolder.feature@Search_folder_by_keyword_common')
    * def destinationId_warm = get[0] getDestination.response.data.folders[?(@.name=='WARM_SAME_WORKSPACE')].id
    * def destinationName_warm = get[0] getDestination.response.data.folders[?(@.name=='WARM_SAME_WORKSPACE')].name

  # 3.1.Get total amount of destination token before doing transfer
    * def getBalanceTokenBeforeTransfer = call read('VerifySameWorkSpace.feature@GetBalanceTokenBeforeTransfer')
    * def destinationAmountBefore = parseFloat(getBalanceTokenBeforeTransfer.response.data.total)

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

   # 7.Approve Transfer from admin quorum
    * call read('ApprovalRequest.feature@ApproveRequestCommon')

   # 8.Waiting to auto approve in fireblock
    * def sleep = function(millis) { java.lang.Thread.sleep(millis); }
    * eval sleep(120000)

   # 9.View transfer detail after complete
    * def getTransactionDetail = call read('Transaction.feature@View_transaction_detail_common')
    * def sourceAdress_from_sourceTransfer = getTransactionDetail.response.data.sourceAddress
    * def destinationAdress_from_sourceTransfer = getTransactionDetail.response.data.destinationAddress
   # --- Verify sourceName, destinationName
    * match sourceName_warm == getTransactionDetail.response.data.sourceName
    * match destinationName_warm == getTransactionDetail.response.data.destinationName
   # --- Verify Txn Type
    * match getTransactionDetail.response.data.status == "COMPLETED"

   # 9.1.Get the balance of source
    * def query_detail = { vaultId :'#(sourceId_warm)', walletId: '#(walletId_warm)'}
    * def getDetailTokenSource = call read('Wallet.feature@VIEW_TOKEN_DETAIL_COMMON')
    * def total_source_afterTransfer = parseFloat(getDetailTokenSource.response.data.total)
    # --- Verify the balance of source is updated correctly
    * match total_source_afterTransfer == total - amount_low

   # 9.2.Verify balance of destination && transaction show in destination
    * call read('VerifySameWorkSpace.feature@VerifyBalanceDestination')

    ######################### REBALANCE  #################################################################

  @RAKCON-19306
  Scenario: REBALANCE - Transfer WARM to WARM - SAME workspace
  # 1.Select token for doing transfer
    * def getToken = call read('Transfer.feature@Get_asset_transfer')
    * def tokenId_transfer = getToken.response.data.tokens[0].id
    * def tokenSymbol = getToken.response.data.tokens[0].externalAssetId

  # 2.Select source
    * def screenType = 'SOURCE_TRANSFER'
    * def getSource = call read('Vault.feature@SearchVaultForTransfer')
    * def sourceId_warm = get[0] getSource.response.data.vaults[?(@.type=='HOT_WALLET')].id
    * def sourceName_warm = get[0] getSource.response.data.vaults[?(@.type=='HOT_WALLET')].name
    * def total = get[0] getSource.response.data.vaults[?(@.type=='HOT_WALLET')].wallets[0].total
    * def walletId_warm = get[0] getSource.response.data.vaults[?(@.type=='HOT_WALLET')].wallets[0].id

  # 3.Select destination from internal.
    * def screenType = 'DESTINATION_TRANSFER'
    * def getSource = call read('Vault.feature@SearchVaultForTransfer')
    * def destinationId_warm = get[1] getSource.response.data.vaults[?(@.type=='HOT_WALLET')].id
    * def destinationName_warm = get[1] getSource.response.data.vaults[?(@.type=='HOT_WALLET')].name

  # Get total amount of destination token before doing transfer
    * def findWallet = get[1] getSource.response.data.vaults[?(@.type=='HOT_WALLET')]
    * def destinationAmountBefore = get[0] findWallet.wallets[?(@.externalAssetId=='XRP_TEST')].total
    * def walletId_destination = get[0] findWallet.wallets[?(@.externalAssetId=='XRP_TEST')].id

  # 4.Get estimated fee
    * def body_estimate_fee = { "assetId":'#(testData.transfer.withdraw.tokenSymbol)', "destinationType": '#(testData.transfer.destinationType)', "sourceType":'#(testData.transfer.source_type)', "sourceId": '#(sourceId_warm)',"amount":#(amount_low),"destinationId":'#(destinationId_warm)'}
    * def getEstimateFee = call read('Transfer.feature@Get_estimate_fee_common')
    * def fee = getEstimateFee.response.data.medium

  # 5.Caculate estimated fee
    * def body_total_estimate = { "assetId":'#(testData.transfer.withdraw.tokenSymbol)', "destinationType": '#(testData.transfer.destinationType)', "sourceType":'#(testData.transfer.source_type)', "sourceId": '#(sourceId_warm)',"amount":#(amount_low),"destinationId":'#(destinationId_warm)', "fee":'#(fee)',"isNetAmount":false}
    * def getCaculateFee = call read('Transfer.feature@Total_estimate_fee_common')
    * def totalEstimatedFee = getCaculateFee.response.data.totalEstimatedFee

  # 6.Submit transfer
    * def body = { "operation":'#(testData.transfer.operation)',"tokenId":'#(tokenId_transfer)',"feeType":'#(testData.transfer.withdraw.feeType)',"fee":'#(fee)', "treatAsGrossAmount": true, "feeLevel": '#(testData.transfer.feeLevel)', "destination":{"type":'#(testData.transfer.source_type)',"id":'#(destinationId_warm)'}, "source": {"type":'#(testData.transfer.source_type)',"id":'#(sourceId_warm)'},"amount":#(amount_low),"totalEstimatedFee":'#(totalEstimatedFee)'}
    * call read('Transfer.feature@Internal_Transfer_Common')
    * match sourceName_warm == response.data.sourceName
    * match destinationName_warm == response.data.destinationName
    * def transactionId = response.data.id
    * def requestId = response.data.requestId

   # 7.Approve Transfer from admin quorum
    * call read('ApprovalRequest.feature@ApproveRequestCommon')

   # 8.Waiting to auto approve in fireblock
    * def sleep = function(millis) { java.lang.Thread.sleep(millis); }
    * eval sleep(120000)

   # 9.View transfer detail after complete
    * def getTransactionDetail = call read('Transaction.feature@View_transaction_detail_common')
    * def sourceAdress_from_sourceTransfer = getTransactionDetail.response.data.sourceAddress
    * def destinationAdress_from_sourceTransfer = getTransactionDetail.response.data.destinationAddress
   # --- Verify sourceName, destinationName
    * match sourceName_warm == getTransactionDetail.response.data.sourceName
    * match destinationName_warm == getTransactionDetail.response.data.destinationName
   # --- Verify Txn Type
    * match getTransactionDetail.response.data.status == "COMPLETED"

   # 9.1.Get the balance of source
    * def query_detail = { vaultId :'#(sourceId_warm)', walletId: '#(walletId_warm)'}
    * def getDetailTokenSource = call read('Wallet.feature@VIEW_TOKEN_DETAIL_COMMON')
    * def total_source_afterTransfer = parseFloat(getDetailTokenSource.response.data.total)
    # --- Verify the balance of source is updated correctly
    * match total_source_afterTransfer == total - amount_low

   # 9.2.Get the balance of destination
    * def query_detail = { vaultId :'#(destinationId_warm)', walletId: '#(walletId_destination)'}
    * def getDetailTokenDestination = call read('Wallet.feature@VIEW_TOKEN_DETAIL_COMMON')
    * def total_destination_afterTransfer = parseFloat(getDetailTokenDestination.response.data.total)
    # --- Verify the balance of source is updated correctly
    * def amount_recieve = parseFloat(amount_low) - parseFloat(testData.transfer.withdraw.fee)
    * def totalExpectedDestination = amount_recieve + parseFloat(destinationAmountBefore)
    * match total_destination_afterTransfer.toFixed(4) == totalExpectedDestination.toFixed(4)


  @RAKCON-19332
  Scenario: REBALANCE - Transfer WARM to COLD - SAME workspace
  # 1.Select token for doing transfer
    * def getToken = call read('Transfer.feature@Get_asset_transfer')
    * def tokenId_transfer = getToken.response.data.tokens[0].id
    * def tokenSymbol = getToken.response.data.tokens[0].externalAssetId

  # 2.Select source
    * def screenType = 'SOURCE_TRANSFER'
    * def getSource = call read('Vault.feature@SearchVaultForTransfer')
    * def sourceId_warm = get[0] getSource.response.data.vaults[?(@.type=='HOT_WALLET')].id
    * def sourceName_warm = get[0] getSource.response.data.vaults[?(@.type=='HOT_WALLET')].name
    * def total = get[0] getSource.response.data.vaults[?(@.type=='HOT_WALLET')].wallets[0].total
    * def walletId_warm = get[0] getSource.response.data.vaults[?(@.type=='HOT_WALLET')].wallets[0].id

  # 3.Select destination from internal.
    * def screenType = 'DESTINATION_TRANSFER'
    * def getSource = call read('Vault.feature@SearchVaultForTransfer')
    * def destinationId_cold = get[0] getSource.response.data.vaults[?(@.type=='COLD_WALLET')].id
    * def destinationName_cold = get[0] getSource.response.data.vaults[?(@.type=='COLD_WALLET')].name

  # Get total amount of destination token before doing transfer
    * def findWallet = get[0] getSource.response.data.vaults[?(@.type=='COLD_WALLET')]
    * def destinationAmountBefore = get[0] findWallet.wallets[?(@.externalAssetId=='XRP_TEST')].total
    * def walletId_destination = get[0] findWallet.wallets[?(@.externalAssetId=='XRP_TEST')].id

  # 4.Get estimated fee
    * def body_estimate_fee = { "assetId":'#(testData.transfer.withdraw.tokenSymbol)', "destinationType": '#(testData.transfer.destinationType)', "sourceType":'#(testData.transfer.source_type)', "sourceId": '#(sourceId_warm)',"amount":#(amount_low),"destinationId":'#(destinationId_cold)'}
    * def getEstimateFee = call read('Transfer.feature@Get_estimate_fee_common')
    * def fee = getEstimateFee.response.data.medium

  # 5.Caculate estimated fee
    * def body_total_estimate = { "assetId":'#(testData.transfer.withdraw.tokenSymbol)', "destinationType": '#(testData.transfer.destinationType)', "sourceType":'#(testData.transfer.source_type)', "sourceId": '#(sourceId_warm)',"amount":#(amount_low),"destinationId":'#(destinationId_cold)', "fee":'#(fee)',"isNetAmount":false}
    * def getCaculateFee = call read('Transfer.feature@Total_estimate_fee_common')
    * def totalEstimatedFee = getCaculateFee.response.data.totalEstimatedFee

  # 6.Submit transfer
    * def body = { "operation":'#(testData.transfer.operation)',"tokenId":'#(tokenId_transfer)',"feeType":'#(testData.transfer.withdraw.feeType)',"fee":'#(fee)', "treatAsGrossAmount": true, "feeLevel": '#(testData.transfer.feeLevel)', "destination":{"type":'#(testData.transfer.source_type)',"id":'#(destinationId_cold)'}, "source": {"type":'#(testData.transfer.source_type)',"id":'#(sourceId_warm)'},"amount":#(amount_low),"totalEstimatedFee":'#(totalEstimatedFee)'}
    * call read('Transfer.feature@Internal_Transfer_Common')
    * match sourceName_warm == response.data.sourceName
    * match destinationName_cold == response.data.destinationName
    * def transactionId = response.data.id
    * def requestId = response.data.requestId

   # 7.Approve Transfer from admin quorum
    * call read('ApprovalRequest.feature@ApproveRequestCommon')

   # 8.Waiting to auto approve in fireblock
    * def sleep = function(millis) { java.lang.Thread.sleep(millis); }
    * eval sleep(120000)

   # 9.View transfer detail after complete
    * def getTransactionDetail = call read('Transaction.feature@View_transaction_detail_common')
    * def sourceAdress_from_sourceTransfer = getTransactionDetail.response.data.sourceAddress
    * def destinationAdress_from_sourceTransfer = getTransactionDetail.response.data.destinationAddress
   # --- Verify sourceName, destinationName
    * match sourceName_warm == getTransactionDetail.response.data.sourceName
    * match destinationName_cold == getTransactionDetail.response.data.destinationName
   # --- Verify Txn Type
    * match getTransactionDetail.response.data.status == "COMPLETED"

   # 9.1.Get the balance of source
    * def query_detail = { vaultId :'#(sourceId_warm)', walletId: '#(walletId_warm)'}
    * def getDetailTokenSource = call read('Wallet.feature@VIEW_TOKEN_DETAIL_COMMON')
    * def total_source_afterTransfer = parseFloat(getDetailTokenSource.response.data.total)
    # --- Verify the balance of source is updated correctly
    * match total_source_afterTransfer == total - amount_low

   # 9.2.Get the balance of destination
    * def query_detail = { vaultId :'#(destinationId_cold)', walletId: '#(walletId_destination)'}
    * def getDetailTokenDestination = call read('Wallet.feature@VIEW_TOKEN_DETAIL_COMMON')
    * def total_destination_afterTransfer = parseFloat(getDetailTokenDestination.response.data.total)
    # --- Verify the balance of source is updated correctly
    * def amount_recieve = parseFloat(amount_low) - parseFloat(testData.transfer.withdraw.fee)
    * def totalExpectedDestination = amount_recieve + parseFloat(destinationAmountBefore)
    * match total_destination_afterTransfer.toFixed(4) == totalExpectedDestination.toFixed(4)




