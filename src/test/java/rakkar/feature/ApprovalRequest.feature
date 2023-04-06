@RAKCON-10945
Feature: Approval Request

  Background:
    #@PRECOND_RAKCON-11369
    * url baseURL
    * call read('ApprovalAuthenticator.feature@GetAccessTokenForLogin')
    * def challengeApprover = call read('GenerateAnswer.feature@FIDO-Approver')
    * def dataBody = read('classpath:data/data_test.json')

  @RAKCON-10975 @ApproveNewVaultRequest
  Scenario: Approval - New vault policy request
    # Create new vault and get request ID of creating vault request
    * callonce read('Vault.feature@GetCrateVaultRequestID')
    * def requestId = requestCreateVaultID
    * karate.call('ApprovalRequest.feature@ApproveRequest')


  @RAKCON-11001 @ApproveEditAccountPolicy
  Scenario: Approval - Edit policy
    * call read('AccountPolicy.feature@ViewAccountPolicy')
    * if (requestId == null) karate.call('AccountPolicy.feature@EditAccountPolicy')
    * call read('AccountPolicy.feature@ViewAccountPolicy')
    * karate.call('ApprovalRequest.feature@ApproveRequest')

   @RAKCON-11367 @ApprovalNewAddressWhitelist
   Scenario: Approval - Add whitelist address folder
    # Get request ID of creating whitelist address
     * def value = call read('WhiteListFolder.feature@View_My_Request_Whitelist')
     * def requestId = value.response.data.records[0].id
     * karate.call('ApprovalRequest.feature@ApproveRequest')

     # Common Approve
  @ApproveRequest @ignore
    Scenario: Approve pending request - Common
    Given path '/core/quorums/approval/'+requestId
    * header challenge-answer = challengeApprover.challengeAnswerRequest
    * header passcode = approverPasscode
    When method POST
    Then status 201
    * def statusMsg = response.status
    * match statusMsg == 'success'