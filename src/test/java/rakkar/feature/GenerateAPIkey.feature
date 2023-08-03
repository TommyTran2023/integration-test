@ignore
Feature: Auto generate and delete api key
  Background:
    * call read('RequesterAuthenticator.feature@RequesterAccessToken')
    * url openApiURL

  @Before @Generate_api_key
  Scenario: Generate x-api-key and accountId
    * def now = function(){ return java.lang.System.currentTimeMillis() }
    * def APIName = 'Key-' + now()
    * def body =  {"name":"#(APIName)", "permission":"VIEW"}
    Given path 'v1/api-keys'
    And request body
    When method POST
    Then status 201

  @Delete_api_key
  Scenario: Delete x-api-key and accountId
    Given path 'v1/api-keys/' + idDeleted
    When method DELETE
    Then status 200





