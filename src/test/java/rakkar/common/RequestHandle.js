function fn(){
    function cancelRequestsByCategories(userId, categories){
        var data = {requestCategories: categories, userId: userId, status : ["PENDING"]}
        var requests = karate.call(svc + 'Quorums.feature@GetMyRequests', data)
        var records = requests.response.data.records

        // Cancel requests
        for(var i = 0; i < records.length; i++) {
            cancelRequest(records[i].id)
        }
    }

    function cancelRequest(requestId){
        // Cancel pending request if have
        if (requestId != null){
            karate.log('Cancel requestId: ' + requestId)
            var biometric = karate.call(svc + 'Biometric.feature@RequesterDoBiometric')
            var cancel = karate.call(svc + 'AdvanceQuorum.feature@CancelRequest', {requestId:requestId , challengeAnswerRequest: biometric.challengeAnswerRequest} ) 

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

            cancelRequest(vaultDetails.response.data.requestId)
        }, 
        cancelRequestById: function(requestId){
            cancelRequest(requestId)
        }
    }
}