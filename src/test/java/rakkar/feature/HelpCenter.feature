@RAKCON-11376
Feature:Help Center

  Background:
    * url baseURL
    * karate.callSingle('UploadFile.feature@UPLOAD_IMAGE_ON_CRM')
    * call read('RequesterAuthenticator.feature@RequesterAccessToken')
    * def getRequesterIDResponse = karate.callSingle('GetRequesterID.feature')
    * def requesterUserEmail = getRequesterIDResponse.response.data.email
    * def schemaJson = read('classpath:data/schema.json')
    * def now = function(){ return java.lang.System.currentTimeMillis() }

  @RAKCON-11377 @CREATE_TICKET_ISSUE
  Scenario: Create a ticket detail page - Issue
    * def descriptionTicket = 'ticket issue' + now()
    Given path '/crm/tickets'
    * request {"description":"#(descriptionTicket)","attachmentToken":["#(token)"],"subject":"#(descriptionTicket)","category":"issue","emailCcs":["#(requesterUserEmail)"],"platforms":["mobile_application"]}
    * call read('Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    When method POST
    Then status 201
    * match response.data.subject == descriptionTicket
    * match response.data.description == descriptionTicket
    And match response.status == "success"
    * def schema = schemaJson.helpCenter.schema_list
    And match response.data contains schema

  @RAKCON-11378 @CREATE_TICKET_QUESTION
  Scenario: Create a ticket detail page - Question
    * def descriptionTicket = 'ticket question' + now()
    Given path '/crm/tickets'
    * request {"description":"#(descriptionTicket)","attachmentToken":["#(token)"],"subject":"#(descriptionTicket)","category":"question","emailCcs":["#(requesterUserEmail)"]}
    * call read('Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    When method POST
    Then status 201
    * match response.data.subject == descriptionTicket
    * match response.data.description == descriptionTicket
    And match response.status == "success"
    * def schema = schemaJson.helpCenter.schema_list
    And match response.data contains schema

  @RAKCON-11379 @CREATE_TICKET_REQUEST
  Scenario: Create a ticket detail page - Request
    * def descriptionTicket = 'ticket request' + now()
    Given path '/crm/tickets'
    * request {"description":"#(descriptionTicket)","attachmentToken":["#(token)"],"subject":"#(descriptionTicket)","category":"request","emailCcs":["#(requesterUserEmail)"], "requestType" : "mark_lost_device"}
    * call read('Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    When method POST
    Then status 201
    * match response.data.subject == descriptionTicket
    * match response.data.description == descriptionTicket
    And match response.status == "success"
    * def schema = schemaJson.helpCenter.schema_list
    And match response.data contains schema




