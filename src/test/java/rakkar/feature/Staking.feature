@ignore @RAKCON-10583
Feature: Staking
  Background:
    * url baseURL
    * call read('RequesterAuthenticator.feature@RequesterAccessToken')

  @RAKCON-15418 @Get_List_Pool
  Scenario: View list pool
    * def query = { limit:'10', page: '1', tokenId: '#(stakeToken)'}
    Given path 'staking/pools'
    And params query
    When method GET
    Then status 200
    And match response.status == "success"