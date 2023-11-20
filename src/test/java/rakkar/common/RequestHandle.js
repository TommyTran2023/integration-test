function fn(){
    function cancelRequest(requestId){
        // Cancel pending request if have
        if (requestId != null){
            karate.log('Cancel requestId: ' + requestId)
            var cancel = karate.call(svc + 'Quorums.feature@CancelRequest', {requestId:requestId} ) 

            if (cancel.responseStatus != 200)
                throw new TypeError('Cannot reject request. Error: ' + JSON.stringify(cancel, null, 4))
        }   
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
        cancelAllMyTransferPendingRequest: function(userId){
            // Get all my pending requests
            var data = {requestCategories:["TRANSFER"], createdBy: userId, status : ["PENDING"]}
            var requests = karate.call(svc + 'Quorums.feature@GetMyRequests', data)

            // Cancel requests
            for(var i = 0; i < requests.length; i++) {
                cancelRequest(requests[i].id)
            }
        },
        cancelAllEditUserPendingRequest: function(userId){
            // Get all my pending requests
            var data = {requestCategories:["USER"], createdBy: userId, status : ["PENDING"]}
            var requests = karate.call(svc + 'Quorums.feature@GetMyRequests', data)

            // Cancel requests
            for(var i = 0; i < requests.length; i++) {
                cancelRequest(requests[i].id)
            }
        }
    }
}