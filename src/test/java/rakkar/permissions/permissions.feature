@ignore
Feature: Permission mapping

Background: Read data
    * def replacePathParams = 
    """
    function (path, params) {
        if (params != ''){
            const obj = JSON.parse(params);
            return path.replace(/\{([^}]+)\}/g, (_, paramName) => obj[paramName]);
        }
        return path
    }
    """
    * def replaceTestData = 
    """
    function (value, user1, user2) {
        var now = java.lang.System.currentTimeMillis();
        value = value
                    .replace(/\{TIMESTAMP}/g, now)
                    .replace(/\{user1}/g, user1)
                    .replace(/\{user2}/g, user2)

        return value
    }
    """

    * def convertJsonParams = 
    """
    function (params){
        return (params == "{}" || params == "") ? "" : JSON.parse(params)
    }
    """
    * def convertHeaders = 
    """
    function (userAccessToken, requirePasscode, passcode, requireAnswer, userName){
        var headers = {
            Authorization: userAccessToken
        }

        if (requirePasscode == "TRUE")
            headers["passcode"] = passcode

        if (requireAnswer == "TRUE"){
            var answer = karate.call(svc + 'Biometric.feature@UserDoBiometric', { userName: userName }).userAnswerApprover
            headers["challenge-answer"] = answer
        }

        return headers
    }
    """
    * def successStatus = 
    """
    function (){
        var status = karate.get('responseStatus'); 
        return status != 403
    }
    """

    @test
    Scenario: Verify API permission
        * def data =
        """
        {
            authorization: '#(requesterAccessToken)',
            body: {"isGetAll":true}
        }
        """
        * callonce read(svc + 'authSvc.feature@GetListUsers') data
        * def user1 = response.data ? (response.data.users && response.data.users.length > 0 ? response.data.users[0].userId : '') : ''
        * def user2 = response.data ? (response.data.users && response.data.users.length > 1 ? response.data.users[1].userId : '') : ''
        * def newPath = replacePathParams(path, pathParams)
        * def headers = convertHeaders(userAccessToken, requirePasscode, user.passcode, requireAnswer, user.userName)
        * def queries = convertJsonParams(queryParams)
        * def requestBody = convertJsonParams(replaceTestData(requestBody,user1,user2))
        Given url baseURL
        * path newPath
        * headers headers
        * params queries
        * request requestBody
        When method method

        # expectedStatus
        # "not <statusCode>" will match that actual is not <statusCode>
        * def isNegation = (expectedStatus+'').startsWith('not')
        * def expectedStatus = isNegation ? expectedStatus.replaceFirst('^not\\s+', '') : expectedStatus
        Then match (responseStatus==expectedStatus) == !isNegation
        * if (expectedSchema) karate.match(response.data, expectedSchema)
