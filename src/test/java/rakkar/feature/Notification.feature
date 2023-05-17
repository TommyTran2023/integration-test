@RAKCON-10583
Feature: Notification

  Background:
    * url baseURL
    * def testData = read('classpath:data/data_test.json')
    * def schemaBody = read('classpath:data/schema.json')

  @RAKCON-11009 @NotificationSetting
  Scenario: Notification Setting
    * call read('ApprovalAuthenticator.feature@GetAccessTokenForLogin')
    Given path '/notification/notifications/settings'
    When method GET
    Then status 200
    * match response.data.policy == schemaBody.notification.policy
    * match response.data.usersAndDevices == schemaBody.notification.usersAndDevices
    * match response.data.announcements == schemaBody.notification.announcements
    * match response.data.transactions == schemaBody.notification.transactions

  @RAKCON-11007 @ViewNotificationCenterRequest
  Scenario: View Notification Center - Request
    * call read('ApprovalAuthenticator.feature@GetAccessTokenForLogin')
    * def createVaultRequestId = call read('Vault.feature@GetCreateVaultRequestID')
    * def notificationCenter = call read('Notification.feature@ViewNotificationCenter-Common')
    * match notificationCenter.response.data.notifications[0].requestId == createVaultRequestId.requestId
    * match notificationCenter.response.data.notifications[0].title == testData.notification.vault.labelInApp
    * match notificationCenter.response.data.notifications[0].type == testData.notification.vault.state
    * def notificationContent = "You have received a request for a new vault policy for <<"+createVaultRequestId.vaultNameResponseWA+">>"
    * match notificationCenter.response.data.notifications[0].body == notificationContent

  @RAKCON-12514 @ViewNotificationCenterAlert
  Scenario: View Notification - Alert
    * def rejectTransfer = call read('RejectRequest.feature@RejectTransfer_Hot_to_Cold')
    * call read('RequesterAuthenticator.feature@RequesterAccessToken')
    * def notificationCenter = call read('Notification.feature@ViewNotificationCenter-Common')
    * match notificationCenter.response.data.notifications[0].requestId == rejectTransfer.requestId
    * match notificationCenter.response.data.notifications[0].title == testData.notification.rejectTransfer.labelInApp
    * match notificationCenter.response.data.notifications[0].type == testData.notification.rejectTransfer.state
    * def notificationContent = "Your request to transfer <<"+rejectTransfer.value.response.data.amount+">> "+"<<"+testData.transfer.withdraw.symbol+">> from <<"+testData.transfer.withdraw.sourceName_hot+">> to <<"+testData.transfer.withdraw.destinationName_cold+">> has been rejected."
    * match notificationCenter.response.data.notifications[0].body == notificationContent

  @RAKCON-12515 @ViewNotificationCenterTransactionAlert
  Scenario: View Notification Center - Transaction Alert
    * def approveTransfer = call read('ApprovalRequest.feature@ApprovalTransfer_Hot_to_cold')
    * call read('RequesterAuthenticator.feature@RequesterAccessToken')
    * def notificationCenter = call read('Notification.feature@ViewNotificationCenter-Common')
    * match notificationCenter.response.data.notifications[0].requestId == approveTransfer.requestId
    * match notificationCenter.response.data.notifications[0].title == testData.notification.approveTransfer.labelInApp
    * match notificationCenter.response.data.notifications[0].type == testData.notification.approveTransfer.state
    * def notificationContent = "Your request to transfer <<"+approveTransfer.value.response.data.amount+">> "+"<<"+testData.transfer.withdraw.symbol+">>"+" from <<"+testData.transfer.withdraw.sourceName_hot+">> to <<"+testData.transfer.withdraw.destinationName_cold+">> has been approved"
    * match notificationCenter.response.data.notifications[0].body == notificationContent

  @ignore @ViewNotificationCenter-Common
  Scenario: View Notification Center - Common
    Given path '/notification/notifications'
    * param status = 'UNREAD'
    * param limit = 10
    * param offset = 0
    * param sort = 'DESC'
    When method GET
    Then status 200
