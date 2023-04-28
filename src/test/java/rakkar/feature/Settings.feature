@RAKCON-10583 @ignore
Feature: Settings

  Background:
    * url baseURL
    * call read('RequesterAuthenticator.feature@RequesterAccessToken')
    * def dataBody = read('classpath:data/data_test.json')

  @RAKCON-11010 @ForgotPIN
  Scenario: Forgot PIN
    * call read('Settings.feature@VerifySecurityQuestion')
    * call read('Settings.feature@CheckNewPassCode')
    Given path '/auth/account/passcode'
    * request { "passcode" : "#(dataBody.settings.newPasscode)", "securityAnswer" : { "dateOfBirth" : "#(requesterInfo.dateOfBirth)", "postalCode" : "#(requesterInfo.postalCode)", "identityType" : 1, "nationalityOrCountry" : "#(requesterInfo.country)", "identityNumber" : "#(requesterInfo.idNumber)", "phoneNumber" : "#(requesterInfo.phoneNumber)" }, "isForgotPasscode" : true }
    When method PUT
    Then status 200
    * match response.status == 'success'
    # Restore to old passcode
    * call read('Settings.feature@RestoreToOldPasscode')

  @ignore @VerifySecurityQuestion
  Scenario: Verify Security Question
    Given path '/auth/account/verify-security-question'
    * request { "identityType" : 1, "dateOfBirth" : "#(requesterInfo.dateOfBirth)", "nationalityOrCountry" : "#(requesterInfo.country)", "phoneNumber" : "#(requesterInfo.phoneNumber)", "postalCode" : "#(requesterInfo.postalCode)", "identityNumber" : "#(requesterInfo.idNumber)" }
    When method POST
    Then status 201
    * match response.data.isValid == true

  @ignore @CheckNewPassCode
  Scenario: Check new passcode
    Given path '/auth/account/check-new-passcode'
    * request { "passcode" : "dataBody.settings.newPasscode" }
    When method POST
    Then status 201
    * match response.data.isSameOldPasscode == false
    * match response.status == 'success'

  @ignore @RestoreToOldPasscode
  Scenario: Restore to old passcode
    Given path '/auth/account/passcode'
    * request { "passcode" : "#(requesterInfo.requesterPasscode)", "securityAnswer" : { "dateOfBirth" : "#(requesterInfo.dateOfBirth)", "postalCode" : "#(requesterInfo.postalCode)", "identityType" : 1, "nationalityOrCountry" : "#(requesterInfo.country)", "identityNumber" : "#(requesterInfo.idNumber)", "phoneNumber" : "#(requesterInfo.phoneNumber)" }, "isForgotPasscode" : true }
    When method PUT
    Then status 200
    * match response.status == 'success'