function fn(){
    return{
        uploadFileForTransfer: function(accessToken){
            // Upload video
            var getVideoPrompt = karate.call(svc + 'Quorums.feature@GetVideoRandomWords', {accessToken: accessToken}) 
            var getUploadLink = karate.call(svc + 'Auth.feature@GetSignedUrl', {userId: txnInfo.userId, accessToken: accessToken} )
            var uploadLink = getUploadLink.response.data
            karate.call(svc + 'File.feature@UploadVideoForTransfer', {url: uploadLink.uploadUrl})
            
            return {
                uploadToken: uploadLink.uploadToken,
                vdoSentence: getVideoPrompt.response.data.join()
            }
        }
    }
}
