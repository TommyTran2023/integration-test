function fn(){
    function cancelRequestsByCategories(userId, categories){
        var data = {requestCategories: categories, userId: userId, status : ["PENDING"]}
        
        while(true){
            var requests = karate.call(svc + 'Quorums.feature@GetMyRequests', data)
            var records = requests.response.data.records

            if(records.length == 0)
                break

            // Cancel requests
            for(var i = 0; i < records.length; i++) {
                cancelRequest(records[i].id)
            }
        }
    }

    function cancelRequest(requestId){
        // Cancel pending request if have
        if (requestId != null){
            karate.log('Cancel requestId: ' + requestId)
            var biometric = karate.call(svc + 'Biometric.feature@RequesterDoBiometric')
            var cancel = karate.call(svc + 'Quorums.feature@CancelRequest', {requestId:requestId , challengeAnswerRequest: biometric.challengeAnswerRequest} ) 

            if (cancel.responseStatus != 200)
                throw new TypeError('Cannot cancel request. Error: ' + JSON.stringify(cancel, null, 4))
        }   
    }

    function generateRandomName(){
        return java.lang.System.currentTimeMillis()
    }

    return {
        cancelPendingRequestOnVault: function(vaultId){
            // Get vault detail
            var vaultDetails = karate.call(svc + 'Vault.feature@GetVaultDetail', {vaultId:vaultId})
            var requestId = vaultDetails.response.data.requestId

            cancelRequest(requestId)
        },

        cancelPendingRequest: function(requestId){
            cancelRequest(requestId)
        },

        cancelAllMyPendingRequest: function(userId){
            cancelRequestsByCategories(userId, [])
        },

        cancelAllMyTransferPendingRequest: function(userId){
            cancelRequestsByCategories(userId, ["TRANSFER"])
        },

        cancelAllEditUserPendingRequest: function(userId){
            cancelRequestsByCategories(userId, ["USER"])
        },

        createEditAccountPolicyRequest: function(){
            var policy = karate.call(svc + 'Quorums.feature@GetAccountPolicy')
            var pendingRequestId = policy.response.data.pendingRequestId
            
            if (pendingRequestId == null){
                var requesterInfo = karate.call(svc + 'Auth.feature@GetRequesterInfo')
                karate.call(svc + 'Customers.feature@EditAccountPolicy', {customerId: requesterInfo.response.data.customerId})
                policy = karate.call(svc + 'Quorums.feature@GetAccountPolicy')
                pendingRequestId = policy.response.data.pendingRequestId
            }
            
            return pendingRequestId
        },

        createNewWhitelistAddressRequest: function(type){
            var folderData = {
                name: type + '_folder - ' + generateRandomName(),
                type: type,
                note: 'create New Whitelist Address Request'
            }
            var folder = karate.call(svc + 'Whitelist.feature@CreateWhitelist', folderData)

            var addressData = {
                folderId: folder.response.data.id,
                tokenId: dataSet.tokenId,
                address: dataSet.address
            }
            karate.call(svc + 'Whitelist.feature@AddWhitelistAddress', addressData)

            // Search for latest New Whitelist Address
            var requesterInfo = karate.call(svc + 'Auth.feature@GetRequesterInfo')

            var searchData = {
                userId:requesterInfo.userId,
                status: ['PENDING'],
                requestCategories:["WHITELIST"]
            }
            var requests = karate.call(svc + 'Quorums.feature@GetMyRequests', searchData)

            return requests.response.data.records[0].id
        },

        createEditVaultPolicyToStandardRequest: function(vaultId, members){
            var editData = {
                vaultId: vaultId,
                note: "Edit Vault Policy To Standard Request",
                members: members
            }
            var editRequest = karate.call(svc + 'Vault.feature@EditVaultPolicy', editData)
            
            return editRequest.response.data.data.record.id
        }

        
    }
}