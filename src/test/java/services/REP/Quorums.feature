@ignore
Feature: REP Advance-quorum

    @REP_RejectRequest
    Scenario: Reject request on REP
        * print approvalAccessToken
        * def data = 
        """
        {
            requestId: "#(requestId)",
            authorization: "#(approvalAccessToken)",
            reason: "AT REP reject reason"
        }
        """
        * print data
        * call read(repSvc + 'advQuorumSvc.feature@REP_RejectRequest') data
