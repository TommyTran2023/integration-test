    @ignore
Feature: Common call from Auth services
  Background:
    * def svc = 'classpath:rakkar/services/'
    * url baseURL


    @GetAccessTokenForLogin
    Scenario: Get token for login
        * def responseTest1 = call read(svc + 'Auth.feature@GetSession') { userName: '#(userName)' }
        * def Session1 = responseTest1.response.data.Session
        * call read(svc + 'Auth.feature@GetAccessToken') { userName: '#(userName)', answer: '#(answer)', session: '#(Session1)' }
        Then response.status == "success"

    @GetApproverAccessToken
    Scenario: Get Approver Access Token
        * call read('this:AuthCommon.feature@GetAccessTokenForLogin') {userName: '#(approverInfo.approvalUsername)', answer: '#(testData.common.challengeAnswerAuth)'}
        * def approvalAuthToken = response.data.AuthenticationResult.AccessToken
        * def approvalAccessToken = 'Bearer ' + approvalAuthToken
        * configure headers = {Authorization: '#(approvalAccessToken)'}

    @GetRequesterAccessToken
    Scenario: Get Requester Access Token
        * call read('this:AuthCommon.feature@GetAccessTokenForLogin') {userName: '#(requesterInfo.requesterUsername)', answer: '#(testData.common.challengeAnswerAuth)'}
        * def approvalAuthToken = response.data.AuthenticationResult.AccessToken
        * def approvalAccessToken = 'Bearer ' + approvalAuthToken
        * configure headers = {Authorization: '#(approvalAccessToken)'}

    @GetRequesterInfo
    Scenario: Get Requester Info
        * call read('this:AuthCommon.feature@GetRequesterAccessToken')
        * call read('this:Auth.feature@GetUserInfo')
        * match responseStatus == 200
        * def userId = response.data.id
        * def requesterID = response.data.id
        * def requesterEmail = response.data.email
        * def requesterName = response.data.name

    @GetAllUsers
    Scenario: Get All Users
        * def requestBody = {"isGetAll":true}
        * call read('this:Auth.feature@GetListUsers') {requestBody: #(requestBody)}
        * match responseStatus == 201
        * def result = response.data.users
        * def approvalUserID = karate.jsonPath(result, "$[?(@.username=='"+ approverInfo.approvalUsername +"')].userId")[0]
        * def adminUserID = karate.jsonPath(result, "$[?(@.username=='"+ adminUsername +"')].userId")[0]
        * def vaultMemberList = [#(requesterUserID), #(approvalUserID), #(adminUserID)]
