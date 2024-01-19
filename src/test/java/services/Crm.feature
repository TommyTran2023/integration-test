Feature: CRM
# /crm

    @SearchTickets
    Scenario: Get ticket list
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            params:{
                category : #(category), //array
                platform : #(platform), //array
                requestType : #(requestType), //string
                productType : #(productType), //string
                keyword : #(keyword), //string
                status : #(status), //string
                page : #(page), //number
                pageSize : #(pageSize), //number
                sort : #(sort), //string
                dateFrom : #(dateFrom), //string
                dateTo : #(dateTo), //string
            }
        }
        """
        * call read(svc + 'crmSvc.feature@SearchTickets') data
    
    @CreateTicket
    Scenario: Submit ticket
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            params:{
                category : #(category), //string
                platforms : #(platforms), //array
                requestType : #(requestType), //string
                productType : #(productType), //array
                subject : #(subject), //string
                description : #(description), //string
                attachmentTokens : #(attachmentTokens), //array
                emailCcs : #(emailCcs), //array
                followupTicketId : #(followupTicketId) //number
            }
        }
        """
        * call read(svc + 'crmSvc.feature@CreateTicket') data
    
    @GetTicketFields
    Scenario: Get ticket fields
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * call read(svc + 'crmSvc.feature@GetTicketFields') {authorization:#(accessToken)}
    
    @GetTicketbyId
    Scenario: Get a ticket by Id
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            ticketId: #(ticketId), //number
        }
        """
        * call read(svc + 'crmSvc.feature@GetTicketbyId') data
    
    @GetTicketComments
    Scenario: Submit ticket
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            ticketId: #(ticketId), //number
            params:{
                page : 0, //number
                pageSize : 50, //number
                order : 'ASC' //string
            }
        }
        """
        * call read(svc + 'crmSvc.feature@GetTicketComments') data
        
