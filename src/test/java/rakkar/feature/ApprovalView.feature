@RAKCON-10583
Feature: Approval View
  # View Approvals feature by Approver account
  Background:
    * url baseURL
    * call read('ApprovalAuthenticator.feature@GetAccessTokenForLogin')
    * def requesterInfo = call read('GetRequesterInfo.feature@GetRequesterInfo')
    * def dataBody = read('classpath:data/data_test.json')
    * def schemaBody = read('classpath:data/schema.json')

  @RAKCON-10983 @ViewListPendingRequest
  Scenario: View list pending request to approve
    # Requester adds a new vault request
    * call read('Vault.feature@AddNewVaultWithAdminSetup')
    # Approver views list pending request to approve
    * def requestBody = {"offset":0, "limit": 10, "status": [PENDING]}
    * call read('ApprovalView.feature@ApprovalView-Common')
    * match each $response.data.records[*].canApproveOrReject == true
    * match each $response.data.records[*].status == "PENDING"

  @RAKCON-10996 @ViewListRequestHistory
  Scenario: View request history - All types
    * def requestBody = { "keyword" : "", "status" : [ "APPROVED", "PENDING", "REJECTED", "CANCELLED" ], "offset" : 10, "isHistory" : true, "limit" : 10 }
    * call read('ApprovalView.feature@ApprovalView-Common')

  @RAKCON-11860 @ViewRequestHistoryByInitiator
  Scenario: View request history by initiator
    * def requestBody = { "keyword" : "", "offset" : 0, "limit" : 10, "isHistory" : true, "createdBy" : #(requesterInfo.requesterID), "status" : [ "APPROVED", "PENDING", "REJECTED", "CANCELLED" ] }
    * call read('ApprovalView.feature@ApprovalView-Common')
    * match each $response.data.records[*].createdBy.name == requesterInfo.requesterName

  @RAKCON-11861 @ViewListRequestHistoryByStatus
  Scenario: View request history by status
    * def requestBody = { "isHistory" : true, "offset" : 0, "limit" : 10, "keyword" : "", "status" : [ #(dataBody.approvalView.statusFiltering) ] }
    * call read('ApprovalView.feature@ApprovalView-Common')
    * def requestStatus = $response.data.records[*].status
    * match each requestStatus == dataBody.approvalView.statusFiltering

  @ApprovalView-Common @ignore
  Scenario: Approve View - Common
    Given path '/core/quorums'
    * request requestBody
    When method POST
    Then status 201
    * match each $response.data.records[*].businessRegistrationId == '#string'
    * match each $response.data.records[*].organizationName == '#string'