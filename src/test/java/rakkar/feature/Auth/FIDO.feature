Feature: Access Control Validation
Background:
    * def value = call read('classpath:rakkar/feature/Transfer.feature@Transfer_medium_value')

@RAKSEC-283 @Auth
Scenario Outline: <No>. Verify user access "<ExpectedErrorCode>" based on Authorization "<Authorization>", Passcode "<Passcode>" and Answer "<Answer>"
    * eval if (ExpectedStatus == 500) karate.abort()
    * eval
    """
        var auth = Authorization == 'random' ? 'Bearer ' + new Date().getTime() : null
        var pass = Passcode == 'random' ? new Date().getTime() : null
        var ans = Answer == 'random' ? new Date().getTime() : null

        if (Authorization == 'valid') {
            var bio = karate.call(svc + 'Auth.feature@GetApproverAccessToken')
            auth = bio.approvalAccessToken
        } 

        if (Answer == 'valid') {
            var bio = karate.call(svc + 'Biometric.feature@ApproverDoBiometric')
            ans = bio.challengeAnswerApprover
        }

        if (Passcode == 'valid') {
            pass = approverPasscode
        }

        if (Authorization == 'requester') {
            var bio = karate.call(svc + 'Auth.feature@GetRequesterAccessToken')
            auth = bio.requesterAccessToken
        } 

        if (Answer == 'requester') {
            var bio = karate.call(svc + 'Biometric.feature@RequesterDoBiometric')
            ans = bio.challengeAnswerRequest
        }

        if (Passcode == 'requester') {
            pass = requesterPasscode
        }

        
    """ 
    * call read(svc + 'Biometric.feature@ApproverDoBiometric')
    * def body =
    """
    {
        approvalAccessToken: "#(auth)",
        challengeAnswerApprover: "#(ans)",
        approverPasscode: "#(pass)",
        requestId: "#(value.response.data.requestId)"
    }
    """
    * print body
    * call read(svc + 'Quorums.feature@ApproveRequestNoValidate') body
    * eval
    """
    if (ExpectedStatus != 201) {
        if (responseStatus == ExpectedStatus && response.status == "error" && response.errorCode == ExpectedErrorCode && response.message == ExpectedErrorMsg) {
            karate.log('Success')
        }
        else {
            var actual = `Actual status: ${responseStatus} - ${response.status}, error code: ${response.errorCode}, message: ${response.message}`
            var expected = `Response status should be "${ExpectedStatus}" and error code should be "${ExpectedErrorCode}" and message should be "${ExpectedErrorMsg}"`
            karate.fail(actual + '\n' + expected)
        }
    } else {
        if (responseStatus == 201 && response.status == "success") {
            karate.log('Success')
        }
        else
            karate.fail('Status should be success')
    }
    """

    Examples:
        | No | Authorization | Passcode  | Answer    | ExpectedStatus | ExpectedErrorCode      | ExpectedErrorMsg      |
        | 1  | valid         | valid     | valid     | 201            |                        |                       |
        | 2  | valid         | valid     | random    | 500            |                        |                       |
        | 3  | valid         | valid     | null      | 403            | UNAUTHORIZED           | Forbidden resource    |
        | 4  | valid         | random    | valid     | 403            | UNAUTHORIZED           | Forbidden resource    |
        | 5  | valid         | random    | random    | 500            |                        |                       |
        | 6  | valid         | random    | null      | 403            | UNAUTHORIZED           | Forbidden resource    |
        | 7  | valid         | null      | valid     | 403            | UNAUTHORIZED           | Forbidden resource    |
        | 8  | valid         | null      | random    | 500            |                        |                       |
        | 9  | valid         | null      | null      | 403            | UNAUTHORIZED           | Forbidden resource    |
        | 10 | random        | valid     | valid     | 401            | UNAUTHORIZED           | Unauthorized          |
        | 11 | random        | valid     | random    | 401            | UNAUTHORIZED           | Unauthorized          |
        | 12 | random        | valid     | null      | 401            | UNAUTHORIZED           | Unauthorized          |
        | 13 | random        | random    | valid     | 401            | UNAUTHORIZED           | Unauthorized          |
        | 14 | random        | random    | random    | 401            | UNAUTHORIZED           | Unauthorized          |
        | 15 | random        | random    | null      | 401            | UNAUTHORIZED           | Unauthorized          |
        | 16 | random        | null      | valid     | 401            | UNAUTHORIZED           | Unauthorized          |
        | 17 | random        | null      | random    | 401            | UNAUTHORIZED           | Unauthorized          |
        | 18 | random        | null      | null      | 401            | UNAUTHORIZED           | Unauthorized          |
        | 19 | null          | valid     | valid     | 401            | UNAUTHORIZED           | Unauthorized          |
        | 20 | null          | valid     | random    | 401            | UNAUTHORIZED           | Unauthorized          |
        | 21 | null          | valid     | null      | 401            | UNAUTHORIZED           | Unauthorized          |
        | 22 | null          | random    | valid     | 401            | UNAUTHORIZED           | Unauthorized          |
        | 23 | null          | random    | random    | 401            | UNAUTHORIZED           | Unauthorized          |
        | 24 | null          | random    | null      | 401            | UNAUTHORIZED           | Unauthorized          |
        | 25 | null          | null      | valid     | 401            | UNAUTHORIZED           | Unauthorized          |
        | 26 | null          | null      | random    | 401            | UNAUTHORIZED           | Unauthorized          |
        | 27 | null          | null      | null      | 401            | UNAUTHORIZED           | Unauthorized          |
        | 28 | requester     | valid     | valid     | 403            | UNAUTHORIZED           | Forbidden resource    |
        | 29 | valid         | requester | valid     | 403            | UNAUTHORIZED           | Forbidden resource    |
    #   | 30 | valid         | valid     | requester | 403            | UNAUTHORIZED           | Forbidden resource    | invalid. cause in IT requester, approver using same public key
        | 31 | requester     | requester | requester | 400            | UNABLE_APPROVE_RECORD  | UNABLE_APPROVE_RECORD |
