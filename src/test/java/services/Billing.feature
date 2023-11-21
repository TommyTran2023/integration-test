Feature: Customer Billings

    @GetBillings
    Scenario: Get Billings
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
    
    @GetCustomerBillingDetail
    Scenario: Get Billings
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            isHistory: true
        }
        """
        * call read(svc + 'coreSvc.feature@GetCustomerBillingDetail') data
    
    @GetPathInvoicePdf
    Scenario: Get Path Invoice Pdf
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            isHistory: true
        }
        """
        * call read(svc + 'coreSvc.feature@GetPathInvoicePdf') data
        
    @ExportBillingDetail
    Scenario: Export billing detail, returned as a CSV file
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body:{
                period : #(period), //string
                billingId : #(billingId), //string
                isHistory : true //boolean
            }
        }
        """
        * call read(svc + 'coreSvc.feature@ExportBillingDetail') data
        
    @ExportInvoicesAsPDF
    Scenario: Export Invoices As PDF
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body:{
                billingIds : #(billingIds), //array
            }
        }
        """
        * call read(svc + 'coreSvc.feature@ExportInvoicesAsPDF') data
        
    @MarkAsReviewedInvoice
    Scenario: Mark as reviewed invoice
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body:{
                billingIds : #(billingIds), //array
            }
        }
        """
        * call read(svc + 'coreSvc.feature@MarkAsReviewedInvoice') data
            
    @MarkAsPaidInvoice
    Scenario: Mark as paid invoice
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body:{
                billingIds : #(billingIds), //array
            }
        }
        """
        * call read(svc + 'coreSvc.feature@MarkAsPaidInvoice') data
         
