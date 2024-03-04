Feature: Upload file to other domains (crm, aws)

@UploadVideoForTransfer
Scenario: Upload video
    Given url url
    # And header Content-type = "video/mp4" , Authorization: "#(accessToken)"
    * configure headers = { Content-type: "video/mp4" }
    # And multipart file myFile = { read: "file:src/main/resources/uploadFile/video.mp4" }
    * request karate.read("file:src/main/resources/uploadFile/video.mp4")
    When method PUT
    Then status 200
