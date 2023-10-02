@RAKCON-10583
Feature: Transaction
  Background:
    * url baseURL
    * call read('this:RequesterAuthenticator.feature@RequesterAccessToken')
    * call read('this:GetUserInfo.feature@GetUserInfo')
    * def transactionSvc = 'classpath:rakkar/services/Transaction.feature'

  @ignore @Filter_transaction_common
  Scenario: Filter transaction
    * def schemaBody = read('classpath:data/schema.json')
    * def filterRequest = call read(transactionSvc + '@GetTransactionsList') { query: '#(query)' }
    * def response = filterRequest.response
    * match filterRequest.responseStatus == 201
    * match $response.status == "success"
    * match $response == schemaBody.transaction.filterTransaction
    * match each $response.data.transactions == schemaBody.transaction.transactionDetails

  @RAKCON-10904 @ViewTransactionListing
  Scenario: View transaction listing
    # View transaction listing
    * def query = { offset: '0', limit:'10'}
    * call read('this:Transaction.feature@Filter_transaction_common')
    * def transListResponse = response.data.transactions

  @RAKCON-12325 @Filter_transaction_by_value
    Scenario: Filter transaction by value
      * def query = { limit:'10', offset: '0', priceFrom:'0', priceTo: '100'}
      * call read('this:Transaction.feature@Filter_transaction_common')
      * match each $response.data.transactions[*].amountUSD == '#? _ <= 100'

  @RAKCON-12326 @Filter_transaction_by_date_last30days
  Scenario: Filter transaction by date
    * def getDate =
      """
      function(numberOfDays){
        var date = new Date();
        date.setDate(date.getDate() + (numberOfDays));
        return date.toISOString()
      }
      """
    * def dateFrom = getDate(-30)
    * def dateTo = getDate(-1)
    * def query = { limit:'10', offset: '0',dateFrom: '#(dateFrom)', dateTo:'#(dateTo)' }
    * call read('this:Transaction.feature@Filter_transaction_common')

  @RAKCON-10973 @Filter_transaction_by_asset
   Scenario: Filter transaction by asset
    * call read('Transfer.feature@Get_asset_transfer')
    * def tokenName = response.data.tokens[0].name
    * def query = { limit:'10', offset: '0',assetId: ['#(tokenId)']}
    * call read('this:Transaction.feature@Filter_transaction_common')
    * match each $response.data.transactions[*].name == "#(tokenName)"

  @RAKCON-12327 @Filter_transaction_by_source
  Scenario: Filter transactions by source
    * def value = call read('Vault.feature@ViewVaultListing')
    * def sourceId = value.response.data.vaults[0].id
    * def sourceName = value.response.data.vaults[0].name
    * def query = { limit:'10', offset: '0', sourceData: [ { sourceType: 'internal', sourceId: '#(sourceId)'}] }
    * call read('this:Transaction.feature@Filter_transaction_common')
    * match each $response.data.transactions[*].sourceName == "#(sourceName)"

  @RAKCON-12328 @Filter_transaction_by_destination
  Scenario: Filter transactions by destination
    * def value = call read('Vault.feature@ViewVaultListing')
    * def destinationId = value.response.data.vaults[0].id
    * def destinationName = value.response.data.vaults[0].name
    * def query = { limit:'10', offset: '0',destinationData: [ { destinationType: 'internal', destinationId: '#(destinationId)'}] }
    * call read('this:Transaction.feature@Filter_transaction_common')
    * match each $response.data.transactions[*].destinationName == "#(destinationName)"

  @RAKCON-12329 @Filter_transaction_by_type_outgoing
  Scenario: Filter transaction by type - outgoing
    * def query = { limit:'10', offset: '0',type: ['#(testData.transaction.type_outgoing)']}
    * call read('this:Transaction.feature@Filter_transaction_common')
    * match each $response.data.transactions[*].type == "#(testData.transaction.type_outgoing)"

  @RAKCON-12421 @Filter_transaction_by_type_incoming
  Scenario: Filter transaction by type - incoming
    * def query = { limit:'10', offset: '0',type: ['#(testData.transaction.type_incoming)']}
    * call read('this:Transaction.feature@Filter_transaction_common')
    * match each $response.data.transactions[*].type == "#(testData.transaction.type_incoming)"

  @RAKCON-12422 @Filter_transaction_by_type_rebalancing
  Scenario: Filter transaction by type - rebalancing
    * def query = { limit:'10', offset: '0',type: ['#(testData.transaction.type_rebalancing)']}
    * call read('this:Transaction.feature@Filter_transaction_common')
    * match each $response.data.transactions[*].type == "#(testData.transaction.type_rebalancing)"

  @RAKCON-12330 @Filter_transaction_by_status_pending
  Scenario: Filter transaction by status - pending
    * def query = { limit:'10', offset: '0', status: ['#(testData.transaction.status_pending)']}
    * call read('this:Transaction.feature@Filter_transaction_common')
    * match each $response.data.transactions[*].status == "#(testData.transaction.status_pending)"

  @RAKCON-12423 @Filter_transaction_by_status_processing
  Scenario: Filter transaction by status - processing
    * def query = { limit:'10', offset: '0',status: ['#(testData.transaction.status_processing)']}
    * call read('this:Transaction.feature@Filter_transaction_common')
    * match each $response.data.transactions[*].status == "#(testData.transaction.status_processing)"

  @RAKCON-12424 @Filter_transaction_by_status_confirming
  Scenario: Filter transaction by status - confirming
    * def query = { limit:'10', offset: '0',status: ['#(testData.transaction.status_confirming)']}
    * call read('this:Transaction.feature@Filter_transaction_common')
    * match each $response.data.transactions[*].status == "#(testData.transaction.status_confirming)"

  @RAKCON-12425 @Filter_transaction_by_status_completed
  Scenario: Filter transaction by status - completed
    * def query = { limit:'10', offset: '0',status: ['#(testData.transaction.status_completed)']}
    * call read('this:Transaction.feature@Filter_transaction_common')
    * match each $response.data.transactions[*].status == "#(testData.transaction.status_completed)"

  @RAKCON-12426 @Filter_transaction_by_status_failed
  Scenario: Filter transaction by status - failed
    * def query = { limit:'10', offset: '0',status: ['#(testData.transaction.status_failed)']}
    * call read('this:Transaction.feature@Filter_transaction_common')
    * match each $response.data.transactions[*].status == "#(testData.transaction.status_failed)"

  @RAKCON-12427 @Filter_transaction_by_status_reject
  Scenario: Filter transaction by status - reject
    * def query = { limit:'10', offset: '0',status: ['#(testData.transaction.status_rejected)']}
    * call read('this:Transaction.feature@Filter_transaction_common')
    * match each $response.data.transactions[*].status == "#(testData.transaction.status_rejected)"

  @RAKCON-12428 @Filter_transaction_create_by
  Scenario: Filter transaction created by
    * def query = { limit:'10', offset: '0',createdById: '#(userId)'}
    * call read('this:Transaction.feature@Filter_transaction_common')
    * match each $response.data.transactions[*].createdById == "#(userId)"

  @RAKCON-10972 @View_transaction_detail
  Scenario: View transaction detail
    * def query = { limit:'10', offset: '0'}
    * call read('this:Transaction.feature@Filter_transaction_common')
    * def transactionId = response.data.transactions[0].id
    * def status = response.data.transactions[0].status
    * def type = response.data.transactions[0].type
    * call read('this:Transaction.feature@View_transaction_detail_common')
    And match response.status == "success"
    And match response.data.id == "#(transactionId)"
    And match response.data.status == "#(status)"
    And match response.data.type == "#(type)"

  @ignore @View_transaction_detail_common
  Scenario: View transaction detail common
    * def txnDetail = call read(transactionSvc + '@ViewTransactionDetail') { transactionId: '#(transactionId)' }
    * def response = txnDetail.response
    * match txnDetail.responseStatus == 200

  @RAKCON-16663 @ExportTransaction
   Scenario: Export transaction
    * def body = { "keyword":'',"offset":0,"sort": 'DESC',"sortBy":'CREATED_DATE'}
    * def exportResponse = call read(transactionSvc + '@ExportTransaction') { body: '#(body)' }
    # Given path 'transaction/transactions/export-web'
    * match exportResponse.responseStatus == 201
    * match exportResponse.response.status == "success"

  @RAKCON-18275 @FilterTransactionFromWhitelistAddress
  Scenario: Filter transaction from whitelist address
    * def listFolders = call read('WhiteListFolder.feature@List_folder')
    * def query = { limit:'10', offset: '0', destinationData: [ { "destinationType": "whitelist", "destinationId": "#(listFolders.response.data.folders[0].id)" } ]}
    * call read('this:Transaction.feature@Filter_transaction_common')

