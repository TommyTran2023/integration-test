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
