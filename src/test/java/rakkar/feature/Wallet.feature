Feature: Wallet
  Background:
    * url baseURL
    * def requesterAuthResponse = call read('RequesterAuthenticator.feature')
    * def requesterAuthToken = requesterAuthResponse.response.data.AuthenticationResult.AccessToken
    * def accessToken = 'Bearer ' + requesterAuthToken
    * def vault = call read('Vault.feature@RAKCON-10217')
    * def vaultId = vault.response.data.id
    * configure headers = {Authorization: '#(accessToken)'}
    * def dataBody = read('classpath:data/data_test.json')

  @RAKCON-10944
  Scenario: Add new asset
   #View list asset
    Given path 'core/wallet/tokens/' + vaultId
    When method GET
    * param limit = 10
    * param offset = 0
    Then status 200
    * def assetId = response.data.tokens[0].id
    * def symbolView = response.data.tokens[0].symbol
    * def networkView = response.data.tokens[0].network


   #Add asset to the vault
    Given path 'core/wallet/' + vaultId
    * request {"tokenIds": ["#(assetId)"]}
    When method POST
    Then status 201
    * def symbolAdd = response.data.success[0].symbol
    * def networkAdd = response.data.success[0].network
    And match symbolAdd == symbolView
    And match networkAdd == networkView

