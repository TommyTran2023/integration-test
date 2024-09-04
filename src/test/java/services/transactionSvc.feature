Feature: Transaction Service
    # including all api calls related to route /transaction
  Background:
    Given url typeof customUrl != 'undefined' ? customUrl : baseURL
  
    @GetTransactionsList
    Scenario: Get transactions list
      Given path 'transaction/transactions/v1'
      * header authorization = authorization
      And request query
      When method POST

    @ViewTransactionDetail
    Scenario: View transaction detail common
      Given path 'transaction/transactions/' + transactionId
      * header authorization = authorization
      When method GET

    @ExportTransactionWeb
    Scenario: Export transaction
      Given path 'transaction/transactions/export-web'
      * header authorization = authorization
      And request body
      When method POST

    @RebalanceMediumAmount
    Scenario: Rebalance Medium Amount
      Given path 'transaction/transactions'
      * header authorization = authorization
      * header challenge-answer = challengeAnswer
      * header passcode = passcode
      And request body
      When method POST

    #----------------------------------
    @FilterTransaction
    Scenario: Filter Transaction
      Given path 'transaction/transactions'
      * header authorization = authorization
      * params params
      When method GET
    
    @CreateTransaction
    Scenario: Create Transaction
      Given path 'transaction/transactions'
      * headers headers
      * request body
      When method POST
  
    #----------------------------------
    @GetListInitiatedBy
    Scenario: Get List Initiated By
      Given path 'transaction/transactions/initiated-by'
      * header authorization = authorization
      * params params
      When method GET
  
    #----------------------------------
    @ExportTransaction
    Scenario: Export Transaction
      Given path 'transaction/transactions/export'
      * header authorization = authorization
      * request body
      When method POST
    
    #----------------------------------
    @GetListTransactionTierSigner
    Scenario: Get List Transaction Tier Signer
      Given path 'transaction/transactions/tiers-signer'
      * header authorization = authorization
      When method GET
    
    #----------------------------------
    @GetRequestTransferByNotiId
    Scenario: Get Request Transfer By Noti Id
      Given path 'transaction/transactions/request-transfer/' + notificationId
      * header authorization = authorization
      When method GET
  
    #----------------------------------
    @GetTransactionApprovalLogs
    Scenario: Get Transaction Approval Logs
       Given path 'transaction/transactions/' + txId +'/approval-logs'
       * header authorization = authorization
       When method GET
    
    #----------------------------------
    @CancelTransaction
    Scenario: Cancel Transaction
      Given path 'transaction/transactions/' + txId +'/cancel'
      * header authorization = authorization
      When method POST
    
    #----------------------------------
    @GetTransactionMarkAsReview
    Scenario: Get Transaction Mark As Review
      Given path 'transaction/transactions/' + txId +'/review'
      * header authorization = authorization
      When method GET
    
    @TransactionReview
    Scenario: Transaction Review
      Given path 'transaction/transactions/' + txId +'/review'
      * header authorization = authorization
      * request body
      When method POST
    
    #----------------------------------
    @GetTransactionReviewChecklist
    Scenario: Get Transaction Review Checklist
      Given path 'transaction/transactions/' + txId +'/review/checklist'
      * header authorization = authorization
      When method GET
    
    #----------------------------------
    @GetEstimatedFee
    Scenario: Get Estimated Fee
      Given path 'transaction/transactions/estimated-fee'
      * header authorization = authorization
      * request body
      When method POST
    
    #----------------------------------
    @GetTotalFee
    Scenario: Get Total Fee
      Given path 'transaction/transactions/total-estimate-fee'
      * header authorization = authorization
      * request body
      When method POST
    
    #----------------------------------
    @UnFreezeTransaction
    Scenario: Un Freeze Transaction
      Given path 'transaction/transactions/unfreeze'
      * header authorization = authorization
      * request body
      When method POST
    
    #----------------------------------
    @RejectUnfreezeTransaction
    Scenario: Reject Unfreeze Transaction
      Given path 'transaction/transactions/reject-unfreeze'
      * header authorization = authorization
      * request body
      When method POST
    
    #----------------------------------
    @RequestCreateTransaction
    Scenario: Request Create Transaction
      Given path 'transaction/transactions/request-create-transaction'
      * header authorization = authorization
      * request body
      When method POST
    
    #----------------------------------
    @SubmitTransaction
    Scenario: Submit Transaction
      Given path 'transaction/transactions/submit-req-create-transaction'
      * header authorization = authorization
      * request body
      When method POST
    
    #----------------------------------
    @CancelReqTransactionCreateFromWeb
    Scenario: Cancel Req Transaction Create From Web
      Given path 'transaction/transactions/cancel-req-create-transaction'
      * header authorization = authorization
      * request body
      When method PUT

    #----------------------------------
    @SyncTransaction
    Scenario: Sync Transaction
      Given path `transaction/transactions/${transactionId}/sync`
      * header authorization = authorization
      When method POST
    
    
