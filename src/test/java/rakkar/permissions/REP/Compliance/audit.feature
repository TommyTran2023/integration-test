Feature: Validate audit permission
Background:
    * callonce read('classpath:rakkar/permissions/REP/login.feature@LoginAsCompliance')

@Permissions @REPCompliance
Scenario Outline: audit: <method> <path>
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
        expectedSchema: <expectedREPSchema_Compliance>,
        expectedStatus: <expectedREPStatus_Compliance>
    }
    """
    * call read('classpath:rakkar/feature/permissions/permissions.feature@test') testData
    Examples:
        |  read('classpath:rakkar/feature/permissions/apis_data/apis_audit.csv')  |


