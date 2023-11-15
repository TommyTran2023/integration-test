Feature: Authorization

    Background: Approval is logged in
        * url baseURL

    @GetSession
    Scenario: Get session for login
        * def bodyInitiateAuth = 
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
        Given path '/auth/authorization/initiate-auth'  
        And request bodyInitiateAuth
        When method POST

    @GetAccessToken
    Scenario: Approval - Get token for login
        * def bodyGetToken =
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
          "deviceName": "AT Integration Test"
        }
        """
        Given path '/auth/authorization/respond-to-auth-challenge'
        And request bodyGetToken
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
        * request body
        When method POST
    
    @GetUsers
    Scenario: Get users
        Given path '/auth/account/users'
        * header Authorization = authorization
        * params params
        When method GET
    
    @GetUserDetail
    Scenario: Get user details
        Given path '/auth/account/users/' + userId
        * header Authorization = authorization
        When method GET
