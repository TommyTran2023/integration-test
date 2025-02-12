@RAKCON-10583
Feature: Notification

  Background:
    * url baseURL
    * def Const = read('classpath:data/enum.json')
    * def schemaBody = read('classpath:data/schema.json')

  @RAKCON-11009 @NotificationSetting @smoke
  Scenario: Notification Setting
    * call read('this:RequesterAuthenticator.feature@RequesterAccessToken')
    Given path '/notification/notifications/settings'
    When method GET
    Then status 200
    * match response.data.policy == schemaBody.notification.policy
    * match response.data.usersAndDevices == schemaBody.notification.usersAndDevices
    * match response.data.announcements == schemaBody.notification.announcements
    * match response.data.transactions == schemaBody.notification.transactions

  @RAKCON-11007 @ViewNotificationCenterRequest
  Scenario: View Notification Center - Request
    * def createVaultRequestId = call read('this:Vault.feature@GetCreateVaultRequestID')
    * call read('this:ApprovalAuthenticator.feature@GetAccessTokenForLogin')
    * def notificationCenter = call read('this:Notification.feature@ViewNotificationCenter-Common')
    * def noti = notificationCenter.response.data.notifications[0]
    * match noti.requestId == createVaultRequestId.requestId
    * match noti.title == Const.Notifications.CreateVaultPolicy.title
    * match noti.type == Const.Notifications.CreateVaultPolicy.type
    * def notificationContent = Const.Notifications.CreateVaultPolicy.body.replace("vaultName", createVaultRequestId.vaultNameResponseWA) 
    * match noti.body == notificationContent

  @RAKCON-12514 @ViewNotificationCenterAlert
  Scenario: View Notification - Alert
    * def rejectTransfer = call read('this:RejectRequest.feature@RejectTransfer_Hot_to_Cold')
    * call read('this:RequesterAuthenticator.feature@RequesterAccessToken')
    * def notificationCenter = call read('this:Notification.feature@ViewNotificationCenter-Common')
    * def noti = notificationCenter.response.data.notifications[0]
    * def expectedMetadataParams = 
    """
    {
      "AMOUNT":"#string",
      "ASSET_SYMBOL":"#string",
      "FROM_VAULT_NAME":"#string",
      "TO_VAULT_NAME":"#string"
    }
    """
    * match noti.requestId == rejectTransfer.requestId
    * match noti.title == Const.Notifications.RejectTransfer.title
    * match noti.type == Const.Notifications.RejectTransfer.type
    * match noti.body == Const.Notifications.RejectTransfer.body
    * match noti.params == expectedMetadataParams

  @RAKCON-12515 @ViewNotificationCenterTransactionAlert
  Scenario: View Notification Center - Transaction Alert
    * def approveTransfer = call read('this:ApprovalRequest.feature@ApprovalTransfer_Hot_to_cold')
    * call read('this:RequesterAuthenticator.feature@RequesterAccessToken')
    * def notificationCenter = call read('this:Notification.feature@ViewNotificationCenter-Common')
    * def noti = notificationCenter.response.data.notifications[0]
    * def expectedMetadataParams = 
    """
    {
      "AMOUNT":"#string",
      "ASSET_SYMBOL":"#string",
      "FROM_VAULT_NAME":"#string",
      "TO_VAULT_NAME":"#string"
    }
    """
    * match noti.requestId == approveTransfer.requestId
    * match noti.title == Const.Notifications.ApproveTransfer.title
    * match noti.type == Const.Notifications.ApproveTransfer.type
    * match noti.body == Const.Notifications.ApproveTransfer.body
    * match noti.params == expectedMetadataParams

  @ignore @ViewNotificationCenter-Common
  Scenario: View Notification Center - Common
    Given path '/notification/notifications'
    * param status = 'UNREAD'
    * param limit = 10
    * param offset = 0
    * param sort = 'DESC'
    When method GET
    Then status 200

  @ignore @ReadNotificationById
  Scenario: Read Notification Detail By Id
    Given path '/notification/notifications/by-notification-id/' + notificationId
    When method GET
    Then status 200
