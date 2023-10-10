@RAKCON-10583 @e2e
Feature: Withdraw from WARM vault - Same and cross workspace

  Background:
    * url baseURL
    * def classpath = 'classpath:rakkar/feature/'
    * def testData = read('classpath:data/data_test.json')
    * def Const = read('classpath:data/enum.json')
    * call read(classpath + 'RequesterAuthenticator.feature@RequesterAccessToken')
    * call read(classpath + 'Common.feature@CACULATE_LIMIT_TRANSFER')
    * def BigDecimal = Java.type('java.math.BigDecimal')
    * def sleep = function() { java.lang.Thread.sleep(120000); }

  @RAKCON-19300
  Scenario: WITHDRAW - Transfer WARM to WARM - CROSS workspace
  # 1.Select token for doing transfer
    * def getToken = call read(classpath + 'Transfer.feature@Get_asset_transfer')
    * def tokenId_transfer = getToken.response.data.tokens[0].id
    * def tokenSymbol = getToken.response.data.tokens[0].externalAssetId

  # 2.Select source
    * def screenType = Const.Transfer.FromScreen.SOURCE
    * def vaultType = Const.Vault.VaultType.HOT_WALLET
    * def getSource = call read(classpath + 'Vault.feature@SearchVaultForTransfer')
    * def source_warm = karate.jsonPath(getSource.response.data, "$.vaults[?(@.type=='"+ vaultType +"')]")[0]
    * def sourceId_warm = source_warm.id
    * def sourceName_warm = source_warm.name
    * def total = source_warm.wallets[0].total
    * def walletId_warm = source_warm.wallets[0].id

  # 3.Select destination from whitelist. The whitelist contains token from an other workspace
    * def folderName = "WARM_CROSS_WORKSPACE"
    * def getDestination = call read(classpath + 'WhiteListFolder.feature@Search_folder_by_keyword_common')
    * def destination_warm = karate.jsonPath(getDestination.response.data, "$.folders[?(@.name=='"+ folderName +"')]")[0]
    * def destinationId_warm = destination_warm.id
    * def destinationName_warm = destination_warm.name

  # 3.1.Get total amount of destination token before doing transfer
    * def getBalanceTokenBeforeTransfer = call read('this:VerifyCrossWorkSpace.feature@GetBalanceTokenBeforeTransferDev')
    * def destinationAmountBefore = parseFloat(getBalanceTokenBeforeTransfer.response.data.total)

  # 4.Get estimated fee
    * def body_estimate_fee = { "assetId":'#(testData.transfer.withdraw.tokenSymbol)', "destinationType": '#(testData.transfer.destinationType)', "sourceType":'#(testData.transfer.source_type)', "sourceId": '#(sourceId_warm)',"amount":#(amount_low),"destinationId":'#(destinationId_warm)'}
    * def getEstimateFee = call read(classpath + 'Transfer.feature@Get_estimate_fee_common') {body_estimate_fee: body_estimate_fee}
    * def fee = getEstimateFee.response.data.medium

  # 5.Caculate estimated fee
    * def body_total_estimate = { "assetId":'#(testData.transfer.withdraw.tokenSymbol)', "destinationType": '#(testData.transfer.destinationType)', "sourceType":'#(testData.transfer.source_type)', "sourceId": '#(sourceId_warm)',"amount":#(amount_low),"destinationId":'#(destinationId_warm)', "fee":'#(fee)',"isNetAmount":false}
    * def getCaculateFee = call read(classpath + 'Transfer.feature@Total_estimate_fee_common') {body_estimate_fee: body_estimate_fee}
    * def totalEstimatedFee = getCaculateFee.response.data.totalEstimatedFee

  # 6.Submit transfer
    * def body_transfer = { "operation":'#(testData.transfer.operation)',"tokenId":'#(tokenId_transfer)',"feeType":'#(testData.transfer.withdraw.feeType)',"fee":'#(fee)', "treatAsGrossAmount": true, "feeLevel": '#(testData.transfer.feeLevel)', "destination":{"type":'#(testData.transfer.destinationType)',"id":'#(destinationId_warm)'}, "source": {"type":'#(testData.transfer.source_type)',"id":'#(sourceId_warm)'},"amount":#(amount_low),"totalEstimatedFee":'#(totalEstimatedFee)'}
    * call read(classpath +'Transfer.feature@External_Transfer_Common')
    * match sourceName_warm == response.data.sourceName
    * match destinationName_warm == response.data.destinationName
    * def transactionId = response.data.id
    * def requestId = response.data.requestId

   # 7.Approve Transfer from admin quorum
    * call read(classpath +'ApprovalRequest.feature@ApproveRequestCommon')

   # 8.Waiting to auto approve in fireblock
    * eval sleep()

   # 9.View transfer detail after complete
    * def getTransactionDetail = call read(classpath +'Transaction.feature@View_transaction_detail_common')
    * def sourceAdress_from_sourceTransfer = getTransactionDetail.response.data.sourceAddress
    * def destinationAdress_from_sourceTransfer = getTransactionDetail.response.data.destinationAddress
   # --- Verify sourceName, destinationName
    * match sourceName_warm == getTransactionDetail.response.data.sourceName
    * match destinationName_warm == getTransactionDetail.response.data.destinationName
   # --- Verify Txn Type
    * match getTransactionDetail.response.data.status == "COMPLETED"

   # 9.1.Get the balance of source
    * def query_detail = { vaultId :'#(sourceId_warm)', walletId: '#(walletId_warm)'}
    * def getDetailTokenSource = call read(classpath +'Wallet.feature@VIEW_TOKEN_DETAIL_COMMON')
    * def total_source_afterTransfer = parseFloat(getDetailTokenSource.response.data.total)
    # --- Verify the balance of source is updated correctly
    * match total_source_afterTransfer == total - amount_low

   # 9.2.Verify balance of destination && transaction show in destination
    * call read('this:VerifyCrossWorkSpace.feature@VerifyBalanceDestinationDev')

  @RAKCON-19301 
  Scenario: WITHDRAW - Transfer WARM to COLD - CROSS workspace
  # 1.Select token for doing transfer
    * def getToken = call read(classpath +'Transfer.feature@Get_asset_transfer')
    * def tokenId_transfer = getToken.response.data.tokens[0].id
    * def tokenSymbol = getToken.response.data.tokens[0].externalAssetId

  # 2.Select source
    * def screenType = Const.Transfer.FromScreen.SOURCE
    * def vaultType = Const.Vault.VaultType.HOT_WALLET
    * def getSource = call read(classpath + 'Vault.feature@SearchVaultForTransfer')
    * def source_warm = karate.jsonPath(getSource.response.data, "$.vaults[?(@.type=='"+ vaultType +"')]")[0]
    * def sourceId_warm = source_warm.id
    * def sourceName_warm = source_warm.name
    * def total = source_warm.wallets[0].total
    * def walletId_warm = source_warm.wallets[0].id

  # 3.Select destination from whitelist. The whitelist contains token from an other workspace
    * def folderName = "COLD_CROSS_WORKSPACE"
    * def getDestination = call read(classpath + 'WhiteListFolder.feature@Search_folder_by_keyword_common')
    * def destination_cold = karate.jsonPath(getDestination.response.data, "$.folders[?(@.name=='"+ folderName +"')]")[0]
    * def destinationId_cold = destination_cold.id
    * def destinationName_cold = destination_cold.name

  # 3.1.Get total amount of destination token before doing transfer
    * def getBalanceTokenBeforeTransfer = call read('this:VerifyCrossWorkSpace.feature@GetBalanceTokenBeforeTransferUat')
    * def destinationAmountBefore = parseFloat(getBalanceTokenBeforeTransfer.response.data.total)

  # 4.Get estimated fee
    * def body_estimate_fee = { "assetId":'#(testData.transfer.withdraw.tokenSymbol)', "destinationType": '#(testData.transfer.destinationType)', "sourceType":'#(testData.transfer.source_type)', "sourceId": '#(sourceId_warm)',"amount":#(amount_low),"destinationId":'#(destinationId_cold)'}
    * def getEstimateFee = call read(classpath + 'Transfer.feature@Get_estimate_fee_common') {body_estimate_fee: body_estimate_fee}
    * def fee = getEstimateFee.response.data.medium

  # 5.Caculate estimated fee
    * def body_total_estimate = { "assetId":'#(testData.transfer.withdraw.tokenSymbol)', "destinationType": '#(testData.transfer.destinationType)', "sourceType":'#(testData.transfer.source_type)', "sourceId": '#(sourceId_warm)',"amount":#(amount_low),"destinationId":'#(destinationId_cold)', "fee":'#(fee)',"isNetAmount":false}
    * def getCaculateFee = call read(classpath + 'Transfer.feature@Total_estimate_fee_common')
    * def totalEstimatedFee = getCaculateFee.response.data.totalEstimatedFee

  # 6.Submit transfer
    * def body_transfer = { "operation":'#(testData.transfer.operation)',"tokenId":'#(tokenId_transfer)',"feeType":'#(testData.transfer.withdraw.feeType)',"fee":'#(fee)', "treatAsGrossAmount": true, "feeLevel": '#(testData.transfer.feeLevel)', "destination":{"type":'#(testData.transfer.destinationType)',"id":'#(destinationId_cold)'}, "source": {"type":'#(testData.transfer.source_type)',"id":'#(sourceId_warm)'},"amount":#(amount_low),"totalEstimatedFee":'#(totalEstimatedFee)'}
    * call read(classpath + 'Transfer.feature@External_Transfer_Common')
    * match sourceName_warm == response.data.sourceName
    * match destinationName_cold == response.data.destinationName
    * def transactionId = response.data.id
    * def requestId = response.data.requestId

   # 7.Approve Transfer from admin quorum
    * call read(classpath + 'ApprovalRequest.feature@ApproveRequestCommon')

   # 8.Waiting to auto approve in fireblock
    * eval sleep()

   # 9.View transfer detail after complete
    * def getTransactionDetail = call read(classpath + 'Transaction.feature@View_transaction_detail_common')
    * def sourceAdress_from_sourceTransfer = getTransactionDetail.response.data.sourceAddress
    * def destinationAdress_from_sourceTransfer = getTransactionDetail.response.data.destinationAddress
   # --- Verify sourceName, destinationName
    * match sourceName_warm == getTransactionDetail.response.data.sourceName
    * match destinationName_cold == getTransactionDetail.response.data.destinationName
   # --- Verify Txn Type
    * match getTransactionDetail.response.data.status == "COMPLETED"

   # 9.1.Verify balance of source
    * def query_detail = { vaultId :'#(sourceId_warm)', walletId: '#(walletId_warm)'}
    * def getDetailTokenSource = call read(classpath + 'Wallet.feature@VIEW_TOKEN_DETAIL_COMMON')
    * def total_source_afterTransfer = parseFloat(getDetailTokenSource.response.data.total)
    # --- Verify the balance of source is updated correctly
    * match total_source_afterTransfer == total - amount_low

   # 9.2.Verify balance of destination && transaction show in destination
    * call read('this:VerifyCrossWorkSpace.feature@VerifyBalanceDestinationUat')

  @RAKCON-19302
  Scenario: WITHDRAW - Transfer WARM to WARM - SAME workspace (Different company)
  # 1.Select token for doing transfer
    * def getToken = call read(classpath + 'Transfer.feature@Get_asset_transfer')
    * def tokenId_transfer = getToken.response.data.tokens[0].id
    * def tokenSymbol = getToken.response.data.tokens[0].externalAssetId

  # 2.Select source
    * def screenType = Const.Transfer.FromScreen.SOURCE
    * def vaultType = Const.Vault.VaultType.HOT_WALLET
    * def getSource = call read(classpath + 'Vault.feature@SearchVaultForTransfer')
    * def source_warm = karate.jsonPath(getSource.response.data, "$.vaults[?(@.type=='"+ vaultType +"')]")[0]
    * def sourceId_warm = source_warm.id
    * def sourceName_warm = source_warm.name
    * def total = source_warm.wallets[0].total
    * def walletId_warm = source_warm.wallets[0].id

  # 3.Select destination from whitelist. The whitelist contains token from an other workspace
    * def folderName = "WARM_SAME_WORKSPACE"
    * def getDestination = call read(classpath + 'WhiteListFolder.feature@Search_folder_by_keyword_common')
    * def destination_warm = karate.jsonPath(getDestination.response.data, "$.folders[?(@.name=='"+ folderName +"')]")[0]
    * def destinationId_warm = destination_warm.id
    * def destinationName_warm = destination_warm.name

  # 3.1.Get total amount of destination token before doing transfer
    * def getBalanceTokenBeforeTransfer = call read('this:VerifySameWorkSpace.feature@GetBalanceTokenBeforeTransfer')
    * def destinationAmountBefore = parseFloat(getBalanceTokenBeforeTransfer.response.data.total)

  # 4.Get estimated fee
    * def body_estimate_fee = { "assetId":'#(testData.transfer.withdraw.tokenSymbol)', "destinationType": '#(testData.transfer.destinationType)', "sourceType":'#(testData.transfer.source_type)', "sourceId": '#(sourceId_warm)',"amount":#(amount_low),"destinationId":'#(destinationId_warm)'}
    * def getEstimateFee = call read(classpath + 'Transfer.feature@Get_estimate_fee_common') {body_estimate_fee: body_estimate_fee}
    * def fee = getEstimateFee.response.data.medium

  # 5.Caculate estimated fee
    * def body_total_estimate = { "assetId":'#(testData.transfer.withdraw.tokenSymbol)', "destinationType": '#(testData.transfer.destinationType)', "sourceType":'#(testData.transfer.source_type)', "sourceId": '#(sourceId_warm)',"amount":#(amount_low),"destinationId":'#(destinationId_warm)', "fee":'#(fee)',"isNetAmount":false}
    * def getCaculateFee = call read(classpath + 'Transfer.feature@Total_estimate_fee_common')
    * def totalEstimatedFee = getCaculateFee.response.data.totalEstimatedFee

  # 6.Submit transfer
    * def body_transfer = { "operation":'#(testData.transfer.operation)',"tokenId":'#(tokenId_transfer)',"feeType":'#(testData.transfer.withdraw.feeType)',"fee":'#(fee)', "treatAsGrossAmount": true, "feeLevel": '#(testData.transfer.feeLevel)', "destination":{"type":'#(testData.transfer.destinationType)',"id":'#(destinationId_warm)'}, "source": {"type":'#(testData.transfer.source_type)',"id":'#(sourceId_warm)'},"amount":#(amount_low),"totalEstimatedFee":'#(totalEstimatedFee)'}
    * call read(classpath + 'Transfer.feature@External_Transfer_Common')
    * match sourceName_warm == response.data.sourceName
    * match destinationName_warm == response.data.destinationName
    * def transactionId = response.data.id
    * def requestId = response.data.requestId

   # 7.Approve Transfer from admin quorum
    * call read(classpath + 'ApprovalRequest.feature@ApproveRequestCommon')

   # 8.Waiting to auto approve in fireblock
    * eval sleep()

   # 9.View transfer detail after complete
    * def getTransactionDetail = call read(classpath + 'Transaction.feature@View_transaction_detail_common')
    * def sourceAdress_from_sourceTransfer = getTransactionDetail.response.data.sourceAddress
    * def destinationAdress_from_sourceTransfer = getTransactionDetail.response.data.destinationAddress
   # --- Verify sourceName, destinationName
    * match sourceName_warm == getTransactionDetail.response.data.sourceName
    * match destinationName_warm == getTransactionDetail.response.data.destinationName
   # --- Verify Txn Type
    * match getTransactionDetail.response.data.status == "COMPLETED"

   # 9.1.Get the balance of source
    * def query_detail = { vaultId :'#(sourceId_warm)', walletId: '#(walletId_warm)'}
    * def getDetailTokenSource = call read(classpath + 'Wallet.feature@VIEW_TOKEN_DETAIL_COMMON')
    * def total_source_afterTransfer = parseFloat(getDetailTokenSource.response.data.total)
    # --- Verify the balance of source is updated correctly
    * match total_source_afterTransfer == total - amount_low

   # 9.2.Verify balance of destination && transaction show in destination
    * call read('VerifySameWorkSpace.feature@VerifyBalanceDestination')

    ######################### REBALANCE  #################################################################

  @RAKCON-19306
  Scenario: REBALANCE - Transfer WARM to WARM - SAME company
  # 1.Select token for doing transfer
    * def getToken = call read(classpath + 'Transfer.feature@Get_asset_transfer')
    * def tokenId_transfer = getToken.response.data.tokens[0].id
    * def tokenSymbol = getToken.response.data.tokens[0].externalAssetId

  # 2.Select source
    * def screenType = Const.Transfer.FromScreen.SOURCE
    * def vaultType = Const.Vault.VaultType.HOT_WALLET
    * def getSource = call read(classpath + 'Vault.feature@SearchVaultForTransfer')
    * def source_warm = karate.jsonPath(getSource.response.data, "$.vaults[?(@.type=='"+ vaultType +"')]")[0]
    * def sourceId_warm = source_warm.id
    * def sourceName_warm = source_warm.name
    * def total = source_warm.wallets[0].total
    * def walletId_warm = source_warm.wallets[0].id

  # 3.Select destination from internal.
    * def screenType = Const.Transfer.FromScreen.DESTINATION
    * def getDestination = call read(classpath + 'Vault.feature@SearchVaultForTransfer')
    * def destination_warm = karate.jsonPath(getDestination.response.data, "$.vaults[?(@.type=='"+ vaultType +"')]")[1]
    * def destinationId_warm = destination_warm.id
    * def destinationName_warm = destination_warm.name

  # Get total amount of destination token before doing transfer
    * def findWallet = destination_warm
    * def destinationAmountBefore = get[0] findWallet.wallets[?(@.externalAssetId=='XRP_TEST')].total
    * def walletId_destination = get[0] findWallet.wallets[?(@.externalAssetId=='XRP_TEST')].id

  # 4.Get estimated fee
    * def body_estimate_fee = { "assetId":'#(testData.transfer.withdraw.tokenSymbol)', "destinationType": '#(testData.transfer.destinationType)', "sourceType":'#(testData.transfer.source_type)', "sourceId": '#(sourceId_warm)',"amount":#(amount_low),"destinationId":'#(destinationId_warm)'}
    * def getEstimateFee = call read(classpath + 'Transfer.feature@Get_estimate_fee_common') {body_estimate_fee: body_estimate_fee}
    * def fee = getEstimateFee.response.data.medium

  # 5.Caculate estimated fee
    * def body_total_estimate = { "assetId":'#(testData.transfer.withdraw.tokenSymbol)', "destinationType": '#(testData.transfer.destinationType)', "sourceType":'#(testData.transfer.source_type)', "sourceId": '#(sourceId_warm)',"amount":#(amount_low),"destinationId":'#(destinationId_warm)', "fee":'#(fee)',"isNetAmount":false}
    * def getCaculateFee = call read(classpath + 'Transfer.feature@Total_estimate_fee_common')
    * def totalEstimatedFee = getCaculateFee.response.data.totalEstimatedFee

  # 6.Submit transfer
    * def body = { "operation":'#(testData.transfer.operation)',"tokenId":'#(tokenId_transfer)',"feeType":'#(testData.transfer.withdraw.feeType)',"fee":'#(fee)', "treatAsGrossAmount": true, "feeLevel": '#(testData.transfer.feeLevel)', "destination":{"type":'#(testData.transfer.source_type)',"id":'#(destinationId_warm)'}, "source": {"type":'#(testData.transfer.source_type)',"id":'#(sourceId_warm)'},"amount":#(amount_low),"totalEstimatedFee":'#(totalEstimatedFee)'}
    * call read(classpath + 'Transfer.feature@Internal_Transfer_Common')
    * match sourceName_warm == response.data.sourceName
    * match destinationName_warm == response.data.destinationName
    * def transactionId = response.data.id
    * def requestId = response.data.requestId

   # 7.Approve Transfer from admin quorum
    * call read(classpath + 'ApprovalRequest.feature@ApproveRequestCommon')

   # 8.Waiting to auto approve in fireblock
    * eval sleep()

   # 9.View transfer detail after complete
    * def getTransactionDetail = call read(classpath + 'Transaction.feature@View_transaction_detail_common')
    * def sourceAdress_from_sourceTransfer = getTransactionDetail.response.data.sourceAddress
    * def destinationAdress_from_sourceTransfer = getTransactionDetail.response.data.destinationAddress
   # --- Verify sourceName, destinationName
    * match sourceName_warm == getTransactionDetail.response.data.sourceName
    * match destinationName_warm == getTransactionDetail.response.data.destinationName
   # --- Verify Txn Type
    * match getTransactionDetail.response.data.status == "COMPLETED"

   # 9.1.Get the balance of source
    * def query_detail = { vaultId :'#(sourceId_warm)', walletId: '#(walletId_warm)'}
    * def getDetailTokenSource = call read(classpath + 'Wallet.feature@VIEW_TOKEN_DETAIL_COMMON')
    * def total_source_afterTransfer = parseFloat(getDetailTokenSource.response.data.total)
    # --- Verify the balance of source is updated correctly
    * match total_source_afterTransfer == total - amount_low

   # 9.2.Get the balance of destination
    * def query_detail = { vaultId :'#(destinationId_warm)', walletId: '#(walletId_destination)'}
    * def getDetailTokenDestination = call read(classpath + 'Wallet.feature@VIEW_TOKEN_DETAIL_COMMON')
    * def total_destination_afterTransfer = parseFloat(getDetailTokenDestination.response.data.total)
    # --- Verify the balance of source is updated correctly
    * def amount_recieve = parseFloat(amount_low) - parseFloat(testData.transfer.withdraw.fee)
    * def totalExpectedDestination = amount_recieve + parseFloat(destinationAmountBefore)
    * match total_destination_afterTransfer.toFixed(4) == totalExpectedDestination.toFixed(4)


  @RAKCON-19332
  Scenario: REBALANCE - Transfer WARM to COLD - SAME company
  # 1.Select token for doing transfer
    * def getToken = call read(classpath + 'Transfer.feature@Get_asset_transfer')
    * def tokenId_transfer = getToken.response.data.tokens[0].id
    * def tokenSymbol = getToken.response.data.tokens[0].externalAssetId

  # 2.Select source
    * def screenType = Const.Transfer.FromScreen.SOURCE
    * def vaultType = Const.Vault.VaultType.HOT_WALLET
    * def getSource = call read(classpath + 'Vault.feature@SearchVaultForTransfer')
    * def source_warm = karate.jsonPath(getSource.response.data, "$.vaults[?(@.type=='"+ vaultType +"')]")[0]
    * def sourceId_warm = source_warm.id
    * def sourceName_warm = source_warm.name
    * def total = source_warm.wallets[0].total
    * def walletId_warm = source_warm.wallets[0].id

  # 3.Select destination from internal.
    * def screenType = Const.Transfer.FromScreen.DESTINATION
    * def vaultType = Const.Vault.VaultType.COLD_WALLET
    * def getSource = call read(classpath + 'Vault.feature@SearchVaultForTransfer')
    * def destination_cold = karate.jsonPath(getSource.response.data, "$.vaults[?(@.type=='"+ vaultType +"')]")[0]
    * def destinationId_cold = destination_cold.id
    * def destinationName_cold = destination_cold.name

  # Get total amount of destination token before doing transfer
    * def findWallet = destination_cold
    * def destinationAmountBefore = get[0] findWallet.wallets[?(@.externalAssetId=='XRP_TEST')].total
    * def walletId_destination = get[0] findWallet.wallets[?(@.externalAssetId=='XRP_TEST')].id

  # 4.Get estimated fee
    * def body_estimate_fee = { "assetId":'#(testData.transfer.withdraw.tokenSymbol)', "destinationType": '#(testData.transfer.destinationType)', "sourceType":'#(testData.transfer.source_type)', "sourceId": '#(sourceId_warm)',"amount":#(amount_low),"destinationId":'#(destinationId_cold)'}
    * def getEstimateFee = call read(classpath + 'Transfer.feature@Get_estimate_fee_common') {body_estimate_fee: body_estimate_fee}
    * def fee = getEstimateFee.response.data.medium

  # 5.Caculate estimated fee
    * def body_total_estimate = { "assetId":'#(testData.transfer.withdraw.tokenSymbol)', "destinationType": '#(testData.transfer.destinationType)', "sourceType":'#(testData.transfer.source_type)', "sourceId": '#(sourceId_warm)',"amount":#(amount_low),"destinationId":'#(destinationId_cold)', "fee":'#(fee)',"isNetAmount":false}
    * def getCaculateFee = call read(classpath + 'Transfer.feature@Total_estimate_fee_common')
    * def totalEstimatedFee = getCaculateFee.response.data.totalEstimatedFee

  # 6.Submit transfer
    * def body = { "operation":'#(testData.transfer.operation)',"tokenId":'#(tokenId_transfer)',"feeType":'#(testData.transfer.withdraw.feeType)',"fee":'#(fee)', "treatAsGrossAmount": true, "feeLevel": '#(testData.transfer.feeLevel)', "destination":{"type":'#(testData.transfer.source_type)',"id":'#(destinationId_cold)'}, "source": {"type":'#(testData.transfer.source_type)',"id":'#(sourceId_warm)'},"amount":#(amount_low),"totalEstimatedFee":'#(totalEstimatedFee)'}
    * call read(classpath + 'Transfer.feature@Internal_Transfer_Common')
    * match sourceName_warm == response.data.sourceName
    * match destinationName_cold == response.data.destinationName
    * def transactionId = response.data.id
    * def requestId = response.data.requestId

   # 7.Approve Transfer from admin quorum
    * call read(classpath + 'ApprovalRequest.feature@ApproveRequestCommon')

   # 8.Waiting to auto approve in fireblock
    * eval sleep()

   # 9.View transfer detail after complete
    * def getTransactionDetail = call read(classpath + 'Transaction.feature@View_transaction_detail_common')
    * def sourceAdress_from_sourceTransfer = getTransactionDetail.response.data.sourceAddress
    * def destinationAdress_from_sourceTransfer = getTransactionDetail.response.data.destinationAddress
   # --- Verify sourceName, destinationName
    * match sourceName_warm == getTransactionDetail.response.data.sourceName
    * match destinationName_cold == getTransactionDetail.response.data.destinationName
   # --- Verify Txn Type
    * match getTransactionDetail.response.data.status == "COMPLETED"

   # 9.1.Get the balance of source
    * def query_detail = { vaultId :'#(sourceId_warm)', walletId: '#(walletId_warm)'}
    * def getDetailTokenSource = call read(classpath + 'Wallet.feature@VIEW_TOKEN_DETAIL_COMMON')
    * def total_source_afterTransfer = parseFloat(getDetailTokenSource.response.data.total)
    # --- Verify the balance of source is updated correctly
    * match total_source_afterTransfer == total - amount_low

   # 9.2.Get the balance of destination
    * def query_detail = { vaultId :'#(destinationId_cold)', walletId: '#(walletId_destination)'}
    * def getDetailTokenDestination = call read(classpath + 'Wallet.feature@VIEW_TOKEN_DETAIL_COMMON')
    * def total_destination_afterTransfer = parseFloat(getDetailTokenDestination.response.data.total)
    # --- Verify the balance of source is updated correctly
    * def amount_recieve = parseFloat(amount_low) - parseFloat(testData.transfer.withdraw.fee)
    * def totalExpectedDestination = amount_recieve + parseFloat(destinationAmountBefore)
    * match total_destination_afterTransfer.toFixed(4) == totalExpectedDestination.toFixed(4)
