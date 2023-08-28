@RAKCON-10583
Feature: Reports

    Background:
    * url baseURL
    * call read('this:RequesterAuthenticator.feature@RequesterAccessToken')
    * call read('this:Common.feature@FIDO-Requester')
    * def Collections = Java.type('java.util.Collections')

    @ignore @RequestReport
    Scenario: Request Report From Web
        Given path 'reports/reports'
        * request requestReport
        When method POST
        Then status 201
        * match response.status == "success"
        * match response.code == 200

    @ignore @FilterReports
    Scenario: Request Report From Web
        Given path 'reports/reports'
        * params params
        When method GET
        Then status 200
        * match response.status == "success"
        * match response.code == 200

    @RAKCON-19416 @RequestAssetReportGroupByAsset
    Scenario: Request Asset Report Group By Asset
        * def requestReport = 
        """
            {
                "reportType":"POA",
                "additionalData":{
                    "POA":{
                        "message":"I, hereby confirm that, Rakkar Digital are providing the Proof of Assets to our organization. Rakkar Digital will provide the signature hash on post-signing for the verification.",
                        "groupBy":"ASSET"
                    }
                }
            }
        """
        * def createdReport = call read('this:Reports.feature@RequestReport')
        * def res = karate.match("createdReport.response.data == {id:'#uuid', name: 'Proof of Assets', status:'PENDING',fileFormat:'PDF',requestedDate:'#string'}")
        * match res == { pass: true, message: null }
    
    @RAKCON-19417 @RequestAssetReportGroupByVaultName
    Scenario: Request Asset Report Group By Asset
        * def requestReport = 
        """
            {
                "reportType":"POA",
                "additionalData":{
                    "POA":{
                        "message":"I, hereby confirm that, Rakkar Digital are providing the Proof of Assets to our organization. Rakkar Digital will provide the signature hash on post-signing for the verification.",
                        "groupBy":"VAULT_NAME"
                    }
                }
            }
        """
        * call read('this:Reports.feature@RequestReport')

    @RAKCON-19418 @SearchAndSortReportsByRequestedDateAscending
    Scenario: Search and Sort Reports by Requested Date Ascending
        * def params = 
        """
            {
                offset: 0,
                limit: 10,
                keyword: "",
                sort: "ASC",
                sortBy: "REQUESTED_DATE",
            }
        """
        * def filterReports = call read('this:Reports.feature@FilterReports')
        * assert filterReports.response.data.reports.length > 0
        * assert filterReports.response.data.totalCount > 0
        * def toUpper =
        """
        function(x){
        return x.toUpperCase();
        }
        """
        * def filterReports = filterReports.response.data.reports
        * def filterReportsDate = $filterReports[*].requestedDate
        * def actualList = filterReportsDate
        * eval Collections.sort(filterReportsDate.map(toUpper), Collections.reverseOrder())
        * def expected = filterReportsDate.map(toUpper)
        * def actual = actualList.map(toUpper)
        * match actual.toString() == expected.toString()




