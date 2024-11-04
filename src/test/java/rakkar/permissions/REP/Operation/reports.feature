Feature: Validate report permission
Background:
    * callonce read('classpath:rakkar/permissions/REP/login.feature@LoginAsOperation')

@reports @Permissions @REPOperation
Scenario Outline: report: <method> <path>
    * def testData = 
    """
    {
        userAccessToken: '#(repAccessToken)',
        user: #(user),
        method: <method>, 
        path: <path>, 
        pathParams: '<pathParams>', 
        queryParams: '<queryParams>', 
        requestBody: '<requestBody>', 
        requirePasscode: <requirePasscode>, 
        requireAnswer: <requireAnswer>, 
        expectedSchema: <expectedREPSchema_CustomerSuccess>,
        expectedStatus: <expectedREPStatus_CustomerSuccess>
    }
    """
    * call read('classpath:rakkar/permissions/permissions.feature@test') testData
    Examples:
        |  read('classpath:rakkar/permissions/apis_data/apis_reports.csv')  |


