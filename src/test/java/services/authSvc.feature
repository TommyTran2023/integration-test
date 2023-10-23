Feature: Authorization

    Background: Approval is logged in
        * url baseURL

    @GetSession
    Scenario: Get session for login
        Given path '/auth/authorization/initiate-auth'  
        And request body
        When method POST
        * print body

    @GetAccessToken
    Scenario: Approval - Get token for login
        Given path '/auth/authorization/respond-to-auth-challenge'
        And request body2
        When method POST
        * print body

    @GetUserInfo  
    Scenario: Get user information
        Given path '/auth/account/me'
        * header Authorization = authorization
        When method GET

    @GetListUsers
    Scenario: Get list of users
        Given path '/auth/account/list-users'
        * header Authorization = authorization
        * request body
        When method POST


