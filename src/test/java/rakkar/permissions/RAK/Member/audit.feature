Feature: Validate audit permission
Background:
    * callonce read('classpath:rakkar/permissions/RAK/login.feature@LoginAsMember')

@audit @Permissions @RAKMember
Scenario Outline: audit: <method> <path>
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
        expectedSchema: <expectedRAKSchema_Member>,
        expectedStatus: <expectedRAKStatus_Member>
    }
    """
    * call read('classpath:rakkar/permissions/permissions.feature@test') testData
    Examples:
        |  read('classpath:rakkar/permissions/apis_data/apis_audit.csv')  |


