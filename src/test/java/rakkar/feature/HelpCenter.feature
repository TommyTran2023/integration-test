@ignore @RAKCON-10583
Feature:Help Center

  Background:
    * url baseURL
    * karate.callSingle('UploadFile.feature@UPLOAD_IMAGE_ON_CRM')
    * call read('RequesterAuthenticator.feature@RequesterAccessToken')
    * def getRequesterIDResponse = karate.callSingle('GetRequesterInfo.feature')
    * def requesterUserEmail = getRequesterIDResponse.response.data.email
    * def schemaJson = read('classpath:data/schema.json')
    * def now = function(){ return java.lang.System.currentTimeMillis() }
    * def dataBody = read('classpath:data/data_test.json')

  @RAKCON-11377 @CREATE_TICKET_ISSUE
  Scenario: Create a ticket detail page - Issue
    * def descriptionTicket = 'description for create issue' + now()
    * def subject = 'subject for create issue' + now()
    * def body =  {"description":"#(descriptionTicket)","attachmentToken":["#(token)"],"subject":"#(subject)","category":"issue","emailCcs":["#(requesterUserEmail)"],"platforms":["#(dataBody.help_center.platform)"]}
    * call read('HelpCenter.feature@Create_ticket_common')
    * match response.data.category == "#(dataBody.help_center.type_issue)"
    * match response.data.platforms[0] == "#(dataBody.help_center.platform)"

  @RAKCON-11378 @CREATE_TICKET_QUESTION
  Scenario: Create a ticket detail page - Question
    * def descriptionTicket = 'description for create question' + now()
    * def subject = 'subject for create question' + now()
    * def body = {"description":"#(descriptionTicket)","attachmentToken":["#(token)"],"subject":"#(subject)","category":"question","emailCcs":["#(requesterUserEmail)"]}
    * call read('HelpCenter.feature@Create_ticket_common')
    * match response.data.category == "#(dataBody.help_center.type_question)"

  @RAKCON-11379 @CREATE_TICKET_REQUEST
  Scenario: Create a ticket detail page - Request
    * def descriptionTicket = 'description for create request' + now()
    * def subject = 'subject for create request' + now()
    * def body = {"description":"#(descriptionTicket)","attachmentToken":["#(token)"],"subject":"#(subject)","category":"request","emailCcs":["#(requesterUserEmail)"], "requestType" : "mark_lost_device"}
    * call read('HelpCenter.feature@Create_ticket_common')
    * match response.data.category == "#(dataBody.help_center.type_request)"
    * match response.data.requestType == "mark_lost_device"

  @RAKCON-11380 @VIEW_LISTING_TICKET_IN_PROGRESS
  Scenario: View listing ticket on tab In progress
    * def query = {limit: '20', page: '1', status: 'in_progress'}
    * call read('HelpCenter.feature@Search_Filter_ticket_common')

  @RAKCON-11381 @VIEW_LISTING_TICKET_SOLVED
  Scenario: View listing ticket on tab Solved
    * def query = {page: '1', status: 'solved'}
    * call read('HelpCenter.feature@Search_Filter_ticket_common')

  @RAKCON-11386 @FILTER_TICKET_BY_CATEGORY
  Scenario: Filter ticket by Category
  * def query = { limit:'20', page: '1', status: 'in_progress', category:'issue'}
  * call read('HelpCenter.feature@Search_Filter_ticket_common')

   @RAKCON-11385 @FILTER_TICKET_BY_DATE
   Scenario: Filter ticket by Date
     * def query = { limit:'20', page: '1', status: 'in_progress', dateTo:'2023-04-26',dateFrom:'2023-04-19'}
     * call read('HelpCenter.feature@Search_Filter_ticket_common')

  @RAKCON-11382 @SEARCH_TICKET_IN_PROGRESS
   Scenario: Search ticket on tab In progress
    * call read('HelpCenter.feature@CREATE_TICKET_ISSUE')
    * def keyword = response.data.subject
    * def query = { limit:'20', page: '1', status: 'in_progress', keyword:'#(keyword)'}
    * call read('HelpCenter.feature@Search_Filter_ticket_common')
    * match each $response.data.tickets[*].subject contains "#(keyword)"

  @RAKCON-11383 @SEARCH_TICKET_SOLVED
  Scenario: Search ticket on tab Solved
    * def keyword = dataBody.help_center.search_solved
    * def query = { limit:'20', page: '1', status: 'solved', keyword:'#(dataBody.help_center.search_solved)'}
    * call read('HelpCenter.feature@Search_Filter_ticket_common')
    * match each $response.data.tickets[*].subject contains keyword

  @ignore @Create_ticket_common
    Scenario: Create ticket common
      Given path '/crm/tickets'
      * call read('Common.feature@FIDO-Requester')
      * header challenge-answer = challengeAnswerRequest
      And request body
      When method POST
      Then status 201
      * match response.data.description == descriptionTicket
      * match response.data.subject == "#(subject)"

     @ignore @Search_Filter_ticket_common
     Scenario: Filter - Search ticket common
       Given path 'crm/tickets'
       And params query
       When method GET
       Then status 200
       And match response.status == "success"
#       * def schema = schemaJson.helpCenter.tickets
#       * def listTickets = ["##(schema)"]
#       And match response.data.tickets contains listTickets


