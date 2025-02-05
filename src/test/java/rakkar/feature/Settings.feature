@RAKCON-10583
Feature: Settings

  Background:
    * url baseMobileURL
    * call read('this:RequesterAuthenticator.feature@RequesterAccessToken')
    * def challengeRequester = call read('this:Common.feature@FIDO-Requester')
    * def testData = read('classpath:data/dataTest.json')

  @RAKCON-11010 @ForgotPIN
  Scenario: Forgot PIN
    * def requestIv = requesterInfo.userId.replaceAll('-', '').slice(0, 16);
    * def newPasscode = karate.exec(`node aes.js encrypt ${testData.settings.newPasscode} MIIBCgKCAQEAniN5htNE5JBVkA5M3Tfi ${requestIv}`)
    * def requestBody = 
    """
    { 
      "passcode" : "#(newPasscode)", 
      "securityAnswer" : { 
        "dateOfBirth" : "#(requesterInfo.dateOfBirth)", 
        "postalCode" : "#(requesterInfo.postalCode)", 
        "identityType" : "#(requesterInfo.identityType)", 
        "nationalityOrCountry" : "#(requesterInfo.country)", 
        "identityNumber" : "#(requesterInfo.idNumber)", 
        "phoneNumber" : "#(requesterInfo.phoneNumber)" 
      }, 
      "isForgotPasscode" : true 
    }
    """
    * call read('this:Settings.feature@ForgotPIN-Common')
    # Restore to old passcode
    * call read('this:Settings.feature@RestoreToOldPasscode')

  @RAKCON-13184 @VerifySecurityQuestion
  Scenario: Verify Security Question when performing forgot PIN
    Given path '/auth/account/verify-security-question'
    * request { "identityType" : "#(requesterInfo.identityType)", "dateOfBirth" : "#(requesterInfo.dateOfBirth)", "nationalityOrCountry" : "#(requesterInfo.country)", "phoneNumber" : "#(requesterInfo.phoneNumber)", "postalCode" : "#(requesterInfo.postalCode)", "identityNumber" : "#(requesterInfo.idNumber)" }
    When method POST
    Then status 201
    * match response.data.isValid == true

  @RAKCON-13185 @CheckNewPassCode
  Scenario: Check new passcode when performing forgot PIN
    * def requestIv = requesterInfo.userId.replaceAll('-', '').slice(0, 16);
    * def newPasscode = karate.exec(`node aes.js encrypt ${testData.settings.newPasscode} MIIBCgKCAQEAniN5htNE5JBVkA5M3Tfi ${requestIv}`)
    Given path '/auth/account/check-new-passcode'
    * request { "passcode" : "#(newPasscode)" }
    When method POST
    Then status 201
    * match response.data.isSameOldPasscode == false
    * match response.status == 'success'

  @ignore @RestoreToOldPasscode
  Scenario: Restore to old passcode
    * def requestBody = 
    """
    { 
      "passcode" : "#(requesterPasscode)", 
      "securityAnswer" : { 
        "dateOfBirth" : "#(requesterInfo.dateOfBirth)", 
        "postalCode" : "#(requesterInfo.postalCode)", 
        "identityType" : "#(requesterInfo.identityType)", 
        "nationalityOrCountry" : "#(requesterInfo.country)", 
        "identityNumber" : "#(requesterInfo.idNumber)", 
        "phoneNumber" : "#(requesterInfo.phoneNumber)" 
      }, 
      "isForgotPasscode" : true 
    }
    """
    * call read('this:Settings.feature@ForgotPIN-Common')

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
    * def requestIv = requesterInfo.userId.replaceAll('-', '').slice(0, 16);
    * def newPasscode = karate.exec(`node aes.js encrypt ${testData.settings.changePasscode} MIIBCgKCAQEAniN5htNE5JBVkA5M3Tfi ${requestIv}`)
    Given path '/auth/account/passcode'
    * header challenge-answer = challengeRequester.challengeAnswerRequest
    * header passcode = requesterPasscode
    * request { "isForgotPasscode" : false, "passcode" : "#(newPasscode)", "securityAnswer" : null }
    When method PUT
    Then status 200
    * match response.status == 'success'
    # Restore to old passcode
    * call read('this:Settings.feature@RestoreToOldPasscode')

  @GetAccountConfig @smoke
  Scenario: Get Account Config
    * call read(svc + 'Auth.feature@GetAccountConfig')
    * def expectedSchema =
    """
    {
      currency: "#string",
      baseToken: "#string",
      lang: "#string"
    }
    """
    Then match response.data contains expectedSchema
