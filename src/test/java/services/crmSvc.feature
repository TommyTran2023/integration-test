Feature: CRM

    @SearchTickets
    Scenario: Get ticket list
        Given path 'crm/tickets'
        * header authorization = authorization
        And params params
        When method GET

    @CreateTicket
    Scenario: Submit ticket
        Given path 'crm/tickets'
        * header authorization = authorization
        And request body
        When method POST

    @GetTicketFields
    Scenario: Get ticket fields
        Given path 'crm/tickets/fields'
        * header authorization = authorization
        When method GET

    @GetTicketbyId
    Scenario: Get a ticket by Id
        Given path 'crm/tickets/' + ticketId
        * header authorization = authorization
        When method GET

    @GetTicketComments
    Scenario: Get a ticket by Id
        Given path 'crm/tickets/' + ticketId + '/comments'
        * header authorization = authorization
        * params params
        When method GET


