Feature: Validate core permission
Background:
    * callonce read('classpath:rakkar/permissions/REP/login.feature@LoginAsProductReviewTransaction')

@Permissions @REPProductReviewTransaction
Scenario Outline: core: <method> <path>
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
        expectedSchema: <expectedREPSchema_ProductReviewTransaction>,
        expectedStatus: <expectedREPStatus_ProductReviewTransaction>
    }
    """
    * call read('classpath:rakkar/permissions/permissions.feature@test') testData
    Examples:
        |  read('classpath:rakkar/permissions/apis_data/apis_core.csv')  |


