@ignore
Feature: Auto generate and delete api key
  Background:
    * call read('this:RequesterAuthenticator.feature@RequesterAccessToken')
    * url baseURL

  @Before @Generate_api_key
  Scenario: Generate x-api-key and accountId
    * def now = function(){ return java.lang.System.currentTimeMillis() }
    * def APIName = 'Key-' + now()
    * def body =  {"name":"#(APIName)", "permission":"VIEW"}
    Given path 'openapi/v1/api-keys'
    And request body
    When method POST
    Then status 201

  @After @Delete_api_key
  Scenario: Delete x-api-key and accountId
    Given path 'openapi/v1/api-keys/' + idDeleted
    When method DELETE
    Then status 200



