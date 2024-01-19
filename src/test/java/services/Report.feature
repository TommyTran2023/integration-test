Feature: Reports Service
# A service for generating reports of user
# /crm

    @GetListReports
    Scenario: Get list reports of user
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            params:{
                limit : 10, //number
                offset : 0, //number
                sort : 'ASC' //string
                keyword : '' //string
                sortBy : '' //string
            }
        }
        """
        * call read(svc + 'reportSvc.feature@GetListReports') data
    
    @GenerateReport
    Scenario: Get list reports of user
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body:{
                reportType : #(reportType), //string
                additionalData : #(additionalData), //null
            }
        }
        """
        * call read(svc + 'reportSvc.feature@GetListReports') data
    
    @DeleteReports
    Scenario: Delete Reports
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body:{
                reportIds : #(reportIds), //array
            }
        }
        """
        * call read(svc + 'reportSvc.feature@DeleteReports') data

    @ExportReportsAsZipFile
    Scenario: Download reports file or Zip file
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body:{
                reportIds : #(reportIds), //array
            }
        }
        """
        * call read(svc + 'reportSvc.feature@ExportReportsAsZipFile') data
    
    @ValidateReport
    Scenario: Validate report
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken)
        }
        """
        * call read(svc + 'reportSvc.feature@ValidateReport') data
    



