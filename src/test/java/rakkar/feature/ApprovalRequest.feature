@RAKCON-10945
Feature: Approval Request

  Background:
    * url baseURL
    * call read('ApprovalAuthenticator.feature@GetAccessTokenForLogin')
    * def challengeApprover = call read('GenerateAnswer.feature@FIDO-Approver')
    * def dataBody = read('classpath:data/data_test.json')
    * callonce read('ApprovalView.feature@ViewListPendingRequest')
    * def recordsResponse = response.data.records
    * print recordsResponse

  @RAKCON-10975 @ApproveNewVaultRequest
  Scenario: Approval - New vault policy request
    # Get request ID of creating vault request
    Given def requestID = recordsResponse.length > 0 ? karate.jsonPath(recordsResponse, "$.[?(@.type.value=='CREATE_VAULT')].id")[0] : 0
    * print requestID

    # If there is Create new vault request available -> Approve new vault policy request
    * eval requestID != 0 ? karate.call('ApprovalRequest.feature@ApproveRequest') : karate.fail('Not available creating vault request to approve')

    @ApproveRequest @ignore
    Scenario: Approve pending request - Common
    Given path '/core/quorums/approval/'+requestID
    * header challenge-answer = challengeApprover.challengeAnswerRequest
    * header passcode = approverPasscode

    When method POST
    Then status 201
    * def statusMsg = response.status
    * match statusMsg == 'success'