Feature: Validate crm permission
Background:
    * callonce read('classpath:rakkar/permissions/REP/login.feature@LoginAsProduct')

@crm @Permissions @REPProduct
Scenario Outline: crm: <method> <path>
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
        expectedSchema: <expectedREPSchema_Product>,
        expectedStatus: <expectedREPStatus_Product>
    }
    """
    * call read('classpath:rakkar/permissions/permissions.feature@test') testData
    Examples:
        |  read('classpath:rakkar/permissions/apis_data/apis_crm.csv')  |


