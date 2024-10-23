Feature: Validate notification permission
Background:
    * callonce read('classpath:rakkar/permissions/REP/login.feature@LoginAsProduct')

@Permissions @REPProduct
Scenario Outline: notification: <method> <path>
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
        expectedSchema: <expectedREPSchema_Product>,
        expectedStatus: <expectedREPStatus_Product>
    }
    """
    * call read('classpath:rakkar/feature/permissions/permissions.feature@test') testData
    Examples:
        |  read('classpath:rakkar/feature/permissions/apis_data/apis_notification.csv')  |


