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

  @RAKCON-11007 @ViewNotificationCenterCreateVault
  Scenario: View Notification Center - Creating Vault
    * def createVaultRequestId = call read('Vault.feature@GetCreateVaultRequestID')
    Given path '/notification/notifications'
    * param status = 'UNREAD'
    * param limit = 10
    * param offset = 0
    * param sort = 'DESC'
    When method GET
    Then status 200
    * match response.data.notifications[0].requestId == createVaultRequestId.requestId
    * match response.data.notifications[0].title == dataBody.notification.vault.labelInApp
    * match response.data.notifications[0].type == dataBody.notification.vault.state
    * def notificationContent = "You have received a request for a new vault policy for <<"+createVaultRequestId.vaultNameResponseWA+">>"
    * match response.data.notifications[0].body == notificationContent
