@RAKCON-10583
Feature: Staking
  Background:
    * url baseURL
    * def schemaBody = read('classpath:data/schema.json')
    * call read('this:RequesterAuthenticator.feature@RequesterAccessToken')
    * def testData = read('classpath:data/data_test.json')
    * call read('this:GetUserInfo.feature@GetUserInfo')

  @RAKCON-15418 @Get_List_Pool
  Scenario: View list pool
    * def query = { limit:'10', page: '1', tokenId: '#(dataSet.stakeToken)'}
    Given path 'staking/pools'
    And params query
    When method GET
    Then status 200
    And match response.status == "success"

  @RAKCON-15440 @Get_estimatefee_stake
  Scenario: Get estimate fee for staking
    * def query = { tokenId: '#(dataSet.stakeToken)'}
    Given path 'staking/records/estimated-fee'
    And params query
    When method GET
    Then status 200
    And match response.status == "success"
    * def totalEstimatedFee = response.data

  @RAKCON-15441 @Create_staking
  Scenario: Create staking
    * call read('this:Staking.feature@Get_estimatefee_stake')
    * def body = { "totalEstimatedFee":'#(totalEstimatedFee)',"tokenId":'#(dataSet.stakeToken)',"registrationFee": 2,"feeLevel":'#(testData.staking.feeLevel)', "source": {"type":'#(testData.transfer.source_type)',"id":'#(dataSet.vaultCreateStake)'},"amount":#(testData.staking.amount),"destinationId":'#(testData.staking.poolID)', "tokenExternalId": '#(testData.staking.tokenExternalId)'}
    * call read('this:Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    * header passcode = requesterInfo.requesterPasscode
    Given path 'staking/records'
    And request body
    When method POST
    Then status 201
    And response.status == "success"
    And match response.message == "Success"

  @RAKCON-15442 @CancelCreateStaking
  Scenario: Cancel request create staking
    * call read('this:Staking.feature@View_My_Request_Stake')
    * call read('this:CancelRequest.feature@CancelRequestCommon')

  @RAKCON-15443 @Staking_from_account_tab
  Scenario: View staking from account tab
    * def query = { limit:'10', offset: '0'}
    Given path 'staking/records'
    And params query
    When method GET
    Then status 200
    And match response.status == "success"
    And match response.data == schemaBody.staking.staking_accountTab
    * def stakeId = response.data.result[0].id
    * def transactionId = response.data.result[0].transactionId

  @RAKCON-15444 @Staking_detail
  Scenario: View staking detail
    * call read('this:Staking.feature@Staking_from_account_tab')
    * def query = { stakeId: '#(stakeId)'}
    Given path 'staking/actions/progress'
    And params query
    When method GET
    Then status 200
    And match response.status == "success"

  @RAKCON-15445 @Staking_action_dashboard
  Scenario: View staking action from dashboard
    * def query = { limit: '10'}
    Given path 'staking/actions/dashboard'
    And params query
    When method GET
    Then status 200
    And match response.status == "success"
    And match response.data == schemaBody.staking.action_staking

  @RAKCON-15446 @Staking_asset_dashboard
  Scenario: View staking asset from dashboard
    * def query = { page: '1'}
    Given path 'staking/records/assets'
    And params query
    When method GET
    Then status 200
    And match response.status == "success"
    And match response.data[0].symbol == "ADA Test"

  @RAKCON-15447 @Un_staking
  Scenario: Check unstake
    * call read('this:Staking.feature@Get_estimatefee_stake')
    * call read('this:Staking.feature@Staking_from_account_tab')
    * def body = { "estimatedFee":'#(totalEstimatedFee)'}
    * call read('Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    * header passcode = requesterInfo.requesterPasscode
    Given path 'staking/records/' + transactionId +'/un-staking'
    And request body
    When method PUT
    Then status 200
    And response.status == "success"

  @RAKCON-15952 @CancelUnStaking
  Scenario: Cancel request unstake
    * call read('this:Staking.feature@View_My_Request_Stake')
    * call read('this:CancelRequest.feature@CancelRequestCommon')

  @RAKCON-15952 @ChangeStakingPool
  Scenario: Change staking pool
    * call read('this:Staking.feature@Get_estimatefee_stake')
    * def value = call read('this:Staking.feature@Get_List_Pool')
    * def poolChangeId = value.response.data.pools[2].bech32Id
    * call read('this:Staking.feature@Staking_detail')
    * def body = { "totalEstimatedFee":'#(totalEstimatedFee)',"tokenId":'#(dataSet.stakeToken)',"registrationFee": 2,"feeLevel":'#(testData.staking.feeLevel)', "source": {"type":'#(testData.transfer.source_type)',"id":'#(dataSet.vaultUpdateStake)'},"amount":#(testData.staking.amount),"destinationId":'#(poolChangeId)', "tokenExternalId": '#(testData.staking.tokenExternalId)'}
    * call read('this:Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    * header passcode = requesterInfo.requesterPasscode
    Given path 'staking/records/change-staking-pool/'+ stakeId
    And request body
    When method PUT
    Then status 200
    And response.status == "success"
    And match response.message == "Success"

  @RAKCON-15954 @CancelChangePoolStaking
  Scenario: Cancel request change staking pool
    * call read('this:Staking.feature@View_My_Request_Stake')
    * call read('this:CancelRequest.feature@CancelRequestCommon')

  @ignore @RAKCON-17459 @GetstakeSubcription
  Scenario: Staking from Newsletter - Get stake subscription
    * def query = { limit: 10, offset: 0 }
    Given path 'core/wallet/stake-subscription/tokens'
    And params query
    When method GET
    Then status 200
    And match response.status == "success"

  @ignore @RAKCON-17460 @Getvaultforstake
  Scenario: Staking from Newsletter - Get vault for stake
    * def query = { limit: 10, offset: 0 }
    Given path 'core/vault/stake/' + '#(dataSet.stakeToken)'
    And params query
    When method GET
    Then status 200
    And match response.status == "success"

  @ignore @View_My_Request_Stake
  Scenario: View my request for type staking
    * def body = 
    """
    { 
    "offset":'0',
    "limit": '10',
    "keyword":'',
    "requestCategories":["STAKE"],
    "createdBy": '#(userId)',
    "status" : ["PENDING"],
    "isHistory" : true 
    }
    """
    * call read(svc + 'Quorums.feature@GetMyRequests') body
    Then status 201
    * def requestId = response.data.records[0].id


  @StakingOnAdvanceVault @ignore
  Scenario: Staking on hot advance vault
    # BUG @MOB-1945
    * def schemaBody = read('classpath:data/schema.json')
    * call read('this:Staking.feature@Get_estimatefee_stake')
    * def body = 
    """
      { 
        "totalEstimatedFee":'#(totalEstimatedFee)',
        "tokenId":'#(dataSet.stakeToken)',
        "registrationFee": 2,
        "feeLevel":'#(testData.staking.feeLevel)', 
        "source": 
        {
          "type":'#(testData.transfer.source_type)',
          "id":'#(dataSet.advanceHotVaultForStakeId)'
        },
        "amount":#(testData.staking.amount),
        "destinationId":'#(testData.staking.poolID)', 
        "tokenExternalId": '#(testData.staking.tokenExternalId)'
      }
    """
    * call read('this:Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    * header passcode = requesterInfo.requesterPasscode
    Given path 'staking/records'
    And request body
    When method POST
    Then status 201
    And response.status == "success"
    And match response.message == "Success"
    * def data = response.data
    * def requestId = response.data.requestId
    * call read('this:CancelRequest.feature@CancelRequestCommon')
    * match data == schemaBody.staking.stakingRecord
    



