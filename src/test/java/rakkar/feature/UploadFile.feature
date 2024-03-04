@ignore
Feature: Upload file
  Background:
    * url crmUploadUrl
    * call read('this:RequesterAuthenticator.feature@RequesterAccessToken')

  @UPLOAD_IMAGE_ON_CRM
  Scenario: Upload image on CRM
    * configure headers = {Content-type: "image/png"}
    And param filename = 'image.png'
    And request karate.read("file:src/main/resources/uploadFile/image.png")
    When method POST
    Then status 201
    * configure headers = {Authorization: '#(accessToken)'}
    * def token = response.upload.token

  @UPLOAD_VIDEO_ON_CRM
  Scenario: Upload video
    And header Content-type = "video/mp4"
    And param filename = 'video.mp4'
    And request karate.read("file:src/main/resources/uploadFile/video.mp4")
    When method POST
    Then status 201
    * def token = response.upload.token

  @PUT_VIDEO
  Scenario: Put video
    Given url uploadUrl
    * request {}
    And header Content-type = "video/mp4"
    When method PUT
    Then status 200
    And response.status == "success"

  @PUT_VIDEO_v2
  Scenario: Put video
    * def userInfo = call read('this:GetUserInfo.feature@GetUserInfo')
    * def handler = read('classpath:rakkar/common/UploadFileHandle.js')
    * def vdo = handler().uploadFileForTransfer(requesterAccessToken, userInfo.userId)
    * def uploadToken = vdo.uploadToken
    * def vdoSentence = vdo.vdoSentence
