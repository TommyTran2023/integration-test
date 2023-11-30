function fn(){
    function cancelRequest(requestId){
        // Cancel pending request if have
        if (requestId != null){
            karate.log('Cancel requestId: ' + requestId)
            var cancel = karate.call(svc + 'Quorums.feature@CancelRequest', {requestId:requestId} ) 

            if (cancel.responseStatus != 200)
                throw new TypeError('Cannot cancel request. Error: ' + JSON.stringify(cancel, null, 4))
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
            var data = {requestCategories:["TRANSFER"], userId: userId, status : ["PENDING"]}
            var requests = karate.call(svc + 'Quorums.feature@GetMyRequests', data)
            var records = requests.response.data.records

            // Cancel requests
            for(var i = 0; i < records.length; i++) {
                cancelRequest(records[i].id)
            }
        },

        cancelAllEditUserPendingRequest: function(userId){
            // Get all my pending requests
            var data = {requestCategories:["USER"], userId: userId, status : ["PENDING"]}
            var requests = karate.call(svc + 'Quorums.feature@GetMyRequests', data)
            var records = requests.response.data.records

            // Cancel requests
            for(var i = 0; i < records.length; i++) {
                cancelRequest(records[i].id)
            }
        }
    }
}