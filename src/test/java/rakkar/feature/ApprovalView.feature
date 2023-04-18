@RAKCON-10943 @ignore
Feature: Approval View
  # Login by approver account
  Background:
    * url baseURL
    * call read('ApprovalAuthenticator.feature')
    * def challengeApprover = call read('Common.feature@FIDO-Approver')
    * def dataBody = read('classpath:data/data_test.json')
    * def schemaBody = read('classpath:data/schema.json')

  @RAKCON-10983 @ViewListPendingRequest
  Scenario: View list pending request to approve
    # Requester adds a new vault request
    * call read('Vault.feature@AddNewVaultWithAdminSetup')
    # Appprover views list pending request to approve
    * def requestBody = {"offset":0, "limit": 10, "status": [PENDING]}
    * call read('ApprovalView.feature@ApprovalView-Common')
    * def recordsSchema = schemaBody.approvalView.viewListRequest
    * match response.data.records contains recordsSchema

  @RAKCON-10994 @ViewMyRequestAllType
  Scenario: View my request - All types
    # Requester adds a new vault request
    * call read('Vault.feature@AddNewVaultWithAdminSetup')
    # Check list request by Requester ID
    * def requesterInfo = call read('GetRequesterInfo.feature@GetRequesterInfo')
    * call read('RequesterAuthenticator.feature@RequesterAccessToken')
    Given path '/core/quorums'
    * request { "limit" : 10, "offset" : 0, "keyword" : "", "isHistory" : true, "status" : [ "APPROVED", "PENDING", "REJECTED", "CANCELLED" ], "createdBy" : #(requesterInfo.requesterID)}
    When method POST
    Then status 201
    * def recordsSchema = schemaBody.approvalView.viewListRequest
    * match response.data.records contains recordsSchema

  @ApprovalView-Common @ignore
  Scenario: Approve View - Common
    Given path '/core/quorums'
    * request requestBody
    When method POST
    Then status 201