Feature: Staking

    @GetStakingRecords
    Scenario: Get Staking Records
        * def keyword = karate.get('keyword','')
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
        {
            authorization: #(accessToken),
            params: {
                keyword: '#(keyword)',
                limit: 10,
                offset: 0
            }
        }
        """
        * call read('this:stakingSvc.feature@GetStakingRecords') data

    @GetStakingDetails
    Scenario: Get Staking Details
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * call read('this:stakingSvc.feature@GetStakingDetails') {authorization: #(accessToken), stakeId:#(stakeId)}
        
    @GetChainTransactions
    Scenario: Get Chain Transactions
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken)
        }
        """
        * call read(svc + 'stakingSvc.feature@GetChainTransactions') data

    @GetDashboardStake
    Scenario: Get Dashboard Stake
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken)
        }
        """
        * call read(svc + 'stakingSvc.feature@GetDashboardStake') data
        
    @GetAssetStakeInfo
    Scenario: Get Asset Stake Info
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            assetId : #(assetId) //string
        }
        """
        * call read(svc + 'stakingSvc.feature@GetAssetStakeInfo') data
    
    @StoreStakeRecord
    Scenario: Store Stake Record
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                tokenId : #(tokenId), //string
                tokenExternalId : #(tokenExternalId), //string
                source : #(source), //null
                destinationId : #(destinationId), //string
                amount : #(amount), //number
                note : #(note), //string
                fee : #(fee), //number
                feeType : #(feeType), //string
                totalEstimatedFee : #(totalEstimatedFee), //number
                feeLevel : #(feeLevel), //string
                registrationFee : #(registrationFee) //number
            }
        }
        """
        * call read(svc + 'stakingSvc.feature@StoreStakeRecord') data
    
    @UnstakeStoredRecord
    Scenario: Unstake Stored Record 
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            transactionId : #(transactionId), //string
            body: 
            {
                note : #(note), //string
                estimatedFee : #(estimatedFee), //number
            }
        }
        """
        * call read(svc + 'stakingSvc.feature@UnstakeStoredRecord') data

    @ClaimReward
    Scenario: Claim Reward
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                tokenId : #(tokenId), //string
                sourceId : #(sourceId), //string
                destination : #(destination), //null
                amount : #(amount), //number
                note : #(note), //string
                fee : #(fee), //number
                feeType : #(feeType), //string
                totalEstimatedFee : #(totalEstimatedFee), //number
                feeLevel : #(feeLevel) //string
            }
        }
        """
        * call read(svc + 'stakingSvc.feature@ClaimReward') data
     
    @EstimatedFee
    Scenario: Estimated Fee
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            tokenId : #(tokenId) //string
        }
        """
        * call read(svc + 'stakingSvc.feature@EstimatedFee') data
    
    @GetStakedAssets
    Scenario: Get Staked Assets
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            params: {
               keyword : '', //string
               limit : 10, //number
               page : 0 //number
            }
        }
        """
        * call read(svc + 'stakingSvc.feature@GetStakedAssets') data

    @StoreChangePoolRecord
    Scenario: Store Change Pool Record
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            stakeRecordId : #(stakeRecordId), //number
            body: 
            {
                source : #(source), //null
                tokenExternalId : #(tokenExternalId), //string
                destinationId : #(destinationId), //string
                note : #(note), //string
                fee : #(fee), //number
                feeType : #(feeType), //string
                totalEstimatedFee : #(totalEstimatedFee), //number
                feeLevel : #(feeLevel) //string
            }
        }
        """
        * call read(svc + 'stakingSvc.feature@StoreChangePoolRecord') data
    
    @GetPools
    Scenario: Get Pools
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            params:{
                sort : 'ASC', //string
                sortBy : #(sortBy), //string
                keyword : '', //string
                page : #(page), //number
                limit : #(limit), //number
                tokenId : #(tokenId), //string
                allPools : #(allPools), //boolean
                fromScreen : #(fromScreen) //string
            }
        }
        """
        * call read(svc + 'stakingSvc.feature@GetPools') data
     
    @GetPoolDetail
    Scenario: Get Pool Detail
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            tokenId : #(tokenId), //string
            poolId : #(poolId) //string
        }
        """
        * call read(svc + 'stakingSvc.feature@GetPoolDetail') data
         
    @SetPoolRecommendation
    Scenario: Set Pool Recommendation
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
            }
        }
        """
        * call read(svc + 'stakingSvc.feature@SetPoolRecommendation') data
     


        
