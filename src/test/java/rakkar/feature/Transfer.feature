@RAKCON-10583
Feature: Transfer
  Background:
    * url baseURL
    * call read('RequesterAuthenticator.feature@RequesterAccessToken')
    * call read('UserManagement.feature@GetAccountMe')
    * def dataBody = read('classpath:data/data_test.json')

    #TCs: GET LIST ASSET FOR TRANSFER
  @RAKCON-13183 @Get_asset_transfer
  Scenario: Transfer - View asset list for transfer
    * def query = { limit:'10', offset: '0', sort:'ASC', groupBy: 'ASSET', keyword:'xrp'}
    Given path 'core/wallet/transfer-tokens'
    And params query
    When method GET
    Then status 200
    And match response.status == "success"

  #Get estimated fee : Hot to Hot
  @ignore @Get_estimate_fee_common
    Scenario: Transfer Hot to hot - Get estimated fee common
      Given path 'core/transactions/estimated-fee'
      And request body_estimate_fee
      When method POST
      Then status 201
      And match response.status == "success"
      And match response.data.feeType == "#(dataBody.transfer.withdraw.tokenSymbol)"

    #Get estimated fee : Hot to Hot
  @RAKCON-13154 @Get_estimate_fee_hot_to_hot
  Scenario: Transfer Hot to Hot- Get estimated fee
    * def body_estimate_fee = { "assetId":'#(dataBody.transfer.withdraw.tokenSymbol)', "destinationType": '#(dataBody.transfer.source_type)', "sourceType":'#(dataBody.transfer.source_type)', "sourceId": '#(sourceId_hot)',"amount":#(amount_low),"destinationId":'#(destinationId_hot)'}
    * call read('Transfer.feature@Get_estimate_fee_common')

  #Get estimated fee : Hot to Cold
   @RAKCON-13155 @Get_estimate_fee_hot_to_cold
  Scenario: Transfer Hot to cold- Get estimated fee
    * def body_estimate_fee = { "assetId":'#(dataBody.transfer.withdraw.tokenSymbol)', "destinationType": '#(dataBody.transfer.source_type)', "sourceType":'#(dataBody.transfer.source_type)', "sourceId": '#(sourceId_hot)',"amount":#(amount_low),"destinationId":'#(destinationId_cold)'}
    * call read('Transfer.feature@Get_estimate_fee_common')

  #Get estimated fee : Cold to Hot
   @RAKCON-13156 @Get_estimate_fee_cold_to_hot
  Scenario: Transfer Cold to hot - Get estimated fee
    * def body_estimate_fee = { "assetId":'#(dataBody.transfer.withdraw.tokenSymbol)', "destinationType": '#(dataBody.transfer.source_type)', "sourceType":'#(dataBody.transfer.source_type)', "sourceId": '#(sourceId_cold)',"amount":#(amount_low),"destinationId":'#(destinationId_hot)'}
    * call read('Transfer.feature@Get_estimate_fee_common')

     #Get estimated fee : Cold to Cold
   @RAKCON-13157 @Get_estimate_fee_cold_to_cold
  Scenario: Transfer Cold to cold - Get estimated fee
    * def body_estimate_fee = { "assetId":'#(dataBody.transfer.withdraw.tokenSymbol)', "destinationType": '#(dataBody.transfer.source_type)', "sourceType":'#(dataBody.transfer.source_type)', "sourceId": '#(sourceId_cold)',"amount":#(amount_low),"destinationId":'#(destinationId_cold)'}
    * call read('Transfer.feature@Get_estimate_fee_common')

  @ignore @Total_estimate_fee_common
  Scenario: Transfer Hot to hot - Total estimated fee common
    Given path 'core/transactions/total-estimate-fee'
    And request body_total_estimate
    When method POST
    Then status 201
    And match response.status == "success"

    #TCs: Total estimate fee: Hot to hot
  @RAKCON-13158 @Total_estimate_fee_hot_hot
  Scenario: Transfer Hot to hot - Total estimated fee
    * def body_total_estimate = { "assetId":'#(dataBody.transfer.withdraw.tokenSymbol)', "destinationType": '#(dataBody.transfer.source_type)', "sourceType":'#(dataBody.transfer.source_type)', "sourceId": '#(sourceId_hot)',"amount":#(amount_low),"destinationId":'#(destinationId_hot)', "fee":#(Number(dataBody.transfer.withdraw.fee)),"isNetAmount":false}
    * call read('Transfer.feature@Total_estimate_fee_common')

   #TCs: Total estimate fee: Hot to Cold
  @RAKCON-13159 @Total_estimate_fee_hot_cold
  Scenario: Transfer Hot to cold - Total estimated fee
    * def body_total_estimate = { "assetId":'#(dataBody.transfer.withdraw.tokenSymbol)', "destinationType": '#(dataBody.transfer.source_type)', "sourceType":'#(dataBody.transfer.source_type)', "sourceId": '#(sourceId_hot)',"amount":#(amount_low),"destinationId":'#(destinationId_cold)', "fee":'#(Number(dataBody.transfer.withdraw.fee))',"isNetAmount":false}
    * call read('Transfer.feature@Total_estimate_fee_common')

     #TCs: Total estimate fee: Cold to Hot
  @RAKCON-13160 @Total_estimate_fee_cold_hot
  Scenario: Transfer Cold to hot - Total estimated fee
    * def body_total_estimate = { "assetId":'#(dataBody.transfer.withdraw.tokenSymbol)', "destinationType": '#(dataBody.transfer.source_type)', "sourceType":'#(dataBody.transfer.source_type)', "sourceId": '#(sourceId_cold)',"amount":#(amount_low),"destinationId":'#(destinationId_hot)', "fee":'#(Number(dataBody.transfer.withdraw.fee))',"isNetAmount":false}
    * call read('Transfer.feature@Total_estimate_fee_common')

     #TCs: Total estimate fee: Cold to Cold
  @RAKCON-13161 @Total_estimate_fee_cold_cold
  Scenario: Transfer Cold to cold - Total estimated fee
    * def body_total_estimate = { "assetId":'#(dataBody.transfer.withdraw.tokenSymbol)', "destinationType": '#(dataBody.transfer.source_type)', "sourceType":'#(dataBody.transfer.source_type)', "sourceId": '#(sourceId_cold)',"amount":#(amount_low),"destinationId":'#(destinationId_cold)', "fee":'#(Number(dataBody.transfer.withdraw.fee))',"isNetAmount":false}
    * call read('Transfer.feature@Total_estimate_fee_common')

    #Tcs: TRANSFER VAULT HOT TO HOT
  @RAKCON-11390 @Transfer_value_hot_to_hot
  Scenario: Transfer Hot to hot - Submit transfer
    * def body = { "operation":'#(dataBody.transfer.operation)',"tokenId":'#(tokenId)',"feeType":'#(dataBody.transfer.withdraw.feeType)',"fee":'#(Number(dataBody.transfer.withdraw.fee))', "treatAsGrossAmount": true, "feeLevel": '#(dataBody.transfer.feeLevel)', "destination":{"type":'#(dataBody.transfer.source_type)',"id":'#(destinationId_hot)'}, "source": {"type":'#(dataBody.transfer.source_type)',"id":'#(sourceId_hot)'},"amount":#(amount_low),"totalEstimatedFee":'#(dataBody.transfer.withdraw.fee)'}
    * call read('Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    Given path 'core/transactions'
    And request body
    When method POST
    Then status 201
    And response.status == "success"
    And response.data.status == "PENDING"
    And response.data.amount == "#(amount_low)"
    And response.data.sourceName == "#(dataBody.transfer.withdraw.sourceName_hot)"
    And response.data.destinationName == "#(dataBody.transfer.withdraw.destinationName_hot)"
    And response.data.symbol == "#(dataBody.transfer.withdraw.symbol)"

  @RAKCON-11918 @Cancel_transaction_hot_to_hot
  Scenario: Transfer Hot to hot - Cancel transfer
    * call read('Transfer.feature@View_My_Request_Transfer')

    #Tcs: TRANSFER VAULT HOT TO COLD
  @RAKCON-11393 @Transfer_value_hot_to_cold
  Scenario: Transfer Hot to cold - Submit transfer
    * def body = { "operation":'#(dataBody.transfer.operation)',"tokenId":'#(tokenId)',"feeType":'#(dataBody.transfer.withdraw.feeType)',"fee":'#(Number(dataBody.transfer.withdraw.fee))', "treatAsGrossAmount": true, "feeLevel": '#(dataBody.transfer.feeLevel)', "destination":{"type":'#(dataBody.transfer.source_type)',"id":'#(destinationId_cold)'}, "source": {"type":'#(dataBody.transfer.source_type)',"id":'#(sourceId_hot)'},"amount":#(amount_low),"totalEstimatedFee":'#(dataBody.transfer.withdraw.fee)'}
    * call read('Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    Given path 'core/transactions'
    And request body
    When method POST
    Then status 201
    And response.status == "success"
    And response.data.status == "PENDING"
    And response.data.amount == "#(amount_low)"
    And response.data.sourceName == "#(dataBody.transfer.withdraw.sourceName_hot)"
    And response.data.destinationName == "#(dataBody.transfer.withdraw.destinationName_cold)"
    And response.data.symbol == "#(dataBody.transfer.withdraw.symbol)"

  @RAKCON-11919 @Cancel_transaction_hot_to_cold
  Scenario: Transfer Hot to cold - Cancel transfer
    * call read('Transfer.feature@View_My_Request_Transfer')

    #Tcs: TRANSFER VAULT COLD TO HOT
  @RAKCON-11396 @Transfer_value_cold_to_hot
  Scenario: Transfer Cold to hot - Submit transfer
    * def body = { "operation":'#(dataBody.transfer.operation)',"tokenId":'#(tokenId)',"feeType":'#(dataBody.transfer.withdraw.feeType)',"fee":'#((dataBody.transfer.withdraw.fee))', "treatAsGrossAmount": true, "feeLevel": '#(dataBody.transfer.feeLevel)', "destination":{"type":'#(dataBody.transfer.source_type)',"id":'#(destinationId_hot)'}, "source": {"type":'#(dataBody.transfer.source_type)',"id":'#(sourceId_cold)'},"amount":#(amount_low),"totalEstimatedFee":'#(dataBody.transfer.withdraw.fee)'}
    * call read('Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    Given path 'core/transactions'
    And request body
    When method POST
    Then status 201
    And response.status == "success"
    And response.data.status == "PENDING"
    And response.data.amount == "#(amount_low)"
    And response.data.sourceName == "#(dataBody.transfer.withdraw.sourceName_cold)"
    And response.data.destinationName == "#(dataBody.transfer.withdraw.destinationName_hot)"
    And response.data.symbol == "#(dataBody.transfer.withdraw.symbol)"

  @RAKCON-11920 @Cancel_transaction_cold_to_hot
  Scenario: Transfer Cold to hot - Cancel transfer
    * call read('Transfer.feature@View_My_Request_Transfer')

  #Tcs: TRANSFER VAULT COLD TO COLD
  @RAKCON-11399 @Transfer_value_cold_to_cold
  Scenario: Transfer Cold to cold - Submit transfer
    * def body = { "operation":'#(dataBody.transfer.operation)',"tokenId":'#(tokenId)',"feeType":'#(dataBody.transfer.withdraw.feeType)',"fee":'#(Number(dataBody.transfer.withdraw.fee))', "treatAsGrossAmount": true, "feeLevel": '#(dataBody.transfer.feeLevel)', "destination":{"type":'#(dataBody.transfer.source_type)',"id":'#(destinationId_cold)'}, "source": {"type":'#(dataBody.transfer.source_type)',"id":'#(sourceId_cold)'},"amount":#(amount_low),"totalEstimatedFee":'#(dataBody.transfer.withdraw.fee)'}
    * call read('Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    Given path 'core/transactions'
    And request body
    When method POST
    Then status 201
    And response.status == "success"
    And response.data.status == "PENDING"
    And response.data.amount == "#(amount_low)"
    And response.data.sourceName == "#(dataBody.transfer.withdraw.sourceName_cold)"
    And response.data.destinationName == "#(dataBody.transfer.withdraw.destinationName_cold)"
    And response.data.symbol == "#(dataBody.transfer.withdraw.symbol)"

  @RAKCON-11921 @Cancel_transaction_cold_to_cold
  Scenario: Transfer Cold to cold - Cancel transfer
    * call read('Transfer.feature@View_My_Request_Transfer')

  #Tcs: TRANSFER MEDIUM VALUE
  @Get_estimate_fee_medium_value
  Scenario: Transfer medium - Get estimated fee
    * def body_estimate_fee = { "assetId":'#(dataBody.transfer.withdraw.tokenSymbol)', "destinationType": '#(dataBody.transfer.source_type)', "sourceType":'#(dataBody.transfer.source_type)', "sourceId": '#(sourceId_hot)',"amount":#(amount_medium),"destinationId":'#(destinationId_hot)'}
    * call read('Transfer.feature@Get_estimate_fee_common')

    #Total estimate fee for high value
  @Total_estimate_fee_medium_value
  Scenario: Transfer medium - Total estimated fee
    * def body_total_estimate = { "assetId":'#(dataBody.transfer.withdraw.tokenSymbol)', "destinationType": '#(dataBody.transfer.source_type)', "sourceType":'#(dataBody.transfer.source_type)', "sourceId": '#(sourceId_hot)',"amount":#(amount_medium),"destinationId":'#(destinationId_hot)', "fee":'#(Number(dataBody.transfer.withdraw.fee))',"isNetAmount":false}
    * call read('Transfer.feature@Total_estimate_fee_common')

  @RAKCON-11402 @Transfer_medium_value
  Scenario: Transfer medium - Submit transfer
    * def body = { "operation":'#(dataBody.transfer.operation)',"tokenId":'#(tokenId)',"feeType":'#(dataBody.transfer.withdraw.feeType)',"fee":'#((dataBody.transfer.withdraw.fee))', "treatAsGrossAmount": true, "feeLevel": '#(dataBody.transfer.feeLevel)', "destination":{"type":'#(dataBody.transfer.source_type)',"id":'#(destinationId_hot)'}, "source": {"type":'#(dataBody.transfer.source_type)',"id":'#(sourceId_hot)'},"amount":#(amount_medium),"totalEstimatedFee":'#(dataBody.transfer.withdraw.fee)'}
    * call read('Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    * header passcode = requesterInfo.requesterPasscode
    Given path 'core/transactions'
    And request body
    When method POST
    Then status 201
    And response.status == "success"
    And response.data.status == "PENDING"
    And response.data.amount == "#(amount_medium)"
    And response.data.sourceName == "#(dataBody.transfer.withdraw.sourceName_hot)"
    And response.data.destinationName == "#(dataBody.transfer.withdraw.destinationName_hot)"
    And response.data.symbol == "#(dataBody.transfer.withdraw.symbol)"

  @RAKCON-11922 @Cancel_transaction_medium
  Scenario: Transfer Medium - Cancel transfer
    * call read('Transfer.feature@View_My_Request_Transfer')

  #Tcs: TRANSFER HIGH VALUE
  @Get_estimate_fee_high_value
  Scenario: Transfer high - Get estimated fee
    * def body_estimate_fee = { "assetId":'#(dataBody.transfer.withdraw.tokenSymbol)', "destinationType": '#(dataBody.transfer.source_type)', "sourceType":'#(dataBody.transfer.source_type)', "sourceId": '#(sourceId_hot)',"amount":#(amount_high),"destinationId":'#(destinationId_hot)'}
    * call read('Transfer.feature@Get_estimate_fee_common')

  @Total_estimate_fee_high_value
  Scenario: Transfer high - Total estimated fee
    * def body_total_estimate = { "assetId":'#(dataBody.transfer.withdraw.tokenSymbol)', "destinationType": '#(dataBody.transfer.source_type)', "sourceType":'#(dataBody.transfer.source_type)', "sourceId": '#(sourceId_hot)',"amount":#(amount_high),"destinationId":'#(destinationId_hot)', "fee":'#(Number(dataBody.transfer.withdraw.fee))',"isNetAmount":false}
    * call read('Transfer.feature@Total_estimate_fee_common')

  @RAKCON-11405 @Transfer_high_value
   Scenario: Transfer high - Submit transfer
    * call read('Common.feature@VIDEO_SPEECH_PROMPT')
    * def query_upload_link = { contentType: 'video/mp4', fileName:'video.mp4', userId: '#(userId)', type: 'VIDEO'}
    * call read('Common.feature@UPLOAD_LINK')
    * call read('UploadFile.feature@PUT_VIDEO')
    * def body = { "uploadToken":'#(uploadToken)',"vdoSentence":'#(vdoSentence)', "operation":'#(dataBody.transfer.operation)',"tokenId":'#(tokenId)',"feeType":'#(dataBody.transfer.withdraw.feeType)',"fee":'#(Number(dataBody.transfer.withdraw.fee))', "treatAsGrossAmount": true, "feeLevel": '#(dataBody.transfer.feeLevel)', "destination":{"type":'#(dataBody.transfer.source_type)',"id":'#(destinationId_hot)'}, "source": {"type":'#(dataBody.transfer.source_type)',"id":'#(sourceId_hot)'},"amount":#(amount_high),"totalEstimatedFee":'#(dataBody.transfer.withdraw.fee)'}
    * call read('Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    * header passcode = requesterInfo.requesterPasscode
    Given path 'core/transactions'
    And request body
    When method POST
    Then status 201
    And response.status == "success"
    And response.data.status == "PENDING"
    And response.data.amount == "#(dataBody.transfer.amount_high)"
    And response.data.sourceName == "#(dataBody.transfer.withdraw.sourceName_hot)"
    And response.data.destinationName == "#(dataBody.transfer.withdraw.destinationName_hot)"
    And response.data.symbol == "#(dataBody.transfer.withdraw.symbol)"

  @RAKCON-11923 @Cancel_transaction_high
  Scenario: Transfer High - Cancel transfer
    * call read('Transfer.feature@View_My_Request_Transfer')

  #EXTERNAL WITHDRAW
  @Get_estimate_fee_external_transfer
  Scenario: External - Get estimated fee
    * def body_estimate_fee = { "assetId":'#(dataBody.transfer.withdraw.tokenSymbol)', "destinationType": '#(dataBody.transfer.destinationType)', "sourceType":'#(dataBody.transfer.source_type)', "sourceId": '#(sourceId_hot)',"amount":#(amount_low),"destinationId":'#(externalId)'}
    * call read('Transfer.feature@Get_estimate_fee_common')

  @Total_estimate_fee_external_transfer
  Scenario: External - Total estimated fee
    * def body_total_estimate = { "assetId":'#(dataBody.transfer.withdraw.tokenSymbol)', "destinationType": '#(dataBody.transfer.destinationType)', "sourceType":'#(dataBody.transfer.source_type)', "sourceId": '#(sourceId_hot)',"amount":#(amount_low),"destinationId":'#(externalId)', "fee":'#(Number(dataBody.transfer.withdraw.fee))',"isNetAmount":false}
    * call read('Transfer.feature@Total_estimate_fee_common')

  @RAKCON-11408 @External_Transfer
  Scenario:  External - Submit transfer
    * def body = { "operation":'#(dataBody.transfer.operation)',"tokenId":'#(tokenId)',"feeType":'#(dataBody.transfer.withdraw.feeType)',"fee":'#(Number(dataBody.transfer.withdraw.fee))', "treatAsGrossAmount": true, "feeLevel": '#(dataBody.transfer.feeLevel)', "destination":{"type":'#(dataBody.transfer.destinationType)',"id":'#(externalId)'}, "source": {"type":'#(dataBody.transfer.source_type)',"id":'#(sourceId_hot)'},"amount":#(amount_low),"totalEstimatedFee":'#(dataBody.transfer.withdraw.fee)'}
    * call read('Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    Given path 'core/transactions'
    And request body
    When method POST
    Then status 201
    And response.status == "success"
    And response.data.status == "PENDING"
    And response.data.amount == "#(amount_low)"
    And response.data.sourceName == "#(dataBody.transfer.withdraw.sourceName_hot)"
#    And response.data.destinationName == "#(externalName)"
    And response.data.symbol == "#(dataBody.transfer.withdraw.symbol)"

  @RAKCON-11924 @Cancel_transaction_external
  Scenario: Transfer External - Cancel transfer
    * call read('Transfer.feature@View_My_Request_Transfer')

  @RAKCON-12493 @Check_vault_missing_policy
   Scenario: Check vault missing policy
    * def query = { offset: '0',limit: '10', sort: 'ASC', groupBy: 'ASSET'}
   Given path 'core/vault/vault-missing-policy'
   And params query
   When method GET
   Then status 200
    And response.status == "success"

  @RAKCON-12803 @Get_restrict_country_list
  Scenario: Get restrict country list
    Given path 'core/restricted/check-country'
    When method GET
    Then status 200
    And response.status == "success"

  @ignore @View_My_Request_Transfer
  Scenario: View my request for type transfer
    Given path 'core/quorums'
    * def body = { offset : '0',limit : '10',keyword : '',requestCategories:["TRANSFER"],createdBy: '#(userId)',status : ["PENDING"],isHistory : true }
    And request body
    When method POST
    Then status 201
    And match response.data.records[0].type.value == 'WITHDRAW_APPROVAL'
    And match response.data.records[0].type.nameDisplay == 'Withdraw Approval'
    * def requestId = response.data.records[0].id
    * call read('CancelRequest.feature@CancelRequestCommon')

