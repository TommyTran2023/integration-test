@RAKCON-10583 @e2e
Feature: Withdraw from WARM vault - Same and cross workspace

    Background:
        * callonce read(svc + 'ReadData.feature')
        * call read(svc + 'Biometric.feature@RequesterDoBiometric')
        * def env = karate.properties['karate.env']
        * def amount_low = 2
        * def BigDecimal = Java.type('java.math.BigDecimal')
        * def waitUntilTransactionCompleted = 
        """
        function(transactionId){ 
            var retry = 18
            do {
                java.lang.Thread.sleep(10000); 
                var getTransactionDetail = karate.call(svc + 'Transaction.feature@ViewTransactionDetail', { transactionId: transactionId })
                retry--
            }
            while (getTransactionDetail.response.data.status != "COMPLETED" && retry > 0)

            if (retry <= 0 && getTransactionDetail.response.data.status != "COMPLETED")
                throw Error ("Transaction cannot be completed: " + transactionId)

            java.lang.Thread.sleep(10000);     
            return getTransactionDetail
        }
        """
        * def verifyCrossWorkSpace =
        """
        function(env, totalEstimatedFee, isWarm){
            java.lang.Thread.sleep(180000); 
            var destEnv = 'qa';
            
            if (env != 'uat'){
                destEnv = 'uat'
            }

            karate.call('this:CrossWorkSpace.feature@VerifyBalanceDestination', { destinationEnv: destEnv, feeData: totalEstimatedFee, isWarm: isWarm } )
        }
        """
        * def getDestinationBalance =
        """
        function(env, isWarm){
            var destEnv = 'qa';

            if (env != 'uat'){
                destEnv = 'uat'
            }

            var balance = karate.call('this:CrossWorkSpace.feature@GetDestinationBalance', { destinationEnv: destEnv, isWarm: isWarm } ).response
            
            return balance
        }
        """

    @RAKCON-19300
    Scenario: WITHDRAW - Transfer WARM to WARM - CROSS workspace
        # 1.Select token for doing transfer
        * def getToken = karate.call(svc + 'Wallet.feature@GetWalletTransferTokens', {keyword: 'ADA'}).response.data
        * def tokenId_transfer = getToken.tokens[0].id
        * def tokenSymbol = getToken.tokens[0].externalAssetId

        # 2.Select source
        * def vaultType = Const.VaultType.HOT_WALLET
        * def getSource = call read(svc + 'Vault.feature@GetVaultFromSourceScreen') {externalAssetId:#(Const.TokenSymbol.ADA), searchText:#(testData.stdVaultE2E)}
        * def source_warm = karate.jsonPath(getSource.response.data, "$.list[?(@.type=='"+ vaultType +"')]")[0]
        * def sourceId_warm = source_warm.id
        * def sourceName_warm = source_warm.name
        * def available = source_warm.wallets[0].available
        * def walletId_warm = source_warm.wallets[0].id

        # 3.Select destination from whitelist. The whitelist contains token from an other workspace
        * def folderName = "WARM_CROSS_WORKSPACE"
        * def getDestination = karate.call(svc + 'Whitelist.feature@GetWhitelistFolders', {keyword: folderName})
        * def destination_warm = karate.jsonPath(getDestination.response.data, "$.folders[?(@.name=='"+ folderName +"')]")[0]
        * def destinationId_warm = destination_warm.id
        * def destinationName_warm = destination_warm.name
        * def whitelist_type = destination_warm.type == "external" ? Const.PeerType.EXTERNAL_WALLET : Const.PeerType.INTERNAL_WALLET

        # 4.Get total amount of destination token before doing transfer
        * def getBalanceTokenBeforeTransfer = getDestinationBalance(env, true)
        * print getBalanceTokenBeforeTransfer
        * def destinationAmountBefore = parseFloat(getBalanceTokenBeforeTransfer.data.available)

        # 5.Get estimated fee
        * def body_estimate_fee = 
        """
        { 
            "assetId":'#(Const.TokenSymbol.ADA)', 
            "destinationType": '#(whitelist_type)', 
            "sourceType":'#(Const.PeerType.VAULT_ACCOUNT)', 
            "sourceId": '#(sourceId_warm)',
            "amount": '#(amount_low)',
            "destinationId":'#(destinationId_warm)'
        }
        """
        * def getEstimateFee = call read(svc + 'Transaction.feature@GetEstimatedFee') body_estimate_fee
        * def fee = getEstimateFee.response.data.medium

        # 6.Caculate estimated fee
        * def body_total_estimate = 
        """
        { 
            "assetId":'#(Const.TokenSymbol.ADA)', 
            "destinationType": '#(whitelist_type)', 
            "sourceType":'#(Const.PeerType.VAULT_ACCOUNT)', 
            "sourceId": '#(sourceId_warm)',
            "amount":'#(amount_low)',
            "destinationId":'#(destinationId_warm)', 
            "fee":#(fee),
            "isNetAmount":false,
            "isStake":false
        }
        """
        * def getCaculateFee = call read(svc + 'Transaction.feature@GetTotalFee') body_total_estimate
        * def totalEstimatedFee = getCaculateFee.response.data.totalEstimatedFee
      
        # 7.Submit transfer
        * call read(svc + "Biometric.feature@RequesterDoBiometric")
        * def body_transfer = 
        """
        { 
            "operation":'#(Const.Transfer.Operation.TRANSFER)',
            "tokenId":'#(tokenId_transfer)',
            "feeType":'#(Const.TokenSymbol.ADA)',
            "fee":#(fee), 
            "treatAsGrossAmount": true, 
            "feeLevel": '#(Const.Transfer.FeeLevel.MEDIUM)', 
            "destination":{
                "type":'#(whitelist_type)',
                "id":'#(destinationId_warm)'
            }, 
            "source": {
                "type":'#(Const.PeerType.VAULT_ACCOUNT)',
                "id":'#(sourceId_warm)'
            },
            "amount":'#(amount_low)',
            "totalEstimatedFee":'#(totalEstimatedFee)'
        }
        """
        * call read(svc + "Transaction.feature@CreateTransaction") body_transfer
        * match response.data.sourceName contains sourceName_warm
        * match destinationName_warm == response.data.destinationName
        * def transactionId = response.data.id
        * def requestId = response.data.requestId

        # 8.Approve Transfer from admin quorum  
        * call read(svc + 'Biometric.feature@ApproverDoBiometric')
        * call read(svc + 'Quorums.feature@ApproveRequest') {requestId: "#(requestId)"}

        # 9.Waiting to auto approve in fireblock

        # 10.View transfer detail after complete
        * def getTransactionDetail = waitUntilTransactionCompleted(transactionId)
        * def sourceAdress_from_sourceTransfer = getTransactionDetail.response.data.sourceAddress
        * def destinationAdress_from_sourceTransfer = getTransactionDetail.response.data.destinationAddress
        # --- Verify sourceName, destinationName
        * match sourceName_warm == getTransactionDetail.response.data.sourceName
        * match destinationName_warm == getTransactionDetail.response.data.destinationName
        # --- Verify Txn Type
        * match getTransactionDetail.response.data.status == "COMPLETED"

        # 11. Get the balance of source
        * def query_detail = { vaultId :'#(sourceId_warm)', walletId: '#(walletId_warm)'}
        * def getDetailTokenSource = call read(svc +'Wallet.feature@GetTokenDetails') query_detail
        * def available_source_afterTransfer = parseFloat(getDetailTokenSource.response.data.available)

        # 12. Verify the balance of source is updated correctly 
        * print available, amount_low, available_source_afterTransfer
        * match available_source_afterTransfer == available - amount_low

        # 13. Verify balance of destination && transaction show in destination
        * eval verifyCrossWorkSpace(env, totalEstimatedFee, true)

    @RAKCON-19301
    Scenario: WITHDRAW - Transfer WARM to COLD - CROSS workspace
        # 1.Select token for doing transfer
        * def getToken = karate.call(svc + 'Wallet.feature@GetWalletTransferTokens', {keyword: 'ADA'}).response.data
        * def tokenId_transfer = getToken.tokens[0].id
        * def tokenSymbol = getToken.tokens[0].externalAssetId

        # 2.Select source
        * def vaultType = Const.VaultType.HOT_WALLET
        * def getSource = call read(svc + 'Vault.feature@GetVaultFromSourceScreen') {externalAssetId:#(Const.TokenSymbol.ADA), searchText:#(testData.stdVaultE2E)}
        * def source_warm = karate.jsonPath(getSource.response.data, "$.list[?(@.type=='"+ vaultType +"')]")[0]
        * def sourceId_warm = source_warm.id
        * def sourceName_warm = source_warm.name
        * def available = source_warm.wallets[0].available
        * def walletId_warm = source_warm.wallets[0].id

        # 3.Select destination from whitelist. The whitelist contains token from an other workspace
        * def folderName = "COLD_CROSS_WORKSPACE"
        * def getDestination = karate.call(svc + 'Whitelist.feature@GetWhitelistFolders', {keyword: folderName})
        * def destination_warm = karate.jsonPath(getDestination.response.data, "$.folders[?(@.name=='"+ folderName +"')]")[0]
        * def destinationId_warm = destination_warm.id
        * def destinationName_warm = destination_warm.name
        * def whitelist_type = destination_warm.type == "external" ? Const.PeerType.EXTERNAL_WALLET : Const.PeerType.INTERNAL_WALLET

        # 4.Get total amount of destination token before doing transfer
        * def getBalanceTokenBeforeTransfer = call read('this:VerifyCrossWorkSpace.feature@GetBalanceTokenBeforeTransferUat') {isWarm: false}
        * def destinationAmountBefore = parseFloat(getBalanceTokenBeforeTransfer.response.data.available)

        # 5.Get estimated fee
        * def body_estimate_fee = 
        """
        { 
            "assetId":'#(Const.TokenSymbol.ADA)', 
            "destinationType": '#(whitelist_type)', 
            "sourceType":'#(Const.PeerType.VAULT_ACCOUNT)', 
            "sourceId": '#(sourceId_warm)',
            "amount": '#(amount_low)',
            "destinationId":'#(destinationId_warm)'
        }
        """
        * def getEstimateFee = call read(svc + 'Transaction.feature@GetEstimatedFee') body_estimate_fee
        * def fee = getEstimateFee.response.data.medium

        # 6.Caculate estimated fee
        * def body_total_estimate = 
        """
        { 
            "assetId":'#(Const.TokenSymbol.ADA)', 
            "destinationType": '#(whitelist_type)', 
            "sourceType":'#(Const.PeerType.VAULT_ACCOUNT)', 
            "sourceId": '#(sourceId_warm)',
            "amount":'#(amount_low)',
            "destinationId":'#(destinationId_warm)', 
            "fee":#(fee),
            "isNetAmount":false,
            "isStake":false
        }
        """
        * def getCaculateFee = call read(svc + 'Transaction.feature@GetTotalFee') body_total_estimate
        * def totalEstimatedFee = getCaculateFee.response.data.totalEstimatedFee
    
        # 7.Submit transfer
        * call read(svc + "Biometric.feature@RequesterDoBiometric")
        * def body_transfer = 
        """
        { 
            "operation":'#(Const.Transfer.Operation.TRANSFER)',
            "tokenId":'#(tokenId_transfer)',
            "feeType":'#(Const.TokenSymbol.ADA)',
            "fee":#(fee), 
            "treatAsGrossAmount": true, 
            "feeLevel": '#(Const.Transfer.FeeLevel.MEDIUM)', 
            "destination":{
                "type":'#(whitelist_type)',
                "id":'#(destinationId_warm)'
            }, 
            "source": {
                "type":'#(Const.PeerType.VAULT_ACCOUNT)',
                "id":'#(sourceId_warm)'
            },
            "amount":'#(amount_low)',
            "totalEstimatedFee":'#(totalEstimatedFee)'
        }
        """
        * call read(svc + "Transaction.feature@CreateTransaction") body_transfer
        * match response.data.sourceName contains sourceName_warm
        * match destinationName_warm == response.data.destinationName
        * def transactionId = response.data.id
        * def requestId = response.data.requestId

        # 8.Approve Transfer from admin quorum  
        * call read(svc + 'Biometric.feature@ApproverDoBiometric')
        * call read(svc + 'Quorums.feature@ApproveRequest') {requestId: "#(requestId)"}

        # 9.Waiting to auto approve in fireblock

        # 10.View transfer detail after complete
        * def getTransactionDetail = waitUntilTransactionCompleted(transactionId)
        * def sourceAdress_from_sourceTransfer = getTransactionDetail.response.data.sourceAddress
        * def destinationAdress_from_sourceTransfer = getTransactionDetail.response.data.destinationAddress
        # --- Verify sourceName, destinationName
        * match sourceName_warm == getTransactionDetail.response.data.sourceName
        * match destinationName_warm == getTransactionDetail.response.data.destinationName
        # --- Verify Txn Type
        * match getTransactionDetail.response.data.status == "COMPLETED"

        # 11. Get the balance of source
        * def query_detail = { vaultId :'#(sourceId_warm)', walletId: '#(walletId_warm)'}
        * def getDetailTokenSource = call read(svc +'Wallet.feature@GetTokenDetails') query_detail
        * def available_source_afterTransfer = parseFloat(getDetailTokenSource.response.data.available)

        # 12. Verify the balance of source is updated correctly 
        * print available, amount_low, available_source_afterTransfer
        * match available_source_afterTransfer == available - amount_low

        # 13. Verify balance of destination && transaction show in destination
        * call read('this:VerifyCrossWorkSpace.feature@VerifyBalanceDestinationUat') {feeData: #(totalEstimatedFee), isWarm: false}


    @RAKCON-19302
    Scenario: WITHDRAW - Transfer WARM to WARM - SAME workspace (Different company)
        # 1.Select token for doing transfer
        * def getToken = karate.call(svc + 'Wallet.feature@GetWalletTransferTokens', {keyword: 'ADA'}).response.data
        * def tokenId_transfer = getToken.tokens[0].id
        * def tokenSymbol = getToken.tokens[0].externalAssetId

        # 2.Select source
        * def vaultType = Const.VaultType.HOT_WALLET
        * def getSource = call read(svc + 'Vault.feature@GetVaultFromSourceScreen') {externalAssetId:#(Const.TokenSymbol.ADA), searchText:#(testData.stdVaultE2E)}
        * def source_warm = karate.jsonPath(getSource.response.data, "$.list[?(@.type=='"+ vaultType +"')]")[0]
        * def sourceId_warm = source_warm.id
        * def sourceName_warm = source_warm.name
        * def available = source_warm.wallets[0].available
        * def walletId_warm = source_warm.wallets[0].id

        # 3.Select destination from whitelist. The whitelist contains token from an other workspace
        * def folderName = "WARM_SAME_WORKSPACE"
        * def getDestination = karate.call(svc + 'Whitelist.feature@GetWhitelistFolders', {keyword: folderName})
        * def destination_warm = karate.jsonPath(getDestination.response.data, "$.folders[?(@.name=='"+ folderName +"')]")[0]
        * def destinationId_warm = destination_warm.id
        * def destinationName_warm = destination_warm.name
        * def whitelist_type = destination_warm.type == "external" ? Const.PeerType.EXTERNAL_WALLET : Const.PeerType.INTERNAL_WALLET

        # 4.Get total amount of destination token before doing transfer
        * def getBalanceTokenBeforeTransfer = call read('this:VerifyCrossWorkSpace.feature@GetBalanceTokenBeforeTransferUat') {isWarm: true}
        * def destinationAmountBefore = parseFloat(getBalanceTokenBeforeTransfer.response.data.available)

        # 5.Get estimated fee
        * def body_estimate_fee = 
        """
        { 
            "assetId":'#(Const.TokenSymbol.ADA)', 
            "destinationType": '#(whitelist_type)', 
            "sourceType":'#(Const.PeerType.VAULT_ACCOUNT)', 
            "sourceId": '#(sourceId_warm)',
            "amount": '#(amount_low)',
            "destinationId":'#(destinationId_warm)'
        }
        """
        * def getEstimateFee = call read(svc + 'Transaction.feature@GetEstimatedFee') body_estimate_fee
        * def fee = getEstimateFee.response.data.medium

        # 6.Caculate estimated fee
        * def body_total_estimate = 
        """
        { 
            "assetId":'#(Const.TokenSymbol.ADA)', 
            "destinationType": '#(whitelist_type)', 
            "sourceType":'#(Const.PeerType.VAULT_ACCOUNT)', 
            "sourceId": '#(sourceId_warm)',
            "amount":'#(amount_low)',
            "destinationId":'#(destinationId_warm)', 
            "fee":#(fee),
            "isNetAmount":false,
            "isStake":false
        }
        """
        * def getCaculateFee = call read(svc + 'Transaction.feature@GetTotalFee') body_total_estimate
        * def totalEstimatedFee = getCaculateFee.response.data.totalEstimatedFee
    
        # 7.Submit transfer
        * call read(svc + "Biometric.feature@RequesterDoBiometric")
        * def body_transfer = 
        """
        { 
            "operation":'#(Const.Transfer.Operation.TRANSFER)',
            "tokenId":'#(tokenId_transfer)',
            "feeType":'#(Const.TokenSymbol.ADA)',
            "fee":#(fee), 
            "treatAsGrossAmount": true, 
            "feeLevel": '#(Const.Transfer.FeeLevel.MEDIUM)', 
            "destination":{
                "type":'#(whitelist_type)',
                "id":'#(destinationId_warm)'
            }, 
            "source": {
                "type":'#(Const.PeerType.VAULT_ACCOUNT)',
                "id":'#(sourceId_warm)'
            },
            "amount":'#(amount_low)',
            "totalEstimatedFee":'#(totalEstimatedFee)'
        }
        """
        * call read(svc + "Transaction.feature@CreateTransaction") body_transfer
        * match response.data.sourceName contains sourceName_warm
        * match destinationName_warm == response.data.destinationName
        * def transactionId = response.data.id
        * def requestId = response.data.requestId

        # 8.Approve Transfer from admin quorum  
        * call read(svc + 'Biometric.feature@ApproverDoBiometric')
        * call read(svc + 'Quorums.feature@ApproveRequest') {requestId: "#(requestId)"}

        # 9.Waiting to auto approve in fireblock

        # 10.View transfer detail after complete
        * def getTransactionDetail = waitUntilTransactionCompleted(transactionId)
        * def sourceAdress_from_sourceTransfer = getTransactionDetail.response.data.sourceAddress
        * def destinationAdress_from_sourceTransfer = getTransactionDetail.response.data.destinationAddress
        # --- Verify sourceName, destinationName
        * match sourceName_warm == getTransactionDetail.response.data.sourceName
        * match destinationName_warm == getTransactionDetail.response.data.destinationName
        # --- Verify Txn Type
        * match getTransactionDetail.response.data.status == "COMPLETED"

        # 11. Get the balance of source
        * def query_detail = { vaultId :'#(sourceId_warm)', walletId: '#(walletId_warm)'}
        * def getDetailTokenSource = call read(svc +'Wallet.feature@GetTokenDetails') query_detail
        * def available_source_afterTransfer = parseFloat(getDetailTokenSource.response.data.available)

        # 12. Verify the balance of source is updated correctly 
        * print available, amount_low, available_source_afterTransfer
        * match available_source_afterTransfer == available - amount_low

        # 13. Verify balance of destination && transaction show in destination
        * call read('this:VerifyCrossWorkSpace.feature@VerifyBalanceDestinationUat') {feeData: #(totalEstimatedFee), isWarm: true }


    ######################### REBALANCE  #################################################################
    @RAKCON-19306
    Scenario: REBALANCE - Transfer WARM to WARM - SAME company
        # 1.Select token for doing transfer
        * def getToken = karate.call(svc + 'Wallet.feature@GetWalletTransferTokens', {keyword: 'ADA'}).response.data
        * def tokenId_transfer = getToken.tokens[0].id
        * def tokenSymbol = getToken.tokens[0].externalAssetId

        # 2.Select source
        * def vaultType = Const.VaultType.HOT_WALLET
        * def getSource = call read(svc + 'Vault.feature@GetVaultFromSourceScreen') {externalAssetId:#(Const.TokenSymbol.ADA),searchText:#(testData.stdVaultE2E)}
        * def source_warm = karate.jsonPath(getSource.response.data, "$.list[?(@.type=='"+ vaultType +"')]")[0]
        * def sourceId_warm = source_warm.id
        * def sourceName_warm = source_warm.name
        * def available = source_warm.wallets[0].available
        * def walletId_warm = source_warm.wallets[0].id

        # 3.Select destination from whitelist. The whitelist contains token from an other workspace
        * def getDestination = call read(svc + 'Vault.feature@GetVaultFromDestinationScreen') {sourceVaultId:#(sourceId_warm)}
        * def destination_warm = karate.jsonPath(getDestination.response.data, "$.list[?(@.type=='"+ vaultType +"' && @.id!='"+sourceId_warm+"')]")[1]
        * def destinationId_warm = destination_warm.id
        * def destinationName_warm = destination_warm.name
        
        # 4.Get total amount of destination token before doing transfer
        * def findWallet = call read(svc + 'Wallet.feature@GetWallets') {vaultId:#(destination_warm.id), tokenSymbol:'ADA'}
        * def destinationAmountBefore = get[0] findWallet.response.data.wallets[0].available
        * def walletId_destination = get[0] findWallet.response.data.wallets[0].id

        # 5.Get estimated fee
        * def body_estimate_fee = 
        """
        { 
            "assetId":'#(Const.TokenSymbol.ADA)', 
            "destinationType": '#(Const.PeerType.VAULT_ACCOUNT)', 
            "sourceType":'#(Const.PeerType.VAULT_ACCOUNT)', 
            "sourceId": '#(sourceId_warm)',
            "amount": '#(amount_low)',
            "destinationId":'#(destinationId_warm)'
        }
        """
        * def getEstimateFee = call read(svc + 'Transaction.feature@GetEstimatedFee') body_estimate_fee
        * def fee = getEstimateFee.response.data.medium

        # 6.Caculate estimated fee
        * def body_total_estimate = 
        """
        { 
            "assetId":'#(Const.TokenSymbol.ADA)', 
            "destinationType": '#(Const.PeerType.VAULT_ACCOUNT)', 
            "sourceType":'#(Const.PeerType.VAULT_ACCOUNT)', 
            "sourceId": '#(sourceId_warm)',
            "amount":'#(amount_low)',
            "destinationId":'#(destinationId_warm)', 
            "fee":#(fee),
            "isNetAmount":false,
            "isStake":false
        }
        """
        * def getCaculateFee = call read(svc + 'Transaction.feature@GetTotalFee') body_total_estimate
        * def totalEstimatedFee = getCaculateFee.response.data.totalEstimatedFee
    
        # 7.Submit transfer
        * def transferAmount = amount_low
        * call read(svc + "Biometric.feature@RequesterDoBiometric")
        * def body_transfer = 
        """
        { 
            "operation":'#(Const.Transfer.Operation.TRANSFER)',
            "tokenId":'#(tokenId_transfer)',
            "feeType":'#(Const.TokenSymbol.ADA)',
            "fee":#(fee), 
            "treatAsGrossAmount": true, 
            "feeLevel": '#(Const.Transfer.FeeLevel.MEDIUM)', 
            "destination":{
                "type":'#(Const.PeerType.VAULT_ACCOUNT)',
                "id":'#(destinationId_warm)'
            }, 
            "source": {
                "type":'#(Const.PeerType.VAULT_ACCOUNT)',
                "id":'#(sourceId_warm)'
            },
            "amount":'#(amount_low)',
            "totalEstimatedFee":'#(totalEstimatedFee)'
        }
        """
        * call read(svc + "Transaction.feature@CreateTransaction") body_transfer
        * match response.data.sourceName contains sourceName_warm
        * match destinationName_warm == response.data.destinationName
        * def transactionId = response.data.id
        * def requestId = response.data.requestId

        # 8.Approve Transfer from admin quorum  
        * call read(svc + 'Biometric.feature@ApproverDoBiometric')
        * call read(svc + 'Quorums.feature@ApproveRequest') {requestId: "#(requestId)"}

        # 9.Waiting to auto approve in fireblock

        # 10.View transfer detail after complete
        * def getTransactionDetail = waitUntilTransactionCompleted(transactionId)
        * def sourceAdress_from_sourceTransfer = getTransactionDetail.response.data.sourceAddress
        * def destinationAdress_from_sourceTransfer = getTransactionDetail.response.data.destinationAddress
        # --- Verify sourceName, destinationName
        * match sourceName_warm == getTransactionDetail.response.data.sourceName
        * match destinationName_warm == getTransactionDetail.response.data.destinationName
        # --- Verify Txn Type
        * match getTransactionDetail.response.data.status == "COMPLETED"

        # 11. Get the balance of source
        * def query_detail = { vaultId :'#(sourceId_warm)', walletId: '#(walletId_warm)'}
        * def getDetailTokenSource = call read(svc +'Wallet.feature@GetTokenDetails') query_detail
        * def available_source_afterTransfer = parseFloat(getDetailTokenSource.response.data.available)

        # 12. Verify the balance of source is updated correctly 
        * print available, amount_low, available_source_afterTransfer
        * match available_source_afterTransfer == available - amount_low

        # 13. Verify balance of destination && transaction show in destination
        * def query_detail = { vaultId :'#(destinationId_warm)', walletId: '#(walletId_destination)'}
        * def getDetailTokenDestination = call read(svc +'Wallet.feature@GetTokenDetails') query_detail
        * def total_destination_afterTransfer = parseFloat(getDetailTokenDestination.response.data.available)
        # --- Verify the balance of source is updated correctly
        * def amount_recieve = parseFloat(transferAmount) - parseFloat(fee)
        * def totalExpectedDestination = amount_recieve + parseFloat(destinationAmountBefore)
        * match total_destination_afterTransfer.toFixed(4) == totalExpectedDestination.toFixed(4)

    @RAKCON-19332
    Scenario: REBALANCE - Transfer WARM to COLD - SAME company
        # 1.Select token for doing transfer
        * def getToken = karate.call(svc + 'Wallet.feature@GetWalletTransferTokens', {keyword: 'ADA'}).response.data
        * def tokenId_transfer = getToken.tokens[0].id
        * def tokenSymbol = getToken.tokens[0].externalAssetId

        # 2.Select source
        * def vaultType = Const.VaultType.HOT_WALLET
        * def getSource = call read(svc + 'Vault.feature@GetVaultFromSourceScreen') {externalAssetId:#(Const.TokenSymbol.ADA),searchText:#(testData.stdVaultE2E)}
        * def source_warm = karate.jsonPath(getSource.response.data, "$.list[?(@.type=='"+ vaultType +"')]")[0]
        * def sourceId_warm = source_warm.id
        * def sourceName_warm = source_warm.name
        * def available = source_warm.wallets[0].available
        * def walletId_warm = source_warm.wallets[0].id

        # 3.Select destination from internal.
        * def vaultType = Const.VaultType.COLD_WALLET
        * def getDestination = call read(svc + 'Vault.feature@GetVaultFromDestinationScreen') {sourceVaultId:#(sourceId_warm)}
        * def destination_warm = karate.jsonPath(getDestination.response.data, "$.list[?(@.type=='"+ vaultType +"' && @.id!='"+sourceId_warm+"')]")[1]
        * def destinationId_warm = destination_warm.id
        * def destinationName_warm = destination_warm.name
        
        # 4.Get total amount of destination token before doing transfer
        * def findWallet = call read(svc + 'Wallet.feature@GetWallets') {vaultId:#(destination_warm.id), tokenSymbol:'ADA'}
        * def destinationAmountBefore = get[0] findWallet.response.data.wallets[0].available
        * def walletId_destination = get[0] findWallet.response.data.wallets[0].id

        # 5.Get estimated fee
        * def body_estimate_fee = 
        """
        { 
            "assetId":'#(Const.TokenSymbol.ADA)', 
            "destinationType": '#(Const.PeerType.VAULT_ACCOUNT)', 
            "sourceType":'#(Const.PeerType.VAULT_ACCOUNT)', 
            "sourceId": '#(sourceId_warm)',
            "amount": '#(amount_low)',
            "destinationId":'#(destinationId_warm)'
        }
        """
        * def getEstimateFee = call read(svc + 'Transaction.feature@GetEstimatedFee') body_estimate_fee
        * def fee = getEstimateFee.response.data.medium

        # 6.Caculate estimated fee
        * def body_total_estimate = 
        """
        { 
            "assetId":'#(Const.TokenSymbol.ADA)', 
            "destinationType": '#(Const.PeerType.VAULT_ACCOUNT)', 
            "sourceType":'#(Const.PeerType.VAULT_ACCOUNT)', 
            "sourceId": '#(sourceId_warm)',
            "amount":'#(amount_low)',
            "destinationId":'#(destinationId_warm)', 
            "fee":#(fee),
            "isNetAmount":false,
            "isStake":false
        }
        """
        * def getCaculateFee = call read(svc + 'Transaction.feature@GetTotalFee') body_total_estimate
        * def totalEstimatedFee = getCaculateFee.response.data.totalEstimatedFee
    
        # 7.Submit transfer
        * def transferAmount = amount_low
        * call read(svc + "Biometric.feature@RequesterDoBiometric")
        * def body_transfer = 
        """
        { 
            "operation":'#(Const.Transfer.Operation.TRANSFER)',
            "tokenId":'#(tokenId_transfer)',
            "feeType":'#(Const.TokenSymbol.ADA)',
            "fee":#(fee), 
            "treatAsGrossAmount": true, 
            "feeLevel": '#(Const.Transfer.FeeLevel.MEDIUM)', 
            "destination":{
                "type":'#(Const.PeerType.VAULT_ACCOUNT)',
                "id":'#(destinationId_warm)'
            }, 
            "source": {
                "type":'#(Const.PeerType.VAULT_ACCOUNT)',
                "id":'#(sourceId_warm)'
            },
            "amount":'#(amount_low)',
            "totalEstimatedFee":'#(totalEstimatedFee)'
        }
        """
        * call read(svc + "Transaction.feature@CreateTransaction") body_transfer
        * match response.data.sourceName contains sourceName_warm
        * match destinationName_warm == response.data.destinationName
        * def transactionId = response.data.id
        * def requestId = response.data.requestId

        # 8.Approve Transfer from admin quorum  
        * call read(svc + 'Biometric.feature@ApproverDoBiometric')
        * call read(svc + 'Quorums.feature@ApproveRequest') {requestId: "#(requestId)"}

        # 9.Waiting to auto approve in fireblock

        # 10.View transfer detail after complete
        * def getTransactionDetail = waitUntilTransactionCompleted(transactionId)
        * def sourceAdress_from_sourceTransfer = getTransactionDetail.response.data.sourceAddress
        * def destinationAdress_from_sourceTransfer = getTransactionDetail.response.data.destinationAddress
        # --- Verify sourceName, destinationName
        * match sourceName_warm == getTransactionDetail.response.data.sourceName
        * match destinationName_warm == getTransactionDetail.response.data.destinationName
        # --- Verify Txn Type
        * match getTransactionDetail.response.data.status == "COMPLETED"

        # 11. Get the balance of source
        * def query_detail = { vaultId :'#(sourceId_warm)', walletId: '#(walletId_warm)'}
        * def getDetailTokenSource = call read(svc +'Wallet.feature@GetTokenDetails') query_detail
        * def available_source_afterTransfer = parseFloat(getDetailTokenSource.response.data.available)

        # 12. Verify the balance of source is updated correctly 
        * print available, amount_low, available_source_afterTransfer
        * match available_source_afterTransfer == available - amount_low

        # 13. Verify balance of destination && transaction show in destination
        * def query_detail = { vaultId :'#(destinationId_warm)', walletId: '#(walletId_destination)'}
        * def getDetailTokenDestination = call read(svc +'Wallet.feature@GetTokenDetails') query_detail
        * def total_destination_afterTransfer = parseFloat(getDetailTokenDestination.response.data.available)
        # --- Verify the balance of source is updated correctly
        * def amount_recieve = parseFloat(transferAmount) - parseFloat(fee)
        * def totalExpectedDestination = amount_recieve + parseFloat(destinationAmountBefore)
        * match total_destination_afterTransfer.toFixed(4) == totalExpectedDestination.toFixed(4)

