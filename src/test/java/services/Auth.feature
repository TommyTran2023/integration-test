@ignore
Feature: Common call from Auth services
  Background:
    * def svc = 'classpath:services/'
    * url baseURL


    @GetAccessTokenForLogin
    Scenario: Get token for login
        * def responseTest1 = call read(svc + 'authSvc.feature@GetSession') { userName: '#(userName)' }
        * def Session1 = responseTest1.response.data.Session
        * call read(svc + 'authSvc.feature@GetAccessToken') { userName: '#(userName)', answer: '#(answer)', session: '#(Session1)' }
        Then match response.status == "success"

    @GetApproverAccessToken
    Scenario: Get Approver Access Token
        * call read('this:Auth.feature@GetAccessTokenForLogin') {userName: '#(approverInfo.approvalUsername)', answer: '#(testData.challengeAnswerAuth)'}
        * def approvalAuthToken = response.data.AuthenticationResult.AccessToken
        * def approvalAccessToken = 'Bearer ' + approvalAuthToken
        # * configure headers = {Authorization: '#(approvalAccessToken)'}

    @GetRequesterAccessToken
    Scenario: Get Requester Access Token
        * call read('this:Auth.feature@GetAccessTokenForLogin') {userName: '#(requesterInfo.requesterUsername)', answer: '#(testData.challengeAnswerAuth)'}
        * def requesterAuthToken = response.data.AuthenticationResult.AccessToken
        * def requesterAccessToken = 'Bearer ' + requesterAuthToken
        # * configure headers = {Authorization: '#(requesterAccessToken)'}

    @GetRequesterInfo
    Scenario: Get Requester Info
        * call read('this:Auth.feature@GetRequesterAccessToken')
        * call read('this:authSvc.feature@GetUserInfo') {authorization: '#(requesterAccessToken)'}
        * match responseStatus == 200
        * def userId = response.data.id
        * def requesterID = response.data.id
        * def requesterEmail = response.data.email
        * def requesterName = response.data.name

    @GetAllUsers
    Scenario: Get All Users
        * def requestBody = {"isGetAll":true}
        * call read('this:authSvc.feature@GetListUsers') {requestBody: #(requestBody), authorization: '#(requesterAccessToken)'}
        * match responseStatus == 201
        * def allUsers = response.data.users
        * def approvalUserID = karate.jsonPath(allUsers, "$[?(@.username=='"+ approverInfo.approvalUsername +"')].userId")[0]
        * def adminUserID = karate.jsonPath(allUsers, "$[?(@.username=='"+ adminUsername +"')].userId")[0]
        * def vaultMemberList = [#(requesterUserID), #(approvalUserID), #(adminUserID)]
