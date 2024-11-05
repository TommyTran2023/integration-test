Feature: Validate staking permission
Background:
    * callonce read('classpath:rakkar/permissions/RAK/login.feature@LoginAsAdmin')

@staking @Permissions @RAKAdmin
Scenario Outline: staking: <method> <path>
    * def testData = 
    """
    {
        userAccessToken: '#(userAccessToken)',
        user: #(user),
        method: <method>, 
        path: <path>, 
        pathParams: '<pathParams>', 
        queryParams: '<queryParams>', 
        requestBody: '<requestBody>', 
        requirePasscode: <requirePasscode>, 
        requireAnswer: <requireAnswer>, 
        expectedSchema: <expectedRAKSchema_Admin>,
        expectedStatus: <expectedRAKStatus_Admin>
    }
    """
    * call read('classpath:rakkar/permissions/permissions.feature@test') testData
    Examples:
        |  read('classpath:rakkar/permissions/apis_data/apis_staking.csv')  |


