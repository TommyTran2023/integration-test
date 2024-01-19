Feature: Upload file to other domains (crm, aws)

@UploadVideoForTransfer
Scenario: Upload video
    * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
    Given url url
    And header Content-type = "video/mp4"
    * header Authorization = accessToken
    * request {}
    When method PUT
    Then status 200
