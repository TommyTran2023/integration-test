@RAKCON-10942
Feature: Transfer
  Background:
    * url baseURL
    * call read('RequesterAuthenticator.feature@RequesterAccessToken')
    * call read('UserManagement.feature@GetAccountMe')
    * call read('common.feature@TIERS_SIGNER')
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
    * def sourceId_hot = ""
    * def sourceId_cold = ""
    * def sourceName_hot = ""
    * def sourceName_cold = ""
    And for(var i = 0; i < response.data.vaults.length; i++) if (response.data.vaults[i].type == "HOT_WALLET") { sourceId_hot = response.data.vaults[i].id ; sourceName_hot = response.data.vaults[i].name } else if (response.data.vaults[i].type == "COLD_WALLET") { sourceId_cold = response.data.vaults[i].id ; sourceName_cold = response.data.vaults[i].name}
    * def sourceId_hot = sourceId_hot
    * def sourceId_cold = sourceId_cold
    * def sourceName_hot = sourceName_hot
    * def sourceName_cold = sourceName_cold

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
    * def destinationId_hot = ""
    * def destinationId_cold = ""
    * def destinationName_hot = ""
    * def destinationName_cold = ""
    And for(var i = 0; i < response.data.vaults.length; i++) if (response.data.vaults[i].type == "HOT_WALLET") { destinationId_hot = response.data.vaults[i].id ; destinationName_hot = response.data.vaults[i].name } else if (response.data.vaults[i].type == "COLD_WALLET") { destinationId_cold = response.data.vaults[i].id ; destinationName_cold = response.data.vaults[i].name}
    * def destinationId_hot = destinationId_hot
    * def destinationId_cold = destinationId_cold
    * def destinationName_hot = destinationName_hot
    * def destinationName_cold = destinationName_cold

  #Get estimated fee : Hot to Hot
  @ignore @Get_estimate_fee_common
    Scenario: Transfer Hot to hot - Get estimated fee common
      Given path 'core/transactions/estimated-fee'
      And request body_estimate_fee
      When method POST
      Then status 201
      And match response.status == "success"
      And match response.data.feeType == "#(tokenSymbol)"
    * def fee = response.data.medium
    * def feeType = response.data.feeType

    #Get estimated fee : Hot to Hot
  @ignore @RAKCON-11334 @Get_estimate_fee_hot_to_hot
  Scenario: Transfer Hot to Hot- Get estimated fee
    * call read('Transfer.feature@Get_asset_transfer')
    * call read('Transfer.feature@Get_source_transfer')
    * call read('Transfer.feature@Get_destination_transfer')
    * def body_estimate_fee = { "assetId":'#(tokenSymbol)', "destinationType": '#(dataBody.transfer.source_type)', "sourceType":'#(dataBody.transfer.source_type)', "sourceId": '#(sourceId_hot)',"amount":#(amount_low),"destinationId":'#(destinationId_hot)'}
    * call read('Transfer.feature@Get_estimate_fee_common')

  #Get estimated fee : Hot to Cold
  @ignore @RAKCON-11391 @Get_estimate_fee_hot_to_cold
  Scenario: Transfer Hot to cold- Get estimated fee
    * call read('Transfer.feature@Get_asset_transfer')
    * call read('Transfer.feature@Get_source_transfer')
    * call read('Transfer.feature@Get_destination_transfer')
    * def body_estimate_fee = { "assetId":'#(tokenSymbol)', "destinationType": '#(dataBody.transfer.source_type)', "sourceType":'#(dataBody.transfer.source_type)', "sourceId": '#(sourceId_hot)',"amount":#(amount_low),"destinationId":'#(destinationId_cold)'}
    * call read('Transfer.feature@Get_estimate_fee_common')

  #Get estimated fee : Cold to Hot
  @ignore @RAKCON-11394 @Get_estimate_fee_cold_to_hot
  Scenario: Transfer Cold to hot - Get estimated fee
    * call read('Transfer.feature@Get_asset_transfer')
    * call read('Transfer.feature@Get_source_transfer')
    * call read('Transfer.feature@Get_destination_transfer')
    * def body_estimate_fee = { "assetId":'#(tokenSymbol)', "destinationType": '#(dataBody.transfer.source_type)', "sourceType":'#(dataBody.transfer.source_type)', "sourceId": '#(sourceId_cold)',"amount":#(amount_low),"destinationId":'#(destinationId_hot)'}
    * call read('Transfer.feature@Get_estimate_fee_common')

     #Get estimated fee : Cold to Cold
  @ignore @RAKCON-11397 @Get_estimate_fee_cold_to_cold
  Scenario: Transfer Cold to cold - Get estimated fee
    * call read('Transfer.feature@Get_asset_transfer')
    * call read('Transfer.feature@Get_source_transfer')
    * call read('Transfer.feature@Get_destination_transfer')
    * def body_estimate_fee = { "assetId":'#(tokenSymbol)', "destinationType": '#(dataBody.transfer.source_type)', "sourceType":'#(dataBody.transfer.source_type)', "sourceId": '#(sourceId_cold)',"amount":#(amount_low),"destinationId":'#(destinationId_cold)'}
    * call read('Transfer.feature@Get_estimate_fee_common')

  @ignore @Total_estimate_fee_common
  Scenario: Transfer Hot to hot - Total estimated fee common
    Given path 'core/transactions/total-estimate-fee'
    And request body_total_estimate
    When method POST
    Then status 201
    And match response.status == "success"
    * def totalEstimatedFee = response.data.totalEstimatedFee

    #TCs: Total estimate fee: Hot to hot
  @ignore @RAKCON-11349 @Total_estimate_fee_hot_hot
  Scenario: Transfer Hot to hot - Total estimated fee
    * call read('Transfer.feature@Get_estimate_fee_hot_to_hot')
    * def body_total_estimate = { "assetId":'#(tokenSymbol)', "destinationType": '#(dataBody.transfer.source_type)', "sourceType":'#(dataBody.transfer.source_type)', "sourceId": '#(sourceId_hot)',"amount":#(amount_low),"destinationId":'#(destinationId_hot)', "fee":#(Number(fee)),"isNetAmount":false}
    * call read('Transfer.feature@Total_estimate_fee_common')

   #TCs: Total estimate fee: Hot to Cold
  @ignore @RAKCON-11392 @Total_estimate_fee_hot_cold
  Scenario: Transfer Hot to cold - Total estimated fee
    * call read('Transfer.feature@Get_estimate_fee_hot_to_cold')
    * def body_total_estimate = { "assetId":'#(tokenSymbol)', "destinationType": '#(dataBody.transfer.source_type)', "sourceType":'#(dataBody.transfer.source_type)', "sourceId": '#(sourceId_hot)',"amount":#(amount_low),"destinationId":'#(destinationId_cold)', "fee":'#(Number(fee))',"isNetAmount":false}
    * call read('Transfer.feature@Total_estimate_fee_common')

     #TCs: Total estimate fee: Cold to Hot
  @ignore @RAKCON-11395 @Total_estimate_fee_cold_hot
  Scenario: Transfer Cold to hot - Total estimated fee
    * call read('Transfer.feature@Get_estimate_fee_cold_to_hot')
    * def body_total_estimate = { "assetId":'#(tokenSymbol)', "destinationType": '#(dataBody.transfer.source_type)', "sourceType":'#(dataBody.transfer.source_type)', "sourceId": '#(sourceId_cold)',"amount":#(amount_low),"destinationId":'#(destinationId_hot)', "fee":'#(Number(fee))',"isNetAmount":false}
    * call read('Transfer.feature@Total_estimate_fee_common')

     #TCs: Total estimate fee: Cold to Cold
  @ignore @RAKCON-11398 @Total_estimate_fee_cold_cold
  Scenario: Transfer Cold to cold - Total estimated fee
    * call read('Transfer.feature@Get_estimate_fee_cold_to_cold')
    * def body_total_estimate = { "assetId":'#(tokenSymbol)', "destinationType": '#(dataBody.transfer.source_type)', "sourceType":'#(dataBody.transfer.source_type)', "sourceId": '#(sourceId_cold)',"amount":#(amount_low),"destinationId":'#(destinationId_cold)', "fee":'#(Number(fee))',"isNetAmount":false}
    * call read('Transfer.feature@Total_estimate_fee_common')

    #Tcs: TRANSFER VAULT HOT TO HOT
  @RAKCON-11390 @Transfer_value_hot_to_hot
  Scenario: Transfer Hot to hot - Submit transfer
    * call read('Transfer.feature@tiger_signer')
    * call read('Transfer.feature@Total_estimate_fee_hot_hot')
    * def body = { "operation":'#(dataBody.transfer.operation)',"tokenId":'#(tokenId)',"feeType":'#(feeType)',"fee":'#(Number(fee))', "treatAsGrossAmount": true, "feeLevel": '#(dataBody.transfer.feeLevel)', "destination":{"type":'#(dataBody.transfer.source_type)',"id":'#(destinationId_hot)'}, "source": {"type":'#(dataBody.transfer.source_type)',"id":'#(sourceId_hot)'},"amount":#(amount_low),"totalEstimatedFee":'#(totalEstimatedFee)'}
    * call read('Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    Given path 'core/transactions'
    And request body
    When method POST
    Then status 201
    And response.status == "success"
    And response.data.status == "PENDING"
    And response.data.amount == "#(amount_low)"
    And response.data.sourceName == "#(sourceName_hot)"
    And response.data.destinationName == "#(destinationName_hot)"
    And response.data.symbol == "#(symbol)"

    #Tcs: TRANSFER VAULT HOT TO COLD
  @RAKCON-11393 @Transfer_value_hot_to_cold
  Scenario: Transfer Hot to cold - Submit transfer
    * call read('Transfer.feature@Total_estimate_fee_hot_cold')
    * def body = { "operation":'#(dataBody.transfer.operation)',"tokenId":'#(tokenId)',"feeType":'#(feeType)',"fee":'#(Number(fee))', "treatAsGrossAmount": true, "feeLevel": '#(dataBody.transfer.feeLevel)', "destination":{"type":'#(dataBody.transfer.source_type)',"id":'#(destinationId_cold)'}, "source": {"type":'#(dataBody.transfer.source_type)',"id":'#(sourceId_hot)'},"amount":#(amount_low),"totalEstimatedFee":'#(totalEstimatedFee)'}
    * call read('Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    Given path 'core/transactions'
    And request body
    When method POST
    Then status 201
    And response.status == "success"
    And response.data.status == "PENDING"
    And response.data.amount == "#(amount_low)"
    And response.data.sourceName == "#(sourceName_hot)"
    And response.data.destinationName == "#(destinationName_cold)"
    And response.data.symbol == "#(symbol)"

    #Tcs: TRANSFER VAULT COLD TO HOT
  @RAKCON-11396 @Transfer_value_cold_to_hot
  Scenario: Transfer Cold to hot - Submit transfer
    * call read('Transfer.feature@Total_estimate_fee_cold_hot')
    * def body = { "operation":'#(dataBody.transfer.operation)',"tokenId":'#(tokenId)',"feeType":'#(feeType)',"fee":'#((fee))', "treatAsGrossAmount": true, "feeLevel": '#(dataBody.transfer.feeLevel)', "destination":{"type":'#(dataBody.transfer.source_type)',"id":'#(destinationId_hot)'}, "source": {"type":'#(dataBody.transfer.source_type)',"id":'#(sourceId_cold)'},"amount":#(amount_low),"totalEstimatedFee":'#(totalEstimatedFee)'}
    * call read('Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    Given path 'core/transactions'
    And request body
    When method POST
    Then status 201
    And response.status == "success"
    And response.data.status == "PENDING"
    And response.data.amount == "#(amount_low)"
    And response.data.sourceName == "#(sourceName_cold)"
    And response.data.destinationName == "#(destinationName_hot)"
    And response.data.symbol == "#(symbol)"

  #Tcs: TRANSFER VAULT COLD TO COLD
  @RAKCON-11399 @Transfer_value_cold_to_cold
  Scenario: Transfer Cold to cold - Submit transfer
    * call read('Transfer.feature@Total_estimate_fee_cold_cold')
    * def body = { "operation":'#(dataBody.transfer.operation)',"tokenId":'#(tokenId)',"feeType":'#(feeType)',"fee":'#(Number(fee))', "treatAsGrossAmount": true, "feeLevel": '#(dataBody.transfer.feeLevel)', "destination":{"type":'#(dataBody.transfer.source_type)',"id":'#(destinationId_cold)'}, "source": {"type":'#(dataBody.transfer.source_type)',"id":'#(sourceId_cold)'},"amount":#(amount_low),"totalEstimatedFee":'#(totalEstimatedFee)'}
    * call read('Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    Given path 'core/transactions'
    And request body
    When method POST
    Then status 201
    And response.status == "success"
    And response.data.status == "PENDING"
    And response.data.amount == "#(amount_low)"
    And response.data.sourceName == "#(sourceName_cold)"
    And response.data.destinationName == "#(destinationName_cold)"
    And response.data.symbol == "#(symbol)"

  #Tcs: TRANSFER MEDIUM VALUE
  @ignore @RAKCON-11401 @Get_estimate_fee_medium_value
  Scenario: Transfer medium - Get estimated fee
    * call read('Transfer.feature@Get_asset_transfer')
    * call read('Transfer.feature@Get_source_transfer')
    * call read('Transfer.feature@Get_destination_transfer')
    * def body_estimate_fee = { "assetId":'#(tokenSymbol)', "destinationType": '#(dataBody.transfer.source_type)', "sourceType":'#(dataBody.transfer.source_type)', "sourceId": '#(sourceId_hot)',"amount":#(amount_medium),"destinationId":'#(destinationId_hot)'}
    * call read('Transfer.feature@Get_estimate_fee_common')

    #Total estimate fee for high value
  @ignore @RAKCON-11401 @Total_estimate_fee_medium_value
  Scenario: Transfer medium - Total estimated fee
    * call read('Transfer.feature@Get_estimate_fee_medium_value')
    * def body_total_estimate = { "assetId":'#(tokenSymbol)', "destinationType": '#(dataBody.transfer.source_type)', "sourceType":'#(dataBody.transfer.source_type)', "sourceId": '#(sourceId_hot)',"amount":#(amount_medium),"destinationId":'#(destinationId_hot)', "fee":'#(Number(fee))',"isNetAmount":false}
    * call read('Transfer.feature@Total_estimate_fee_common')

  @RAKCON-11402 @Transfer_medium_value
  Scenario: Transfer medium - Submit transfer
    * call read('Transfer.feature@Total_estimate_fee_medium_value')
    * def body = { "operation":'#(dataBody.transfer.operation)',"tokenId":'#(tokenId)',"feeType":'#(feeType)',"fee":'#((fee))', "treatAsGrossAmount": true, "feeLevel": '#(dataBody.transfer.feeLevel)', "destination":{"type":'#(dataBody.transfer.source_type)',"id":'#(destinationId_hot)'}, "source": {"type":'#(dataBody.transfer.source_type)',"id":'#(sourceId_hot)'},"amount":#(amount_medium),"totalEstimatedFee":'#(totalEstimatedFee)'}
    * call read('Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    * header passcode = requesterPasscode
    Given path 'core/transactions'
    And request body
    When method POST
    Then status 201
    And response.status == "success"
    And response.data.status == "PENDING"
    And response.data.amount == "#(amount_medium)"
    And response.data.sourceName == "#(sourceName_hot)"
    And response.data.destinationName == "#(destinationName_hot)"
    And response.data.symbol == "#(symbol)"

  #Tcs: TRANSFER HIGH VALUE
  @ignore @RAKCON-11403 @Get_estimate_fee_high_value
  Scenario: Transfer high - Get estimated fee
    * call read('Transfer.feature@Get_asset_transfer')
    * call read('Transfer.feature@Get_source_transfer')
    * call read('Transfer.feature@Get_destination_transfer')
    * def body_estimate_fee = { "assetId":'#(tokenSymbol)', "destinationType": '#(dataBody.transfer.source_type)', "sourceType":'#(dataBody.transfer.source_type)', "sourceId": '#(sourceId_hot)',"amount":'#(dataBody.transfer.amount_high)',"destinationId":'#(destinationId_hot)'}
    * call read('Transfer.feature@Get_estimate_fee_common')

  @ignore @RAKCON-11404 @Total_estimate_fee_high_value
  Scenario: Transfer high - Total estimated fee
    * call read('Transfer.feature@Get_estimate_fee_high_value')
    * def body_total_estimate = { "assetId":'#(tokenSymbol)', "destinationType": '#(dataBody.transfer.source_type)', "sourceType":'#(dataBody.transfer.source_type)', "sourceId": '#(sourceId_hot)',"amount":'#(dataBody.transfer.amount_high)',"destinationId":'#(destinationId_hot)', "fee":'#(Number(fee))',"isNetAmount":false}
    * call read('Transfer.feature@Total_estimate_fee_common')

  @RAKCON-11405 @Transfer_high_value
   Scenario: Transfer high - Submit transfer
    * call read('Transfer.feature@Total_estimate_fee_high_value')
    * call read('Common.feature@VIDEO_SPEECH_PROMPT')
    * def query_upload_link = { contentType: 'video/mp4', fileName:'video.mp4', userId: '#(userId)', type: 'VIDEO'}
    * call read('Common.feature@UPLOAD_LINK')
    * call read('UploadFile.feature@PUT_VIDEO')
    * def body = { "uploadToken":'#(uploadToken)',"vdoSentence":'#(vdoSentence)', "operation":'#(dataBody.transfer.operation)',"tokenId":'#(tokenId)',"feeType":'#(feeType)',"fee":'#(Number(fee))', "treatAsGrossAmount": true, "feeLevel": '#(dataBody.transfer.feeLevel)', "destination":{"type":'#(dataBody.transfer.source_type)',"id":'#(destinationId_hot)'}, "source": {"type":'#(dataBody.transfer.source_type)',"id":'#(sourceId_hot)'},"amount":'#(dataBody.transfer.amount_high)',"totalEstimatedFee":'#(totalEstimatedFee)'}
    * call read('Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    * header passcode = requesterPasscode
    Given path 'core/transactions'
    And request body
    When method POST
    Then status 201
    And response.status == "success"
    And response.data.status == "PENDING"
    And response.data.amount == "#(dataBody.transfer.amount_high)"
    And response.data.sourceName == "#(sourceName_hot)"
    And response.data.destinationName == "#(destinationName_hot)"
    And response.data.symbol == "#(symbol)"

  #EXTERNAL WITHDRAW
  @ignore @RAKCON-11406 @Get_estimate_fee_external_transfer
  Scenario: External - Get estimated fee
    * call read('Transfer.feature@Get_asset_transfer')
    * call read('Transfer.feature@Get_source_transfer')
    * call read('WhiteListFolder.feature@Search_folder_by_type')
    * def body_estimate_fee = { "assetId":'#(tokenSymbol)', "destinationType": '#(dataBody.transfer.destinationType)', "sourceType":'#(dataBody.transfer.source_type)', "sourceId": '#(sourceId_hot)',"amount":#(amount_low),"destinationId":'#(externalId)'}
    * call read('Transfer.feature@Get_estimate_fee_common')

  @ignore @RAKCON-11407 @Total_estimate_fee_external_transfer
  Scenario: External - Total estimated fee
    * call read('Transfer.feature@Get_estimate_fee_external_transfer')
    * def body_total_estimate = { "assetId":'#(tokenSymbol)', "destinationType": '#(dataBody.transfer.destinationType)', "sourceType":'#(dataBody.transfer.source_type)', "sourceId": '#(sourceId_hot)',"amount":#(amount_low),"destinationId":'#(externalId)', "fee":'#(Number(fee))',"isNetAmount":false}
    * call read('Transfer.feature@Total_estimate_fee_common')

  @RAKCON-11408 @External_Transfer
  Scenario:  External - Submit transfer
    * call read('Transfer.feature@Total_estimate_fee_external_transfer')
    * def body = { "operation":'#(dataBody.transfer.operation)',"tokenId":'#(tokenId)',"feeType":'#(feeType)',"fee":'#(Number(fee))', "treatAsGrossAmount": true, "feeLevel": '#(dataBody.transfer.feeLevel)', "destination":{"type":'#(dataBody.transfer.destinationType)',"id":'#(externalId)'}, "source": {"type":'#(dataBody.transfer.source_type)',"id":'#(sourceId_hot)'},"amount":#(amount_low),"totalEstimatedFee":'#(totalEstimatedFee)'}
    * call read('Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    Given path 'core/transactions'
    And request body
    When method POST
    Then status 201
    And response.status == "success"
    And response.data.status == "PENDING"
    And response.data.amount == "#(amount_low)"
    And response.data.sourceName == "#(sourceName_hot)"
    And response.data.destinationName == "#(externalName)"
    And response.data.symbol == "#(symbol)"
    * def requestId = response.data.requestId
    * call read('CancelRequest.feature@CancelRequestCommon')
  # TCs: View transaction after submit
