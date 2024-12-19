Feature: Validate network permission
Background:
    * callonce read('classpath:rakkar/permissions/REP/login.feature@LoginAsOperation')

@network @Permissions @REPOperation
Scenario Outline: network: <method> <path>
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
        expectedSchema: <expectedREPSchema_Operation>,
        expectedStatus: <expectedREPStatus_Operation>
    }
    """
    * call read('classpath:rakkar/permissions/permissions.feature@test') testData
    Examples:
        |  read('classpath:rakkar/permissions/apis_data/apis_network.csv')  |


