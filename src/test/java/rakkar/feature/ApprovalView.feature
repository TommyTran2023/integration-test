@RAKCON-10583 @ignore
Feature: Approval View
  # View Approvals feature by Approver account
  Background:
    * url baseURL
    * call read('ApprovalAuthenticator.feature@GetAccessTokenForLogin')
    * def requesterInformation = call read('GetRequesterInfo.feature@GetRequesterInfo')
    * def testData = read('classpath:data/data_test.json')
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
    * def requestBody = { "keyword" : "", "offset" : 0, "limit" : 10, "isHistory" : true, "createdBy" : #(requesterInformation.requesterID), "status" : [ "APPROVED", "PENDING", "REJECTED", "CANCELLED" ] }
    * call read('ApprovalView.feature@ApprovalView-Common')
    * match each $response.data.records[*].createdBy.name == requesterInformation.requesterName

  @RAKCON-11861 @ViewListRequestHistoryByStatus
  Scenario: View request history by status
    * def requestBody = { "isHistory" : true, "offset" : 0, "limit" : 10, "keyword" : "", "status" : [ #(testData.approvalView.statusFiltering) ] }
    * call read('ApprovalView.feature@ApprovalView-Common')
    * def requestStatus = $response.data.records[*].status
    * match each requestStatus == testData.approvalView.statusFiltering

  @RAKCON-11863 @ViewListRequestHistoryByDate
  Scenario: View request history by date
    * def getDate =
      """
      function(numberOfDays){
        var date = new Date();
        date.setDate(date.getDate() + (numberOfDays));
        return date.toISOString()
      }
      """
    # Filter request list by last 7 days
    * def dateFrom = getDate(-7)
    * def dateTo = getDate(-1)
    * def dateToLong =
      """
      function(s) {
        var SimpleDateFormat = Java.type('java.text.SimpleDateFormat');
        var sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
        return sdf.parse(s).time;
      }
      """
    * def min = dateToLong(dateFrom)
    * def max = dateToLong(dateTo)
    * def isValid = function(x){ var temp = dateToLong(x); return temp >= min && temp <= max }
    * def requestBody = { "isHistory" : true, "offset" : 0, "status" : [ "APPROVED", "PENDING", "REJECTED", "CANCELLED" ], "limit" : 10, "keyword" : "", "dateTo" : #(dateTo), "dateFrom" : #(dateFrom) }
    * call read('ApprovalView.feature@ApprovalView-Common')
    # List records should have createdAt between dateFrom and dateTo
    * match each $response.data.records[*].createdAt == '#? isValid(_)'

  @RAKCON-11862 @ViewRequestHistoryByType
  Scenario: View request history by type
    * def requestBody = { "offset" : 0, "status" : [ "APPROVED", "PENDING", "REJECTED", "CANCELLED" ], "keyword" : "", "requestCategories" : [ #(testData.viewListMyRequest.typeFiltering) ], "isHistory" : true, "limit" : 10 }
    * call read('ApprovalView.feature@ApprovalView-Common')
    * def typeValue = $response.data.records[*].type.value
    * match testData.approvalView.valueOfPolicyType contains any typeValue

  @ApprovalView-Common @ignore
  Scenario: Approve View - Common
    Given path '/core/quorums'
    * request requestBody
    When method POST
    Then status 201
    * match each $response.data.records[*].businessRegistrationId == '#string'
    * match each $response.data.records[*].organizationName == '#string'