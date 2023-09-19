@ignore @RAKCON-10583
Feature: Verify after transfer same workspace but different company

  Background:
    * url baseURL
    * def testData = read('classpath:data/cross_workspace_data.json')
    * def feeData = read('classpath:data/data_test.json')

 # ============ This is for verify the destination on same workspace but different company =============
  @GetBalanceTokenBeforeTransfer @GetBalanceTokenAfterTransfer
  Scenario: Get balance token before transfer in same workspace but different company
    * call read('DiffCustomerAuthenticator.feature@RequesterAccessToken_DifferentCompany')
    * def query_detail = { vaultId :'#(userOtherCustomerInfor.vaultId)', walletId: '#(userOtherCustomerInfor.walletId)'}
    Given path '/core/wallet/token-details/'
    And params query_detail
    When method GET
    Then status 200

  @VerifyBalanceDestination
  Scenario: Verify balance for destination in same workspace but different company
    * call read('DiffCustomerAuthenticator.feature@RequesterAccessToken_DifferentCompany')
    # Get detail token in destination
    * def query_detail = { vaultId :'#(userOtherCustomerInfor.vaultId)', walletId: '#(userOtherCustomerInfor.walletId)'}
    * def getDestinationToken = call read('VerifySameWorkSpace.feature@GetBalanceTokenAfterTransfer')
    * def total_destination_after_transfer = parseFloat(getDestinationToken.response.data.total)
    * def amount_recieve = parseFloat(amount_low) - parseFloat(feeData.transfer.withdraw.fee)
    * def totalExpectedDestination = parseFloat(destinationAmountBefore) + amount_recieve
    # --- Verify balance of destination updated correctly
    * match total_destination_after_transfer.toFixed(4) == totalExpectedDestination.toFixed(4)

    # Get recent transaction to check destination show in transaction
    * def query = { offset: 0, limit: 20,type: ['INCOMING']  }
    Given path '/transaction/transactions/v1'
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









