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
