@RAKCON-10583
Feature: View List My Request
    # View Approvals feature by Requester account
  Background:
    * url baseURL
    * call read('RequesterAuthenticator.feature@RequesterAccessToken')
    * def requesterInformation = call read('GetRequesterInfo.feature@GetRequesterInfo')
    * def schemaBody = read('classpath:data/schema.json')
    * def testData = read('classpath:data/data_test.json')

  @RAKCON-10994 @ViewMyRequestAllType
  Scenario: View my request - All types
    # Requester adds a new vault request
    * call read('Vault.feature@AddNewVaultWithAdminSetup')
    # Check list request by Requester ID in My Request list
    * def requestBody = { "limit" : 10, "offset" : 0, "keyword" : "", "isHistory" : true, "status" : [ "APPROVED", "PENDING", "REJECTED", "CANCELLED" ], "createdBy" : #(requesterInformation.requesterID)}
    * call read('ViewListMyRequest.feature@ViewListMyRequest-Common')


  @RAKCON-11857 @ViewMyRequestByStatus
  Scenario: View my request by status
    # Check list request by Requester ID in My Request list by status
    * def requestBody = { "isHistory" : true, "offset" : 0, "limit" : 10, "keyword" : "", "status" : [ #(testData.viewListMyRequest.statusFiltering) ], "createdBy" : #(requesterInformation.requesterID) }
    * call read('ViewListMyRequest.feature@ViewListMyRequest-Common')
    * def requestStatus = $response.data.records[*].status
    * match each requestStatus == testData.viewListMyRequest.statusFiltering

  @RAKCON-11859 @ViewMyRequestByDate
  Scenario: View my request by date
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
    * def requestBody = { "isHistory" : true, "offset" : 0, "status" : [ "APPROVED", "PENDING", "REJECTED", "CANCELLED" ], "limit" : 10, "keyword" : "", "dateTo" : #(dateTo), "createdBy" : #(requesterInformation.requesterID), "dateFrom" : #(dateFrom) }
    * call read('ViewListMyRequest.feature@ViewListMyRequest-Common')
    # List records should have createdAt between dateFrom and dateTo
    * match each $response.data.records[*].createdAt == '#? isValid(_)'

  @RAKCON-11858 @ViewMyRequestByType
  Scenario: View my request by type
    # Check list request by Request ID in My Request list by type
    * def requestBody = { "offset" : 0, "status" : [ "APPROVED", "PENDING", "REJECTED", "CANCELLED" ], "keyword" : "", "createdBy" : #(requesterInformation.requesterID), "requestCategories" : [ #(testData.viewListMyRequest.typeFiltering) ], "isHistory" : true, "limit" : 10 }
    * call read('ViewListMyRequest.feature@ViewListMyRequest-Common')
    * def typeValue = $response.data.records[*].type.value
    * match testData.viewListMyRequest.valueOfPolicyType contains any typeValue

  @ViewListMyRequest-Common @ignore
  Scenario: Approve View - Common
    Given path '/core/quorums'
    * request requestBody
    When method POST
    Then status 201
    * def pendingRequest = karate.jsonPath(response.data,"$.records[?(@.status=='PENDING')].canApproveOrReject")
    # User can cancel themselves request that has Pending status => param "canApproveOrReject" should be true
    * match each $pendingRequest == true
    * match each $response.data.records[*].businessRegistrationId == '#string'
    * match each $response.data.records[*].organizationName == '#string'