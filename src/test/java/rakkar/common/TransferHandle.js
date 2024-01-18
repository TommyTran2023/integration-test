function fn(){
    function getEstimateFee(tokenSymbol, destinationType, sourceType, sourceId, destinationId, amount){
        var body_estimate_fee = { 
            assetId: tokenSymbol, 
            destinationType: destinationType, 
            sourceType: sourceType, 
            sourceId: sourceId,
            amount: amount,
            destinationId: destinationId
        }
        var estimatedFee = karate.call(svc + 'Transaction.feature@GetEstimatedFee', body_estimate_fee)
        
        return (estimatedFee.response.data.totalToUSD / 10)
    }

    function getTiersSigner(){
        var getTiersSigner = karate.call(svc + 'Transaction.feature@GetListTransactionTierSigner')
        
        return {
            limit_low: getTiersSigner.response.data[0].to - 1,
            limit_medium: getTiersSigner.response.data[1].to - 1,
            limit_high: getTiersSigner.response.data[2].from + 1
        }
    }

    function calculateLimitTransfer(tokenSymbol, destinationType, sourceType, sourceId, destinationId, amount){
        var estimatedFee = getEstimateFee(tokenSymbol, destinationType, sourceType, sourceId, destinationId, amount)
        var tier_signer = getTiersSigner()
        
        return {
            tokenPrice: estimatedFee,
            amount_low: Math.round(tier_signer.limit_low / estimatedFee),
            amount_medium: Math.round(tier_signer.limit_medium / estimatedFee),
            amount_high: Math.round(tier_signer.limit_high / estimatedFee)
        }
    }

    return {
        createTransferRequest: function(txnInfo){
            //tier: 1-small, 2-medium, 3-high
            var amount = 0
            var estimatedFee = calculateLimitTransfer(txnInfo.tokenSymbol, txnInfo.destinationType, txnInfo.sourceType, txnInfo.sourceId, txnInfo.destinationId, 10)

            var biometric = karate.call(svc + 'Biometric.feature@RequesterDoBiometric')
            var transferData = {
                challengeAnswerRequest: biometric.challengeAnswerRequest,
                tokenId : txnInfo.tokenId,
                source : {
                    type: txnInfo.sourceType,
                    id: txnInfo.sourceId
                },
                destination : {
                    type: txnInfo.destinationType,
                    id: txnInfo.destinationId
                },
                amount : 11,
                operation : "TRANSFER",
                fee : txnInfo.fee,
                feeType : txnInfo.tokenSymbol,
                totalEstimatedFee : txnInfo.fee,
                feeLevel : "MEDIUM",
                note : 'Rebalancing',
                treatAsGrossAmount : true
            }

            if (typeof txnInfo.tier == 'number'){
                if (txnInfo.tier == 1){
                    transferData[amount] = estimatedFee.amount_low
                }
                else if (txnInfo.tier == 2) {
                    transferData["amount"] = estimatedFee.amount_medium
                    transferData["passcode"] = txnInfo.passcode
                }
                else if (txnInfo.tier == 3) {
                    // Upload video
                    var getVideoPrompt = karate.call(svc + 'Quorums.feature@GetVideoRandomWords')
                    var videoPrompt = getVideoPrompt.response
                    var getUploadLink = karate.call(svc + 'Auth.feature@GetSignedUrl', {userId: txnInfo.userId} )
                    var uploadLink = getUploadLink.response.data
                    karate.call(svc + 'File.feature@UploadVideoForTransfer', {url: uploadLink.uploadUrl})

                    transferData["amount"] = estimatedFee.amount_high
                    transferData["passcode"] = txnInfo.passcode
                    transferData["uploadToken"] = uploadLink.uploadToken
                    transferData["vdoSentence"] = videoPrompt.data.join()
                }
            }

            var txnRequest = karate.call(svc + 'Transaction.feature@CreateTransaction', transferData) 
            return txnRequest.response
        }
    }
}
