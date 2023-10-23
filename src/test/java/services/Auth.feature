@ignore
Feature: Common call from Auth services

    @GetAccessTokenForLogin
    Scenario: Get token for login
        # 1. Get session
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
        * def responseTest1 = call read(svc + 'authSvc.feature@GetSession') body
        * def Session1 = responseTest1.response.data.Session
        
        # 2. Get access token
        * def body2 =
        """
        { 
          "respondToAuthChallengeRequest": { 
              "ChallengeName": "CUSTOM_CHALLENGE", 
              "ChallengeResponses": { 
                  "USERNAME": '#(userName)', 
                  "ANSWER": '#(answer)' 
              }, 
              "Session": '#(Session1)' 
              }, 
          "deviceName": "AT Integration Test"
        }
        """
        * call read(svc + 'authSvc.feature@GetAccessToken') body2
        Then match response.status == "success"

    @GetApproverAccessToken
    Scenario: Get Approver Access Token
        * call read('this:Auth.feature@GetAccessTokenForLogin') {userName: '#(approverInfo.approvalUsername)', answer: '#(testData.challengeAnswerAuth)'}
        * def approvalAuthToken = response.data.AuthenticationResult.AccessToken
        * def approvalAccessToken = 'Bearer ' + approvalAuthToken

    @GetRequesterAccessToken
    Scenario: Get Requester Access Token
        * call read('this:Auth.feature@GetAccessTokenForLogin') {userName: '#(requesterInfo.requesterUsername)', answer: '#(testData.challengeAnswerAuth)'}
        * def requesterAuthToken = response.data.AuthenticationResult.AccessToken
        * def requesterAccessToken = 'Bearer ' + requesterAuthToken

    @GetRequesterInfo
    Scenario: Get Requester Info
        * call read('this:Auth.feature@GetRequesterAccessToken')
        * call read('this:authSvc.feature@GetUserInfo') {authorization: '#(requesterAccessToken)'}
        * match responseStatus == 200
        * def userId = response.data.id
        * def requesterID = response.data.id
        * def requesterEmail = response.data.email
        * def requesterName = response.data.name

    @GetListUsers
    Scenario: Get All Users
        * def data =
        """
        {
            authorization: '#(requesterAccessToken)',
            body: {"isGetAll":true}
        }
        """
        * call read('this:authSvc.feature@GetListUsers') data
        * match responseStatus == 201
        * def allUsers = response.data.users
        # Add requester, approver and admin to vault member list
        * def requesterUserID = karate.jsonPath(allUsers, "$[?(@.username=='"+ requesterInfo.requesterUsername +"')].userId")[0]
        * def approvalUserID = karate.jsonPath(allUsers, "$[?(@.username=='"+ approverInfo.approvalUsername +"')].userId")[0]
        * def adminUserID = karate.jsonPath(allUsers, "$[?(@.username=='"+ adminUsername +"')].userId")[0]
        * def adminUserID2 = karate.jsonPath(allUsers, "$[?(@.username=='"+ adminUsername2 +"')].userId")[0]
        * def vaultMemberList = [#(requesterUserID), #(approvalUserID), #(adminUserID), #(adminUserID2)]
