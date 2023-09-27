@RAKCON-10583
Feature:Help Center

  Background:
    * url baseURL
    * call read('this:RequesterAuthenticator.feature@RequesterAccessToken')
    * def getRequesterIDResponse = call read('this:GetUserInfo.feature')
    * def requesterUserEmail = getRequesterIDResponse.response.data.email
    * def schemaJson = read('classpath:data/schema.json')
    * def now = function(){ return java.lang.System.currentTimeMillis() }
    * def testData = read('classpath:data/data_test.json')

  @RAKCON-11377 @CreateTicketIssue
  Scenario: Create a ticket detail page - Issue
    * def descriptionTicket = 'description for create issue' + now()
    * def subject = 'subject for create issue' + now()
    * def body =  {"description":"#(descriptionTicket)","attachmentToken":["#(token)"],"subject":"#(subject)","category":"issue","emailCcs":["#(requesterUserEmail)"],"platforms":["#(testData.help_center.platform)"]}
    * call read('this:HelpCenter.feature@Create_ticket_common')
    * match response.data.category == "#(testData.help_center.type_issue)"
    * match response.data.platforms[0] == "#(testData.help_center.platform)"

  @CreateTicketIssueWithUploadVideo
  Scenario: Create Ticket Issue With Upload Video
    * karate.callSingle('this:UploadFile.feature@UPLOAD_IMAGE_ON_CRM') //this will fail on uat due to WEB-54 is not ready on UAT
    * call read('this:HelpCenter.feature@CreateTicketIssue')

  @RAKCON-11378 @CreateTicketQuestion
  Scenario: Create a ticket detail page - Question
    * def descriptionTicket = 'description for create question' + now()
    * def subject = 'subject for create question' + now()
    * def body = {"description":"#(descriptionTicket)","attachmentToken":["#(token)"],"subject":"#(subject)","category":"question","emailCcs":["#(requesterUserEmail)"]}
    * call read('this:HelpCenter.feature@Create_ticket_common')
    # we using mock service so data in here is not correct
    # * match response.data.category == "#(testData.help_center.type_question)"
    * match response.data.category == "issue" 

  @RAKCON-11379 @CreateTicketRequest
  Scenario: Create a ticket detail page - Request
    * def descriptionTicket = 'description for create request' + now()
    * def subject = 'subject for create request' + now()
    * def body = {"description":"#(descriptionTicket)","attachmentToken":["#(token)"],"subject":"#(subject)","category":"request","emailCcs":["#(requesterUserEmail)"], "requestType" : "mark_lost_device"}
    * call read('this:HelpCenter.feature@Create_ticket_common')
    # we using mock service so data in here is not correct
    # * match response.data.category == "#(testData.help_center.type_request)" 
    # * match response.data.requestType == "mark_lost_device"
    * match response.data.category == "issue"  
    * match response.data.requestType == null

  @RAKCON-11380 @ViewListingTicketInProgress
  Scenario: View listing ticket on tab In progress
    * def query = {limit: '20', page: '1', status: 'in_progress'}
    * call read('this:HelpCenter.feature@Search_Filter_ticket_common')

  @RAKCON-11381 @ViewListingTicketSolved @VIEW_LISTING_TICKET_SOLVED
  Scenario: View listing ticket on tab Solved
    * def query = {page: '1', status: 'solved'}
    * call read('this:HelpCenter.feature@Search_Filter_ticket_common')

  @RAKCON-11386 @FilterTicketByCategory
  Scenario: Filter ticket by Category
  * def query = { limit:'20', page: '1', status: 'in_progress', category:'issue'}
  * call read('this:HelpCenter.feature@Search_Filter_ticket_common')

   @RAKCON-11385 @FilterTicketByDate
   Scenario: Filter ticket by Date
     * def query = { limit:'20', page: '1', status: 'in_progress', dateTo:'2023-04-26',dateFrom:'2023-04-19'}
     * call read('this:HelpCenter.feature@Search_Filter_ticket_common')

  @RAKCON-11382 @SearchTicketInProgress
   Scenario: Search ticket on tab In progress
    * call read('this:HelpCenter.feature@CreateTicketIssue')
    * def keyword = response.data.subject
    * def query = { limit:'20', page: '1', status: 'in_progress', keyword:'#(keyword)'}
    * call read('this:HelpCenter.feature@Search_Filter_ticket_common')
    # we using mock service so data in here is not correct
    # * match each $response.data.tickets[*].subject contains "#(keyword)"

  @RAKCON-11383 @SearchTicketSolved
  Scenario: Search ticket on tab Solved
    * def keyword = testData.help_center.search_solved
    * def query = { limit:'20', page: '1', status: 'solved', keyword:'#(testData.help_center.search_solved)'}
    * call read('HelpCenter.feature@Search_Filter_ticket_common')
    # we using mock service so data in here is not correct
    # * match each $response.data.tickets[*].subject contains keyword

  @ignore @Create_ticket_common
  Scenario: Create ticket common
    Given path '/crm/tickets'
    * call read('this:Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    And request body
    When method POST
    Then status 201
    # we using mock service so data in here is not correct
    # * match response.data.description == descriptionTicket
    # * match response.data.subject == "#(subject)"
    * match response.data.description == 'Create request response from wiremock' 
    * match response.data.subject == 'PT Helpcenter'

   @ignore @Search_Filter_ticket_common
   Scenario: Filter - Search ticket common
     Given path 'crm/tickets'
     And params query
     When method GET
     Then status 200
     And match response.status == "success"
