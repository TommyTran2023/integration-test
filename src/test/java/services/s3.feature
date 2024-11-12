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
                return { contentType: 'video/mp4', file:'file:src/main/resources/uploadFile/video.mp4', filename: 'video.mp4'}
            else
                return { contentType: 'image/jpeg', file:'file:src/main/resources/uploadFile/image.png', filename: 'image.png'}
        }
        """
        * print uploadUrl
        * def params = defineParams(typeof fileType == 'undefined' ? 'image' : fileType)
        * print params
        * def fields = uploadUrl.fields
        * def imageFile = read(params.file)

        * configure headers = {}
        Given url uploadUrl.url
        And multipart field bucket = fields.bucket
        And multipart field X-Amz-Date = fields['X-Amz-Date']
        And multipart field X-Amz-Algorithm = fields['X-Amz-Algorithm']
        And multipart field Policy = fields.Policy
        And multipart field X-Amz-Credential = fields['X-Amz-Credential']
        And multipart field X-Amz-Signature = fields['X-Amz-Signature']
        And multipart field Content-Type = fields.ContentType
        And multipart field ContentType = fields.ContentType
        And multipart field key = fields.key
        And multipart file file = { read: '#(params.file)', filename: '#(params.filename)', contentType: '#(params.contentType)' }
        When method post
        Then status 204
