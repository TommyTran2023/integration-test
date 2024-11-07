Feature: Validate auth permission
Background:
    * callonce read('classpath:rakkar/permissions/REP/login.feature@LoginAsFinance')

@auth @Permissions @REPFinance
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
        requirePasscode: "FALSE", 
        requireAnswer: "FALSE", 
        expectedSchema: <expectedREPSchema_Finance>,
        expectedStatus: <expectedREPStatus_Finance>
    }
    """
    * call read('classpath:rakkar/permissions/permissions.feature@test') testData
    Examples:
        |  read('classpath:rakkar/permissions/apis_data/apis_auth.csv')  |


