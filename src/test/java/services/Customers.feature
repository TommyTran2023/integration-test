Feature: Customers
# under core/customers

    @EditAccountPolicy
    Scenario: Edit Account Policy
        * def data =
        """
        {
            authorization: #(requesterAccessToken),
            customerId: #(customerId),
            challengeAnswer: #(challengeAnswerRequest),
            passcode: #(requesterInfo.requesterPasscode),
            body: {"note" : "AT Edit Account Policy Note",  "memberRequired" : [],  "quorumSize" : 2}
        }
        """
        * call read(svc + 'coreSvc.feature@EditAccountPolicy') data
        Then match responseStatus == 200
        * match response.status == 'success'
