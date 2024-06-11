    @RAKCON-10583
Feature: Transaction
  Background:
    * url baseURL
    * call read('this:RequesterAuthenticator.feature@RequesterAccessToken')
    * def userInfo = call read('this:GetUserInfo.feature@GetUserInfo')
    * def transactionSvc = 'classpath:services/Transaction.feature'
    * def Const = read('classpath:data/enum.json')

    @ignore @Filter_transaction_common
  Scenario: Filter transaction
    * def schemaBody = read('classpath:data/schema.json')
    * def filterRequest = call read(transactionSvc + '@GetTransactionsList') { query: '#(query)' }
    * def response = filterRequest.response
    * match $response.status == "success"
    * match $response == schemaBody.transaction.filterTransaction
    * match each $response.data.transactions contains schemaBody.transaction.transactionDetails

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
    * def query = { limit:'10', offset: '0',assetId: ['#(dataSet.tokenId)']}
    * call read('this:Transaction.feature@Filter_transaction_common')
    * match each $response.data.transactions[*].name == "#(tokenName)"

    @RAKCON-12327 @Filter_transaction_by_source
  Scenario: Filter transactions by source
    * def value = call read(svc + 'Vault.feature@GetAllVaults')
    * def sourceId = value.response.data.vaults[0].id
    * def sourceName = value.response.data.vaults[0].name
    * def query = { limit:'10', offset: '0', sourceData: [ { sourceType: 'internal', sourceId: '#(sourceId)'}] }
    * call read('this:Transaction.feature@Filter_transaction_common')
    * match each $response.data.transactions[*].sourceName == "#(sourceName)"

    @RAKCON-12328 @Filter_transaction_by_destination
  Scenario: Filter transactions by destination
    * def value = call read(svc + 'Vault.feature@GetAllVaults')
    * def destinationId = value.response.data.vaults[0].id
    * def destinationName = value.response.data.vaults[0].name
    * def query = { limit:'10', offset: '0',destinationData: [ { destinationType: 'internal', destinationId: '#(destinationId)'}] }
    * call read('this:Transaction.feature@Filter_transaction_common')
    * match each $response.data.transactions[*].destinationName == "#(destinationName)"

    @RAKCON-12329 @Filter_transaction_by_type_outgoing
  Scenario: Filter transaction by type - outgoing
    * def query = { limit:'10', offset: '0',type: ['#(Const.TransactionType.OUTGOING)']}
    * call read('this:Transaction.feature@Filter_transaction_common')
    * match each $response.data.transactions[*].type == "#(Const.TransactionType.OUTGOING)"

    @RAKCON-12421 @Filter_transaction_by_type_incoming
  Scenario: Filter transaction by type - incoming
    * def query = { limit:'10', offset: '0',type: ['#(Const.TransactionType.INCOMING)']}
    * call read('this:Transaction.feature@Filter_transaction_common')
    * match each $response.data.transactions[*].type == "#(Const.TransactionType.INCOMING)"

    @RAKCON-12422 @Filter_transaction_by_type_rebalancing
  Scenario: Filter transaction by type - rebalancing
    * def query = { limit:'10', offset: '0',type: ['#(Const.TransactionType.REBALANCING)']}
    * call read('this:Transaction.feature@Filter_transaction_common')
    * match each $response.data.transactions[*].type == "#(Const.TransactionType.REBALANCING)"

    @RAKCON-12330 @Filter_transaction_by_status_pending
  Scenario: Filter transaction by status - pending
    * def query = { limit:'10', offset: '0', status: ['#(Const.TransactionStatus.PENDING)']}
    * call read('this:Transaction.feature@Filter_transaction_common')
    * match each $response.data.transactions[*].status == "#(Const.TransactionStatus.PENDING)"

    @RAKCON-12423 @Filter_transaction_by_status_processing
  Scenario: Filter transaction by status - processing
    * def query = { limit:'10', offset: '0',status: ['#(Const.TransactionStatus.PROCESSING)']}
    * call read('this:Transaction.feature@Filter_transaction_common')
    * match each $response.data.transactions[*].status == "#(Const.TransactionStatus.PROCESSING)"

    @RAKCON-12424 @Filter_transaction_by_status_confirming
  Scenario: Filter transaction by status - confirming
    * def query = { limit:'10', offset: '0',status: ['#(Const.TransactionStatus.CONFIRMING)']}
    * call read('this:Transaction.feature@Filter_transaction_common')
    * match each $response.data.transactions[*].status == "#(Const.TransactionStatus.CONFIRMING)"

    @RAKCON-12425 @Filter_transaction_by_status_completed
  Scenario: Filter transaction by status - completed
    * def query = { limit:'10', offset: '0',status: ['#(Const.TransactionStatus.COMPLETED)']}
    * call read('this:Transaction.feature@Filter_transaction_common')
    * match each $response.data.transactions[*].status == "#(Const.TransactionStatus.COMPLETED)"

    @RAKCON-12426 @Filter_transaction_by_status_failed
  Scenario: Filter transaction by status - failed
    * def query = { limit:'10', offset: '0',status: ['#(Const.TransactionStatus.FAILED)']}
    * call read('this:Transaction.feature@Filter_transaction_common')
    * match each $response.data.transactions[*].status == "#(Const.TransactionStatus.FAILED)"

    @RAKCON-12427 @Filter_transaction_by_status_reject
  Scenario: Filter transaction by status - reject
    * def query = { limit:'10', offset: '0',status: ['#(Const.TransactionStatus.REJECTED)']}
    * call read('this:Transaction.feature@Filter_transaction_common')
    * match each $response.data.transactions[*].status == "#(Const.TransactionStatus.REJECTED)"

    @RAKCON-12428 @Filter_transaction_create_by
  Scenario: Filter transaction created by
    * def query = { limit:'10', offset: '0',createdById: '#(userInfo.userId)'}
    * call read('this:Transaction.feature@Filter_transaction_common')
    * match each $response.data.transactions[*].createdById == "#(userInfo.userId)"

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

    @RAKCON-16663 @ExportTransaction
   Scenario: Export transaction
    * def body = { "keyword":'',"offset":0,"sort": 'DESC',"sortBy":'CREATED_DATE'}
    * def exportResponse = call read(transactionSvc + '@ExportTransaction') { body: '#(body)' }
    * match exportResponse.responseStatus == 201
    * match exportResponse.response contains "Transaction ID,Transaction type,Transaction status,Asset,Asset amount,Value in USD,Network,Transaction date,Last updated date,Network fee asset amount,Network fee USD,Transaction hash,Internal note,Source,Source address,Destination,Destination address,Destination tag/memo,Initiated date,Initiated by,Approved date,Approved by,Rejected date,Rejected by,Rejected reason,Signed date,Signed by,Completed date,Cancelled date,Cancelled by,Failed date,Failed by,Failed reason"
    * print exportResponse.response

    @ExportTransactionWithFilter
   Scenario: Export transaction With Filter
    * def vaults = call read(svc + 'Vault.feature@GetListVault_v2')
    * def networks = call read(svc + 'Network.feature@GetNetworkList')
    * def whitelists = call read(svc + 'Whitelist.feature@GetWhitelistFolders')
    * def assetId = vaults.response.data.list.find(x => x.wallets != null && x.wallets.length > 0).wallets[0].id
    * def pools = call read(svc + 'Staking.feature@GetPools') {}

    * def sdf = new java.text.SimpleDateFormat("yyyy-MM-dd")
    * def today = sdf.format(new java.util.Date())
    * def body = 
    """
    { 
      keyword:'',
      offset:0,
      sort: 'DESC',
      sortBy:'CREATED_DATE',
      txnDateFrom: "#(today)",
      txnDateTo: "#(today)",
      priceFrom: 1,
      priceTo: 1000,
      dateFrom: "#(today)",
      dateTo: "#(today)",
      status: [
        "PENDING"
      ],
      transactionType: [
        "INCOMING"
      ],
      sourceData: [
        {
          sourceType: "internal",
          sourceId: "#(vaults.response.data.list[0].id)"
        },
        {
          sourceType: "connection",
          sourceId: "#(networks.response.data.networks[0].id)"
        },
        {
          sourceType: "staking",
          sourceId: "#(pools.response.data.pools[0].bech32Id)"
        }
      ],  
      destinationData:[{
        destinationType: "internal",
        destinationId: "#(vaults.response.data.list[1].id)"
      },
      {
        destinationType: "whitelist",
        destinationId: "#(whitelists.response.data.folders.list[0].id)"
      },
      {
        destinationType: "connection",
        destinationId: "#(networks.response.data.networks[0].id)"
      },
      {
        destinationType: "staking",
        destinationId: "#(pools.response.data.pools[0].bech32Id)"
      }
      ],
      assetId:[
        "#(assetId)"
      ],
      initiatedByIds: [
        "#(userInfo.userId)"
      ]
    }
    """
    * def exportResponse = call read(transactionSvc + '@ExportTransactionFull') body
    * match exportResponse.responseStatus == 201
    * match exportResponse.response contains "Transaction ID,Transaction type,Transaction status,Asset,Asset amount,Value in USD,Network,Transaction date,Last updated date,Network fee asset amount,Network fee USD,Transaction hash,Internal note,Source,Source address,Destination,Destination address,Destination tag/memo,Initiated date,Initiated by,Approved date,Approved by,Rejected date,Rejected by,Rejected reason,Signed date,Signed by,Completed date,Cancelled date,Cancelled by,Failed date,Failed by,Failed reason"
    * print exportResponse.response

    @RAKCON-18275 @FilterTransactionFromWhitelistAddress
  Scenario: Filter transaction from whitelist address
    * def listFolders = call read(svc + 'Whitelist.feature@GetWhitelistFolders')
    * def query = { limit:'10', offset: '0', destinationData: [ { "destinationType": "whitelist", "destinationId": "#(listFolders.response.data.folders[0].id)" } ]}
    * call read('this:Transaction.feature@Filter_transaction_common')

    @RAKCON-20141 @CheckTransactionFromOtherCustomer @RAKCON-20140
  Scenario: Customer cannot search for another customer vault
    * def userInfo = call read('this:GetUserInfo.feature@GetUserInfo')
    * def customerId = userInfo.response.data.customerId
    * def query = { limit:'100', offset: '0' }
    * call read('this:Transaction.feature@Filter_transaction_common')
    * def transactions = response.data.transactions
    * def isCustomerData = 
    """
      function(txn) { 
        if (txn.dcusId != customerId && txn.scusId != customerId) {
          karate.log(txn)
          throw new Error(txn.transactionId+' - is not customer data')
        }
      }
    """
    * eval karate.forEach(transactions, isCustomerData)

    @RAKCON-20191 @ViewTransactionDetailsOfOtherCustomer
  Scenario: View Transaction Details Of Other Customer
    * def userInfo = call read('this:GetUserInfo.feature@GetUserInfo')
    * def customerId = userInfo.response.data.customerId
    * def crossTxnId = call read('this:ConnectDB.feature@SelectATransactionNotBelongToCustomer') {customerId: #(customerId)}
    * call read(svc + 'Transaction.feature@ViewTransactionDetail') { transactionId: #(crossTxnId.result[0].id) }
    * match responseStatus == 404
    * match response.message == "TRANSACTION_NOT_FOUND"
      
    @RAKCON-23649 @SearchTransactionsOnMaskedVault
  Scenario: User unable to search transactions on Masked Vault
    * def testData_v2 = read('classpath:data/data.json')
    * def query = { limit:'50', offset: '0'}
    * call read('this:Transaction.feature@Filter_transaction_common') 
    * match each response.data.transactions[*].sourceName !contains testData_v2.maskedVault
    * match each response.data.transactions[*].destinationName !contains testData_v2.maskedVault
      
    @RAKCON-23650 @ExportTransactionsOnMaskedVault
  Scenario: User unable to export transactions on Masked Vault
    * def testData_v2 = read('classpath:data/data.json')
    * def query = { limit:'50', offset: '0'}
    * def exportResponse = call read(transactionSvc + '@ExportTransaction') { body: '#(query)' }
    * print 'Export transaction should not contains masked vault transactions: ', testData_v2.maskedVault
    * def txnList = exportResponse.response.split("\n")
    # Find index of Source column
    * def sourceIndex = txnList[0].split(",").indexOf("Source")
    # All transaction with mask vault information can't be Source
    * def txnWithMaskVault = txnList.filter(x => x.contains(testData_v2.maskedVault))
    * print txnWithMaskVault
    * def checkSource = 
    """
    function(txn, index, text){
      return txn.split(",")[index]?.contains(text)
    }
    """
    * match txnWithMaskVault.filter(x => checkSource(x, sourceIndex, "AT - Cold Standard Vault 1 100092")).length == 0

    @GetVaultFromTransactionFilter
    Scenario: Get Vault From Transaction Filter
      # Will be removed on sprint 24.2.0
      * def params = 
      """
      {
        keyword:'',
        limit: 40,
        offset: 0,
        searchType: 'VAULT_NAME',
        sort: 'ASC',
        sortBy: 'NAME'
      }
      """
      Given path 'core/vault/v2/accounts'
      And params params
      When method GET
      * def expectedSchema = 
      """
      {
        totalUSD:'#number', 
        totalBTC: '#number', 
        availableUSD: '#number', 
        availableBTC: '#number'
      } 
      """
      Then match response.data contains expectedSchema
    
    

