@RAKCON-10583
Feature: User Onboarding

  Background:
    * url baseURL

  @RAKCON-12772 @View_workspace_information @smoke
  Scenario: View workspace information
    * call read('this:RequesterAuthenticator.feature@RequesterAccessToken')
    Given path 'core/customers/workspace/user'
    When method GET
    Then status 200
    And match response.status == "success"

  @RAKCON-12773 @Get_role @smoke
  Scenario: Get roles information
    * call read('this:RequesterAuthenticator.feature@RequesterAccessToken')
    * def query = { target:'current'}
    Given path 'auth/authorization/roles'
    And params query
    When method GET
    Then status 200
    And match response.status == "success"

