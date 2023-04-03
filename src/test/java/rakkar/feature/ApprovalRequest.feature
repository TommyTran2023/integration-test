@RAKCON-10945
Feature: Approval Request

  Background:
    * url baseURL
    * call read('ApprovalAuthenticator.feature@GetAccessTokenForLogin')
    * def challengeApprover = call read('GenerateAnswer.feature@FIDO-Approver')
    * def dataBody = read('classpath:data/data_test.json')

  @RAKCON-10975 @ApproveNewVaultRequest
  Scenario: Approval - New vault policy request
    # Create new vault and get request ID of creating vault request
    * callonce read('Vault.feature@GetCrateVaultRequestID')
    * def requestID = requestCreateVaultID
    * karate.call('ApprovalRequest.feature@ApproveRequest')

    @ApproveRequest @ignore
    Scenario: Approve pending request - Common
    Given path '/core/quorums/approval/'+requestID
    * header challenge-answer = challengeApprover.challengeAnswerRequest
    * header passcode = approverPasscode

    When method POST
    Then status 201
    * def statusMsg = response.status
    * match statusMsg == 'success'