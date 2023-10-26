Feature: Notification service
Background:
    * url baseURL

@ListNotifications
Scenario: List Notifications
    Given path 'notification/notifications'
    * header Authorization = authorization
    * params params
    When method GET

@ReadNotification
Scenario: Read Notification
    Given path '/notification/notifications/by-notification-id', notificationId
    * header Authorization = authorization
    When method GET
