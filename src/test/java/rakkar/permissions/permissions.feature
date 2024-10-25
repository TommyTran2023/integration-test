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

        if (requirePasscode)
            headers["passcode"] = passcode

        if (requireAnswer){
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
        * def newPath = replacePathParams(path, pathParams)
        * def headers = convertHeaders(userAccessToken, requirePasscode, user.passcode, requireAnswer, user.userName)
        * def queries = convertJsonParams(queryParams)
        * def requestBody = convertJsonParams(requestBody)
        Given url baseURL
        * path newPath
        * headers headers
        * params queries
        * request requestBody
        When method method
        # * assert successStatus()
        Then match responseStatus == expectedStatus


    


