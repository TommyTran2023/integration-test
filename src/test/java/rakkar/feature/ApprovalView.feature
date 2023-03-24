@RAKCON-10943 @ignore
Feature: Approval View
  # Login by approver account
  Background:
    * url baseURL
    * def approvalAuthResponse = call read('ApprovalAuthenticator.feature')
    * def approvalAuthToken = approvalAuthResponse.response.data.AuthenticationResult.AccessToken
    * def approvalAccessToken = 'Bearer ' + approvalAuthToken
    * configure headers = {Authorization: '#(approvalAccessToken)'}
    * def challengeApprover = call read('GenerateAnswer.feature@FIDO-Approver')
    * def dataBody = read('classpath:data/data_test.json')
  Scenario: View list pending request to approve
