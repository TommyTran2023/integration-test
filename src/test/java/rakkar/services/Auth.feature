Feature: Authorization

    Background: Approval is logged in
        * url baseURL

    @GetSession
        Scenario: Get session for login
        Given path '/auth/authorization/initiate-auth'
        And request body
        When method POST

    @GetAccessToken
    Scenario: Approval - Get token for login
      Given path '/auth/authorization/respond-to-auth-challenge'
      And request body
      When method POST

    @GetUserInfo  
    Scenario: Get user information
        Given path '/auth/account/me'
        When method GET

# Common call for Authorization scenarios 
    @GetAccessTokenForLogin
        Scenario: Approval - Get token for login
        Given path '/auth/authorization/respond-to-auth-challenge'
        * request body
        When method POST
        Then def APIStatus = response.status
        * assert (APIStatus == "success")
        * def approvalAuthToken = response.data.AuthenticationResult.AccessToken
        * def approvalAccessToken = 'Bearer ' + approvalAuthToken
        * configure headers = {Authorization: '#(approvalAccessToken)'}
    
    