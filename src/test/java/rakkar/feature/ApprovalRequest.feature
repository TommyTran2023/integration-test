@RAKCON-10945
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
    * callonce read('ApprovalView.feature@RAKCON-10983')
    * def recordsResponse = response.data.records
    * print recordsResponse
    * def requestID = recordsResponse.length > 0 ? karate.jsonPath(recordsResponse, "$.[?(@.type.value=='CREATE_VAULT')].id")[0] : 0
    * print requestID

    # If there is Create new vault request available -> Approve new vault policy request
    * eval if (requestID != 0) karate.call('ApprovalRequest.feature@ApproveRequest')

    @ApproveRequest @ignore
    Scenario: Approve pending request - Common
    Given path '/core/quorums/approval/'+requestID
    * header challenge-answer = challengeApprover.challengeAnswerRequest
    * header passcode = dataBody.common.approverPasscode

    When method POST
    Then status 201
    * def statusMsg = response.status
    * match statusMsg == 'success'