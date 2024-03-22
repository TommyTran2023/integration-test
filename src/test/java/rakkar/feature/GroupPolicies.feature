@RAKCON-10583
Feature: Group Policies

    Background:
        * url baseURL
        * call read('this:RequesterAuthenticator.feature@RequesterAccessToken')
        * def groupHandle = read('classpath:rakkar/common/GroupHandle.js')
        * def requestHandle = read('classpath:rakkar/common/RequestHandle.js')

    @ignore @GetGroupPolicies
    Scenario: Get Group Policies
        Given path '/advance-quorum/group-policies'
        And param limit = 10
        And param offset = 0
        When method GET
        Then status 200
        * def groups = response.data.groups

    @ignore @GenerateGroupName
    Scenario: Generate vault name
        * def now = function(){ return java.lang.System.currentTimeMillis() }
        * def groupName = 'AT-RAK-GR' + now()

    @ignore @ValidateGroupPolicies
    Scenario: Validate Group Policies
        Given path '/advance-quorum/group-policies/validate-group-policy'
        * request requestBody
        When method POST
        Then status 201
        * match response.data == { "isValid": true }
        * match response.code == 200
        * match response.status == 'success'

    @RAKCON-18242 @EditGroupWithNewName
    Scenario: Edit Group name With New Name
        * call read('this:GroupPolicies.feature@GetGroupPolicies')
        * call read('this:GroupPolicies.feature@GenerateGroupName')
        * def requestBody = { "groupName": '#(groupName)' }
        * call read('this:GroupPolicies.feature@ValidateGroupPolicies')
        Given path '/advance-quorum/group-policies/'+groups[0].id
        * request { "name": '#(groupName)' }
        When method POST
        Then status 201
        * match response.data == true
        * match response.code == 200
        * match response.status == 'success'

    @RAKCON-18245 @EditDuplicateGroupName
    Scenario: Edit Duplicate Group Name
        * call read('this:GroupPolicies.feature@GetGroupPolicies')
        Given path '/advance-quorum/group-policies/'+groups[0].id
        * request { "name": '#(groups[1].name)' }
        When method POST
        Then status 404
        * match response.errorCode == "GROUP_NAME_EXISTS"
        * match response.message == "GROUP_NAME_EXISTS"
        * match response.code == 404
        * match response.status == 'error'

    @RAKCON-18246 @ViewGroupDetails
    Scenario: View Group Details
        * call read('this:GroupPolicies.feature@GetGroupPolicies')
        Given path '/advance-quorum/group-policies/'+groups[0].id
        When method GET
        Then status 200
        * match response.data.id == groups[0].id
        * match response.data.name == groups[0].name
        * assert response.data.memberInfos.length == groups[0].numMemberInGroup

    @RAKCON-18247 @SearchUserInGroupDetails
    Scenario: Search User In Group Details
        * def groupDetails = call read('this:GroupPolicies.feature@ViewGroupDetails')
        * def username = karate.lowerCase(groupDetails.response.data.memberInfos[0].name)
        Given path '/advance-quorum/group-policies/'+groupDetails.response.data.id
        And param keywordUser = username
        When method GET
        Then status 200
        * def compare = function(x){ return karate.lowerCase(x.name).contains(username) }
        * for(var i = 0; i < response.data.memberInfos.length; i++) karate.match(compare(response.data.memberInfos[i]), true)

    @RAKCON-18248 @CreateAndEditMembersInGroup @ignore
    Scenario: Create and Edit Members In Group
        # Get another random user from list of users
        * def listUsers = call read('this:Vault.feature@CHECK-LIST-USER')
        * def JSONpath = "$..ADMIN[?(@.userId!='#(requesterUserID)' || @.userId!='#(approvalUserID)' || @.userId!='#(adminUserID)')]"
        * def userToAdd = karate.jsonPath(listUsers.response.data,JSONpath)
        * def random = function(){ return Math.floor(Math.random() * userToAdd.length) }
        * def randomUserId = userToAdd[random()].userId
        # Get Group Policy to edit
        * call read('this:GroupPolicies.feature@GetGroupPolicies')
        * def groupDetails = call read('this:GroupPolicies.feature@ViewGroupDetails')
        * def requestId = groupDetails.response.data.editRequestId
        * if (requestId != null) karate.call('this:RejectRequest.feature@RejectRequestCommon')
        * call read('this:GroupPolicies.feature@GenerateGroupName')
        * def requestBody = 
        """
            {
                 "groupName": '#(groupName)', 
                 "exceptGroupId": '#(groups[0].id)' , 
                 "userIds": [#(requesterUserID), #(approvalUserID), #(adminUserID), #(randomUserId)]
            }
        """
        # Validate Group Policy
        * call read('this:GroupPolicies.feature@ValidateGroupPolicies')
        * call read('this:Common.feature@FIDO-Requester')
        * header challenge-answer = challengeAnswerRequest
        * header passcode = requesterInfo.requesterPasscode
        Given path '/advance-quorum/group-policies/'+groups[0].id
        * request { "memberIds": [#(requesterUserID), #(approvalUserID), #(adminUserID), #(randomUserId)]}
        When method PUT
        Then status 200
        * match response.code == 200
        * match response.status == 'success'
        * def groupDetails = call read('this:GroupPolicies.feature@ViewGroupDetails')
        * match groupDetails.response.data contains { "editRequestId" : '#uuid'}

    @RAKCON-18248 @CreateAndEditMembersInGroup @MOB-77
    Scenario: Edit group member
        # Select an existing group
        * call read('@GetGroupForEdit')

        # Select a user to add
        * def listUsers = karate.call(svc + 'Auth.feature@GetListUsers').allUsers
        * def newUser = listUsers.find(x => !memberIds.includes(x.userId))
        * memberIds.push(newUser.userId)

        # Edit group
        * def data =
        """
        {
            groupName: "#(group.name)",
            userIds: "#(memberIds)",
            exceptGroupId: "#(group.id)"
        }
        """
        * call read(svc + 'Group.feature@ValidateGroupPolicy') data
        Then match responseStatus == 201

        * def data = 
        """
        {
            groupId: "#(group.id)",
            name: "#(group.name)",
            memberIds: "#(memberIds)"
        }
        """
        * call read(svc + 'Biometric.feature@RequesterDoBiometric')
        * call read(svc + 'Group.feature@EditGroupMember') data
        Then match responseStatus == 200

        # View request and total check total members
        * def groupDetails = call read(svc + 'Group.feature@GetGroupDetails') { groupId: #(group.id) }
        * def requestDetails = call read(svc + 'Quorums.feature@ViewAccountPolicyRequest') {requestId: #(groupDetails.response.data.editRequestId)}
        * print requestDetails.response
        * assert (requestDetails.response.data.currentMember.length + requestDetails.response.data.newMember.length + requestDetails.response.data.removeMember.length) == memberIds.length
        

    @ignore @GetGroupForEdit
    Scenario: Get Group for Edit
        * def group = groupHandle().selectGroupForEdit()
        * requestHandle().cancelPendingRequest(group.editRequestId)
        * def memberIds = group.memberInfos.map(x => x.userId)

    @RAKCON-25631 @CreateAndDeleteGroup @MOB-153
    Scenario: Create and Delete Group
        * def createdGroup = call read('@CreateGroup')
        # Search for created group
        * def groups = call read(svc + 'Group.feature@GetGroupPolicies') {keyword: #(createdGroup.response.data.name)}
        * assert groups.response.data.groups.length > 0
        * call read('@DeleteGroup') {groupId: #(createdGroup.response.data.id)}

    @CreateGroup @ignore
    Scenario: Create Group
        * call read('@GenerateGroupName')
        * call read(svc + 'Group.feature@ValidateGroupPolicy') { groupName: "#(groupName)" }
        Then match responseStatus == 201

        * def listUsers = call read(svc + 'Auth.feature@GetListUsers')
        * def data =
        """
        {
            groupName: "#(groupName)",
            userId: #(listUsers.vaultMemberList)
        }
        """
        * call read(svc + 'Group.feature@ValidateGroupPolicy') data
        Then match responseStatus == 201

        * call read(svc + 'Biometric.feature@RequesterDoBiometric')
        * def data =
        """
        {
            name: "#(groupName)",
            memberIds: #(listUsers.vaultMemberList)
        }
        """
        * call read(svc + 'Group.feature@CreateGroupUsers') data
        Then match responseStatus == 201


    @DeleteGroup @ignore
    Scenario: Delete Group
        * call read(svc + 'Group.feature@ValidateDeleteGroup') {groupId: #(groupId)}
        Then match responseStatus == 200
        And match response == {"status":"success","code":200}

        * call read(svc + 'Biometric.feature@RequesterDoBiometric')
        * call read(svc + 'Group.feature@DeleteGroup') {groupId: #(groupId)}
        Then match responseStatus == 200

    @ignore @GetNormalGroup
    Scenario: Get Normal Group
        * def group = groupHandle().selectNormalGroup()
        * requestHandle().cancelPendingRequest(group.editRequestId)
        * def memberIds = group.memberInfos.map(x => x.userId)

    @RAKCON-25916 @MOB-77 @ValidateEditGroupWith1User
    Scenario: Validate edit group with 1 user
        * call read('@GetNormalGroup')
        * def data =
        """
        {
            exceptGroupId: "#(group.id)",
            groupName: "#(group.name)",
            userIds: "#(memberIds.slice(0,1))"
        }
        """
        * call read(svc + 'Group.feature@ValidateGroupPolicy') data
        Then match responseStatus == 400
        And match response == {"status":"error","errorCode":"Bad Request","message":"userIds must contain at least 2 elements","code":400}
    
    @RAKCON-25917 @MOB-77 @ValidateEditGroupWith2User
    Scenario: Validate edit group with 2 user
        * call read('@GetNormalGroup')
        * def data =
        """
        {
            exceptGroupId: "#(group.id)",
            groupName: "#(group.name)",
            userIds: "#(memberIds.slice(0,2))"
        }
        """
        * call read(svc + 'Group.feature@ValidateGroupPolicy') data
        Then match responseStatus == 201
        And match response == {"status":"success","code":200,"data":{"isValid":true}}

    @RAKCON-25632 @MOB-77 @EditGroupWith1User
    Scenario: Edit Group With 1 User
        * call read('@GetNormalGroup')
        
        # Edit group
        * def data = 
        """
        {
            groupId: "#(group.id)",
            name: "#(group.name)",
            memberIds: "#(memberIds.slice(0,1))"
        }
        """
        * call read(svc + 'Biometric.feature@RequesterDoBiometric')
        * call read(svc + 'Group.feature@EditGroupMember') data
        Then match responseStatus == 400
        And match response == {"status":"error","errorCode":"THERE_CANNOT_BE_FEWER_THAN_TWO_MEMBERS","message":"THERE_CANNOT_BE_FEWER_THAN_TWO_MEMBERS","code":400}
    
    @RAKCON-25658 @MOB-77 @ValidateEditGroupWithSameSetUser
    Scenario: Validate Edit Group With Same Set Of Users
        * def groups = groupHandle().selectGroupsForSameSet()
        * print groups
        * def group1 = groups[0]
        * def group2 = groups[1]
        * def data =
        """
        {
            exceptGroupId: "#(group1.id)",
            groupName: "#(group1.name)",
            userIds: "#(group2.memberInfos.map(x => x.userId))"
        }
        """
        * call read(svc + 'Group.feature@ValidateGroupPolicy') data
        Then match responseStatus == 201
        And match response == {"status":"success","code":200,"data":{"isValid":false,"errorCode":"GROUP_MEMBER_PART_OF_ANOTHER"}}

    @RAKCON-25918 @MOB-77 @EditGroupHavePendingVaultPolicy
    Scenario: Edit Group Have Pending Vault Policy
        * def group = groupHandle().selectGroupHavePendingPolicyRequest()
        * call read(svc + 'Group.feature@ValidatePrerequisitesGroup') {groupId: #(group.id)}
        Then match responseStatus == 400
        And match response == {"status":"error","errorCode":"msg-edit-group:GROUP_HAS_PENDING_VAULT_POLICY_REQUEST","message":"msg-edit-group:GROUP_HAS_PENDING_VAULT_POLICY_REQUEST","code":400}

    @RAKCON-25919 @MOB-77 @EditGroupMemberInMultipleVaultPolicies
    Scenario: Edit Group Member In Multiple Vault Policies
        * def group = groupHandle().selectGroupHaveMultiplesPolicy()
        * def data =
        """
        {
            exceptGroupId: "#(group.id)",
            groupName: "#(group.name)",
            userIds: "#(group.memberInfos.map(x => x.userId).slice(1))"
        }
        """
        * call read(svc + 'Group.feature@ValidateGroupPolicy') data
        Then match responseStatus == 201
        And match response == {"status":"success","code":200,"data":{"isValid":false,"errorCode":"GROUP_MEMBER_REMOVE_USER_FROM_THE_GROUP"}}

        * def data =
        """
        {
            countAdded: 0,
            countRemoved: 1,
            groupId: "#(group.id)"
        }
        """
        * call read(svc + 'Group.feature@AdvVaultByGroup') data
        Then match responseStatus == 200
        * assert response.data.total > 0
        * assert response.data.data.length > 0
        * def expectedVaultDetail = 
        """
        {
            "id":"##uuid",
            "vaultExternalId":"#string",
            "name":"#string",
            "hiddenOnUI":"#boolean",
            "customerRefId":"##string",
            "autoFuel":"#boolean",
            "status":"#string",
            "customerId":"#string",
            "type":"#string",
            "createdAt":"#string",
            "updatedAt":"#string"
        }
        """
        * match each response.data.data == expectedVaultDetail

    @RAKCON-25920 @MOB-77 @EditGroupHavePendingRequest
    Scenario: Edit Group have pending request
        * def group = groupHandle().selectGroupHavePendingRequest()
        * match group.editRequestId == "#uuid"
        * def data =
        """
        {
            exceptGroupId: "#(group.id)",
            groupName: "#(group.name)",
            userIds: "#(group.memberInfos.map(x => x.userId).slice(1))"
        }
        """
        * call read(svc + 'Group.feature@ValidateGroupPolicy') data
        Then match responseStatus == 201
        And match response == {"status":"success","code":200,"data":{"isValid":false,"errorCode":"GROUP_PENDING_REQUEST"}}

    @RAKCON-25996 @MOB-154 @EditViewerGroup
    Scenario: Edit Group - Select all Viewers
        * def group = groupHandle().selectViewerGroup()
        * def viewers = group.memberInfos.filter(x => x.role == "VIEWER").map(x => x.userId)
        * def data =
        """
        {
            exceptGroupId: "#(group.id)",
            groupName: "#(group.name)",
            userIds: "#(viewers)"
        }
        """
        * call read(svc + 'Group.feature@ValidateGroupPolicy') data
        Then match responseStatus == 201
        Then match response.data.isValid == true

        * def data = 
        """
        {
            groupId: "#(group.id)",
            name: "#(group.name)",
            memberIds: "#(viewers)"
        }
        """
        * call read(svc + 'Biometric.feature@RequesterDoBiometric')
        * call read(svc + 'Group.feature@EditGroupMember') data
        Then match responseStatus == 200

    @RAKCON-25997 @MOB-154 @EditAndAddViewerToGroup
    Scenario: Edit groups and add viewer to group
        * def selectAdminOnlyGroup = groupHandle().selectAdminOnlyGroup()
        * print selectAdminOnlyGroup
        * def group = selectAdminOnlyGroup.group
        * def viewerId = selectAdminOnlyGroup.viewers.userId
        * def memberIds = group.memberInfos.map(x => x.userId)
        * memberIds.push(viewerId)
        * def data =
        """
        {
            exceptGroupId: "#(group.id)",
            groupName: "#(group.name)",
            userIds: "#(memberIds)"
        }
        """
        * call read(svc + 'Group.feature@ValidateGroupPolicy') data
        Then match responseStatus == 201
        Then match response.data.isValid == true

        * def data = 
        """
        {
            groupId: "#(group.id)",
            name: "#(group.name)",
            memberIds: "#(memberIds)"
        }
        """
        * call read(svc + 'Biometric.feature@RequesterDoBiometric')
        * call read(svc + 'Group.feature@EditGroupMember') data
        Then match responseStatus == 200

    @MOB-153 @CannotDeleteGroupUsingOnQuorum
    Scenario: Cannot Delete Group Using On Quorum
        * def group = groupHandle().selectGroupHaveMultiplesPolicy()
        * call read(svc + 'Group.feature@ValidateDeleteGroup') {groupId: "#(group.id)"}
        Then match responseStatus == 400
        And match response == {"status":"error","errorCode":"msg-delete-group:REMOVE_GROUP_IS_EXISTS_VAULT","message":"msg-delete-group:REMOVE_GROUP_IS_EXISTS_VAULT","code":400}



