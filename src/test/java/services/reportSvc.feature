Feature: Reports Service
# A service for generating reports of user

    @GetListReports
    Scenario: Get list reports of user
        Given path 'report/reports'
        * header authorization = authorization
        * params params
        When method GET

    @GenerateReport
    Scenario: Generate report of user
        Given path 'report/reports'
        * header authorization = authorization
        * request body
        When method POST

    @DeleteReports
    Scenario: Delete Reports
        Given path 'report/reports'
        * header authorization = authorization
        * request body
        When method DELETE

    @ExportReportsAsZipFile
    Scenario: Download reports file or Zip file
        Given path 'report/reports/download'
        * header authorization = authorization
        * request body
        When method POST

    @ValidateReport
    Scenario: Validate report
        Given path 'report/reports/validate-report'
        * header authorization = authorization
        When method GET
   

