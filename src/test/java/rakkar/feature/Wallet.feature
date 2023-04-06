@RAKCON-10941
Feature: Wallet

  Background:
    #@PRECOND_RAKCON-11355
    * url baseURL
    * call read('RequesterAuthenticator.feature@RequesterAccessToken')
    * def vault = karate.callSingle('Vault.feature@RAKCON-10217')
    * def vaultId = vault.response.data.id

  @ignore @VIEW-LIST-ASSET
  Scenario: View list asset
    Given path 'core/wallet/tokens/' + vaultId
    When method GET
    And params {limit: '10', offset: '0'}
    Then status 200
    * def assetId = response.data.tokens[0].id
    * def symbolView = response.data.tokens[0].symbol
    * def networkView = response.data.tokens[0].network

  @RAKCON-10944 @ADD_WALLET
  Scenario: Add asset to the vault
    * call read('Wallet.feature@VIEW-LIST-ASSET')
    Given path 'core/wallet/' + vaultId
    * request {"tokenIds": ["#(assetId)"]}
    When method POST
    Then status 201
    * def symbolAdd = response.data.success[0].symbol
    * def networkAdd = response.data.success[0].network
    And match symbolAdd == symbolView
    And match networkAdd == networkView

  @RAKCON-10952 @SORT_WALLETS_FROM_A_Z
  Scenario: Sort wallets from A >Z
  # Add new asset
    * call read('Wallet.feature@ADD_WALLET')
  # View asset listing
    Given path 'core/vault/account/' + vaultId + '/wallets'
    And params {limit: '10', offset: '0', sort: 'ASC', sortBy: 'NAME', isHiddenList: false}
    When method GET
    Then status 200
  #Sorting the response in ascending order by name
    * def listAssetActual = response.data.wallets
    * def listAssetExpected = karate.jsonPath(listAssetActual, "$[*]").sort(function(a, b) { return a.symbol.localeCompare(b.symbol) })
    * match listAssetActual == listAssetActual

  @RAKCON-11371 @SORT_WALLETS_FROM_Z_A
  Scenario: Sort wallets from Z > A
    Given path 'core/vault/account/' + vaultId + '/wallets'
    And params {limit: '10', offset: '0', sort: 'ASC', sortBy: 'NAME', isHiddenList: false}
    When method GET
    Then status 200
  #Sorting the response in descending order by name
    * def listAssetActual = response.data.wallets
    * def listAssetExpected = karate.jsonPath(listAssetActual, "$[*]").sort(function(a, b) { return b.symbol.localeCompare(a.symbol) })
    * match listAssetActual == listAssetActual

  @RAKCON-11373 @SORT_WALLETS_FROM_LOWEST_VALUE
  Scenario: Sort wallets from lowest value
    Given path 'core/vault/account/' + vaultId + '/wallets'
    And params {limit: '10', offset: '0', sort: 'ASC', sortBy: 'TOTAL_USD', isHiddenList: false}
    When method GET
    Then status 200
  #Sorting the response in ascending order by price
    * def listAssetActual = response.data.wallets
    * def valueUSD = 0
    * def sortByValueUSD = function(arr, valueUSD) {var result = arr.filter(function(item) {return item.totalUSD >= valueUSD;});result.sort(function(a, b) {return a.totalUSD - b.totalUSD;});return result;}
    * def listAssetExpected = sortByValueUSD(listAssetActual, valueUSD)
    * match listAssetExpected == listAssetActual

  @RAKCON-10953 @SEARCH_WALLETS
  Scenario: Search wallets
  # Add new asset
    * call read('Wallet.feature@ADD_WALLET')
  #View asset listing with keyword
    * def keyword = "a"
    * def pattern = '#regex ^.*['+ keyword.toUpperCase() + keyword.toLowerCase() +'].*$'
    Given path 'core/vault/account/' + vaultId + '/wallets'
    And params {limit: '10', offset: '0', sort: 'ASC', sortBy: 'TOTAL_USD', isHiddenList: false, keyword: '#(keyword)'}
    When method GET
    Then status 200
  #Validate the response with keyword
    * def listAssetActual = response.data.wallets
    * def size = listAssetActual.length
    * def checkListAsset = karate.filter(listAssetActual, function(item){ return karate.match(item.name, pattern).pass || karate.match(item.symbol, pattern).pass }).length == size
    * match checkListAsset == true

  @RAKCON-10958 @VIEW_WALLET_ADDRESS_LISTING
  Scenario: View wallet address listing
  # Add new asset can
    * call read('Wallet.feature@ADD_WALLET')
  # View asset listing
    Given path 'core/vault/account/' + vaultId + '/wallets'
    And params {limit: '10', offset: '0', sort: 'DESC', sortBy: 'TOTAL_USD', isHideList: false}
    When method GET
    Then status 200
  #Sorting the response in descending order by price
    * def listAssetActual = response.data.wallets
    * def valueUSD = 0
    * def sortByValueUSD = function(arr, valueUSD) {var result = arr.filter(function(item) {return item.totalUSD >= valueUSD;});result.sort(function(a, b) {return b.totalUSD - a.totalUSD;});return result;}
    * def listAssetExpected = sortByValueUSD(listAssetActual, valueUSD)
    * match listAssetExpected == listAssetActual

  @RAKCON-10961 @VIEW_TOKEN_DETAIL
  Scenario: View token detail
  # Add new asset
    * def addAsset = call read('Wallet.feature@RAKCON-10944')
    * def walletId = addAsset.response.data.success[0].id
  # View token detail
    Given path 'core/wallet/token-details/'
    And params {vaultId: '#(vaultId)', walletId: '#(walletId)'}
    When method GET
    Then status 200
  # Check the variable expected
    * def networkExpected = addAsset.response.data.success[0].network
    * def symbolExpected = addAsset.response.data.success[0].symbol
    * def priceYesterdayExpected = addAsset.response.data.success[0].priceYesterday
    * def priceExpected = addAsset.response.data.success[0].price
    * def imageExpected = addAsset.response.data.success[0].icon
    * def nameExpected = addAsset.response.data.success[0].name
    * def vaultTypeExpected = vault.response.data.type
  # Check the variable actual
    * def walletIdActual = response.data.walletId
    * def networkActual = response.data.network
    * def symbolActual = response.data.symbol
    * def priceYesterdayActual = response.data.priceYesterday
    * def priceActual = response.data.price
    * def imageActual = response.data.image
    * def nameActual = response.data.name
    * def vaultTypeActual = response.data.vaultType
  # Verify the variable actual with the variable expected
    * match walletIdActual == walletId
    * match networkActual == networkExpected
    * match symbolActual == symbolExpected
    * match priceYesterdayActual == priceYesterdayExpected
    * match priceActual == priceExpected
    * match imageActual == imageExpected
    * match nameActual == nameExpected
    * match vaultTypeActual == vaultTypeExpected

  @ignore @EXTRACT_WALLET_SUPPORT_MULTIPLE_ADDRESS
  Scenario: View list asset
    Given path 'core/wallet/tokens/' + vaultId
    And params {limit: '10', offset: '0', keyword: 'XRP'}
    When method GET
    Then status 200
    * def assetId = response.data.tokens[0].id
    * def symbolView = response.data.tokens[0].symbol
    * def networkView = response.data.tokens[0].network

  @ignore @ADD_WALLET_SUPPORT_MULTIPLE_ADDRESS
  Scenario: Add asset support multiple address to the vault
    * call read('Wallet.feature@EXTRACT_WALLET_SUPPORT_MULTIPLE_ADDRESS')
    Given path 'core/wallet/' + vaultId
    * request {"tokenIds": ["#(assetId)"]}
    When method POST
    Then status 201
    * def symbolAdd = response.data.success[0].symbol
    * def networkAdd = response.data.success[0].network
    And match symbolAdd == symbolView
    And match networkAdd == networkView

  @RAKCON_10963 @CREATE_DEPOSIT_ADDRESS
  Scenario: Create a deposit address
    * def addWallet = karate.callSingle('Wallet.feature@ADD_WALLET_SUPPORT_MULTIPLE_ADDRESS')
    * def walletId = addWallet.response.data.success[0].id
    * karate.set('walletId', walletId)
    * def addressName = "Address2"
    Given path 'core/address'
    And request {"vaultId": "#(vaultId)", "walletId": "#(walletId)", "addressName": "#(addressName)"}
    When method POST
    Then status 201
    * def newAddressActual = response.data.address
    * def nameActual = response.data.description
    * def idActual = response.data.id
    * def assetIdActual = response.data.assetId
    * match newAddressActual != null
    * match idActual != null
    * match assetIdActual != null
    * match nameActual == addressName

  @RAKCON-11374 @VIEW_DEPOSIT_ADDRESS
  Scenario: View deposit address
    * def addWallet = karate.callSingle('Wallet.feature@ADD_WALLET_SUPPORT_MULTIPLE_ADDRESS')
    * def walletId = addWallet.response.data.success[0].id
    * def createDepositAddress = call read('Wallet.feature@CREATE_DEPOSIT_ADDRESS')
    Given path 'core/wallet/get-address-wallet'
    And params {limit: '10', offset: '0', vaultId: '#(vaultId)', walletId: '#(walletId)'}
    When method GET
    Then status 200
    #Check the actual value of variable
    * def canCreateAddress = response.data.canCreateAddress
    * def totalCount = response.data.totalCount
    * def address = response.data.address
    * def sizeAddress = address.length
    * def sizeNumber = sizeAddress - 1
    * def newAddressActual = response.data.address[sizeNumber].address
    * def nameActual = response.data.address[sizeNumber].description
    * def assetIdActual = response.data.address[sizeNumber].assetId
    * def idActual = response.data.address[sizeNumber].id
    #Check the expected value of variable
    * def newAddressExpected = createDepositAddress.response.data.address
    * def nameExpected = createDepositAddress.response.data.description
    * def idExpected = createDepositAddress.response.data.id
    * def assetIdExpected = createDepositAddress.response.data.assetId
    * def idExpected = createDepositAddress.response.data.id
    #Verify the actual variable and the expected variable
    * match newAddressActual == newAddressExpected
    * match nameActual == nameExpected
    * match assetIdActual == assetIdExpected
    * match idActual == idExpected
    * match canCreateAddress == true
    * match totalCount == sizeAddress

  @RAKCON-10964 @HIDE_AN_ASSET
  Scenario: Hide an asset
    * def addAsset = call read('Wallet.feature@ADD_WALLET')
    * def assetId = addAsset.response.data.success[0].id
    Given path 'core/wallet/' + assetId + '/hide'
    And method POST
    Then status 201
    * def statusMsg = response.status
    * match statusMsg == 'success'
    * def symbol = addAsset.response.data.success[0].symbol
    * def network = addAsset.response.data.success[0].network
    * def name = addAsset.response.data.success[0].name
    * def icon = addAsset.response.data.success[0].icon
    * def price = addAsset.response.data.success[0].price

  @RAKCON-10966 @VIEW_HIDDEN_AN_ASSET
  Scenario: View hidden an asset
    * def hideAsset = call read('Wallet.feature@HIDE_AN_ASSET')
    # View asset listing
    Given path 'core/vault/account/' + vaultId + '/wallets'
    And params {limit: '10', offset: '0', sort: 'ASC', sortBy: 'NAME', isHideList: true}
    When method GET
    Then status 200
    * def wallet = response.data.wallets
    * def sizeAddress = wallet.length
    * def sizeNumber = sizeAddress - 1
    #Check the expected value of varieble
    * def assetIdExpected = hideAsset.assetId
    * def symbolExpected = hideAsset.symbol
    * def networkExpected = hideAsset.network
    * def nameExpected = hideAsset.name
    * def iconExpected = hideAsset.icon
    * def priceExpected = hideAsset.price
    #Check the actual value of variable
    * def assetIdActual = wallet[sizeNumber].id
    * def symbolActual = wallet[sizeNumber].symbol
    * def networkActual = wallet[sizeNumber].network
    * def nameActual = wallet[sizeNumber].name
    * def iconActual = wallet[sizeNumber].icon
    * def priceActual = wallet[sizeNumber].price
    #Verify the actual variable and the expected variable
    * match assetIdActual == assetIdExpected
    * match symbolActual == symbolExpected
    * match networkActual == networkExpected
    * match nameActual == nameExpected
    * match iconActual == iconExpected
    * match priceActual == priceExpected

  @RAKCON-10965 @UNHIDE_AN_ASSET
  Scenario: Unhide an asset
    * call read('Wallet.feature@VIEW_HIDDEN_AN_ASSET')
    Given path 'core/wallet/' + assetIdActual + '/unhide'
    And method POST
    Then status 201
    * def statusMsg = response.status
    * match statusMsg == 'success'






















