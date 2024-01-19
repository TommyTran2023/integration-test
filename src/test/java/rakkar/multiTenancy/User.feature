@RAKCON-10583 @RAKCON-20140
Feature: Check Multi Tenancy for Users
    Background:
        * callonce read(svc + 'ReadData.feature')
        * call read(svc + 'Auth.feature@GetUserAccessToken') {userName:#(userOtherCustomerInfor.userName)}
        * def token = 'Bearer ' + response.data.AuthenticationResult.AccessToken   
        * callonce read(svc + 'Auth.feature@GetRequesterInfo')

    @RAKCON-21751
    Scenario: Search User of Cross tenant User
        * call read(svc + 'Auth.feature@GetUsers') {accessToken:#(token),keyword:#(requesterName)}
        * assert response.data.users.length == 0
    
    @RAKSEC-110 @RAKCON-21752
    Scenario: Get Cross tenant User details
        * call read(svc + 'Auth.feature@GetUserDetailById') {accessToken:#(token),userId:#(requesterID)}
        * assert responseStatus == 403
        
