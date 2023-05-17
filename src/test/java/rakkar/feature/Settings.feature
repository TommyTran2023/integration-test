@RAKCON-10583 @ignore
Feature: Settings

  Background:
    * url baseURL
    * call read('RequesterAuthenticator.feature@RequesterAccessToken')
    * def challengeRequester = call read('Common.feature@FIDO-Requester')
    * def testData = read('classpath:data/data_test.json')

  @RAKCON-11010 @ForgotPIN
  Scenario: Forgot PIN
    * def requestBody = { "passcode" : "#(testData.settings.newPasscode)", "securityAnswer" : { "dateOfBirth" : "#(requesterInfo.dateOfBirth)", "postalCode" : "#(requesterInfo.postalCode)", "identityType" : 1, "nationalityOrCountry" : "#(requesterInfo.country)", "identityNumber" : "#(requesterInfo.idNumber)", "phoneNumber" : "#(requesterInfo.phoneNumber)" }, "isForgotPasscode" : true }
    * call read('Settings.feature@ForgotPIN-Common')
    # Restore to old passcode
    * call read('Settings.feature@RestoreToOldPasscode')

  @RAKCON-13184 @VerifySecurityQuestion
  Scenario: Verify Security Question when performing forgot PIN
    Given path '/auth/account/verify-security-question'
    * request { "identityType" : 1, "dateOfBirth" : "#(requesterInfo.dateOfBirth)", "nationalityOrCountry" : "#(requesterInfo.country)", "phoneNumber" : "#(requesterInfo.phoneNumber)", "postalCode" : "#(requesterInfo.postalCode)", "identityNumber" : "#(requesterInfo.idNumber)" }
    When method POST
    Then status 201
    * match response.data.isValid == true

  @RAKCON-13185 @CheckNewPassCode
  Scenario: Check new passcode when performing forgot PIN
    Given path '/auth/account/check-new-passcode'
    * request { "passcode" : "testData.settings.newPasscode" }
    When method POST
    Then status 201
    * match response.data.isSameOldPasscode == false
    * match response.status == 'success'

  @ignore @RestoreToOldPasscode
  Scenario: Restore to old passcode
    * def requestBody = { "passcode" : "#(requesterInfo.requesterPasscode)", "securityAnswer" : { "dateOfBirth" : "#(requesterInfo.dateOfBirth)", "postalCode" : "#(requesterInfo.postalCode)", "identityType" : 1, "nationalityOrCountry" : "#(requesterInfo.country)", "identityNumber" : "#(requesterInfo.idNumber)", "phoneNumber" : "#(requesterInfo.phoneNumber)" }, "isForgotPasscode" : true }
    * call read('Settings.feature@ForgotPIN-Common')

  @ignore @ForgotPIN-Common
  Scenario: Forgot PIN - Common
    Given path '/auth/account/passcode'
    * header challenge-answer = challengeRequester.challengeAnswerRequest
    * request requestBody
    When method PUT
    Then status 200
    * match response.status == 'success'

  @RAKCON-11012 @ChangePIN
  Scenario: Change PIN
    Given path '/auth/account/passcode'
    * header challenge-answer = challengeRequester.challengeAnswerRequest
    * header passcode = requesterInfo.requesterPasscode
    * request { "isForgotPasscode" : false, "passcode" : "#(testData.settings.changePasscode)", "securityAnswer" : null }
    When method PUT
    Then status 200
    * match response.status == 'success'
    # Restore to old passcode
    * call read('Settings.feature@RestoreToOldPasscode')