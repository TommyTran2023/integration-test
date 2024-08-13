Feature: Upload file to S3

    @GetUploadLink
    Scenario: Get Upload Link
        * def defineParams = 
        """
        function(fileType){
            if (fileType == 'video')
                return { contentType: 'video/mp4', fileName:'video.mp4', userId: '#(userId)'}
            else
                return { contentType: 'image/jpg', fileName:'image_test.jpg', userId: '#(userId)'}
        }
        """
        * def params = defineParams(typeof fileType == 'undefined' ? 'image' : fileType)
        * def data = 
        """
        {
            authorization: "#(accessToken)",
            params: "#(params)"
        }
        """
        * call read(svc + 'authSvc.feature@GetSignedUrl') data
        

    @PutFile
    Scenario: Put file
        * def defineParams = 
        """
        function(fileType){
            if (fileType == 'video')
                return { contentType: 'video/mp4', file:'file:src/main/resources/uploadFile/video.mp4'}
            else
                return { contentType: 'image/jpg', file:'file:src/main/resources/uploadFile/image.png'}
        }
        """
        * def params = defineParams(typeof fileType == 'undefined' ? 'image' : fileType)
        Given url uploadUrl
        * configure headers = {Content-Type: '#(params.contentType)'}
        And request karate.read(params.file)
        When method PUT
        * configure headers = {Authorization: '#(accessToken)'}
        Then status 200
