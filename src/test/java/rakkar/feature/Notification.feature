@RAKCON-10583
Feature: Notification

  Background:
    * url baseURL
    * call read('ApprovalAuthenticator.feature@GetAccessTokenForLogin')
    * def dataBody = read('classpath:data/data_test.json')
    * def schemaBody = read('classpath:data/schema.json')

  @RAKCON-11009 @NotificationSetting
  Scenario: Notification Setting
    Given path '/notification/notifications/settings'
    When method GET
    Then status 200
    * match response.data.policy == schemaBody.notification.policy
    * match response.data.usersAndDevices == schemaBody.notification.usersAndDevices
    * match response.data.announcements == schemaBody.notification.announcements
    * match response.data.transactions == schemaBody.notification.transactions