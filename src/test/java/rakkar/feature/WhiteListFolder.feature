@RAKCON-10586 @AT
Feature: WhiteList Folder

  Background:
    #@PRECOND_RAKCON-10228
    * url baseURL
    * def requesterAuthResponse = call read('RequesterAuthenticator.feature')
    * def requesterAuthToken = requesterAuthResponse.response.data.AuthenticationResult.AccessToken
    * def accessToken = 'Bearer ' + requesterAuthToken
    * configure headers = { Authorization: '#(accessToken)'}

  @RAKCON-10226
  Scenario: Check create a new folder
    #Get list folder
    * def query = { limit:'10', offset: '0', sort:'ASC', sortBy: 'NAME'}
    Given path 'core/folders'
    And params query
    When method GET
    Then status 200
    #Create new folder
    * def body = {"name" : "Folder_test_02",type: "internal"}
    Given path 'core/folders'
    And request body
    When method POST
    Then status 201
    And print response
    And match response.data.name == "Folder_test_02"
    And match response.data.type == "internal"

  @RAKCON-10227
  Scenario: Check delete a folder
    #Get list folder
    * def query = { limit:'10', offset: '0', sort:'ASC', sortBy: 'NAME',keyword: 'Folder_test_02'}
    Given path 'core/folders'
    And params query
    When method GET
    Then status 200
    #Select a folder then delete
    * def id = response.data.folders[0].id
    Given path 'core/folders/' + id
    When method DELETE
    Then status 200
    #Verify delete success
    Given path 'core/folders'
    And params query
    When method GET
    Then status 200
    And match response.data.totalCount == 0

  @RAKCON-10587
  Scenario: View folder listing
    * def query = { limit:'10', offset: '0', sort:'ASC', sortBy: 'NAME',keyword: 'Folder_test_02'}
    Given path 'core/folders'
    And params query
    When method GET
    Then status 200


