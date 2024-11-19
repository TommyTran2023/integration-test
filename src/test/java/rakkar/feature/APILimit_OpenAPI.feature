@RAKSEC-115
Feature: OpenAPI Query size limit

  Background:
    * url openApiURL
    * def apiKey = callonce read('this:GenerateAPIkey.feature@Generate_api_key')
    * print apiKey.response.data.key
    * def key = apiKey.response.data.key
    * def accountId = apiKey.response.data.accountId
    * def idDeleted = apiKey.response.data.id

  @RAKCON-34017
  Scenario Outline: OpenAPI Limit exceeds maximum <api> <limit>
    Given path '<api>'
    * header x-api-key = key
    * header account-id = accountId
    And request <param>
    When method GET
    Then status 400
    And match response == { 'status': 'error', 'errorCode': 'Bad Request', 'message': 'limit must not be greater than <limit>', 'code': 400 }

  Examples:
    | api               | param            | limit |
    | /v1/balances      | { "limit": 101 } | 100 |
    | /v1/vaults        | { "limit": 501 } | 500 |
    | /v1/transactions  | { "limit": 501 } | 500 |
    | /v1/whitelist     | { "limit": 501 } | 500 |

  @RAKCON-34018
  Scenario Outline: GET Limit within range <api>
    Given path '<api>'
    * header x-api-key = key
    * header account-id = accountId  
    And params <param>
    When method GET
    Then status 200

  Examples:
    | api               | param |
    | /v1/balances      | { "limit": 100 } |
    | /v1/vaults        | { "limit": 500 } |
    | /v1/transactions  | { "limit": 500 } |
    | /v1/whitelist     | { "limit": 500 } |


  @AfterFeature @Delete_api_key
  Scenario: Delete api key
    * call read('this:GenerateAPIkey.feature@Delete_api_key')
