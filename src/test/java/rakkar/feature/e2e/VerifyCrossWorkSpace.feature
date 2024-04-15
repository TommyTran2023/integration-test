@ignore @RAKCON-10583
Feature: Verify after transfer cross workspace

  Background:
    * def testData = read('classpath:data/cross_workspace_data.json')
    * def feeData = read('classpath:data/data_test.json')

 # ============ This is for verify the destination on DEV env - with WARM workspace =============
  @GetBalanceTokenBeforeTransferDev @GetBalanceTokenAfterTransferDev
  Scenario: Get balance token before transfer in Dev workspace
    * call read('CrossWorkSpaceAuthenticator.feature@RequesterAccessTokenDev')
    * def query_detail = { vaultId :'#(testData.dev_workspace.vaultId_Destination)', walletId: '#(testData.dev_workspace.walletId_Destination)'}
    Given url testData.dev_workspace.url_dev + '/core/wallet/token-details/'
    And params query_detail
    When method GET
    Then status 200

  @VerifyBalanceDestinationDev
  Scenario: Verify balance for destination in Dev workspace
    * call read('CrossWorkSpaceAuthenticator.feature@RequesterAccessTokenDev')
    # Get detail token in destination
    * def query_detail = { vaultId :'#(testData.dev_workspace.vaultId_Destination)', walletId: '#(testData.dev_workspace.walletId_Destination)'}
    * def getDestinationToken = call read('VerifyCrossWorkSpace.feature@GetBalanceTokenAfterTransferDev')
    * def total_destination_after_transfer = parseFloat(getDestinationToken.response.data.total)
    * def amount_recieve = parseFloat(amount_low) - parseFloat(feeData.transfer.withdraw.fee)
    # --- Verify balance of destination updated correctly
    * def totalExpectedDestination = amount_recieve + parseFloat(destinationAmountBefore)
    * print amount_recieve, destinationAmountBefore, totalExpectedDestination
    * match total_destination_after_transfer.toFixed(4) == totalExpectedDestination.toFixed(4)

    # Get recent transaction to check destination show in transaction
    * def query = { offset: 0, limit: 20,type: ['INCOMING']  }
    Given url testData.dev_workspace.url_dev + '/transaction/transactions/v1'
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

  # ============ This is for verify the destination on UAT env - with COLD workspace =============
  @GetBalanceTokenBeforeTransferUat @GetBalanceTokenAfterTransferUat
  Scenario: Get balance token before transfer in UAT workspace
    * call read('CrossWorkSpaceAuthenticator.feature@RequesterAccessTokenUat')
    * def query_detail = { vaultId :'#(testData.uat_workspace.vaultId_Destination)', walletId: '#(testData.uat_workspace.walletId_Destination)'}
    Given url testData.uat_workspace.url_uat + '/core/wallet/token-details/'
    And params query_detail
    When method GET
    Then status 200

  @VerifyBalanceDestinationUat
  Scenario: Verify balance for destination in Uat workspace
    * call read('CrossWorkSpaceAuthenticator.feature@RequesterAccessTokenUat')
    # Verify balance updated correct
    * def query_detail = { vaultId :'#(testData.uat_workspace.vaultId_Destination)', walletId: '#(testData.uat_workspace.walletId_Destination)'}
    * def getDestinationToken = call read('VerifyCrossWorkSpace.feature@GetBalanceTokenAfterTransferUat')
    * def total_destination_after_transfer = parseFloat(getDestinationToken.response.data.total)
    * def amount_recieve = parseFloat(amount_low) - parseFloat(feeData.transfer.withdraw.fee)

    # --- Verify balance of destination updated correctly
    # Bug REP-1222
    * def totalExpectedDestination = amount_recieve + parseFloat(destinationAmountBefore)
    * print amount_recieve, destinationAmountBefore, totalExpectedDestination
    # * match total_destination_after_transfer.toFixed(4) == totalExpectedDestination.toFixed(4)

    # Get recent transaction to check destination show in transaction
    * def query = { offset: 0, limit: 20,type: ['INCOMING']  }
    Given url testData.uat_workspace.url_uat + '/transaction/transactions/v1'
    And request query
    When method POST
    Then status 201
    And match response.status == "success"
    * def transactionID_inDestination = response.data.transactions[0].id
    # --- Verify the destination show transaction
    # Bug REP-1222
    * match response.data.transactions[0].sourceAddress == sourceAdress_from_sourceTransfer
    # * match response.data.transactions[0].destinationAddress == destinationAdress_from_sourceTransfer
    # --- Verify the type of transaction is "Deposit"
    * match response.data.transactions[0].type == "INCOMING"







