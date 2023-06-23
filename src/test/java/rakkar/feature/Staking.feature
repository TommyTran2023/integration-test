@ignore @RAKCON-10583
Feature: Staking
  Background:
    * url baseURL
    * call read('RequesterAuthenticator.feature@RequesterAccessToken')
    * def testData = read('classpath:data/data_test.json')


  @RAKCON-15418 @Get_List_Pool
  Scenario: View list pool
    * def query = { limit:'10', page: '1', tokenId: '#(stakeToken)'}
    Given path 'staking/pools'
    And params query
    When method GET
    Then status 200
    And match response.status == "success"

  @RAKCON-15440 @Get_estimatefee_stake
  Scenario: Get estimate fee for staking
    * def query = { tokenId: '#(stakeToken)'}
    Given path 'staking/records/estimated-fee'
    And params query
    When method GET
    Then status 200
    And match response.status == "success"
    * def totalEstimatedFee = response.data

  @RAKCON-15441 @Create_staking
  Scenario: Create staking
    * call read('Staking.feature@Get_estimatefee_stake')
    * def body = { "totalEstimatedFee":'#(totalEstimatedFee)',"tokenId":'#(stakeToken)',"registrationFee": 2,"feeLevel":'#(testData.staking.feeLevel)', "source": {"type":'#(testData.transfer.source_type)',"id":'#(sourceId_hot)'},"amount":#(testData.staking.amount),"destinationId":'#(testData.staking.poolID)', "tokenExternalId": '#(testData.staking.tokenExternalId)'}
    * call read('Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    * header passcode = requesterInfo.requesterPasscode
    Given path 'staking/records'
    And request body
    When method POST
    Then status 201
    And response.status == "success"
    And match response.message == "Success"

  @RAKCON-15444 @Staking_detail
    * call read('Staking.feature@Staking_from_account_tab')
  Scenario: View staking detail
    Given path 'staking/actions/progress' + stakeId
    And params query
    When method GET
    Then status 200
    And match response.status == "success"
    And match response.data.tokenData.symbol == "ADA"
    And match response.data.tokenData.externalAssetId == "ADA_Test"
    * def transactionId = response.data.rewardData.transactionId

  @RAKCON-15447 @Un_staking
  Scenario: Check unstake
    * call read('Staking.feature@Get_estimatefee_stake')
    * call read('Staking.feature@Staking_detail')
    * def body = { "estimatedFee":'#(totalEstimatedFee)'}
    * call read('Common.feature@FIDO-Requester')
    * header challenge-answer = challengeAnswerRequest
    * header passcode = requesterInfo.requesterPasscode
    Given path 'staking/records/' + transactionId +'/un-staking'
    And request body
    When method PUT
    Then status 201
    And response.status == "success"
    And match response.message == "Success"





