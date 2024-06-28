@ignore
Feature: Get access token for user from cross workspace

  Background:
    * def crossData = read('classpath:data/cross_workspace_data.json')
    * def crossData = karate.jsonPath(crossData, "$.." + destinationEnv +"_workspace")[0]
    * def customUrl = karate.jsonPath(crossData, "$..url_"+destinationEnv)[0]
    * call read(svc + 'Auth.feature@GetUserAccessToken') { userName: '#(crossData.userInfo.requesterUsername)'}
    * def accessTokenWP = 'Bearer ' + response.data.AuthenticationResult.AccessToken

  # ============ This is for verify the destination on UAT env - with COLD workspace =============
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
    * def query_detail = { vaultId :'#(destinationVault)', walletId: '#(destinationWallet)'}
    Given url customUrl + '/core/wallet/token-details/'
    And headers { Authorization: '#(accessTokenWP)' }
    And params query_detail
    When method GET
    Then status 200

  @VerifyBalanceDestination
  Scenario: Verify balance for destination 
    * call read('@GetDestinationBalance')
    # Verify balance updated correct
    * def destinationVault = isWarm ? crossData.vaultId_Destination_warm : crossData.vaultId_Destination
    * def destinationWallet = isWarm ? crossData.walletId_Destination_warm : crossData.walletId_Destination
    * def destination = 
    """
    {
      destinationVault: '#(destinationVault)',
      destinationWallet: '#(destinationWallet)'
    }
    """
    * def query_detail = { vaultId :'#(destinationVault)', walletId: '#(destinationWallet)'}
    * def getDestinationToken = call read('@GetDestinationBalance') {isWarm: #(isWarm)}
    * def total_destination_after_transfer = parseFloat(getDestinationToken.response.data.total)
    * def amount_recieve = parseFloat(amount_low) - feeData

    # --- Verify balance of destination updated correctly
    # Bug REP-1222
    * def totalExpectedDestination = amount_recieve + parseFloat(destinationAmountBefore)
    * print amount_recieve, destinationAmountBefore, totalExpectedDestination
    * match total_destination_after_transfer.toFixed(4) == totalExpectedDestination.toFixed(4)

    # Get recent transaction to check destination show in transaction
    * def query = { offset: 0, limit: 20, type: ['INCOMING']  }
    Given url customUrl + '/transaction/transactions/v1'
    And headers { Authorization: '#(accessTokenWP)' }
    And request query
    When method POST
    Then status 201
    And match response.status == "success"
    * def transactionID_inDestination = response.data.transactions[0].id
    # --- Verify the destination show transaction
    * match response.data.transactions[0].sourceAddress == sourceAdress_from_sourceTransfer
    * match response.data.transactions[0].destinationAddress == destinationAdress_from_sourceTransfer
    # --- Verify the type of transaction is "Deposit"
    * match response.data.transactions[0].type == "INCOMING"


