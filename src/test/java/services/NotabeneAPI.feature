@ignore
Feature: Notabene API
    Background:
        Given url 'https://api.notabene.dev'
        * def destEnv = typeof destEnv == 'undefined' ? karate.properties['karate.env'] : destEnv
        * def notabene = karate.jsonPath(privateKey, "$.." + destEnv +"_notabene")[0]
        * print destEnv, notabene
        * def waitTxn =  
        """
        function(){
            var haveTxn = false
            var maxRetry = 6
            var waitTime = 10000

            do {
                java.lang.Thread.sleep(waitTime); 
                maxRetry--;

                var txnList = karate.call("@GetTransfersInDashboard", { txDirection: txDirection }).response.transactions

                if (txnList.length > 0)
                    haveTxn = true
            }
            while(!haveTxn && maxRetry > 0)
            karate.set("txId", txnList[0].id)
        }
        """

    @GetAccessToken
    Scenario: Get Access Token
        Given url 'https://auth.notabene.id'
        Given path 'oauth/token'
        And header Content-Type = "application/x-www-form-urlencoded"
        And form field client_id = notabene.client_id
        And form field client_secret = notabene.client_secret
        And form field grant_type = "client_credentials"
        And form field audience = notabene.audience
        When method POST
        Then status 200
        * def notabeneAccessToken = 'Bearer ' + response.access_token

    @GetTransfersInDashboard
    Scenario: Get Transfers in dashboard
        Given path 'tx/list'
        * def query = 
        """
        {
            txDirection: "#(txDirection)",
            vaspDID: "#(notabene.vaspDID)",
            resultsPerPage: 10,
            page: 0,
            sort: "updatedAt:DESC",
            decrypt: false,
            includeActions: false,
            status: "#(typeof status == 'undefined' ? 'NEW' : status)"
        }
        """
        And params query
        And header Authorization = notabeneAccessToken
        When method GET
        Then status 200

    @ApproveAndSendTransfer
    Scenario: Approve And Send Transfer
        Given path 'tx/approve'
        And header Authorization = notabeneAccessToken
        And param id = txId
        When method POST
        Then status 200

    @CancelTransfer
    Scenario: Cancel Transfer
        Given path 'tx/cancel'
        And header Authorization = notabeneAccessToken
        And request {id: "#(txId)", reason: "Reject from Rakkar IT"}
        When method POST
        Then status 200

    @ApproveLatestTransfer
    Scenario: Approve Latest Transfer
        * call read('@GetAccessToken')
        * eval waitTxn()
        # * call read('@GetTransfersInDashboard') { txDirection: "#(txDirection)" }
        * call read('@ApproveAndSendTransfer')

    @CancelLatestTransfer
    Scenario: Cancel Latest Transfer
        * call read('@GetAccessToken')
        * eval waitTxn()
        # * call read('@GetTransfersInDashboard') { txDirection: "#(txDirection)" }
        * call read('@CancelTransfer')

        


