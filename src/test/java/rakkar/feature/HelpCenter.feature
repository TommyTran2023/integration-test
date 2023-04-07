@RAKCON-11376
Feature:Help Center

  Background:
    * url baseURL
    * karate.callSingle('UploadFile.feature@UPLOAD_IMAGE_ON_CRM')
    * call read('RequesterAuthenticator.feature@RequesterAccessToken')
    * def getRequesterIDResponse = karate.callSingle('GetRequesterID.feature')
    * def requesterUserEmail = getRequesterIDResponse.response.data.email
    * def dataBody = read('classpath:data/data_test.json')

  @RAKCON-11377 @CREATE_TICKET_ISSUE
  Scenario: Create a ticket detail page - Issue
    * def now = function(){ return java.lang.System.currentTimeMillis() }
    * def descriptionTicket = 'ticket' + now()
    Given path '/crm/tickets'
    * request {"description":"#(descriptionTicket)","attachmentToken":["#(token)"],"subject":"#(descriptionTicket)","category":"issue","emailCcs":["#(requesterUserEmail)"],"platforms":["mobile_application"]}
    * call read('Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    When method POST
    Then status 201
    * match response.data.subject == descriptionTicket
    * match response.data.description == descriptionTicket
    And match response.status == "success"
    * def schema = dataBody.helpCenter.schema_list
    And match response.data contains schema




