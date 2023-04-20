@ignore @RAKCON-10583
Feature: Approval View
  # View Approvals feature by Approver account
  Background:
    * url baseURL
    * call read('ApprovalAuthenticator.feature@GetAccessTokenForLogin')
    * def dataBody = read('classpath:data/data_test.json')
    * def schemaBody = read('classpath:data/schema.json')

  @RAKCON-10983 @ViewListPendingRequest
  Scenario: View list pending request to approve
    # Requester adds a new vault request
    * call read('Vault.feature@AddNewVaultWithAdminSetup')
    # Appprover views list pending request to approve
    * def requestBody = {"offset":0, "limit": 10, "status": [PENDING]}
    * call read('ApprovalView.feature@ApprovalView-Common')
    * match each $response.data.records[*].canApproveOrReject == true
    * match each $response.data.records[*].status == "PENDING"

  @RAKCON-10996 @ViewListRequestHistory
  Scenario: View request history - All types
    * def requestBody = { "keyword" : "", "status" : [ "APPROVED", "PENDING", "REJECTED", "CANCELLED" ], "offset" : 10, "isHistory" : true, "limit" : 10 }
    * call read('ApprovalView.feature@ApprovalView-Common')

  @ApprovalView-Common @ignore
  Scenario: Approve View - Common
    Given path '/core/quorums'
    * request requestBody
    When method POST
    Then status 201
    * match each $response.data.records[*].businessRegistrationId == '#string'
    * match each $response.data.records[*].organizationName == '#string'