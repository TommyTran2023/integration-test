@RAKSEC-115
Feature: API Query size limit

  Background:
    * url baseURL
    * call read('this:RequesterAuthenticator.feature@RequesterAccessToken')

  Scenario Outline: POST Limit exceeds maximum of 10000 <api>
    Given path '<api>'
    And request <param>
    When method POST
    Then status 400
    And match response == { 'status': 'error', 'errorCode': 'Bad Request', 'message': 'limit must not be greater than 10000', 'code': 400 }

  Examples:
    | api                                   | param |
    | /transaction/transactions/v1          | { "limit": 10001 } |
    | /transaction/transactions/export      | { "limit": 10001 } |
    | /transaction/transactions/export-web  | { "limit": 10001 } |
    | /advance-quorum/quorums               | { "limit": 10001 } |
    # | /auth/account/list-users              | { "limit": 10001 } | ### Not common listing, will do later

  Scenario Outline: POST Limit within range <api>
    Given path '<api>'
    And request <param>
    When method POST
    Then status 201

  Examples:
    | api                                   | param |
    | /transaction/transactions/v1          | { "limit": 10000 } |
    | /transaction/transactions/export      | { "limit": 10000 } |
    | /transaction/transactions/export-web  | { "limit": 10000 } |
    | /advance-quorum/quorums               | { "limit": 10000 } |
    # | /auth/account/list-users              | { "limit": 10000 } | ### Not common listing, will do later

  Scenario Outline: GET Limit exceeds maximum of 10000 <api>
    Given path '<api>'
    And params <param>
    When method GET
    Then status 400
    And match response == { 'status': 'error', 'errorCode': 'Bad Request', 'message': 'limit must not be greater than 10000', 'code': 400 }

  Examples:
    | api                              | param |
    | /transaction/transactions        | { "limit": 10001 } |
    | /advance-quorum/group-policies   | { "limit": 10001 } |
    # | /auth/account/users              | { "limit": 10001 } | ### Not common listing, will do later
    | /notification/notifications      |  { "limit": 10001, "status": "UNREAD" } |
    | /reports/reports                 | { "limit": 10001 } |
    | /network/networks                | { "limit": 10001 } |
    | /wallet-connect/v2/wcApplication | { "limit": 10001 } |
    | /wallet-connect/v2/wcWeb3Connect | { "limit": 10001 } |

  Scenario Outline: GET Limit within range <api>
    Given path '<api>'
    And params <param>
    When method GET
    Then status 200

  Examples:
    | api                              | param |
    | /transaction/transactions        | { "limit": 10000 } |
    | /advance-quorum/group-policies   | { "limit": 10000 } | 
    # | /auth/account/users              | { "limit": 10000 } | ### Not common listing, will do later
    | /notification/notifications      |  { "limit": 10000, "status": "UNREAD" } |
    | /reports/reports                 | { "limit": 10000 } |
    | /network/networks                | { "limit": 10000 } |
    | /wallet-connect/v2/wcApplication | { "limit": 10000 } |
    | /wallet-connect/v2/wcWeb3Connect | { "limit": 10000 } |
