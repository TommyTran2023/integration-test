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
            "passcode": "#(approverPasscode)",
            "requestBody": "#(typeof requestBody == 'undefined' ? null : requestBody)"
        }
        """
        * call read(svc + 'advQuorumSvc.feature@ApproveRequest') data
        Then match responseStatus == 201
        * match response.status == 'success'

    @ApproveRequestNoValidate
    Scenario: Approve request - no validate
        * def data = 
        """
        {
            "requestId": "#(requestId)",
            "authorization": "#(approvalAccessToken)",
            "challengeAnswer": "#(challengeAnswerApprover)",
            "passcode": "#(approverPasscode)",
            "requestBody": "#(typeof requestBody == 'undefined' ? null : requestBody)"
        }
        """
        * call read(svc + 'advQuorumSvc.feature@ApproveRequest') data

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
        * def requestCategories = karate.get('requestCategories',[])
        * def status = karate.get('status',[])
        * def data = 
        """
        { 
            authorization: "#(accessToken)",
            body:{
                "status" : #(status),
                "createdBy" : "#(userId)",
                "requestCategories": "#(requestCategories)",
                "limit" : #(typeof limit != 'number' ? 10 : limit),
                "isHistory" : true,
                "offset" : 0
            }
        }
        """
        * call read(svc + 'advQuorumSvc.feature@GetApprovalList') data
        Then match responseStatus == 201
        * match response.status == 'success'

    @GetRequestByKeyword
    Scenario: Get My Request List By Keyword
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        { 
            authorization: "#(accessToken)",
            body:{
                "keyword": #(keyword)
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

    @ViewAccountPolicyRequest @ViewRequestDetails
    Scenario: View account policy request
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
        {
            authorization: "#(accessToken)",
            requestId: "#(requestId)"
        }
        """
        * call read(svc + 'advQuorumSvc.feature@ViewAccountPolicyRequest') data

    @GetTotalPendingRequest
    Scenario: Get Total Pending Request
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * call read(svc + 'advQuorumSvc.feature@GetTotalPendingRequest') {authorization:#(accessToken)}
        
    @GetListCreatedByUser
    Scenario: Get list creator
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization:#(accessToken),
            params:{
                "limit" : 10,
                "offset" : 0,
                "keyword" : ""
            }
        }
        """
        * call read(svc + 'advQuorumSvc.feature@GetListCreatedByUser') data
        
    @CheckRequestImpact
    Scenario: Check Request Impact
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * call read(svc + 'advQuorumSvc.feature@CheckRequestImpact') {authorization:#(accessToken)}
        
    @GetVideoTextSentence
    Scenario: Get video captured sentence
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * call read(svc + 'advQuorumSvc.feature@GetVideoTextSentence') {authorization:#(accessToken)}
        
    @GetVideoRandomWords
    Scenario: Get video random words speech prompt
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * call read(svc + 'advQuorumSvc.feature@GetVideoRandomWords') {authorization:#(accessToken)}
        
    @CountPendingRequest
    Scenario: Get count pending request
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * call read(svc + 'advQuorumSvc.feature@CountPendingRequest') {authorization:#(accessToken)}
        
    @ReadPendingRequest
    Scenario: Read pending request
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization:#(accessToken),
            body:{id: #(requestId)}
        }
        """
        * call read(svc + 'advQuorumSvc.feature@ReadPendingRequest') data
    
    @GetQuorumDraftByIdByRequestDraftId
    Scenario: Get Quorum Draft By Id By Request Draft Id
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization:#(accessToken),
            quorumDraftId:#(quorumDraftId)
        }
        """
        * call read(svc + 'advQuorumSvc.feature@GetQuorumDraftByIdByRequestDraftId') data
   
    @ApproveQuorumDraftByIdByRequestDraftId
    Scenario: Approve Quorum Draft By Id By Request Draft Id
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization:#(accessToken),
            quorumDraftId:#(quorumDraftId)
        }
        """
        * call read(svc + 'advQuorumSvc.feature@ApproveQuorumDraftByIdByRequestDraftId') data
    
    @RejectQuorumDraftByIdByRequestDraftId
    Scenario: Reject Quorum Draft By Id By Request Draft Id
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization:#(accessToken),
            quorumDraftId:#(quorumDraftId)
        }
        """
        * call read(svc + 'advQuorumSvc.feature@RejectQuorumDraftByIdByRequestDraftId') data
        
    @CancelQuorumDraftByIdByRequestDraftId
    Scenario: Cancel Quorum Draft By Id By Request Draft Id
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization:#(accessToken),
            quorumDraftId:#(quorumDraftId)
        }
        """
        * call read(svc + 'advQuorumSvc.feature@CancelQuorumDraftByIdByRequestDraftId') data
        
          

