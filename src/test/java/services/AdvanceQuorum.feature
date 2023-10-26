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
        * call read(svc + 'advQuorumSvc.feature@ApproveRequest') data
        Then match responseStatus == 201
        * match response.status == 'success'

    @Approver_GetApprovalList
    Scenario: Get Approval List
        * def status = karate.get('status',[])
        * def data = 
        """
        { 
            "authorization": "#(approvalAccessToken)",
            body:{
                limit: 10, 
                offset: 0, 
                status: #(status) 
            }
        }
        """
        * call read(svc + 'advQuorumSvc.feature@GetApprovalList') data
        Then match responseStatus == 201
        * match response.status == 'success'
    
