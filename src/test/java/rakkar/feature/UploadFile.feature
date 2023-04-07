@ignore
Feature: Upload file

  @UPLOAD_IMAGE_ON_CRM
  Scenario: Upload image on CRM
    Given url 'https://crm.rakkardigital.com/api/v2/uploads'
    And header Content-type = "image/png"
    And param filename = 'image.png'
    And request karate.read("file:src/main/resources/uploadFile/image.png")
    When method POST
    Then status 201
    * def token = response.upload.token
    * print token

  @UPLOAD_VIDEO_ON_CRM
  Scenario: Upload video
    Given url 'https://crm.rakkardigital.com/api/v2/uploads'
    And header Content-type = "video/mp4"
    And param filename = 'video.mp4'
    And request karate.read("file:src/main/resources/uploadFile/video.mp4")
    When method POST
    Then status 201
    * def token = response.upload.token
    * print token