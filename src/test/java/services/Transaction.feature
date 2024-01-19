Feature: Tranaction Service

@RebalanceMediumAmount
Scenario: Rebalance Medium Amount
    * def data =
    """
    {
        authorization: #(requesterAccessToken),
        challengeAnswer: "#(challengeAnswerRequest)",
        passcode: "#(requesterInfo.requesterPasscode)",
        body: #(body)
    }
    """
    * call read(svc + 'transactionSvc.feature@RebalanceMediumAmount') data
    Then match responseStatus == 201

@GetTransactionsList
Scenario: Get transactions list
    * call read(svc + 'transactionSvc.feature@GetTransactionsList') {authorization: #(requesterAccessToken)}
    Then match responseStatus == 201

@ViewTransactionDetail
Scenario: View transaction detail common
    * def data = 
    """
    {
        authorization: #(requesterAccessToken),
        transactionId: #(transactionId)
    }
    """
    * call read(svc + 'transactionSvc.feature@ViewTransactionDetail') data

@ExportTransaction
Scenario: Export transaction
    * call read(svc + 'transactionSvc.feature@ExportTransaction') {authorization: #(requesterAccessToken)}
    Then match responseStatus == 201

@FilterTransaction
Scenario: Filter Transaction
    * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
    * def data = 
    """
    {
        authorization: #(accessToken),
        params:{
            limit : 10, //number
            offset : 0, //number
            sort : 'ASC', //string
            sortBy : #(sortBy), //string
            dateFrom : #(dateFrom), //string
            dateTo : #(dateTo), //string
            createdById : #(createdById), //string
            priceFrom : #(priceFrom), //number
            priceTo : #(priceTo), //number
            keyword : #(keyword), //string
            vaultId : #(vaultId), //string
            isAllRequest : #(isAllRequest), //boolean
            txnDateFrom : #(txnDateFrom), //string
            txnDateTo : #(txnDateTo), //string
            source : #(source), //array
            destination : #(destination), //array
            destinationType : #(destinationType), //string
            assetId : #(assetId), //array
            type : #(type), //string
            status : #(status), //string
            initiatedByIds : #(initiatedByIds) //string
        }
    }
    """
    * call read(svc + 'transactionSvc.feature@FilterTransaction') data
 
    @CreateTransaction
    Scenario: Create Transaction   
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            headers:{
                authorization: #(accessToken),
                challenge-answer: #(challengeAnswerRequest),
                passcode: #(typeof passcode == 'undefined' ? null : passcode)
            },
            body: 
            {
                tokenId : #(tokenId),
                source : #(source), 
                destination : #(destination), 
                amount : #(amount), 
                operation : #(operation),
                fee : #(fee),
                feeType : #(feeType), 
                totalEstimatedFee : #(totalEstimatedFee), 
                feeLevel : #(feeLevel), 
                note : #(note), 
                treatAsGrossAmount : #(treatAsGrossAmount)
            }
        }
        """

        * if (typeof passcode != 'undefined') data.headers["passcode"]=passcode
        * if (typeof uploadToken != 'undefined') data.body["uploadToken"]=uploadToken
        * if (typeof vdoSentence != 'undefined') data.body["vdoSentence"]=vdoSentence

        * call read(svc + 'transactionSvc.feature@CreateTransaction') data
        Then match responseStatus == 201

    @GetListInitiatedBy
    Scenario: Get List Initiated By
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            params:{
                limit : #(limit), //number
                offset : #(offset), //number
                sort : #(sort), //string
                keyword : #(keyword) //string
            }
        }
        """
        * call read(svc + 'transactionSvc.feature@GetListInitiatedBy') data
        
    @ExportTransaction
    Scenario: Export Transaction
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                limit : #(limit), //number
                offset : #(offset), //number
                sort : #(sort), //string
                sortBy : #(sortBy), //string
                dateFrom : #(dateFrom), //string
                dateTo : #(dateTo), //string
                createdById : #(createdById), //string
                priceFrom : #(priceFrom), //number
                priceTo : #(priceTo), //number
                keyword : #(keyword), //string
                vaultId : #(vaultId), //string
                isAllRequest : #(isAllRequest), //boolean
                txnDateFrom : #(txnDateFrom), //string
                txnDateTo : #(txnDateTo), //string
                assetId : #(assetId), //array
                type : #(type), //string
                status : #(status), //string
                initiatedByIds : #(initiatedByIds), //array
                sourceData : #(sourceData), //array
                destinationData : #(destinationData), //array
                transactionType : #(transactionType), //string
            }
        }
        """
        * call read(svc + 'transactionSvc.feature@ExportTransaction') data
     
    @GetListTransactionTierSigner
    Scenario: Get List Transaction Tier Signer
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
        }
        """
        * call read(svc + 'transactionSvc.feature@GetListTransactionTierSigner') data
        Then match responseStatus == 200
     
    @GetRequestTransferByNotiId
    Scenario: Get Request Transfer By Noti Id
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
           authorization: #(accessToken),
           notificationId : #(notificationId) //string
        }
        """
        * call read(svc + 'transactionSvc.feature@GetRequestTransferByNotiId') data
    
    @GetTransactionApprovalLogs
    Scenario: Get Transaction Approval Logs
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            txId : #(txId) //string
        }
        """
        * call read(svc + 'transactionSvc.feature@GetTransactionApprovalLogs') data
     
    @CancelTransaction
    Scenario: Cancel Transaction
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            txId : #(txId) //string
        }
        """
        * call read(svc + 'transactionSvc.feature@CancelTransaction') data
    
    @GetTransactionMarkAsReview
    Scenario: Get Transaction Mark As Review
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            txId : #(txId) //string
        }
        """
        * call read(svc + 'transactionSvc.feature@GetTransactionMarkAsReview') data
     
    @TransactionReview
    Scenario: Transaction Review

        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            txId : #(txId), //string
            body: 
            {
                reviewStatus : #(reviewStatus), //string
                verifyApprovalLogWithQuorumRequirement : #(verifyApprovalLogWithQuorumRequirement), //boolean
                verifyCustomerIdentityFromLiveVideoCapture : #(verifyCustomerIdentityFromLiveVideoCapture), //boolean
                signTransactionOnFBColdWalletApp : #(signTransactionOnFBColdWalletApp), //boolean
                approveTransactionOnFBMobileApp : #(approveTransactionOnFBMobileApp), //boolean
                reviewKYTInformation : #(reviewKYTInformation), //boolean
                approveTransactionOnMobileApp : #(approveTransactionOnMobileApp) //boolean
            }
        }
        """
        * call read(svc + 'transactionSvc.feature@TransactionReview') data
        
    @GetTransactionReviewChecklist
    Scenario: Get Transaction Review Checklist
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            txId : #(txId) //string
        }
        """
        * call read(svc + 'transactionSvc.feature@GetTransactionReviewChecklist') data
    
    @GetEstimatedFee
    Scenario: Get Estimated Fee
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                assetId : #(assetId),
                sourceId : #(sourceId), 
                sourceType : #(sourceType), 
                destinationId : #(destinationId), 
                destinationType : #(destinationType),
                amount : #(amount),
                isStake : false
            }
        }
        """
        * call read(svc + 'transactionSvc.feature@GetEstimatedFee') data
        Then match responseStatus == 201
        
    @GetTotalFee
    Scenario: Get Total Fee
       * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
       * def data = 
       """
       {
           authorization: #(accessToken),
           body: 
           {
               assetId : #(assetId), //string
               sourceId : #(sourceId), //string
               sourceType : #(sourceType), //string
               destinationId : #(destinationId), //string
               destinationType : #(destinationType), //string
               amount : #(amount), //number
               isStake : #(isStake), //object
               fee : #(fee), //number
               isNetAmount : #(isNetAmount) //boolean
           }
       }
       """
       * call read(svc + 'transactionSvc.feature@GetTotalFee') data
    
    @UnFreezeTransaction
   Scenario: Un Freeze Transaction
    * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
    * def data = 
    """
    {
        authorization: #(accessToken),
        body: 
        {
            txId : #(txId) //string
        }
    }
    """
    * call read(svc + 'transactionSvc.feature@UnFreezeTransaction') data
 
    @RejectUnfreezeTransaction
    Scenario: Reject Unfreeze Transaction
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                txId : #(txId), //string
                reason : #(reason) //string
            }
        }
        """
        * call read(svc + 'transactionSvc.feature@RejectUnfreezeTransaction') data
     
    
    @RequestCreateTransaction
    Scenario: Request Create Transaction
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                tokenId : #(tokenId), //string
                source : #(source), //null
                destination : #(destination), //null
                amount : #(amount), //number
                operation : #(operation), //string
                fee : #(fee), //number
                feeType : #(feeType), //string
                totalEstimatedFee : #(totalEstimatedFee), //number
                feeLevel : #(feeLevel), //string
                note : #(note), //string
                treatAsGrossAmount : #(treatAsGrossAmount), //boolean
                uploadToken : #(uploadToken), //string
                vdoSentence : #(vdoSentence), //string
                clientId : #(clientId) //string
            }
        }
        """
        * call read(svc + 'transactionSvc.feature@RequestCreateTransaction') data
    
    @SubmitTransaction
    Scenario: Submit Transaction
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                notificationId : #(notificationId), //string
                uploadToken : #(uploadToken), //string
                vdoSentence : #(vdoSentence), //string
            }
        }
        """
        * call read(svc + 'transactionSvc.feature@SubmitTransaction') data
      
    @CancelReqTransactionCreateFromWeb
    Scenario: Cancel Req Transaction Create From Web
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                notificationId : #(notificationId), //string
                requestCancelFrom : #(requestCancelFrom), //string
            }
        }
        """
        * call read(svc + 'transactionSvc.feature@CancelReqTransactionCreateFromWeb') data
