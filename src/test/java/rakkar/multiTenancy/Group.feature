@RAKCON-10583 @RAKCON-20140
Feature: Check Multi Tenancy for Groups
    Background:
        * callonce read(svc + 'ReadData.feature')
        * call read(svc + 'Auth.feature@GetUserAccessToken') {userName:#(userOtherCustomerInfor.userName)}
        * def token = 'Bearer ' + response.data.AuthenticationResult.AccessToken   
        * callonce read(svc + 'Auth.feature@GetRequesterAccessToken')
        * def getGroups = callonce read(svc + 'Group.feature@GetGroupPolicies')

    @RAKCON-21741
    Scenario: Search Group of Cross Tenant
        * def groupName = getGroups.response.data.groups[0].name
        * call read(svc + 'Group.feature@GetGroupPolicies') {accessToken:#(token), keyword:#(groupName)}
        * assert response.data.groups.length == 0

    @RAKCON-21742
    Scenario: Get group details of Cross Tenant
        * def groupId = getGroups.response.data.groups[0].id
        * call read(svc + 'Group.feature@GetGroupDetails') {accessToken:#(token), groupId:#(groupId)}
        * match responseStatus == 404
        * match response.status == 'error'
        * match response.errorCode == 'GROUP_NOT_FOUND'
        * match response.code == 404

