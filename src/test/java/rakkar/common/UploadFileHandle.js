function fn(){
    return{
        uploadFileForTransfer: function(accessToken, userId){
            // Upload video
            var getVideoPrompt = karate.call(svc + 'Quorums.feature@GetVideoRandomWords', {accessToken: accessToken}) 
            var getUploadLink = karate.call(svc + 'Auth.feature@GetSignedUrl', {userId: userId, accessToken: accessToken} )
            var uploadLink = getUploadLink.response.data.uploadUrl
            var uploadToken = getUploadLink.response.data.uploadToken
            karate.call(svc + 'File.feature@UploadVideoForTransfer', {url: uploadLink, accessToken: uploadToken})
            karate.configure('headers', {Authorization: accessToken})
            
            return {
                uploadToken: uploadToken,
                vdoSentence: getVideoPrompt.response.data.join()
            }
        }
    }
}
