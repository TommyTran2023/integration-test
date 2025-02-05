Feature: Validate notification permission
Background:
    * callonce read('classpath:rakkar/permissions/REP/login.feature@LoginAsOperation')

@notification @Permissions @REPOperation
Scenario Outline: notification: <method> <path>
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
        |  read('classpath:rakkar/permissions/apis_data/apis_notification.csv')  |


