@ignore 
Feature: REP-TRansactions-service

    @GET_transaction_transactions_source-destination
    Scenario: GET transaction transactions source-destination
        * def data =
        """
        {
        headers:{
            Authorization: "#(typeof accessToken == 'undefined' ? repAccessToken : accessToken)"
        },
        params: {
            externalExchangeAccountId: "#(typeof externalExchangeAccountId != 'undefined' ? externalExchangeAccountId : null)",
            type: "#(typeof type != 'undefined' ? type : null)",
            tokenId: "#(typeof tokenId != 'undefined' ? tokenId : null)",
            workspaceId: "#(typeof workspaceId != 'undefined' ? workspaceId : null)"
            }
        }
        """
        * call read('this:transactionSvc.feature@GET_transaction_transactions_source-destination') data



