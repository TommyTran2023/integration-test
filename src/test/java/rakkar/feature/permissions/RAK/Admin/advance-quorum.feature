Feature: Validate core permission
Background:
    * callonce read('this:login.feature@Login')

@Permissions @RAKAdmin
Scenario Outline: advance-quorum: <method> <path>
    * def testData = 
    """
    {
        user: #(user),
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
    * call read('classpath:rakkar/feature/permissions/permissions.feature@test') testData
    Examples:
        |  read('classpath:rakkar/feature/permissions/apis_data/apis_advance-quorum.csv')  |


