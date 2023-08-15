Feature: Group Policies

    Background:
    * url baseMobileURL
    * call read('RequesterAuthenticator.feature@RequesterAccessToken')

    @ignore @GetGroupPolicies
    Scenario: Get Group Policies
        Given path '/core/group-policies'
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
        * call read('Common.feature@FIDO-Requester')
        * header challenge-answer = challengeAnswerRequest
        Given path '/core/group-policies/validate-group-policy'
        * request requestBody
        When method POST
        Then status 201
        * match response.data == { "isValid": true }
        * match response.code == 200
        * match response.status == 'success'

    @RAKCON-18242 @EditGroupWithNewName
    Scenario: Edit Group name With New Name
        * call read('GroupPolicies.feature@GetGroupPolicies')
        * call read('GroupPolicies.feature@GenerateGroupName')
        * def requestBody = { "groupName": '#(groupName)' }
        * call read('GroupPolicies.feature@ValidateGroupPolicies')
        Given path '/core/group-policies/'+groups[0].id
        * request { "name": '#(groupName)' }
        When method POST
        Then status 201
        * match response.data == true
        * match response.code == 200
        * match response.status == 'success'

    @RAKCON-18245 @EditDuplicateGroupName
    Scenario: Edit Duplicate Group Name
        * call read('GroupPolicies.feature@GetGroupPolicies')
        Given path '/core/group-policies/'+groups[0].id
        * request { "name": '#(groups[1].name)' }
        When method POST
        Then status 404
        * match response.errorCode == "GROUP_NAME_EXISTS"
        * match response.message == "GROUP_NAME_EXISTS"
        * match response.code == 404
        * match response.status == 'error'

    @RAKCON-18246 @ViewGroupDetails
    Scenario: View Group Details
        * call read('GroupPolicies.feature@GetGroupPolicies')
        Given path '/core/group-policies/'+groups[0].id
        When method GET
        Then status 200
        * match response.data.id == groups[0].id
        * match response.data.name == groups[0].name
        * assert response.data.memberInfos.length == groups[0].numMemberInGroup

    @RAKCON-18247 @SearchUserInGroupDetails
    Scenario: Search User In Group Details
        * def groupDetails = call read('GroupPolicies.feature@ViewGroupDetails')
        * def username = groupDetails.response.data.memberInfos[0].name
        Given path '/core/group-policies/'+groupDetails.response.data.id
        And param keywordUser = username
        When method GET
        Then status 200
        * match each $response.data.memberInfos[*] contains { name : '#(username)' }

    @RAKCON-18248 @EditMembersInGroup
    Scenario: Edit Members In Group
        * call read('Vault.feature@CHECK-LIST-USER')
        * call read('GroupPolicies.feature@GetGroupPolicies')
        * def groupDetails = call read('GroupPolicies.feature@ViewGroupDetails')
        * call read('GroupPolicies.feature@GenerateGroupName')
        * def requestBody = { "groupName": '#(groupName)', "exceptGroupId": '#(groups[0].id)' , "userIds": [#(requesterUserID), #(approvalUserID), #(adminUserID)]}
        * call read('GroupPolicies.feature@ValidateGroupPolicies')
        * call read('Common.feature@FIDO-Requester')
        * header challenge-answer = challengeAnswerRequest
        * header passcode = requesterInfo.requesterPasscode
        Given path '/core/group-policies/'+groups[0].id
        * request { "memberIds": ["#(requesterUserID)", "#(approvalUserID)", "#(adminUserID)"]}
        When method PUT
        Then status 200
        * match response.code == 200
        * match response.status == 'success'
        * def groupDetails = call read('GroupPolicies.feature@ViewGroupDetails')
        * match groupDetails.response.data contains { "editRequestId" : '#uuid'}

