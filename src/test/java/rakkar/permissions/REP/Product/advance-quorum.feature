Feature: Validate advance-quorum permission
Background:
    * callonce read('classpath:rakkar/permissions/REP/login.feature@LoginAsProduct')

@advance-quorum @Permissions @REPProduct
Scenario Outline: advance-quorum: <method> <path>
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
    * call read('classpath:rakkar/permissions/permissions.feature@test') testData
    Examples:
        |  read('classpath:rakkar/permissions/apis_data/apis_advance-quorum.csv')  |


