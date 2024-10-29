function fn(){
    var requestHandler = karate.call('classpath:rakkar/common/RequestHandle.js')
    function generateVaultName(){
        var now = java.lang.System.currentTimeMillis()
        return 'AT-VRAK-'+now
    }

    function setUpAdvQuorum(memberList, isCreateQuorum = false) {
        var quorums = []

        for (var i in memberList){
            var q = memberList[i]
            var members = []
            
            if (q.users) {
                members = q.users.map( x => { return {
                    "userId": x.userId,
                    "role": x.role,
                    "roleDisplayName": x.roleDisplayName,
                    "isPendingRequest": false,
                    "type": "user"
                }})
            }

            if (q.groups) {
                var groups = q.groups.map( x => { return {
                    "name": x.name,
                    "numMemberInGroup": x.totalMember,
                    "users": x.memberInfos,
                    "members": x.memberInfos,
                    "type": isCreateQuorum ? "group" : "GROUP",
                    "groupName": x.name,
                    "groupId": x.id
                }})
            
                members = members?.concat(groups)
            }
            var quorumApprovals = q.quorumApprovals ? q.quorumApprovals : 1
            quorums.push({"members":members, quorumApprovals: quorumApprovals, isRequired: false})
        }

        return quorums
    }

    function demoteAdminMemberToViewerInAdvVault(userId, quorum){
        for (var i = 0; i < quorum.quorums.length; i++){
            var qu = quorum.quorums[i]
            var members = qu.members
            var user = members.find(u => u.userId == userId)

            if (user != null){
                quorum.viewers.push(user)

                var users = members.filter(u => u.userId != userId)
                qu.members = users

                return quorum
            }
        }
        
        var viewers = quorum.viewers
        var user = viewers.find(u => u.userId == userId)

        if(user == null){
            quorum.viewers.push({
                type: "USER",
                userId: userId
            })

            return quorum
        }

        throw new Error("Cannot demote user to viewer of quorum: " + userId + "\nquorum:\n" + JSON.stringify(quorum))
    }

    function addUserAsMemberToQuorum(userId, quorum){
        var usr = quorum.viewers.find(u => u.userId == userId)
        if (usr != null){
            quorum.viewers = quorum.viewers.filter(u => u.userId != userId)
        }

        quorum.quorums[0].members.push({
            type: "USER",
            userId: userId
        })

        return quorum
    }

    function editAdvPolicyRequest(vaultId, quorums, viewers, note){
        var vaultData = {
            vaultId: vaultId,
            policyType: "advanced",
            quorums: quorums,
            viewers: viewers,
            note: note
        }
        
        var request = karate.call(svc + 'Vault.feature@RequestUpdateVaultPolicy', vaultData).response.data

        var bio = karate.call(svc + 'Biometric.feature@RequesterDoBiometric')
        var submitData = {
            authorization: bio.requesterAccessToken,
            challengeAnswerRequest: bio.challengeAnswerRequest,
            vaultId: vaultId,
            requestDraftId: request.requestDraftId
        }
        var req = karate.call(svc + 'Vault.feature@SubmitRequestEditVaultPolicyByRequestDraftId', submitData).response.data.quorumDraftId
        requestHandler.approveTransaction(req)
    }

    return {
        generateVaultName: function(){
            return generateVaultName()
        },

        createStandardVault: function(){
            var listUsers = karate.call(svc + 'Auth.feature@GetListUsers').vaultMemberList
            var bio = karate.call(svc + 'Biometric.feature@RequesterDoBiometric')
            var data = {
                "memberRequiredApprove":[],
                "name": generateVaultName(),
                "hasRequiredApprover":false,
                "memberIds":listUsers,
                "type":"HOT_WALLET",
                "approverNumber": 2,
                "note":"AT Create Test Data"
            }

            var vault = karate.call(svc + 'Vault.feature@CreateVault', {requestBody:data, authorization: bio.requesterAccessToken, challengeAnswerRequest: bio.challengeAnswerRequest})
            vault = karate.call(svc + 'Vault.feature@GetVaultDetail', {vaultId:vault.response.data.id})
            
            // return vault detail
            return vault.response.data
        },

        archiveVault: function(vaultId){
            karate.call(svc + 'Vault.feature@UnhideVault', {vaultId:vaultId})
        },

        createAdvanceVault: function(memberList, vaultType) {
            var quorums = setUpAdvQuorum(memberList, true)

            var data = {
                "name": "Adv " + generateVaultName(),
                "approverNumber": 2,
                "type": vaultType,
                "clientId": "FYlhu36Ts-qTLLnOAAE2",
                "quorums": quorums,
                "policyType": "advanced",
                "viewers": []
            }
            var request = karate.call(svc + 'Vault.feature@RequestCreateAdvVault', {requestBody: data})

            var bio = karate.call(svc + 'Biometric.feature@RequesterDoBiometric')
            data = {
                accessToken: bio.requesterAccessToken, 
                challengeAnswerRequest: bio.challengeAnswerRequest,
                passcode: requesterPasscode,
                notificationId: request.response.data.notificationId
            }
            var submit = karate.call(svc + 'Vault.feature@SubmitRequestCreateVault', data).response.data

            // View vault details to get vault id
            var vaultId = submit.vaultId
            var vault = karate.call(svc + 'Vault.feature@GetVaultDetail', { vaultId: vaultId }).response.data
            
            bio = karate.call(svc + 'Biometric.feature@ApproverDoBiometric')
            data = {
                requestId: vault.requestId,
                approvalAccessToken: bio.approvalAccessToken, 
                challengeAnswerApprover: bio.challengeAnswerApprover,
                passcode: approverPasscode
            }
            karate.call(svc + 'Quorums.feature@ApproveRequest', data)
            vault = karate.call(svc + 'Vault.feature@GetVaultDetail', { vaultId: vaultId }).response.data

            return vault
        },

        setUpAdvQuorum(memberList) {
            return setUpAdvQuorum(memberList) 
        },

        createEditAdvPolicyRequest: function(memberList, vaultId){
            var vaultData = {
                vaultId: vaultId,
                policyType: "advanced",
                quorums: setUpAdvQuorum(memberList),
                viewers: [],
                clientId: "FYlhu36Ts-qTLLnOAAE2"
            }
            var request = karate.call(svc + 'Vault.feature@RequestUpdateVaultPolicy', vaultData).response.data

            var bio = karate.call(svc + 'Biometric.feature@RequesterDoBiometric')
            var submitData = {
                authorization: bio.requesterAccessToken,
                challengeAnswerRequest: bio.challengeAnswerRequest,
                vaultId:vaultId,
                requestDraftId: request.requestDraftId
            }
            return karate.call(svc + 'Vault.feature@SubmitRequestEditVaultPolicyByRequestDraftId', submitData).response
        },

        getCurrentVaultQuorum: function(vaultId){
            var vault = karate.call(svc + 'Vault.feature@GetVaultDetail', { vaultId: vaultId }).response
            return karate.call(svc + 'Quorums.feature@GetQuorumPolicy', { quorumId: vault.data.quorumId }).response.data 
        },

        removeUserFromVaultQuorum: function(userId, vault){
            if (vault.policyType == 'standard'){
                throw new Error("Not implemeted")
            }
            else {
                var quorum = karate.call(svc + 'Quorums.feature@GetQuorumPolicy', { quorumId: vault.quorumId }).response.data 
                quorum = demoteAdminMemberToViewerInAdvVault(userId, quorum)

                editAdvPolicyRequest(vault.id, quorum.quorums, quorum.viewers, "MOB-3356 removeUserFromVaultQuorum")
            }
        },

        addUserAsMemberToVaultQuorum: function(userId, vault){
            if (vault.policyType == 'advanced'){
                var quorum = karate.call(svc + 'Quorums.feature@GetQuorumPolicy', { quorumId: vault.quorumId }).response.data 
                var index = -1
                for (var i = 0; i < quorum.quorums.length; i++) {
                    var q = quorum.quorums[i]
                    if (q.members.find(u => u.userId == userId) != null){
                        index = i
                        break
                    }
                }

                if (index == -1){
                    quorum = addUserAsMemberToQuorum(userId, quorum)

                    editAdvPolicyRequest(vault.id, quorum.quorums, quorum.viewers, "MOB-3356 addUserAsMemberToVaultQuorum")
                }
            }
            else {
                throw new Error("Not implemeted for Vault Policy: " + vault.policyType)
            }
        }
    }
}
