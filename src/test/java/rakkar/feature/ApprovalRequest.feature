@RAKCON-10945 @ignore
Feature: Approval Request

  Background:
    * url baseURL
    * def approvalAuthResponse = call read('ApprovalAuthenticator.feature')
    * def approvalAuthToken = approvalAuthResponse.response.data.AuthenticationResult.AccessToken
    * def approvalAccessToken = 'Bearer ' + approvalAuthToken
    * configure headers = {Authorization: '#(approvalAccessToken)'}
    * def challengeApprover = call read('GenerateAnswer.feature@FIDO-Approver')
    * def dataBody = read('classpath:data/data_test.json')

  @RAKCON-10975
  Scenario: Approval - New vault policy request
    # Get request ID of creating vault request
    * callonce read('ApprovalRequest.feature@GetCreateVaultRequestID')
    * print requestCreateVaultID

    # Approve new vault policy request
    Given path '/core/quorums/approval/'+requestCreateVaultID
    * header challenge-answer = challengeApprover.challengeAnswerRequest
    * header passcode = dataBody.common.approverPasscode

    When method POST
    Then status 201
    * def statusMsg = response.status
    * match statusMsg == 'success'

  @ignore @GetCreateVaultRequestID
  Scenario: Get request ID by requester
      # Get request ID of creating vault request
    * def requesterAuthResponse = call read('RequesterAuthenticator.feature')
    * def requesterAuthToken = requesterAuthResponse.response.data.AuthenticationResult.AccessToken
    * def accessToken = 'Bearer ' + requesterAuthToken
    * headers Authorization = accessToken
    * call read('Vault.feature@GetRequestID')
    * print requestCreateVaultID
