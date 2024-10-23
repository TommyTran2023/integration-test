Feature: Validate core permission
Background:
    * callonce read('classpath:rakkar/permissions/REP/login.feature@LoginAsSecurity')

@Permissions @REPSecurity
Scenario Outline: core: <method> <path>
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
        expectedSchema: <expectedREPSchema_Security>,
        expectedStatus: <expectedREPStatus_Security>
    }
    """
    * call read('classpath:rakkar/feature/permissions/permissions.feature@test') testData
    Examples:
        |  read('classpath:rakkar/feature/permissions/apis_data/apis_core.csv')  |


