@ignore
Feature: Get access token for user from cross workspace

  Background:
    * def crossData = read('classpath:data/cross_workspace_data.json')
    * def crossData = karate.jsonPath(crossData, "$.." + destinationEnv +"_workspace")[0]
    * def customUrl = karate.jsonPath(crossData, "$..url_"+destinationEnv)[0]
    * call read(svc + 'Auth.feature@GetUserAccessToken') { userName: '#(crossData.userInfo.requesterUsername)'}
    * def accessTokenWP = 'Bearer ' + response.data.AuthenticationResult.AccessToken

    
  @GetDestinationBalance
  Scenario: Get balance token
    * def destinationVault = isWarm ? crossData.vaultId_Destination_warm : crossData.vaultId_Destination
    * def destinationWallet = isWarm ? crossData.walletId_Destination_warm : crossData.walletId_Destination
    * def destination = 
    """
    {
      destinationVault: '#(destinationVault)',
      destinationWallet: '#(destinationWallet)'
    }
    """
    * call read(svc + 'Wallet.feature@GetTokenDetails') { accessToken: #(accessTokenWP), vaultId :'#(destinationVault)', walletId: '#(destinationWallet)'}
    Then match responseStatus == 200

  @VerifyBalanceDestination
  Scenario: Verify balance for destination 
    * def waitNewTransactionComing = 
    """
    function(isWarm, crossData, hash){
      var destinationWallet = karate.call("@GetDestinationBalance")
      
      var today = new Date();
      var yesterday = new Date();
      yesterday.setDate(yesterday.getDate() - 1);
      
      var query = {
        status : [
          "COMPLETED"
        ],
        assetId : [
          destinationWallet.response.data.id
        ],
        limit : 10,
        vaultId : destinationWallet.destinationVault,
        offset : 0,
        dateTo : today.toISOString(),
        dateFrom : yesterday.toISOString()
      }

      for (var i = 18; i > 0; i--) {
        java.lang.Thread.sleep(10000)
        var txnList = karate.call(svc + 'Transaction.feature@GetTransactionsList', { customUrl: customUrl, accessToken: destinationWallet.accessTokenWP, query: query }).response
        var txn = txnList.data.transactions.find(x => x.txHash == hash)
        
        if (txn != null)
          return {
            transaction: txn,
            walletInfo: karate.call("@GetDestinationBalance").response
          }
      }
      throw new Error(`\n---> Destination wallet cannot recieve token\nvaultId: ${destinationWallet.destinationVault}\nwalletId: ${destinationWallet.destinationWallet}\nhash: ${hash}`)
    }
    """
    # Verify balance updated correct
    * def getDestination = waitNewTransactionComing(isWarm, crossData, hash)
    * def total_destination_after_transfer = parseFloat(getDestination.walletInfo.data.available)
    * def amount_recieve = parseFloat(amount_low) - feeData

    # --- Verify balance of destination updated correctly
    * def totalExpectedDestination = amount_recieve + parseFloat(destinationAmountBefore)
    * print amount_recieve, destinationAmountBefore, totalExpectedDestination
    * match total_destination_after_transfer.toFixed(4) == totalExpectedDestination.toFixed(4)

    # Get recent transaction to check destination show in transaction
    * def transactionID_inDestination = getDestination.transaction.id
    # --- Verify the destination show transaction
    * match getDestination.transaction.sourceAddress == sourceAdress_from_sourceTransfer
    * match getDestination.transaction.destinationAddress == destinationAdress_from_sourceTransfer
    # --- Verify the type of transaction is "Deposit"
    * match getDestination.transaction.type == "INCOMING"


