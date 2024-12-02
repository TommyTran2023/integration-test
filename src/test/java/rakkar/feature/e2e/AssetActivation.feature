Feature: Asset Activation e2e
    Background:
        * call read(svc + 'Biometric.feature@RequesterDoBiometric')

    @RAKCON-33357 @CreateAssetActivationTransaction @e2e
    Scenario: Create Asset Activation transaction
      # 1. Create Vault
      * def vaultHandle = read('classpath:rakkar/common/VaultHandle.js')
      * def createdVault = vaultHandle().createStandardVault()

      # 2. Transfer XLM from a vault to created vault (fully approval)
      * def txnInfo = 
      """
      {
        symbol: "XLM",
        destinationType: "VAULT_ACCOUNT",
        sourceType: "VAULT_ACCOUNT",
        sourceId: "#(dataSet.sourceId_hot)",
        destinationId: "#(createdVault.id)",
        amount: 2
      }
      """
      * def transferHandle = read('classpath:rakkar/common/TransferHandle.js')
      * def txn = transferHandle().createTransferRequest(txnInfo)

      # 3. Wait until transaction completed, and created vault have the native token
      * eval 
      """
        var retry = 12
        var vault = null
        var vaultBalance = 0
        do {
          java.lang.Thread.sleep(10000)
          vault = karate.call(svc + 'Vault.feature@GetVaultDetail', {vaultId: txnInfo.destinationId}).response
          vaultBalance = vault.data.totalUSD
          retry --
        } while (retry > 0 && vaultBalance == 0)

        if (retry <= 0 && vaultBalance <= 0){
          throw new Error("Destination vault balance is not updated", vault)
        }
      """

      # 4. Add tokens: USDC on Stella to created vault
      * def nonNativeToken = "USDC"
      * def tokens = karate.call(svc + 'Wallet.feature@GetTokens', {vaultId: vault.data.id, keyword: nonNativeToken}).response.data.tokens
      * def usdc = tokens.find(x => x.nativeAsset.includes(txnInfo.symbol))
      * def checkAsset = karate.call(svc + 'Wallet.feature@CheckAssetPreRequisite', {vaultId: vault.data.id, tokenIds: [usdc.id]}).response.data.pass[0]
      * match checkAsset.nativeSymbol == txnInfo.symbol
      * match each checkAsset.nonNativeSymbol[*] == nonNativeToken
      * def addTokens = karate.call(svc + 'Wallet.feature@AddAssets', {vaultId: vault.data.id, tokenIds: usdc.id})
      * match addTokens.responseStatus == 201
      * match addTokens.response.data.success[0].symbol == nonNativeToken
      * match addTokens.response.data.success[0].network == usdc.network

      # 5. Verify if asset activation transaction created
      * def checkAssetActivationTransaction =  
      """
      function(expectedStatus, vaultId){
        var retry = 12
        var assetActivationCompleted = false
        var transactions = null
        do {
          java.lang.Thread.sleep(30000)
          transactions = karate.call(svc + 'Transaction.feature@GetTransactionsList', {query: { vaultId: vaultId, limit: 10, offset: 0 }}).response.data

          if(transactions.totalCount == 2)
          {
            var assetActivation = transactions.transactions.find(x => x.operation.includes("ENABLE_ASSET"))
            if (assetActivation != null && assetActivation.status == expectedStatus)
              assetActivationCompleted = true
          }

          retry --
        } while (retry > 0 && !assetActivationCompleted)

        if (retry <= 0 && vaultBalance < 2){
          throw new Error("Asset activation transaction is not created or status is not expected", transactions)
        }

        return transactions
      }
      """
      * def vaultTransactions  = checkAssetActivationTransaction("COMPLETED", vault.data.id)
      * match vaultTransactions.transactions[*].type contains any "ENABLE_ASSET"

      # 6. View details of Non-native wallet successfully
      * def usdcWallet = karate.call(svc + 'Vault.feature@GetVaultDetail', {vaultId: txnInfo.destinationId}).response.data.wallets.find(x => x.symbol == nonNativeToken).id
      * call read(svc +'Wallet.feature@GetTokenDetails') { vaultId :'#(txnInfo.destinationId)', walletId: '#(usdcWallet)'}
      * match responseStatus == 200
