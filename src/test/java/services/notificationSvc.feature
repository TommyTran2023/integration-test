Feature: Notification service

    @ListNotifications
    Scenario: List Notifications
        Given path 'notification/notifications'
        * header Authorization = authorization
        * params params
        When method GET

    @ReadNotification
    Scenario: Read Notification
        Given path '/notification/notifications/by-notification-id/' + notificationId
        * header Authorization = authorization
        When method GET

    @AddTokenNotification
    Scenario: Add Token Notification
        Given path 'notification/notifications'
        * header authorization = authorization
        * request body
        When method POST

    #----------------------------------
    @GetSettings
    Scenario: Get Settings
        Given path 'notification/notifications/settings'
        * header authorization = authorization
        When method GET
    
    @SetupNotificationSettings
    Scenario: Setup Notification Settings
        Given path 'notification/notifications/settings'
        * header authorization = authorization
        * request body
        When method POST
    
    #----------------------------------
    @ReplaceDeviceToken
    Scenario: Replace Device Token
        Given path 'notification/notifications/replace-token'
        * header authorization = authorization
        * request body
        When method POST
    
    #----------------------------------
    @ReadNotification
    Scenario: Read Notification
        Given path 'notification/notifications/read'
        * header authorization = authorization
        * request body
        When method PUT
    
    #----------------------------------
    @UnreadCount
    Scenario: Unread Count
        Given path 'notification/notifications/unread-count'
        * header authorization = authorization
        When method GET
        
    #----------------------------------
    @GetByNotificationId
    Scenario: Get By Notification Id
        Given path 'notification/notifications/by-notification-id/' + notificationId
        * header authorization = authorization
        When method GET
   
    #----------------------------------
    @DeleteNotificationById
    Scenario: Delete
        Given path 'notification/notifications/' + notificationId'
        * header authorization = authorization
        When method DELETE
    