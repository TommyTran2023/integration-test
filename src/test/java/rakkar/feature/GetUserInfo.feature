@ignore
Feature: Get user information

  Background:
    #@PRECOND_RAKCON-10224
    * url baseURL

  @RAKCON-10221 @GetRequesterInfo
  Scenario: Requester - Get information of requester
    * call read('RequesterAuthenticator.feature@RequesterAccessToken')
    * call read('GetUserInfo.feature@GetUserInfo')
    * def requesterID = response.data.id
    * def requesterEmail = response.data.email
    * def requesterName = response.data.name

  @ignore @GetApproverInfo
  Scenario: Approver - Get information of approver
    * call read('ApprovalAuthenticator.feature@GetAccessTokenForLogin')
    * call read('GetUserInfo.feature@GetUserInfo')
    * def approverID = response.data.id
    * def approverEmail = response.data.email
    * def approverName = response.data.name

  @ignore @GetUserInfo
  Scenario: Get user information - Common
    Given path '/auth/account/me'
    When method GET
    Then status 200

