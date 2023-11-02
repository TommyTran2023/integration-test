@RAKCON-10583
Feature: Group Policies

    Background:
    * url baseMobileURL
    * call read('this:RequesterAuthenticator.feature@RequesterAccessToken')

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
        * call read('this:Common.feature@FIDO-Requester')
        * header challenge-answer = challengeAnswerRequest
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

    @RAKCON-18248 @EditMembersInGroup @ignore
    Scenario: Edit Members In Group
        # Get another random user from list of users
        * call read('this:Vault.feature@CHECK-LIST-USER')
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

