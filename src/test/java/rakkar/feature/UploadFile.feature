@ignore
Feature: Upload file
  Background:
    * url crmUploadUrl
    * configure charset = null
    * call read('this:RequesterAuthenticator.feature@RequesterAccessToken')

  @UPLOAD_IMAGE_ON_CRM
  Scenario: Upload image on CRM
    * def headers = {Content-type: "image/png"}
    * def filename = 'image.png'
    * call read('this:UploadFile.feature@UPLOAD_CRM')
    Then match responseStatus == 201
    * configure headers = {Authorization: '#(accessToken)'}
    * def token = response.upload.token

  @UPLOAD_VIDEO_ON_CRM
  Scenario: Upload video
    * def headers = {Content-type: "video/mp4"}
    * def filename = 'video.mp4'
    * call read('this:UploadFile.feature@UPLOAD_CRM')
    Then match responseStatus == 201
    * def token = response.upload.token

  @UPLOAD_CRM
  Scenario: Upload file on CRM
  * configure headers = headers
  And param filename = filename
  And request karate.read("file:src/main/resources/uploadFile/" + filename)
  When method POST
