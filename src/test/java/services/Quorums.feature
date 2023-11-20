@ignore
Feature: Advance-quorum

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

    @CancelRequest
    Scenario: Cancel request
        * def data = 
        """
        {
            "requestId": "#(requestId)",
            "authorization": "#(requesterAccessToken)",
            "challengeAnswer": "#(challengeAnswerRequest)",
        }
        """
        * call read(svc + 'advQuorumSvc.feature@CancelRequest') data
        Then match responseStatus == 200
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

    @GetMyRequests
    Scenario: Get My Request List
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def status = karate.get('status',[])
        * def data = 
        """
        { 
            authorization: "#(accessToken)",
            body:{
                "status" : #(status),
                "createdBy" : "#(userId)",
                "limit" : 10,
                "isHistory" : true,
                "offset" : 10,
                "keyword" : ""
            }
        }
        """
        * call read(svc + 'advQuorumSvc.feature@GetApprovalList') data
        Then match responseStatus == 201
        * match response.status == 'success'

    @GetQuorumPolicy
    Scenario: Get Quorum Policy
        * def data = 
        """
        {
            "authorization": "#(requesterAccessToken)",
            "quorumId": "#(quorumId)"
        }
        """
        * call read(svc + 'advQuorumSvc.feature@GetQuorumPolicy') data
        Then match responseStatus == 200
        * match response.status == 'success'

    @GetAccountPolicy
    Scenario: Get Account Policy
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * call read(svc + 'advQuorumSvc.feature@GetAccountPolicy') {authorization:#(accessToken)}
        Then match responseStatus == 200
        * match response.status == 'success'

    @RejectRequest
    Scenario: Reject request
        * print approvalAccessToken
        * print challengeAnswerApprover
        * def data = 
        """
        {
            requestId: "#(requestId)",
            authorization: "#(approvalAccessToken)",
            challengeAnswer: "#(challengeAnswerApprover)",
            reason: "AT reject reason"
        }
        """
        * print data
        * call read(svc + 'advQuorumSvc.feature@RejectRequest') data

    @ViewAccountPolicyRequest
    Scenario: View account policy request
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * call read(svc + 'advQuorumSvc.feature@ViewAccountPolicyRequest') {authorization:#(accessToken)}
        Then match responseStatus == 200
        * match response.status == 'success'
    
