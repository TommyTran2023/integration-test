@RAKCON-10583
Feature: Network Management

  Background:
    * url baseURL
    * call read('this:RequesterAuthenticator.feature@RequesterAccessToken')
    * call read('this:GetUserInfo.feature@GetUserInfo')
    * def schemaBody = read('classpath:data/schema.json')
    * def testData = read('classpath:data/data_test.json')

  @RAKCON-14850 @Checkprofilename
  Scenario: Check profile name
    * def now = function(){ return java.lang.System.currentTimeMillis() }
    * def profileName = 'Profile-' + now()
    * def query = { networkName:'#(profileName)'}
    Given path 'network/networks/validate/network-name'
    And params query
    When method GET
    Then status 200
    And match response.status == "success"
    * match response.data.exist == true

  @RAKCON-14851 @DepositRouting
  Scenario: List deposit routing
    * def query = { limit:'10', offset: '0'}
    Given path 'core/vault/deposit-routing'
    And params query
    When method GET
    Then status 200
    And match response.status == "success"
    And match response.data.vaults contains schemaBody.networkManagament.depositRouting

  @RAKCON-14852 @CheckAddProfile
  Scenario: Check add profile
    * call read('this:Common.feature@FIDO-Requester')
    * def vaultData = call read('this:NetworkManagement.feature@DepositRouting')
    * def vaultId = vaultData.response.data.vaults[0].id
    * def now = function(){ return java.lang.System.currentTimeMillis() }
    * def profileName = 'Profile-' + now()
    * def body = {"isDiscoverable" : true,"networkName": '#(profileName)', "vaultId": "#(vaultId)" }
    Given path 'network/networks'
    * header challenge-answer = challengeAnswerRequest
    And request body
    When method POST
    Then status 201
    And match response.status == "success"
    And match response.data.networkFullName == "#regex .*"+ profileName +".*"

  @RAKCON-14979 @ProfileListing
  Scenario: Check profile listing
    * def profile_query = { limit:'10', offset: '0'}
    * call read('this:NetworkManagement.feature@ProfileListingCommon')

  @RAKCON-14980 @SearchProfile
  Scenario: Check search profile
    * def keyword = "Profile-"
    * def profile_query = { limit:'10', offset: '0', keyword :'#(keyword)'}
    * call read('this:NetworkManagement.feature@ProfileListingCommon')
    * match each $response.data.networks[*].networkName == "#regex .*"+ keyword +".*"

  @ignore @ProfileListingCommon
    Scenario: Check profile listing
      Given path 'network/networks'
      And params profile_query
      When method GET
      Then status 200
      And match response.status == "success"
      And match response.data.networks contains schemaBody.networkManagament.profileListing

  @RAKCON-14981 @ViewProfileDetail
  Scenario: View profile detail
    * def value = call read('this:NetworkManagement.feature@ProfileListing')
    * def networkId = value.response.data.networks[0].id
    * def isDiscoverable = value.response.data.networks[0].isDiscoverable
    * def networkName = value.response.data.networks[0].networkName
    Given path 'network/networks/' + networkId
    When method GET
    Then status 200
    And match response.status == "success"
    And match response.data.id == '#(networkId)'
    And match response.data.networkName == '#(networkName)'
    And match response.data.isDiscoverable == '#(isDiscoverable)'

  @RAKCON-15076 @Editprofilerouting
  Scenario: Edit profile routing
    * call read('this:NetworkManagement.feature@CheckAddProfile')
    * def profileId = response.data.id
    * def body = {"internalNote" :'Note',"networkId": '#(profileId)', "vaultId": "#(vaultId)" }
    * call read('this:Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    * header passcode = requesterInfo.requesterPasscode
    Given path 'network/networks/set-profile-routing'
    And request body
    When method POST
    Then status 201
    And match response.status == "success"
    And match response.data.requestId == "#string"

  @RAKCON-15077 @Canceleditprofilerouting
  Scenario: Cancel edit profile routing
    * def value = "SET_NETWORK_PROFILE_ROUTING"
    * def nameDisplay = "Set network profile routing"
    * call read('this:NetworkManagement.feature@View_My_Request_Network')
    * call read('this:CancelRequest.feature@CancelRequestCommon')

  @ignore @View_My_Request_Network
  Scenario: View my request for type network
    Given path 'core/quorums'
    * def body = { offset:'0',limit: '10',keyword:'',requestCategories:["NETWORK"],createdBy: '#(userId)',status : ["PENDING"],isHistory : true }
    And request body
    When method POST
    Then status 201
    And match response.data.records[0].type.value == '#(value)'
    And match response.data.records[0].type.nameDisplay == '#(nameDisplay)'
    * def requestId = response.data.records[0].id

  @RAKCON-15107 @Editprofilesetting
  Scenario: Edit profile setting
    * def value = call read('this:NetworkManagement.feature@CheckAddProfile')
    * def profileId = value.response.data.id
    * def body = {"isDiscoverable" : false }
    Given path 'network/networks/setting/' + profileId
    And request body
    When method PUT
    Then status 200
    And match response.status == "success"
    And match response.data.success == true

  @RAKCON-15108 @Getdiscoverablenetwork
  Scenario: Get discoverable network id
    * def value = call read('this:NetworkManagement.feature@ProfileListing')
    * def profileId = value.response.data.networks[0].id
    * def query = { limit:'10', offset: '0', currentProfileId: '#(profileId)', keyword: 'Rakkar' }
    Given path 'network/networks/discoverable-network-ids'
    And params query
    When method GET
    Then status 200
    And match response.status == "success"
    And match response.data.counterParties contains schemaBody.networkManagament.discoverableNetworkListing
    * def counterId = response.data.counterParties[0].id
    * def counterName = response.data.counterParties[0].name

  @RAKCON-15109 @Addnetworkconnection
  Scenario: Add new network connection
    * call read('this:NetworkManagement.feature@Getdiscoverablenetwork')
    * def value = call read('this:NetworkManagement.feature@ViewProfileDetail')
    * def profileId = value.response.data.id
    * def vaultId = value.response.data.vault.id
    * def vaultName = value.response.data.vault.name
    *  def body = {"vaultName" :'#(vaultName)', "vaultId": '#(vaultId)', "counterpartyName": '#(counterName)' , "internalNote": 'Note', "counterpartyId": '#(counterId)',  "hasDefaultRouting": true }
    * call read('this:Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    * header passcode = requesterInfo.requesterPasscode
    Given path 'network/networks/'+ profileId +'/connections'
    And request body
    When method POST
    Then status 201
    And match response.status == "success"
    And match response.data.vaultName == '#(vaultName)'
    And match response.data.counterpartyName == '#(counterName)'

  @RAKCON-15205 @CancelAddNewConnectin
  Scenario: Cancel request add new connection
    * def value = "CREATE_NETWORK_CONNECTION"
    * def nameDisplay = "Create network connection"
    * call read('this:NetworkManagement.feature@View_My_Request_Network')
    * call read('this:CancelRequest.feature@CancelRequestCommon')

  @RAKCON-15111 @ViewConnectionDetail
  Scenario: View connection detail
    Given path 'network/networks/' + dataSet.networkID + '/connections/' + dataSet.connectionID
    When method GET
    Then status 200
    And match response.status == "success"
    And match response.data.id == '#(dataSet.connectionID)'
    And match response.data.networkId == '#(dataSet.networkID)'
    * def vaultName = response.data.defaultVault.id
    * def vaultId = response.data.defaultVault.name

  @RAKCON-15110 @ViewListNetworkConnection
  Scenario: View list network connection
    * def value = call read('this:NetworkManagement.feature@ProfileListing')
    * def profileId = value.response.data.networks[0].id
    * def query = { limit:'10', offset: '0' }
    Given path 'network/networks/' + profileId + '/connections'
    And params query
    When method GET
    Then status 200
    And match response.status == "success"
    And match response.data.networkConnections contains schemaBody.networkManagament.networkConnection

  @ignore @RAKCON-15213 @Editconnectiondepositrouting
  Scenario: Edit connection deposit routing
    * call read('this:NetworkManagement.feature@ViewConnectionDetail')
    * def body = {"vaultName" :'#(vaultName)', "vaultId": '#(vaultId)', "hasDefaultRouting": true , "note": 'Note', }
    * call read('this:Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    * header passcode = requesterInfo.requesterPasscode
    Given path 'network/networks/' + dataSet.networkID + '/connections/' + dataSet.connectionID + '/deposit-routing'
    And request body
    When method PUT
    Then status 200
    And match response.status == "success"

  @ignore @RAKCON-15308 @Canceleditconnectionrouting
  Scenario: Cancel request edit connection routing
    * def value = "EDIT_NETWORK_CONNECTION_DEPOSIT"
    * def nameDisplay = "Edit network connection"
    * call read('this:NetworkManagement.feature@View_My_Request_Network')
    * call read('this:CancelRequest.feature@CancelRequestCommon')

  @ignore @RAKCON-15214 @RemoveConnection
  Scenario: Remove connection
    * def body = {"note": 'Note', }
    * call read('this:Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    * header passcode = requesterInfo.requesterPasscode
    Given path 'network/networks/' + dataSet.networkID + '/connections/' + dataSet.connectionID
    And request body
    When method DELETE
    Then status 200
    And match response.status == "success"

  @ignore @RAKCON-15909 @Cancelremoveconnection
  Scenario: Cancel request remove connection
    * def value = "REMOVE_NETWORK_CONNECTION"
    * def nameDisplay = "Remove network connection"
    * call read('this:NetworkManagement.feature@View_My_Request_Network')
    * call read('this:CancelRequest.feature@CancelRequestCommon')

  @ignore @RAKCON-15414 @ListNetworkForTransfer
  Scenario: List network for transfer
    * def query = { limit:'20', offset: '0' }
    Given path 'network/networks/connections/counterparties'
    And params query
    When method GET
    Then status 200
    And match response.status == "success"
    And match response.data.connections contains schemaBody.networkManagament.connectionsList
    * def destinationId_network = response.data.connections[0].id


