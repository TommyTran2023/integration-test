Feature: Notitication  

  Background:
    * def svc = 'classpath:services/'

    @ReadNotificationById
    Scenario: Read notification by id
        * def data = 
        """
        {
            authorization: #(requesterAccessToken),
            notificationId: '#(notificationId)'
        }
        """
        * call read(svc + 'notificationSvc.feature@ReadNotification') data

    @ListNotifications
    Scenario: List unread notifications
        * def data = 
        """
        {
            authorization: #(requesterAccessToken),
            params: {
                "status": 'UNREAD', 
                "limit" : 10,
                "offset" : 0, 
                "sort" : 'DESC'
            }
        }
        """
        * call read(svc + 'notificationSvc.feature@ListNotifications') data

    @AddTokenNotification
    Scenario: Add Token Notification
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                token : #(token), //string
                deviceId : #(deviceId) //string
            }
        }
        """
        * call read(svc + 'notificationSvc.feature@AddTokenNotification') data
     
    @GetSettings
    Scenario: Get Settings
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken)
        }
        """
        * call read(svc + 'notificationSvc.feature@GetSettings') data
     
    @SetupNotificationSettings
    Scenario: Setup Notification Settings
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                transactions : #(transactions), //null
                policy : #(policy), //null
                usersAndDevices : #(usersAndDevices), //null
                announcements : #(announcements) //boolean
            }
        }
        """
        * call read(svc + 'notificationSvc.feature@SetupNotificationSettings') data

    @ReplaceDeviceToken
    Scenario: Replace Device Token
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                token : #(token) //string
            }
        }
        """
        * call read(svc + 'notificationSvc.feature@ReplaceDeviceToken') data
     
    @ReadNotification
    Scenario: Read Notification
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                id : #(id) //string
            }
        }
        """
        * call read(svc + 'notificationSvc.feature@ReadNotification') data

    @UnreadCount
    Scenario: Unread Count
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken)
        }
        """
        * call read(svc + 'notificationSvc.feature@UnreadCount') data

    @GetByNotificationId
    Scenario: Get By Notification Id
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            notificationId : #(notificationId) //string
        }
        """
        * call read(svc + 'notificationSvc.feature@GetByNotificationId') data
    
    @DeleteNotificationById
    Scenario: Delete Notification By Id
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            notificationId : #(notificationId) //string
        }
        """
        * call read(svc + 'notificationSvc.feature@DeleteNotificationById') data




