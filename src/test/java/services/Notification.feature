Feature: Notitication  

  Background:
    * def svc = 'classpath:services/'

    @ReadNotificationById
    Scenario: Read notification by id
        * call read(svc + 'notificationSvc.feature@ReadNotification') {notificationId:'#(notificationId)', authorization:#(requesterAccessToken)}

    @ListNotifications
    Scenario: List unread notifications
        * def params = 
        """
            {
                "status": 'UNREAD', 
                "limit" : 10,
                "offset" : 0, 
                "sort" : 'DESC'
            }
        """
        * call read(svc + 'notificationSvc.feature@ListNotifications') {params: '#(params)', authorization:#(requesterAccessToken)}
