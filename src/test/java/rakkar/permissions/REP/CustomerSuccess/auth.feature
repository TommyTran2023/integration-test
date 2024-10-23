Feature: Validate auth permission
Background:
    * callonce read('classpath:rakkar/permissions/REP/login.feature@LoginAsCustomerSuccess')

@Permissions @REPCustomerSuccess
Scenario Outline: auth: <method> <path>
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
        |  read('classpath:rakkar/permissions/apis_data/apis_auth.csv')  |


