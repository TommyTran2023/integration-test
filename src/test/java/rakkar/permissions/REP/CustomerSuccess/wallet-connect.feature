Feature: Validate wallet connect permission
Background:
    * callonce read('classpath:rakkar/permissions/REP/login.feature@LoginAsCustomerSuccess')

@wallet-connect @Permissions @REPCustomerSuccess
Scenario Outline: wallet connect: <method> <path>
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
        expectedSchema: <expectedREPSchema_CustomerSuccess>,
        expectedStatus: <expectedREPStatus_CustomerSuccess>
    }
    """
    * call read('classpath:rakkar/permissions/permissions.feature@test') testData
    Examples:
        |  read('classpath:rakkar/permissions/apis_data/apis_wallet-connect.csv')  |


