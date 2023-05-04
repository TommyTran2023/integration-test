@RAKCON-10583
Feature: User Onboarding

  Background:
    * url baseURL

  @RAKCON-12772 @View_workspace_information
  Scenario: View workspace information
    * call read('RequesterAuthenticator.feature@RequesterAccessToken')
    Given path 'core/customers/workspace/user'
    When method GET
    Then status 200
    And match response.status == "success"
