@RAKCON-10583
Feature: Transfer
  Background:
    * url baseURL
    * call read('this:RequesterAuthenticator.feature@RequesterAccessToken')
    * def userInfo = call read('this:GetUserInfo.feature@GetUserInfo')
    * call read('this:Common.feature@CACULATE_LIMIT_TRANSFER')
    * def testData = read('classpath:data/data_test.json')
    * def a = read('classpath:data/enum.json')
    * configure afterFeature = function(){ karate.call('this:AfterHook.feature@Handle_Pending_Request_Transfer'); }

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
      * print body_estimate_fee
      Given path 'transaction/transactions/estimated-fee'
      And request body_estimate_fee
      When method POST
      Then status 201
      And match response.status == "success"
      And match response.data.feeType == "#(testData.transfer.withdraw.tokenSymbol)"

    #Get estimated fee : Hot to Hot
  @RAKCON-13154 @Get_estimate_fee_hot_to_hot
  Scenario: Transfer Hot to Hot- Get estimated fee
    * def body_estimate_fee = { "assetId":'#(testData.transfer.withdraw.tokenSymbol)', "destinationType": '#(testData.transfer.source_type)', "sourceType":'#(testData.transfer.source_type)', "sourceId": '#(dataSet.sourceId_hot)',"amount":#(amount_low),"destinationId":'#(dataSet.destinationId_hot)'}
    * call read('this:Transfer.feature@Get_estimate_fee_common') {body_estimate_fee: body_estimate_fee}

  #Get estimated fee : Hot to Cold
   @RAKCON-13155 @Get_estimate_fee_hot_to_cold
  Scenario: Transfer Hot to cold- Get estimated fee
    * def body_estimate_fee = { "assetId":'#(testData.transfer.withdraw.tokenSymbol)', "destinationType": '#(testData.transfer.source_type)', "sourceType":'#(testData.transfer.source_type)', "sourceId": '#(dataSet.sourceId_hot)',"amount":#(amount_low),"destinationId":'#(dataSet.destinationId_cold)'}
    * call read('this:Transfer.feature@Get_estimate_fee_common') {body_estimate_fee: body_estimate_fee}

  #Get estimated fee : Cold to Hot
   @RAKCON-13156 @Get_estimate_fee_cold_to_hot
  Scenario: Transfer Cold to hot - Get estimated fee
    * def body_estimate_fee = { "assetId":'#(testData.transfer.withdraw.tokenSymbol)', "destinationType": '#(testData.transfer.source_type)', "sourceType":'#(testData.transfer.source_type)', "sourceId": '#(dataSet.sourceId_cold)',"amount":#(amount_low),"destinationId":'#(dataSet.destinationId_hot)'}
    * call read('this:Transfer.feature@Get_estimate_fee_common') {body_estimate_fee: body_estimate_fee}

     #Get estimated fee : Cold to Cold
   @RAKCON-13157 @Get_estimate_fee_cold_to_cold
  Scenario: Transfer Cold to cold - Get estimated fee
    * def body_estimate_fee = { "assetId":'#(testData.transfer.withdraw.tokenSymbol)', "destinationType": '#(testData.transfer.source_type)', "sourceType":'#(testData.transfer.source_type)', "sourceId": '#(dataSet.sourceId_cold)',"amount":#(amount_low),"destinationId":'#(dataSet.destinationId_cold)'}
    * call read('this:Transfer.feature@Get_estimate_fee_common') {body_estimate_fee: body_estimate_fee}

  @ignore @Total_estimate_fee_common
  Scenario: Transfer Hot to hot - Total estimated fee common
    Given path 'transaction/transactions/total-estimate-fee'
    And request body_total_estimate
    When method POST
    Then status 201
    And match response.status == "success"

    #TCs: Total estimate fee: Hot to hot
  @RAKCON-13158 @Total_estimate_fee_hot_hot
  Scenario: Transfer Hot to hot - Total estimated fee
    * def body_total_estimate = { "assetId":'#(testData.transfer.withdraw.tokenSymbol)', "destinationType": '#(testData.transfer.source_type)', "sourceType":'#(testData.transfer.source_type)', "sourceId": '#(dataSet.sourceId_hot)',"amount":#(amount_low),"destinationId":'#(dataSet.destinationId_hot)', "fee":#(Number(testData.transfer.withdraw.fee)),"isNetAmount":false}
    * call read('this:Transfer.feature@Total_estimate_fee_common')

   #TCs: Total estimate fee: Hot to Cold
  @RAKCON-13159 @Total_estimate_fee_hot_cold
  Scenario: Transfer Hot to cold - Total estimated fee
    * def body_total_estimate = { "assetId":'#(testData.transfer.withdraw.tokenSymbol)', "destinationType": '#(testData.transfer.source_type)', "sourceType":'#(testData.transfer.source_type)', "sourceId": '#(dataSet.sourceId_hot)',"amount":#(amount_low),"destinationId":'#(dataSet.destinationId_cold)', "fee":'#(Number(testData.transfer.withdraw.fee))',"isNetAmount":false}
    * call read('this:Transfer.feature@Total_estimate_fee_common')

     #TCs: Total estimate fee: Cold to Hot
  @RAKCON-13160 @Total_estimate_fee_cold_hot
  Scenario: Transfer Cold to hot - Total estimated fee
    * def body_total_estimate = { "assetId":'#(testData.transfer.withdraw.tokenSymbol)', "destinationType": '#(testData.transfer.source_type)', "sourceType":'#(testData.transfer.source_type)', "sourceId": '#(dataSet.sourceId_cold)',"amount":#(amount_low),"destinationId":'#(dataSet.destinationId_hot)', "fee":'#(Number(testData.transfer.withdraw.fee))',"isNetAmount":false}
    * call read('this:Transfer.feature@Total_estimate_fee_common')

     #TCs: Total estimate fee: Cold to Cold
  @RAKCON-13161 @Total_estimate_fee_cold_cold
  Scenario: Transfer Cold to cold - Total estimated fee
    * def body_total_estimate = { "assetId":'#(testData.transfer.withdraw.tokenSymbol)', "destinationType": '#(testData.transfer.source_type)', "sourceType":'#(testData.transfer.source_type)', "sourceId": '#(dataSet.sourceId_cold)',"amount":#(amount_low),"destinationId":'#(dataSet.destinationId_cold)', "fee":'#(Number(testData.transfer.withdraw.fee))',"isNetAmount":false}
    * call read('this:Transfer.feature@Total_estimate_fee_common')

    #Tcs: TRANSFER VAULT HOT TO HOT
  @RAKCON-11390 @Transfer_value_hot_to_hot
  Scenario: Transfer Hot to hot - Submit transfer
    * def body = { "operation":'#(testData.transfer.operation)',"tokenId":'#(dataSet.tokenId)',"feeType":'#(testData.transfer.withdraw.feeType)',"fee":'#(Number(testData.transfer.withdraw.fee))', "treatAsGrossAmount": true, "feeLevel": '#(testData.transfer.feeLevel)', "destination":{"type":'#(testData.transfer.source_type)',"id":'#(dataSet.destinationId_hot)'}, "source": {"type":'#(testData.transfer.source_type)',"id":'#(dataSet.sourceId_hot)'},"amount":#(amount_low),"totalEstimatedFee":'#(Number(testData.transfer.withdraw.fee))'}
    * call read('this:Transfer.feature@Internal_Transfer_Common')
    And response.status == "success"
    And response.data.status == "PENDING"
    And response.data.amount == "#(amount_low)"
    And response.data.sourceName == "#(testData.transfer.withdraw.sourceName_hot)"
    And response.data.destinationName == "#(testData.transfer.withdraw.destinationName_hot)"
    And response.data.symbol == "#(testData.transfer.withdraw.symbol)"

    #Tcs: TRANSFER VAULT HOT TO COLD
  @RAKCON-11393 @Transfer_value_hot_to_cold
  Scenario: Transfer Hot to cold - Submit transfer
    * def body = { "operation":'#(testData.transfer.operation)',"tokenId":'#(dataSet.tokenId)',"feeType":'#(testData.transfer.withdraw.feeType)',"fee":'#(Number(testData.transfer.withdraw.fee))', "treatAsGrossAmount": true, "feeLevel": '#(testData.transfer.feeLevel)', "destination":{"type":'#(testData.transfer.source_type)',"id":'#(dataSet.destinationId_cold)'}, "source": {"type":'#(testData.transfer.source_type)',"id":'#(dataSet.sourceId_hot)'},"amount":#(amount_low),"totalEstimatedFee":'#(Number(testData.transfer.withdraw.fee))'}
    * call read('this:Transfer.feature@Internal_Transfer_Common')
    And response.status == "success"
    And response.data.status == "PENDING"
    And response.data.amount == "#(amount_low)"
    And response.data.sourceName == "#(testData.transfer.withdraw.sourceName_hot)"
    And response.data.destinationName == "#(testData.transfer.withdraw.destinationName_cold)"
    And response.data.symbol == "#(testData.transfer.withdraw.symbol)"

    #Tcs: TRANSFER VAULT COLD TO HOT
  @RAKCON-11396 @Transfer_value_cold_to_hot
  Scenario: Transfer Cold to hot - Submit transfer
    * def body = { "operation":'#(testData.transfer.operation)',"tokenId":'#(dataSet.tokenId)',"feeType":'#(testData.transfer.withdraw.feeType)',"fee":'#((testData.transfer.withdraw.fee))', "treatAsGrossAmount": true, "feeLevel": '#(testData.transfer.feeLevel)', "destination":{"type":'#(testData.transfer.source_type)',"id":'#(dataSet.destinationId_hot)'}, "source": {"type":'#(testData.transfer.source_type)',"id":'#(dataSet.sourceId_cold)'},"amount":#(amount_low),"totalEstimatedFee":'#(Number(testData.transfer.withdraw.fee))'}
    * call read('this:Transfer.feature@Internal_Transfer_Common')
    And response.status == "success"
    And response.data.status == "PENDING"
    And response.data.amount == "#(amount_low)"
    And response.data.sourceName == "#(testData.transfer.withdraw.sourceName_cold)"
    And response.data.destinationName == "#(testData.transfer.withdraw.destinationName_hot)"
    And response.data.symbol == "#(testData.transfer.withdraw.symbol)"


  #Tcs: TRANSFER VAULT COLD TO COLD
  @RAKCON-11399 @Transfer_value_cold_to_cold
  Scenario: Transfer Cold to cold - Submit transfer
    * def body = { "operation":'#(testData.transfer.operation)',"tokenId":'#(dataSet.tokenId)',"feeType":'#(testData.transfer.withdraw.feeType)',"fee":'#(Number(testData.transfer.withdraw.fee))', "treatAsGrossAmount": true, "feeLevel": '#(testData.transfer.feeLevel)', "destination":{"type":'#(testData.transfer.source_type)',"id":'#(dataSet.destinationId_cold)'}, "source": {"type":'#(testData.transfer.source_type)',"id":'#(dataSet.sourceId_cold)'},"amount":#(amount_low),"totalEstimatedFee":'#(Number(testData.transfer.withdraw.fee))'}
    * call read('this:Transfer.feature@Internal_Transfer_Common') body
    And response.status == "success"
    And response.data.status == "PENDING"
    And response.data.amount == "#(amount_low)"
    And response.data.sourceName == "#(testData.transfer.withdraw.sourceName_cold)"
    And response.data.destinationName == "#(testData.transfer.withdraw.destinationName_cold)"
    And response.data.symbol == "#(testData.transfer.withdraw.symbol)"


  #Tcs: TRANSFER MEDIUM VALUE
  @Get_estimate_fee_medium_value
  Scenario: Transfer medium - Get estimated fee
    * def body_estimate_fee = { "assetId":'#(testData.transfer.withdraw.tokenSymbol)', "destinationType": '#(testData.transfer.source_type)', "sourceType":'#(testData.transfer.source_type)', "sourceId": '#(dataSet.sourceId_hot)',"amount":#(amount_medium),"destinationId":'#(dataSet.destinationId_hot)'}
    * call read('this:Transfer.feature@Get_estimate_fee_common') {body_estimate_fee: body_estimate_fee}

    #Total estimate fee for high value
  @Total_estimate_fee_medium_value
  Scenario: Transfer medium - Total estimated fee
    * def body_total_estimate = { "assetId":'#(testData.transfer.withdraw.tokenSymbol)', "destinationType": '#(testData.transfer.source_type)', "sourceType":'#(testData.transfer.source_type)', "sourceId": '#(dataSet.sourceId_hot)',"amount":#(amount_medium),"destinationId":'#(dataSet.destinationId_hot)', "fee":'#(Number(testData.transfer.withdraw.fee))',"isNetAmount":false}
    * call read('this:Transfer.feature@Total_estimate_fee_common') {body_estimate_fee: body_estimate_fee}

  @RAKCON-11402 @Transfer_medium_value
  Scenario: Transfer medium - Submit transfer
    * def body = 
    """
      { 
        "operation":'#(testData.transfer.operation)',
        "tokenId":'#(dataSet.tokenId)',"feeType":'#(testData.transfer.withdraw.feeType)',
        "fee":'#((testData.transfer.withdraw.fee))', 
        "treatAsGrossAmount": true, 
        "feeLevel": '#(testData.transfer.feeLevel)', 
        "destination":
        {
          "type":'#(testData.transfer.source_type)',
          "id":'#(dataSet.destinationId_hot)'
        }, 
        "source": 
        {
          "type":'#(testData.transfer.source_type)',
          "id":'#(dataSet.sourceId_hot)'
        },
        "amount":#(amount_medium),
        "totalEstimatedFee":'#(testData.transfer.withdraw.fee)'
      }
    """
    * call read('this:Transfer.feature@Internal_Transfer_Medium_High_Value')
    And response.status == "success"
    And response.data.status == "PENDING"
    And response.data.amount == "#(amount_medium)"
    And response.data.sourceName == "#(testData.transfer.withdraw.sourceName_hot)"
    And response.data.destinationName == "#(testData.transfer.withdraw.destinationName_hot)"
    And response.data.symbol == "#(testData.transfer.withdraw.symbol)"


  #Tcs: TRANSFER HIGH VALUE
  @Get_estimate_fee_high_value
  Scenario: Transfer high - Get estimated fee
    * def body_estimate_fee = { "assetId":'#(testData.transfer.withdraw.tokenSymbol)', "destinationType": '#(testData.transfer.source_type)', "sourceType":'#(testData.transfer.source_type)', "sourceId": '#(dataSet.sourceId_hot)',"amount":#(amount_high),"destinationId":'#(dataSet.destinationId_hot)'}
    * call read('this:Transfer.feature@Get_estimate_fee_common') {body_estimate_fee: body_estimate_fee}

  @Total_estimate_fee_high_value
  Scenario: Transfer high - Total estimated fee
    * def body_total_estimate = { "assetId":'#(testData.transfer.withdraw.tokenSymbol)', "destinationType": '#(testData.transfer.source_type)', "sourceType":'#(testData.transfer.source_type)', "sourceId": '#(dataSet.sourceId_hot)',"amount":#(amount_high),"destinationId":'#(dataSet.destinationId_hot)', "fee":'#(Number(testData.transfer.withdraw.fee))',"isNetAmount":false}
    * call read('this:Transfer.feature@Total_estimate_fee_common') {body_estimate_fee: body_estimate_fee}

  @RAKCON-11405 @Transfer_high_value
  Scenario: Transfer high - Submit transfer
    * call read('this:Common.feature@VIDEO_SPEECH_PROMPT')
    * def query_upload_link = { contentType: 'video/mp4', fileName:'video.mp4', userId: '#(userId)', type: 'VIDEO'}
    * call read('this:Common.feature@UPLOAD_LINK')
    * call read('this:UploadFile.feature@PUT_VIDEO')
    * def body = 
    """
      { 
        "uploadToken":'#(uploadToken)',
        "vdoSentence":'#(vdoSentence)', 
        "operation":'#(testData.transfer.operation)',
        "tokenId":'#(dataSet.tokenId)',
        "feeType":'#(testData.transfer.withdraw.feeType)',
        "fee":'#(testData.transfer.withdraw.fee)', 
        "treatAsGrossAmount": true, 
        "feeLevel": '#(testData.transfer.feeLevel)', 
        "destination":{"type":'#(testData.transfer.source_type)',
        "id":'#(dataSet.destinationId_hot)'}, 
        "source": 
        {
          "type":'#(testData.transfer.source_type)',
          "id":'#(dataSet.sourceId_hot)'
        },
        "amount":#(amount_high),
        "totalEstimatedFee":'#(testData.transfer.withdraw.fee)'
      }
    """
    * call read('this:Transfer.feature@Internal_Transfer_Medium_High_Value')
    And response.status == "success"
    And response.data.status == "PENDING"
    And response.data.amount == "#(testData.transfer.amount_high)"
    And response.data.sourceName == "#(testData.transfer.withdraw.sourceName_hot)"
    And response.data.destinationName == "#(testData.transfer.withdraw.destinationName_hot)"
    And response.data.symbol == "#(testData.transfer.withdraw.symbol)"

  #EXTERNAL WITHDRAW
  @Get_estimate_fee_external_transfer
  Scenario: External - Get estimated fee
    * def body_estimate_fee = 
    """
      { 
        "assetId":'#(a.TokenSymbol.XRP)', 
        "destinationType": '#(a.PeerType.EXTERNAL_WALLET)', 
        "sourceType":'#(a.PeerType.VAULT_ACCOUNT)', 
        "sourceId": '#(dataSet.sourceId_hot)',
        "amount":#(amount_low),
        "destinationId":'#(dataSet.externalId)'
      }
    """
    * print body_estimate_fee
    * call read('this:Transfer.feature@Get_estimate_fee_common') {body_estimate_fee: body_estimate_fee}

  @Total_estimate_fee_external_transfer
  Scenario: External - Total estimated fee
    * def body_total_estimate = 
    """
      { 
        "assetId":'#(testData.transfer.withdraw.tokenSymbol)', 
        "destinationType": '#(testData.transfer.destinationType)', 
        "sourceType":'#(testData.transfer.source_type)', 
        "sourceId": '#(dataSet.sourceId_hot)',
        "amount":#(amount_low),
        "destinationId":'#(dataSet.externalId)', 
        "fee":'#(Number(testData.transfer.withdraw.fee))',
        "isNetAmount":false
      }
    """
    * call read('this:Transfer.feature@Total_estimate_fee_common')

  @RAKCON-11408 @External_Transfer
  Scenario:  External - Submit transfer
    * def body_transfer = { "operation":'#(testData.transfer.operation)',"tokenId":'#(dataSet.tokenId)',"feeType":'#(testData.transfer.withdraw.feeType)',"fee":'#(Number(testData.transfer.withdraw.fee))', "treatAsGrossAmount": true, "feeLevel": '#(testData.transfer.feeLevel)', "destination":{"type":'#(testData.transfer.destinationType)',"id":'#(dataSet.externalId)'}, "source": {"type":'#(testData.transfer.source_type)',"id":'#(dataSet.sourceId_hot)'},"amount":#(amount_low),"totalEstimatedFee":'#(Number(testData.transfer.withdraw.fee))'}
    * call read('this:Transfer.feature@External_Transfer_Common')
    And response.data.sourceName == "#(testData.transfer.withdraw.sourceName_hot)"
    And response.data.symbol == "#(testData.transfer.withdraw.symbol)"

  @ignore @Internal_Transfer_Common
  Scenario:  Internal - Submit internal transfer common
    * call read('this:Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    Given path 'transaction/transactions'
    And request body
    When method POST
    Then status 201

  @ignore @Internal_Transfer_Medium_High_Value
  Scenario:  Internal - Submit internal transfer common
    * call read('this:Common.feature@FIDO-Requester')
    * header passcode = requesterInfo.requesterPasscode
    * header challenge-answer = challengeAnswerRequest
    Given path 'transaction/transactions'
    And request body
    When method POST
    Then status 201

  @ignore @External_Transfer_Common
  Scenario:  External - Submit external transfer common
#    * def body = { "operation":'#(testData.transfer.operation)',"tokenId":'#(dataSet.tokenId)',"feeType":'#(testData.transfer.withdraw.feeType)',"fee":'#(Number(testData.transfer.withdraw.fee))', "treatAsGrossAmount": true, "feeLevel": '#(testData.transfer.feeLevel)', "destination":{"type":'#(testData.transfer.destinationType)',"id":'#(dataSet.externalId)'}, "source": {"type":'#(testData.transfer.source_type)',"id":'#(dataSet.sourceId_hot)'},"amount":#(amount_low),"totalEstimatedFee":'#(Number(testData.transfer.withdraw.fee))'}
    * call read('this:Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    Given path 'transaction/transactions'
    And request body_transfer
    When method POST
    Then status 201
    And response.status == "success"
    And response.data.status == "PENDING"
    And response.data.amount == "#(amount_low)"


    #Get estimated fee : Transfer to other network
  @ignore @RAKCON-15412 @Get_estimate_fee_network
  Scenario: Transfer to other network - Get estimated fee
    * call read('this:NetworkManagement.feature@ListNetworkForTransfer')
    * def body_estimate_fee = { "assetId":'#(testData.transfer.withdraw.tokenSymbol)', "destinationType": '#(testData.transfer.network_type)', "sourceType":'#(testData.transfer.source_type)', "sourceId": '#(dataSet.sourceId_hot)',"amount":#(amount_low),"destinationId":'#(destinationId_network)'}
    * call read('this:Transfer.feature@Get_estimate_fee_common') {body_estimate_fee: body_estimate_fee}

  @ignore @RAKCON-15413 @Total_estimate_fee_network
  Scenario: Transfer to other network - Total estimated fee
    * call read('this:NetworkManagement.feature@ListNetworkForTransfer')
    * def body_total_estimate = { "assetId":'#(testData.transfer.withdraw.tokenSymbol)', "destinationType": '#(testData.transfer.network_type)', "sourceType":'#(testData.transfer.source_type)', "sourceId": '#(dataSet.sourceId_hot)',"amount":#(amount_low),"destinationId":'#(destinationId_network)', "fee":'#(Number(testData.transfer.withdraw.fee))',"isNetAmount":false}
    * call read('this:Transfer.feature@Total_estimate_fee_common')

  @ignore @RAKCON-15409 @Transfer_to_other_network
  Scenario: Transfer to other network - Submit transfer
    * call read('this:NetworkManagement.feature@ListNetworkForTransfer')
    * def body = { "operation":'#(testData.transfer.operation)',"tokenId":'#(dataSet.tokenId)',"feeType":'#(testData.transfer.withdraw.feeType)',"fee":'#((testData.transfer.withdraw.fee))', "treatAsGrossAmount": true, "feeLevel": '#(testData.transfer.feeLevel)', "destination":{"type":'#(testData.transfer.network_type)',"id":'#(destinationId_network)'}, "source": {"type":'#(testData.transfer.source_type)',"id":'#(dataSet.sourceId_hot)'},"amount":#(amount_low),"totalEstimatedFee":'#(Number(testData.transfer.withdraw.fee))'}
    * call read('this:Transfer.feature@Internal_Transfer_Common')
    And response.status == "success"
    And response.data.status == "PENDING"
    And response.data.amount == "#(amount_low)"
    And response.data.sourceName == "#(testData.transfer.withdraw.sourceName_cold)"
    And response.data.symbol == "#(testData.transfer.withdraw.symbol)"
    * def requestId = response.data.requestId
    * call read('this:CancelRequest.feature@CancelRequestCommon')


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

    #Tcs: TRANSFER VAULT ADVANCE HOT TO STANDARD HOT
  @RAKCON-19044 @Transfer_value_advance_hot_to_hot
  Scenario: Transfer from Advance Hot Vault to Standard Hot Vault'
    * def destinationId = dataSet.destinationId_hot
    * def sourceId = dataSet.advanceHotVaultId
    * call read('this:Transfer.feature@TransferSmallCommon')

  @ignore @TransferSmallCommon
  Scenario: Transfer Small Common
    * def body = 
    """
      {
        "operation":'#(testData.transfer.operation)',
        "tokenId":'#(dataSet.tokenId)',
        "feeType":'#(testData.transfer.withdraw.feeType)',
        "fee":'#(Number(testData.transfer.withdraw.fee))', 
        "treatAsGrossAmount": true, 
        "feeLevel": '#(testData.transfer.feeLevel)', 
        "destination":
        {
          "type":'#(testData.transfer.source_type)',
          "id":'#(destinationId)'
        }, 
        "source": 
        {
          "type":'#(testData.transfer.source_type)',
          "id":'#(sourceId)'
        },
        "amount":#(amount_low),
        "totalEstimatedFee":'#(Number(testData.transfer.withdraw.fee))'
        }
    """
    * call read('this:Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    Given path 'transaction/transactions'
    And request body
    When method POST
    Then status 201
    And response.status == "success"
    And response.data.status == "PENDING"
    And response.data.amount == "#(amount_low)"
    And response.data.sourceName == "#(testData.transfer.withdraw.sourceName_hot)"
    And response.data.destinationName == "#(testData.transfer.withdraw.destinationName_hot)"
    And response.data.symbol == "#(testData.transfer.withdraw.symbol)"
    * def requestId = response.data.requestId

  @RAKCON-24730 @GetVaultOnTransferSourceScreen @MOB-300 
  Scenario: Get Vault On Transfer Source Screen
    * call read(svc + 'Vault.feature@GetVaultFromSourceScreen')
    * match responseStatus == 200
    * match response.code == 200
    * match response.message == "OK"
    * match response.status == "success"
    * def expectedVaultSchema = 
    """
    {
      status: '#string',
      isArchived: '#boolean',
      wallets: '#[]',
      id: '#uuid',
      totalUSD: '#number',
      isMasked: '#boolean',
      type: '#string',
      totalUSDYesterday: '#number',
      name: '#string',
      createdAt: '#string',
    }
    """
    * match each response.data.list[*] == expectedVaultSchema
    * def expectedWalletSchema = 
    """
    {
      externalAssetId:'#string',
      id:'#uuid',
      symbol:'#string',
      totalUSD:'#number',
      name:'#string',
      total:'#number',
    }
    """
    * match each response.data.list[*].wallets[*] == expectedWalletSchema

  @RAKCON-24732 @TransferSourceScreenShowSelectedAsset @MOB-300
  Scenario: Transfer source screen should show vault with selected asset
    * def asset = 'ADA_TEST'
    * call read(svc + 'Vault.feature@GetVaultFromSourceScreen') {externalAssetId: #(asset)}
    * match each response.data.list[*].wallets[*] contains {externalAssetId:"#(asset)"}
    * match each response.data.list[*].wallets[*] != null

  @RAKCON-24733 @TransferSourceScreenNotShowMaskedVault @MOB-300
  Scenario: Transfer source screen should not show masked vault
    * def data = 
    """
    {
      userId: "#(userInfo.response.data.id)",
      customerId: "#(userInfo.response.data.customerId)"
    }
    """ 
    * callonce read('classpath:rakkar/feature/ConnectDB.feature@SelectVaultOfUser') data
    * def maskedVault = result.find(x => x.policyType != null && x.assetExternalId == 'XRP_TEST' && x.isMasked && x.total > 1)
    * call read(svc + 'Vault.feature@GetVaultFromSourceScreen') {searchText: #(maskedVault.name)}
    * assert response.data.list.length == 0

  @RAKCON-24734 @TransferSourceScreenNotShowVaultHave0Amount @MOB-300
  Scenario: Transfer Source Screen Not Show Vault Have 0 Amount
    # Bug MOB-2384
    * def data = 
    """
    {
      userId: "#(userInfo.response.data.id)",
      customerId: "#(userInfo.response.data.customerId)"
    }
    """ 
    * call read('classpath:rakkar/feature/ConnectDB.feature@SelectVaultOfUser') data
    * def searchVault = result.find(x => x.policyType != null && x.assetExternalId == 'XRP_TEST' && !x.isMasked && x.total == 0)
    * call read(svc + 'Vault.feature@GetVaultFromSourceScreen') {searchText: #(searchVault.name)}
    * assert response.data.list.length == 0

  @RAKCON-24735 @TransferSourceScreenPendingPolicyVault @MOB-300
  Scenario: Transfer Source Screen Pending Policy Vault
    * def data = 
    """
    {
      userId: "#(userInfo.response.data.id)",
      customerId: "#(userInfo.response.data.customerId)"
    }
    """ 
    * callonce read('classpath:rakkar/feature/ConnectDB.feature@SelectVaultOfUser') data
    * def searchVault = result.find(x => x.policyType != null && x.assetExternalId == 'XRP_TEST' && !x.isMasked && x.status == "PENDING" && x.total != null && x.total != 0)
    * call read(svc + 'Vault.feature@GetVaultFromSourceScreen') {searchText: #(searchVault.name)}
    * match each response.data.list[*] contains {"status":"PENDING"}
    
@RAKCON-24736 @TransferSourceScreenSkipPolicyVault @MOB-300
Scenario: Transfer Source Screen Skip Policy Vault
  * def data = 
  """
  {
    userId: "#(userInfo.response.data.id)",
    customerId: "#(userInfo.response.data.customerId)"
  }
  """ 
  * callonce read('classpath:rakkar/feature/ConnectDB.feature@SelectVaultOfUser') data
  * def searchVault = result.find(x => x.policyType != null && x.assetExternalId == 'XRP_TEST' && !x.isMasked && x.status == "PENDING" && x.total == null)
  * call read(svc + 'Vault.feature@GetVaultFromSourceScreen') {searchText: #(searchVault.name)}
  * match each response.data.list[*] contains {"status":"PENDING"}

  @RAKCON-24737 @GetVaultOnTransferDestinationScreen @MOB-300
  Scenario: Get Vault On Transfer Destination Screen
    * call read(svc + 'Vault.feature@GetVaultFromDestinationScreen') {sourceVaultId:#(dataSet.sourceId_hot)}
    * match responseStatus == 200
    * match response.code == 200
    * match response.message == "OK"
    * match response.status == "success"
    * def expectedVaultSchema = 
    """
    {
      externalAssetId: '#string',
      id: '#string',
      totalUSD: '#number',
      isMasked: '#boolean',
      type: '#string',
      total: '#number',
      name: '#string',
      symbol: '#string'
    }
    """
    * match each response.data.list[*] == expectedVaultSchema

  @RAKCON-24738 @TransferDestinationScreenShowVault0Amount @MOB-300 @ignore
  Scenario: Transfer Destination Screen show vault have asset with 0 amount
    # Bug MOB-2385
    * def data = 
    """
    {
      userId: "#(userInfo.response.data.id)",
      customerId: "#(userInfo.response.data.customerId)"
    }
    """ 
    * callonce read('classpath:rakkar/feature/ConnectDB.feature@SelectVaultOfUser') data
    * def searchVault = result.find(x => x.assetExternalId == 'XRP_TEST' && x.total == 0)
    * call read(svc + 'Vault.feature@GetVaultFromDestinationScreen') {searchText: #(searchVault.name), sourceVaultId:#(dataSet.sourceId_hot)}
    * match each response.data.list[*].symbol == "XRP"
    * match each response.data.list[*] == expectedVaultSchema

  @RAKCON-24739 @TransferDestinationScreenShowVaultDontHaveSelectedAsset @MOB-300 @ignore
  Scenario: Transfer Destination Screen show vault don't have selected asset
    # Bug MOB-2385
    * def data = 
    """
    {
      userId: "#(userInfo.response.data.id)",
      customerId: "#(userInfo.response.data.customerId)"
    }
    """ 
    * callonce read('classpath:rakkar/feature/ConnectDB.feature@SelectVaultOfUser') data
    * def searchVault = result.find(x => x.walletId == null )
    * call read(svc + 'Vault.feature@GetVaultFromDestinationScreen') {searchText: #(searchVault.name), sourceVaultId:#(dataSet.sourceId_hot)}
    * assert response.data.list.length > 0
    * match each response.data.list[*].symbol == "XRP"


