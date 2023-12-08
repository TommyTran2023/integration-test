@ignore
Feature: Common call from Auth services
    
    @GetAccessTokenForLogin
    Scenario: Get token for login
        # 1. Get session
        * def responseTest1 = call read(svc + 'authSvc.feature@GetSession') {userName: '#(userName)'}
        * def Session1 = responseTest1.response.data.Session
        
        # 2. Get access token
        * call read(svc + 'authSvc.feature@GetAccessToken') {userName: '#(userName)', session: '#(Session1)', answer: '#(answer)'}
        Then match response.status == "success"

    @GetApproverAccessToken
    Scenario: Get Approver Access Token
        * call read('this:Auth.feature@GetAccessTokenForLogin') {userName: '#(approverInfo.approvalUsername)', answer: '#(testData.common.challengeAnswerAuth)'}
        * def approvalAuthToken = response.data.AuthenticationResult.AccessToken
        * def approvalAccessToken = 'Bearer ' + approvalAuthToken

    @GetRequesterAccessToken
    Scenario: Get Requester Access Token
        * call read('this:Auth.feature@GetAccessTokenForLogin') {userName: '#(requesterInfo.requesterUsername)', answer: '#(testData.common.challengeAnswerAuth)'}
        * def requesterAuthToken = response.data.AuthenticationResult.AccessToken
        * def requesterAccessToken = 'Bearer ' + requesterAuthToken

    @GetUserAccessToken
    Scenario: Get Requester Access Token
        * call read('this:Auth.feature@GetAccessTokenForLogin') {userName: '#(userName)', answer: '#(testData.common.challengeAnswerAuth)'}
    
    @GetRequesterInfo
    Scenario: Get Requester Info
        * call read('this:Auth.feature@GetRequesterAccessToken')
        * call read('this:authSvc.feature@GetUserInfo') {authorization: '#(requesterAccessToken)'}
        * match responseStatus == 200
        * def userId = response.data.id
        * def requesterID = response.data.id
        * def requesterEmail = response.data.email
        * def requesterName = response.data.name

    @GetUserInfo
    Scenario: Get User Info
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * call read('this:authSvc.feature@GetUserInfo') {authorization: '#(accessToken)'}

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
    
    @GetUsers
    Scenario: Get users
        * def keyword = karate.get('keyword','')
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
        {
            authorization: '#(accessToken)',
            params: {
                keyword:#(keyword),
                limit: 10,
                offet: 0,
                sort: ASC,
                sortBy: NAME,
                status: ACTIVE
            }
        }
        """
        * call read('this:authSvc.feature@GetUsers') data
        * match responseStatus == 200
        * match response.code == 200
        * match response.status == 'success'
        * karate.set('keyword',null)
        * karate.set('accessToken',null)
    
    @GetUserDetails
    Scenario: Get User Details
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
        {
            authorization: '#(accessToken)',
            params:{
                userIds: '#(userIds)',
                limit: 20,
                offset: 0,
                searchText: ''
            }
        }
        """
        * call read('this:authSvc.feature@GetUserDetail') data
        * match responseStatus == 200
        * match response.code == 200
        * match response.status == 'success'
        
