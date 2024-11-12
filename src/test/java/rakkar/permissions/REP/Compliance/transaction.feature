Feature: Validate transaction permission
Background:
    * callonce read('classpath:rakkar/permissions/REP/login.feature@LoginAsCompliance')

@transaction @Permissions @REPCompliance
Scenario Outline: transaction: <method> <path>
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
        expectedSchema: <expectedREPSchema_Compliance>,
        expectedStatus: <expectedREPStatus_Compliance>
    }
    """
    * call read('classpath:rakkar/permissions/permissions.feature@test') testData
    Examples:
        |  read('classpath:rakkar/permissions/apis_data/apis_transaction.csv')  |


