@ignore @RAKCON-10583
Feature: Staking
  Background:
    * url baseURL
    * def schemaBody = read('classpath:data/schema.json')
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

  @RAKCON-15443 @Staking_from_account_tab
  Scenario: View staking from account tab
    * def query = { limit:'10', offset: '0'}
    Given path 'staking/records'
    And params query
    When method GET
    Then status 200
    And match response.status == "success"
    And match response.data == schemaBody.staking.staking_accountTab
#    * def stakeId = response.data.result[0].id

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


