@RAKSEC-115
Feature: REP API Query size limit

  Background:
    * url baseURL
    * callonce read(repSvc + 'Auth.feature@LoginAsCustomerSuccess')
    * configure headers = {"Authorization": '#(repAccessToken)'}

  Scenario Outline: GET Limit exceeds maximum of 10000 <api>
    Given path '<api>'
    And params <param>
    When method GET
    Then status 400
    And match response == { 'status': 'error', 'errorCode': 'Bad Request', 'message': 'limit must not be greater than 10000', 'code': 400 }

  Examples:
    | api                       | param |
    | /audit/audit-log          | { "limit": 10001 } |


  Scenario Outline: GET Limit within range <api>
    Given path '<api>'
    And params <param>
    When method GET
    Then status 200

  Examples:
    | api                       | param |
    | /audit/audit-log          | { "limit": 10000 } |
