Feature: Validate auth permission
Background:
    * callonce read('classpath:rakkar/permissions/RAK/login.feature@LoginAsViewer')

@Permissions @RAKViewer
Scenario Outline: auth: <method> <path>
    * def testData = 
    """
    {
        userAccessToken: '#(userAccessToken)',
        user: #(user),
        method: <method>, 
        path: <path>, 
        pathParams: '<pathParams>', 
        queryParams: '<queryParams>', 
        requestBody: '<requestBody>', 
        requirePasscode: <requirePasscode>, 
        requireAnswer: <requireAnswer>, 
        expectedSchema: <expectedRAKSchema_Viewer>,
        expectedStatus: <expectedRAKStatus_Viewer>
    }
    """
    * call read('classpath:rakkar/permissions/permissions.feature@test') testData
    Examples:
        |  read('classpath:rakkar/permissions/apis_data/apis_auth.csv')  |


