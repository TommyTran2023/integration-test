    @RAKCON-31802 @REP
Feature: Transaction Monitoring

    Background:
        * callonce read(repSvc + 'Auth.feature@LoginAsCustomerSuccess')

    @REP_ListAllTransactions
    Scenario: List all transaction
        * def data = 
        """
        {
            accessToken: "#(repAccessToken)",
            query: {
                page:1,
                offset:0,
                limit:10,
                sortBy:"CREATED_DATE",
                sort:"DESC"
            }
        }
        """
        * call read(svc + 'Transaction.feature@GetTransactionsList') data

