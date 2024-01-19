Feature: Staking service
Background:
    * url baseURL

@GetStakingRecords
Scenario: Get Staking Records
    Given path 'staking/records'
    * header Authorization = authorization
    * params params
    When method GET

@GetStakingDetails
Scenario: Get Staking Details
    Given path 'staking/actions/progress'
    * header Authorization = authorization
    * param stakeId = stakeId
    When method GET

#----------------------------------
@GetChainTransactions
Scenario: Get Chain Transactions
   Given path 'staking/actions/transactions'
   * header authorization = authorization
   When method GET

#----------------------------------
@GetDashboardStake
Scenario: Get Dashboard Stake
   Given path 'staking/actions/dashboard'
   * header authorization = authorization
   When method GET

#----------------------------------
@GetAssetStakeInfo
Scenario: Get Asset Stake Info
   Given path 'staking/actions/asset/{assetId}'
   * header authorization = authorization
   When method GET

#----------------------------------
@StoreStakeRecord
Scenario: Store Stake Record
   Given path 'staking/records'
   * header authorization = authorization
   * request body
   When method POST

#----------------------------------
@UnstakeStoredRecord
Scenario: Unstake Stored Record
   Given path 'staking/records/{transactionId}/un-staking'
   * header authorization = authorization
   * request body
   When method PUT

#----------------------------------
@ClaimReward
Scenario: Claim Reward
   Given path 'staking/records/claim-reward'
   * header authorization = authorization
   * request body
   When method POST

#----------------------------------
@EstimatedFee
Scenario: Estimated Fee
   Given path 'staking/records/estimated-fee'
   * header authorization = authorization
   * param tokenId = tokenId
   When method GET

#----------------------------------
@GetStakedAssets
Scenario: Get Staked Assets
   Given path 'staking/records/assets'
   * header authorization = authorization
   * params params
   When method GET

#----------------------------------
@StoreChangePoolRecord
Scenario: Store Change Pool Record
   Given path 'staking/records/change-staking-pool/{stakeRecordId}'
   * header authorization = authorization
   * request body
   When method PUT

#----------------------------------
@GetPools
Scenario: Get Pools
   Given path 'staking/pools'
   * header authorization = authorization
   * params params
   When method GET

#----------------------------------
@GetPoolDetail
Scenario: Get Pool Detail
   Given path 'staking/pools/' + poolId
   * header authorization = authorization
   * param tokenId = tokenId
   When method GET

#----------------------------------
@SetPoolRecommendation
Scenario: Set Pool Recommendation
   Given path 'staking/pools/recommend'
   * header authorization = authorization
   * request body
   When method POST

