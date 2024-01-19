Feature: Audit Service

    @GetListAuditLog
    Scenario: Get List Audit Log
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            limit : 10, //number
            offset : 0, //number
            sort : 'DESC', //string
            customerIds : #(customerIds), //string
            userIds : #(userIds), //string
            categories : #(categories), //string
            types : #(types), //string
            actions : #(actions), //string
            statuses : #(statuses), //string
            dateFrom : #(dateFrom), //string
            dateTo : #(dateTo), //string
            keyword : #(keyword), //string
            sortBy : #(sortBy), //string
            isAllRequest : #(isAllRequest), //boolean
            timeZone : #(timeZone) //number
        }
        """
        * call read(svc + 'auditSvc.feature@GetListAuditLog') data


    @GetAuditLogDetail
    Scenario: Get Audit Log Detail
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            auditLogId : #(auditLogId) //string
        }
        """
        * call read(svc + 'auditSvc.feature@GetAuditLogDetail') data
    
    @GetListCategoryData
    Scenario: Get List Category Data
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            params: {
                categories : #(categories), //string
                types : #(types), //string
                groupBy : #(groupBy) //string
            }
        }
        """
        * call read(svc + 'auditSvc.feature@GetListCategoryData') data
     
    @ExportAuditLogListing
    Scenario: Export Audit Log Listing
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            params:{
                limit : #(limit), //number
                offset : #(offset), //number
                sort : #(sort), //string
                customerIds : #(customerIds), //string
                userIds : #(userIds), //string
                categories : #(categories), //string
                types : #(types), //string
                actions : #(actions), //string
                statuses : #(statuses), //string
                dateFrom : #(dateFrom), //string
                dateTo : #(dateTo), //string
                keyword : #(keyword), //string
                sortBy : #(sortBy), //string
                isAllRequest : #(isAllRequest), //boolean
                timeZone : #(timeZone) //number
            }
        }
        """
        * call read(svc + 'auditSvc.feature@ExportAuditLogListing') data
    


