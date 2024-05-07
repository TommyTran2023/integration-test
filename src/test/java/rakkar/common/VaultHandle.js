function fn(){
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

    return {
        generateVaultName: function(){
            return generateVaultName()
        },

        createStandardVault: function(memberIds, type){
            var data = {
                "memberRequiredApprove":[],
                "name": generateVaultName(),
                "hasRequiredApprover":false,
                "memberIds":memberIds,
                "type":type,
                "approverNumber": memberIds.length,
                "note":"AT Create Test Data"
            }

            var vault = karate.call(svc + 'Vault.feature@CreateVault', {requestBody:data})
            vault = karate.call(svc + 'Vault.feature@GetVaultDetail', {vaultId:vault.response.data.id})
            
            // return vault detail
            return vault.response
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
                passcode: requesterInfo.requesterPasscode,
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
                passcode: approverInfo.approverPasscode
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
        }
    }
}
