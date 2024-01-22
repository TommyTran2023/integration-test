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
    * def data =
    """
    {
        authorization: "#(typeof accessToken == 'undefined' ? requesterAccessToken : accessToken)",
        body: {
            "keyword": #(typeof keyword == 'undefined' ? "" : keyword),
            "limit": #(typeof limit == 'undefined' ? 10 : limit),
            "offset": #(typeof offset == 'undefined' ? 0 : offset),
            "sort": #(typeof sort == 'undefined' ? "DESC" : sort),
            "sortBy": #(typeof sortBy == 'undefined' ? "CREATED_DATE" : sortBy)
        }
    }
    """
    * call read(svc + 'transactionSvc.feature@ExportTransactionWeb') data
    Then match responseStatus == 201

    @FilterTransaction
  Scenario: Filter Transaction
    * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
    * def data = 
    """
    {
        authorization: #(accessToken),
        params:{
            limit : 10,
            offset : 0, 
            sort : 'ASC', 
            sortBy : #(sortBy), 
            dateFrom : #(dateFrom), 
            dateTo : #(dateTo), 
            createdById : #(createdById), 
            priceFrom : #(priceFrom),
            priceTo : #(priceTo), 
            keyword : #(keyword), 
            vaultId : #(vaultId), 
            isAllRequest : #(isAllRequest), 
            txnDateFrom : #(txnDateFrom), 
            txnDateTo : #(txnDateTo), 
            source : #(source), 
            destination : #(destination), 
            destinationType : #(destinationType), 
            assetId : #(assetId), 
            type : #(type), 
            status : #(status), 
            initiatedByIds : #(initiatedByIds) 
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
                limit : #(limit),
                offset : #(offset),
                sort : #(sort),
                keyword : #(keyword)
            }
        }
        """
        * call read(svc + 'transactionSvc.feature@GetListInitiatedBy') data
        
    @ExportTransactionFull
    Scenario: Export Transaction
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                limit : #(limit), 
                offset : #(offset), 
                sort : #(sort), 
                sortBy : #(sortBy), 
                dateFrom : #(dateFrom), 
                dateTo : #(dateTo), 
                createdById : #(createdById), 
                priceFrom : #(priceFrom),
                priceTo : #(priceTo), 
                keyword : #(keyword), 
                vaultId : #(vaultId), 
                isAllRequest : #(isAllRequest), 
                txnDateFrom : #(txnDateFrom), 
                txnDateTo : #(txnDateTo), 
                assetId : #(assetId), 
                type : #(type), 
                status : #(status), 
                initiatedByIds : #(initiatedByIds),
                sourceData : #(sourceData), 
                destinationData : #(destinationData), 
                transactionType : #(transactionType), 
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
           notificationId : #(notificationId)
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
            txId : #(txId)
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
            txId : #(txId)
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
            txId : #(txId) 
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
            txId : #(txId), 
            body: 
            {
                reviewStatus : #(reviewStatus),
                verifyApprovalLogWithQuorumRequirement : #(verifyApprovalLogWithQuorumRequirement), 
                verifyCustomerIdentityFromLiveVideoCapture : #(verifyCustomerIdentityFromLiveVideoCapture), 
                signTransactionOnFBColdWalletApp : #(signTransactionOnFBColdWalletApp), 
                approveTransactionOnFBMobileApp : #(approveTransactionOnFBMobileApp), 
                reviewKYTInformation : #(reviewKYTInformation), 
                approveTransactionOnMobileApp : #(approveTransactionOnMobileApp) 
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
               assetId : #(assetId), 
               sourceId : #(sourceId),
               sourceType : #(sourceType),
               destinationId : #(destinationId), 
               destinationType : #(destinationType), 
               amount : #(amount), 
               isStake : #(isStake), 
               fee : #(fee), 
               isNetAmount : #(isNetAmount)
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
            txId : #(txId)
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
                txId : #(txId),
                reason : #(reason) 
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
                treatAsGrossAmount : #(treatAsGrossAmount), 
                uploadToken : #(uploadToken), 
                vdoSentence : #(vdoSentence), 
                clientId : #(clientId) 
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
                notificationId : #(notificationId), 
                uploadToken : #(uploadToken), 
                vdoSentence : #(vdoSentence), 
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
                notificationId : #(notificationId),
                requestCancelFrom : #(requestCancelFrom), 
            }
        }
        """
        * call read(svc + 'transactionSvc.feature@CancelReqTransactionCreateFromWeb') data
