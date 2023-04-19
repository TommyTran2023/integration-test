@RAKCON-10583
Feature: View List My Request
    # View Approvals feature by Requester account
  Background:
    * url baseURL
    * call read('RequesterAuthenticator.feature@RequesterAccessToken')
    * def requesterInfo = call read('GetRequesterInfo.feature@GetRequesterInfo')
    * def schemaBody = read('classpath:data/schema.json')
    * def dataBody = read('classpath:data/data_test.json')

  @RAKCON-10994 @ViewMyRequestAllType
  Scenario: View my request - All types
    # Requester adds a new vault request
    * call read('Vault.feature@AddNewVaultWithAdminSetup')
    # Check list request by Requester ID in My Request list
    * def requestBody = { "limit" : 10, "offset" : 0, "keyword" : "", "isHistory" : true, "status" : [ "APPROVED", "PENDING", "REJECTED", "CANCELLED" ], "createdBy" : #(requesterInfo.requesterID)}
    * call read('ViewListMyRequest.feature@ViewListMyRequest-Common')


  @RAKCON-11857 @ViewMyRequestByStatus
  Scenario: View my request by status
    # Check list request by Requester ID in My Request list by status
    * def requestBody = { "isHistory" : true, "offset" : 0, "limit" : 10, "keyword" : "", "status" : [ #(dataBody.viewListMyRequest.statusFiltering) ], "createdBy" : #(requesterInfo.requesterID) }
    * call read('ViewListMyRequest.feature@ViewListMyRequest-Common')
    * def requestStatus = $response.data.records[*].status
    * match each requestStatus == dataBody.viewListMyRequest.statusFiltering

  @ViewListMyRequest-Common @ignore
  Scenario: Approve View - Common
    Given path '/core/quorums'
    * request requestBody
    When method POST
    Then status 201
    * match each $response.data.records[*].canApproveOrReject == false
    * match each $response.data.records[*].businessRegistrationId == '#string'
    * match each $response.data.records[*].organizationName == '#string'