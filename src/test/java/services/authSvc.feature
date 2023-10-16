Feature: Authorization

    Background: Approval is logged in
        * url baseURL

    @GetSession
        Scenario: Get session for login
        Given path '/auth/authorization/initiate-auth'
        * def body = 
        """
        {
            "initiateAuthRequest": { 
                "AuthFlow": "CUSTOM_AUTH", 
                "AuthParameters": { 
                        "USERNAME": '#(userName)' 
                    } 
                }
        }
        """
        And request body
        When method POST

    @GetAccessToken
    Scenario: Approval - Get token for login
      Given path '/auth/authorization/respond-to-auth-challenge'
      * def body =
      """
        { 
            "respondToAuthChallengeRequest": { 
                "ChallengeName": "CUSTOM_CHALLENGE", 
                "ChallengeResponses": { 
                    "USERNAME": '#(userName)', 
                    "ANSWER": '#(answer)' 
                }, 
                "Session": '#(session)' 
                }, 
            "deviceName": "duncan" }
      """
      And request body
      When method POST

    @GetUserInfo  
    Scenario: Get user information
        Given path '/auth/account/me'
        * header Authorization = authorization
        When method GET

    @GetListUsers
    Scenario: Get list of users
        Given path '/auth/account/list-users'
        * header Authorization = authorization
        * request requestBody
        When method POST


