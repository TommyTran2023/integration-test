function fn(){
    var requestHandler = karate.call('classpath:rakkar/common/RequestHandle.js')
    var vaultHandle = karate.call('classpath:rakkar/common/VaultHandle.js')
    var commonHandle = karate.call('classpath:rakkar/common/CommonHandle.js')
    var userHandle = karate.call('classpath:rakkar/common/UserHandle.js')

    function generateGroupName(){
        var now = function(){ return java.lang.System.currentTimeMillis() }
        return 'AT-' + now()
    }

    function getGroupNewMembers(existingMembers, memberSize) {
        var requesterUsername = requesterInfo.requesterUsername
        var allUsers = karate.call(svc + 'Auth.feature@GetListUsers').response.data.users
        var my = allUsers.find(u => u.username == requesterUsername)
        allUsers = allUsers.filter(u => u.username != requesterUsername && !u.username.contains('clean'))
        var newMemberList

        allUsers = commonHandle.shuffleArr(allUsers)

        if (existingMembers != null && existingMembers.length > 0) {
            var existingIds = existingMembers.map(x => x.userId)
            newMemberList = allUsers.filter(u => !existingIds.include(u.userId)).slice(0, memberSize-1)
        }
        else {
            newMemberList = allUsers.slice(0, memberSize-1)
        }
        newMemberList.push(my)
        return newMemberList
    }

    function selectGroupByName(groupName, expectedMembers) {
        var groups = karate.call (svc + 'Group.feature@GetGroupPolicies', { keyword: groupName }).response.data.groups
        var groupId

        if (groups.length > 0) {
            groupId = groups[0].id
        }
        else {
            if (!expectedMembers)
                expectedMembers = 4

            if (typeof expectedMembers == "number")
                expectedMembers = getGroupNewMembers(null, expectedMembers)

            var bio = karate.call(svc + 'Biometric.feature@ApproverDoBiometric')
            var data = {
                challengeAnswerRequest: bio.challengeAnswerApprover,
                name: groupName + generateGroupName(),
                memberIds: expectedMembers.map(u => u.userId)
            }
            groupId = karate.call(svc + 'Group.feature@CreateGroupUsers', data).response.data.id
        }
        
        return karate.call(svc + 'Group.feature@GetGroupDetails', { groupId: groupId }).response.data
    }

    return {
        getGroupNewMembers: function(existingMembers, memberSize) {
            return getGroupNewMembers(existingMembers, memberSize)
        },

        selectNormalGroup: function() {
            var groupName = "Normal "
            return selectGroupByName(groupName, 4)
        },

        selectGroupForEdit: function() {
            var groupName = "Edit "
            return selectGroupByName(groupName, 4)
        },

        selectGroupHaveUserPendingRequest: function() {
            var groupName = "Pending User "
            var group = selectGroupByName(groupName, 4)
            var members = group.memberInfos
            var editUserId = members.find(u => u.userName != requesterInfo.requesterUsername).userId

            var editUserRequest = userHandle.createChangeRoleRequest(editUserId)
            
            return {editedUserId: editUserId, editRequestId: editUserRequest, group: group}
        },

        selectGroupHavePendingPolicyRequest: function() {
            var groupName = "Pending Vault Policy "
            var group = selectGroupByName(groupName, 4)
            var members = group.memberInfos
            var vault
            
            if (group.vaultInfos.length == 0) {
                
                var memberList = [
                    { groups: [group] },
                    { users: getGroupNewMembers(null, 3) }
                ]
                
                vault = vaultHandle.createAdvanceVault(memberList, "COLD_WALLET")
            }
            else {
                vault = karate.call(svc + 'Vault.feature@GetVaultDetail', {vaultId: group.vaultInfos[0].id}).response.data
            }

            if (!vault.requestId) {
                var memberList = [
                    { groups: [group] },
                    { users: getGroupNewMembers(null, 4) }
                ]
                vaultHandle.createEditAdvPolicyRequest(memberList, vault.id)

                group = selectGroupByName(groupName, members)
            }

            return group
        },

        selectGroupHaveMultiplesPolicy: function() {
            var groupName = "Multiple Policy "
            var group = selectGroupByName(groupName, 4)
            
            if (group.vaultInfos.length < 2) {
                var members = group.memberInfos
                
                var memberList = [
                    { groups: [group], quorumApprovals: members.length },
                    { users: getGroupNewMembers(null, 3) }
                ]
                
                vaultHandle.createAdvanceVault(memberList, "COLD_WALLET")
                vaultHandle.createAdvanceVault(memberList, "COLD_WALLET")
            }
            
            return group
        },

        selectGroupHavePendingRequest: function() {
            var groupName = "Pending Request "
            var group = selectGroupByName(groupName, 5)

            if (!group.editRequestId) {
                var bio = karate.call(svc + 'Biometric.feature@RequesterDoBiometric')
                var data = {
                    accessToken:bio.requesterAccessToken,
                    challengeAnswerRequest:bio.challengeAnswerRequest,
                    groupId: group.id,
                    name: group.name,
                    memberIds: group.memberInfos.map(x => x.userId).slice(1)
                }
                karate.call(svc + 'Group.feature@EditGroupMember', data)

                return selectGroupByName(groupName, null)
            }
            else
                return group
        },

        selectViewerGroup: function() {
            var groupName = "Viewers Group "
            var allUsers = karate.call(svc + 'Auth.feature@GetListUsers').allUsers
            
            var someAdmin = allUsers.filter(x => x.role != "VIEWER").slice(0,2)
            var viewers =  allUsers.filter(x => x.role == "VIEWER")
            
            var group = selectGroupByName(groupName, someAdmin.concat(viewers))
            
            requestHandler.cancelPendingRequest(group.editRequestId)
            
            return group
        },

        selectAdminOnlyGroup: function() {
            var groupName = "Admin Group "
            var allUsers = karate.call(svc + 'Auth.feature@GetListUsers').allUsers
            
            var someAdmin = commonHandle.shuffleArr(allUsers).filter(x => x.role == "ADMIN").slice(0,2)
            var viewers =  allUsers.find(x => x.role == "VIEWER")
            
            var group = selectGroupByName(groupName, someAdmin)
            
            requestHandler.cancelPendingRequest(group.editRequestId)

            return {group: group, viewers: viewers}
        },

        selectGroupsForSameSet: function() {
            var group1 = selectGroupByName("Group Set 1", null)
            var group2 = selectGroupByName("Group Set 2", null)

            return [group1, group2]
        },

        selectGroupForChangePolicy: function() {
            var allUsers = karate.call(svc + 'Auth.feature@GetListUsers').response.data.users
            var admin = allUsers.find(x => x.role == "ADMIN" && x.username.contains("clean"))
            var member = allUsers.find(x => x.role == "MEMBER")
            var viewer = allUsers.find(x => x.role == "VIEWER")

            karate.log(allUsers)
            var group = selectGroupByName("Full Role ", [admin, member, viewer])

            if (group.vaultInfos.length == 0){
                var members = group.memberInfos
                
                var memberList = [
                    { groups: [group], quorumApprovals: members.length },
                    { users: getGroupNewMembers(null, 3) }
                ]
                vaultHandle.createAdvanceVault(memberList, "COLD_WALLET")
            }

            return group
        }
    }
}