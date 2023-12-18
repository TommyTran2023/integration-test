function fn(){
    return {
        createChangeRoleRequest(userId){
            var userDetails = karate.call(svc + 'Auth.feature@GetUserDetailById', {userId: userId})
            var requestId = userDetails.response.data.pendingRequestId
            
            if (requestId != null){
                return requestId
            }
            
            var biometric = karate.call(svc + 'Biometric.feature@RequesterDoBiometric')
            var data = { 
                reason:'Note',
                roleWillUpdate:'ADMIN',
                vaultsWillRemoveAccess:[], 
                vaultsWillAddAccess: [],
                isRemoveAccountAccess: false,
                userId: userId,
                challengeAnswerRequest: biometric.challengeAnswerRequest
            }
            karate.call(svc + 'Auth.feature@UpdateUser', data)

            userDetails = karate.call(svc + 'Auth.feature@GetUserDetailById', {userId: userId})
            return userDetails.response.data.pendingRequestId
        },

        createAddVaultAccessRequest(userId){
            var userDetails = karate.call(svc + 'Auth.feature@GetUserDetailById', {userId: userId})
            var requestId = userDetails.response.data.pendingRequestId
            
            if (requestId != null){
                var biometric = karate.call(svc + 'Biometric.feature@RequesterDoBiometric')
                karate.call(svc + 'Quorums.feature@CancelRequest', {requestId:requestId , challengeAnswerRequest: biometric.challengeAnswerRequest} ) 
            }

            var vaultUnassign = karate.call(svc + 'Vault.feature@GetListVaultUnassigned', {userId: userId})
            var biometric = karate.call(svc + 'Biometric.feature@RequesterDoBiometric')
            var data = { 
                reason:'Note',
                roleWillUpdate:'ADMIN',
                vaultsWillRemoveAccess:[], 
                vaultsWillAddAccess: [vaultUnassign.response.data.vaults[0].id],
                isRemoveAccountAccess: false,
                userId: userId,
                challengeAnswerRequest: biometric.challengeAnswerRequest
            }
            karate.call(svc + 'Auth.feature@UpdateUser', data)

            userDetails = karate.call(svc + 'Auth.feature@GetUserDetailById', {userId: userId})
            return userDetails.response.data.pendingRequestId
        }
    }
}