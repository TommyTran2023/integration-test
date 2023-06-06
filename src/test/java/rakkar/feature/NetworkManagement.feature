@RAKCON-10583
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
    * def vaultData = call read('NetworkManagement.feature@DepositRouting')
    * def vaultId = vaultData.response.data.vaults[0].id
    * def now = function(){ return java.lang.System.currentTimeMillis() }
    * def profileName = 'Profile-' + now()
    * def body = {"isDiscoverable" : true,"networkName": '#(profileName)', vaultId: "#(vaultId)" }
    Given path 'network/networks'
    And request body
    When method POST
    Then status 200
    And match response.status == "success"
    And match response.data.networkFullName contains '#(profileName)'


