Feature: Customer Billings

    @GetBillings
    Scenario: Get Whitelist Folders
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            params:{
                limit: 10,
                offset: 0,
                status: "PAID,UNPAID,OVERDUE"
            }
        }
        """
        * call read(svc + 'coreSvc.feature@GetBillings') data
