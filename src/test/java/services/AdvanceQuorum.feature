@ignore
Feature: Advance-quorum
    * def svc = 'classpath:services/'

@ApproveRequest
Scenario: Approve request
    * def data = 
    """
    {
        "requestId": "#(requestId)",
        "authorization": "#(approvalAccessToken)",
        "challengeAnswer": "#(challengeAnswerApprover)",
        "passcode": "#(approverInfo.approverPasscode)"
    }
    """
    * call read(svc + 'advQuorumSvc.feature@ApproveRequest') { data: '#(data)'}
