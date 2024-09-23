Feature: Validate core permission

@permissions
Scenario Outline: Verify Core API permission: <method> <path>
    * def testData = 
    """
    {
        method: <method>, 
        path: <path>, 
        pathParams: '<pathParams>', 
        queryParams: '<queryParams>', 
        requestBody: '<requestBody>', 
        requirePasscode: <requirePasscode>, 
        requireAnswer: <requireAnswer>, 
        expectedStatus: <expectedStatus>
    }
    """
    * call read('this:permissions.feature@test') testData
    Examples:
        |  read('classpath:rakkar/feature/permissions/apis_data/apis_advance-quorum.csv')  |


