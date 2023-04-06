@RAKCON-10942 @ignore
Feature: Transfer
  Background:
    * url baseURL
    * call read('RequesterAuthenticator.feature@RequesterAccessToken')
    * def user = call read('UserManagement.feature@GetAccountMe')
    * def userId = user.response.data.id
    * def dataBody = read('classpath:data/data_test.json')

    #TCs: GET LIST ASSET FOR TRANSFER
  @ignore @RAKCON-11337 @Get_asset_transfer
  Scenario: Transfer - View asset list for transfer
    * def query = { limit:'10', offset: '0', sort:'ASC', groupBy: 'ASSET'}
    Given path 'core/wallet/transfer-tokens'
    And params query
    When method GET
    Then status 200
    And match response.status == "success"
    * def tokenSymbol = response.data.tokens[0].externalAssetId
    * def tokenId = response.data.tokens[0].id
    * def symbol = response.data.tokens[0].nativeSymbol

    #TCs: VIEW SOURCE FOR TRANSFER
  @ignore @RAKCON-11338 @Get_source_transfer
  Scenario: Transfer - View source for transfer
    * call read('Transfer.feature@Get_asset_transfer')
    * def query = { fromScreen: '#(dataBody.transfer.from_screen_source)', limit:'20', offset: '0', sort:'ASC', groupBy: 'VAULT', tokenSymbol: '#(tokenSymbol)',}
    Given path 'core/vault/accounts'
    And params query
    When method GET
    Then status 200
    And match response.status == "success"
    * def sourceId = response.data.vaults[0].id
    * def totalToUSD = response.data.vaults[0].totalUSD
    * def total = response.data.vaults[0].wallets[0].total
    * def sourceName = response.data.vaults[0].name

    #TCs: VIEW DESTINATION FOR TRANSFER
  @ignore @RAKCON-11339 @Get_destination_transfer
  Scenario: Transfer - View destination for transfer
    * call read('Transfer.feature@Get_asset_transfer')
    * def query = { fromScreen: '#(dataBody.transfer.from_screen_destination)', limit:'20', offset: '0', sort:'DESC', sortBy: 'TOTAL_USD', tokenSymbol: '#(tokenSymbol)'}
    Given path 'core/vault/accounts'
    And params query
    When method GET
    Then status 200
    And match response.status == "success"
    * def destinationId = response.data.vaults[0].id
    * def destinationName = response.data.vaults[0].name


  @ignore @RAKCON-11344 @Get_estimate_fee
    Scenario: Transfer - Get estimated fee
    * call read('Transfer.feature@Get_asset_transfer')
    * call read('Transfer.feature@Get_source_transfer')
    * call read('Transfer.feature@Get_destination_transfer')
    * def body = { "assetId":'#(tokenSymbol)', "destinationType": '#(dataBody.transfer.destinationType)', "sourceType":'#(dataBody.transfer.source_type)', "sourceId": '#(sourceId)',"amount":'#(dataBody.transfer.amount_low)',"destinationId":'#(destinationId)'}
      Given path 'core/transactions/estimated-fee'
      And request body
      When method POST
      Then status 201
      And match response.status == "success"
      And match response.data.feeType == "#(tokenSymbol)"
#      And match response.data.totalToUSD == "#(totalToUSD)"
    * def fee = response.data.medium
    * def feeType = response.data.feeType

    #TCs: Total estimate fee
  @ignore @RAKCON-11349 @Total_estimate_fee
  Scenario: Transfer - Total estimated fee
    * call read('Transfer.feature@Get_estimate_fee')
    * def body = { "assetId":'#(tokenSymbol)', "destinationType": '#(dataBody.transfer.destinationType)', "sourceType":'#(dataBody.transfer.source_type)', "sourceId": '#(sourceId)',"amount":'#(dataBody.transfer.amount_low)',"destinationId":'#(destinationId)', "fee":'#(parseInt(fee))',"isNetAmount":false}
    Given path 'core/transactions/total-estimate-fee'
    And request body
    When method POST
    Then status 201
    And match response.status == "success"
    * def totalEstimatedFee = response.data.totalEstimatedFee

    #TCs: Submit tranfer low value
  @RAKCON-10959 @Transfer_low_value
  Scenario: Internal withdraw - Check submit with low value
    * call read('Transfer.feature@Total_estimate_fee')
    * def body = { "operation":'#(dataBody.transfer.operation)',"tokenId":'#(tokenId)',"feeType":'#(feeType)',"fee":'#(parseInt(fee))', "treatAsGrossAmount": true, "feeLevel": '#(dataBody.transfer.feeLevel)', "destination":{"type":'#(dataBody.transfer.destinationType)',"id":'#(destinationId)'}, "source": {"type":'#(dataBody.transfer.source_type)',"id":'#(sourceId)'},"amount":'#(dataBody.transfer.amount_low)',"totalEstimatedFee":'#(totalEstimatedFee)'}
    * callonce read('Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    Given path 'core/transactions'
    And request body
    When method POST
    Then status 201
    And response.status == "success"
    And response.data.status == "PENDING"
    And response.data.amount == "#(dataBody.transfer.amount_low)"
    And response.data.sourceName == "#(sourceName)"
    And response.data.destinationName == "#(destinationName)"
    And response.data.symbol == "#(symbol)"

  #Tcs: Submit transfer medium value
  # TCs: View transaction after submit
