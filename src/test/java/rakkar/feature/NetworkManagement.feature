@ignore @RAKCON-10583
Feature: Network Management

  Background:
    * url baseURL
    * call read('RequesterAuthenticator.feature@RequesterAccessToken')
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
    * call read('Common.feature@FIDO-Requester')
    * def vaultData = call read('NetworkManagement.feature@DepositRouting')
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
    * call read('NetworkManagement.feature@ProfileListingCommon')

  @RAKCON-14980 @SearchProfile
  Scenario: Check search profile
    * def keyword = "Profile-"
    * def profile_query = { limit:'10', offset: '0', keyword :'#(keyword)'}
    * call read('NetworkManagement.feature@ProfileListingCommon')
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
    * def value = call read('NetworkManagement.feature@ProfileListing')
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
    * call read('NetworkManagement.feature@CheckAddProfile')
    * def profileId = response.data.id
    * def body = {"internalNote" :'Note',"networkId": '#(profileId)', "vaultId": "#(vaultId)" }
    * call read('Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    * header passcode = requesterInfo.requesterPasscode
    Given path 'network/networks/set-profile-routing'
    And request body
    When method POST
    Then status 201
    And match response.status == "success"
    And match response.data.requestId == "#string"



