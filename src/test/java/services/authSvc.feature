Feature: Authorization

    Background: Approval is logged in
        * url typeof customUrl != 'undefined' ? customUrl : baseURL

    @GetSession
    Scenario: Get session for login
        * def bodyInitiateAuth = 
        """
        {
            "initiateAuthRequest": { 
                "AuthFlow": "CUSTOM_AUTH", 
                "AuthParameters": { 
                        "USERNAME": '#(userName)' 
                    } 
                }
        }
        """
        Given path '/auth/authorization/initiate-auth'  
        And request bodyInitiateAuth
        When method POST

    @GetAccessToken
    Scenario: Approval - Get token for login
        * def bodyGetToken =
        """
        { 
          "respondToAuthChallengeRequest": { 
              "ChallengeName": "CUSTOM_CHALLENGE", 
              "ChallengeResponses": { 
                  "USERNAME": '#(userName)', 
                  "ANSWER": '#(answer)' 
              }, 
              "Session": '#(session)' 
              }, 
          "deviceName": "AT Integration Test"
        }
        """
        Given path '/auth/authorization/respond-to-auth-challenge'
        And request bodyGetToken
        When method POST

    @GetUserInfo
    Scenario: Get user information
        Given path '/auth/account/me'
        * header Authorization = authorization
        When method GET

    @GetListUsers
    Scenario: Get list of users
        Given path '/auth/account/list-users'
        * header Authorization = authorization
        * request body
        When method POST
    
    @GetUsers
    Scenario: Get users
        Given path '/auth/account/users'
        * header Authorization = authorization
        * params params
        When method GET
    
    @GetUserDetail
    Scenario: Get user details
        Given path '/auth/account/users/'
        * header Authorization = authorization
        * params params
        When method GET

   @GetUserDetailById
   Scenario: Get user details
       Given path '/auth/account/users/'+ userId
       * header Authorization = authorization
       When method GET

   @GetAccountConfig
   Scenario: Get Account Config
      Given path '/auth/account/config'
      * headers headers
      When method GET

#----------------------------------
    @GetMyPermissions
    Scenario: Get My Permissions
        Given path 'auth/authorization/roles'
        * header authorization = authorization
        * param target = target
        When method GET

#----------------------------------
    @SignOut
    Scenario: Sign Out
        Given path 'auth/authorization/sign-out'
        * header authorization = authorization
        When method POST

#----------------------------------
@AcceptDeviceAuth
Scenario: Accept Device Auth
   Given path 'auth/account/accept-device-auth'
   * header authorization = authorization
   When method POST

#----------------------------------
@GetDeviceInfo
Scenario: Get Device Info
   Given path 'auth/account/device-info'
   * header authorization = authorization
   * request body
   When method POST

#----------------------------------
@RepInitialReplaceDevice
Scenario: Rep Initial Replace Device
   Given path 'auth/account/rep-replace-device'
   * header authorization = authorization
   * request body
   When method POST

#----------------------------------
@ReplaceDevice
Scenario: Replace Device
   Given path 'auth/account/request-replace-device'
   * header authorization = authorization
   When method POST

#----------------------------------
@AcceptRequestReplaceDevice
Scenario: Accept Request Replace Device
   Given path 'auth/account/accept-replace-device'
   * header authorization = authorization
   * request body
   When method POST

#----------------------------------
@RevokeAccessTokens
Scenario: Revoke Access Tokens
   Given path 'auth/account/revoke-access-tokens'
   * header authorization = authorization
   * request body
   When method POST

#----------------------------------
@ExchangeToken
Scenario: Exchange Token
   Given path 'auth/account/exchange-token'
   * header authorization = authorization
   * request body
   When method POST

#----------------------------------
@GetSignedUrl
Scenario: Get Signed Url
   Given path 'auth/account/users/upload-link'
   * header authorization = authorization
   * params params
   When method GET

#----------------------------------
@UpdateUser
Scenario: Update User
   Given path 'auth/account/users/' + userId
   * header authorization = authorization
   * header challenge-answer = challengeAnswerRequest
   * request body
   When method PUT

#----------------------------------
@GetListUsersByCustomerId
Scenario: Get List Users By Customer Id
   Given path 'auth/account/'+customerId+'/users'
   * header authorization = authorization
   * params params
   When method GET

@CreateUserRak
Scenario: Create User Rak
   Given path 'auth/account/'+customerId+'/users'
   * header authorization = authorization
   * request body
   When method POST


#----------------------------------
@GetListUsersGroupByCustomer
Scenario: Get List Users Group By Customer
   Given path 'auth/account/group-user'
   * header authorization = authorization
   When method GET

#----------------------------------
@UpdateUserFromREP
Scenario: Update User From REP
   Given path 'auth/account/rep/users/' + userId
   * header authorization = authorization
   * request body
   When method PUT

#----------------------------------
@CheckUpdateUser
Scenario: Check Update User
   Given path 'auth/account/check-quorum/' + userId
   * header authorization = authorization
   * request body
   When method PUT

#----------------------------------
@UpdateUserAvatar
Scenario: Update User Avatar
   Given path 'auth/account/users/'+userId+'/avatar'
   * header authorization = authorization
   * request body
   When method PUT

#----------------------------------
@SignUp
Scenario: Sign Up
   Given path 'auth/account/sign-up'
   * header authorization = authorization
   * request body
   When method POST

#----------------------------------
@GenerateQrCode
Scenario: Generate Qr Code
   Given path 'auth/account/generate-qr-code'
   * header authorization = authorization
   * request body
   When method POST

#----------------------------------
@MarkAsLostDevice
Scenario: Mark As Lost Device
   Given path 'auth/account/lost-device'
   * header authorization = authorization
   * request body
   When method POST

#----------------------------------
@ConfirmLostDevice
Scenario: Confirm Lost Device
   Given path 'auth/account/confirm-lost-device'
   * header authorization = authorization
   * request body
   When method POST

#----------------------------------
@UpdateDeviceStatus
Scenario: Update Device Status
   Given path 'auth/account/device-status'
   * header authorization = authorization
   * request body
   When method POST

#----------------------------------
@VerifyPasscode
Scenario: Verify Passcode
   Given path 'auth/account/verify-passcode'
   * header authorization = authorization
   * request body
   When method POST

#----------------------------------
@CheckNewPasscode
Scenario: Check New Passcode
   Given path 'auth/account/check-new-passcode'
   * header authorization = authorization
   * request body
   When method POST

#----------------------------------
@ChangePasscode
Scenario: Change Passcode
   Given path 'auth/account/passcode'
   * header authorization = authorization
   * request body
   When method PUT

#----------------------------------
@IsStartJourney
Scenario: Is Start Journey
   Given path 'auth/account/is-start-journey'
   * header authorization = authorization
   * request body
   When method POST

#----------------------------------
@VerifyQuestion
Scenario: Verify Question
   Given path 'auth/account/verify-security-question'
   * header authorization = authorization
   * request body
   When method POST

#----------------------------------
@CheckIdCardNumber
Scenario: Check Id Card Number
   Given path 'auth/account/check-id-card-number/' + idCardNumber
   * header authorization = authorization
   When method GET

#----------------------------------
@CheckPassportNumber
Scenario: Check Passport Number
   Given path 'auth/account/check-passport-number/' + passportNumber
   * header authorization = authorization
   When method GET

#----------------------------------
@ValidateDuplicateUser
Scenario: Validate Duplicate User
   Given path 'auth/account/validate-duplicate-user'
   * header authorization = authorization
   When method GET

#----------------------------------
@UserStatus
Scenario: User Status
   Given path 'auth/account/user-status/' + userId
   * header authorization = authorization
   * param getStatusLiveness = getStatusLiveness
   When method GET

#----------------------------------
@VerifyInfoOCR
Scenario: Verify Info OCR
   Given path 'auth/account/verify-info-ocr/' + userId
   * header authorization = authorization
   * request body
   When method POST

#----------------------------------
@ConfirmReplaceDevice
Scenario: Confirm Replace Device
   Given path 'auth/account/confirm-replace-device'
   * header authorization = authorization
   * request body
   When method POST

#----------------------------------
@CancelReplaceDevice
Scenario: Cancel Replace Device
   Given path 'auth/account/cancel-replace-device'
   * header authorization = authorization
   * request body
   When method POST

#----------------------------------
@SendDownloadLink
Scenario: Send Download Link
   Given path 'auth/account/send-download-link'
   * header authorization = authorization
   When method GET

#----------------------------------
@GetVerifyLinkLiveNessCheck
Scenario: Get Verify Link Live Ness Check
   Given path 'auth/account/verify-link/' + userId
   * header authorization = authorization
   When method GET

#----------------------------------
@VerifyRegTankData
Scenario: Verify Reg Tank Data
   Given path 'auth/account/liveness'
   * header authorization = authorization
   * request body
   When method POST

#----------------------------------
@CheckVerifyOcr
Scenario: Check Verify Ocr
   Given path 'auth/account/check-ocr-status'
   * header authorization = authorization
   * request body
   When method POST

#----------------------------------
@UnlockUserFromREP
Scenario: Unlock User From REP
   Given path 'auth/account/rep/unlock-user/' + userId
   * header authorization = authorization
   When method PUT

#----------------------------------
@AcceptDeviceAuthForAction
Scenario: Accept Device Auth For Action
   Given path 'auth/account/accept-device-auth-for-action'
   * header authorization = authorization
   * request body
   When method POST

#----------------------------------
@VerifyQRcodeLogin
Scenario: Verify QRcode Login
   Given path 'auth/onboarding/verify-qr-code-login'
   * header authorization = authorization
   * request body
   When method POST

#----------------------------------
@VerifyQRcode
Scenario: Verify QRcode
   Given path 'auth/onboarding/verify-qr-code'
   * header authorization = authorization
   * request body
   When method POST

#----------------------------------
@VerifyQRCodeWithAuth
Scenario: Verify QRCode With Auth
   Given path 'auth/onboarding/verify-qr-code-with-auth'
   * header authorization = authorization
   * request body
   When method POST

#----------------------------------
@VerifyUserInformation
Scenario: Verify User Information
   Given path 'auth/onboarding/verify-user'
   * header authorization = authorization
   * request body
   When method POST

#----------------------------------
@VerifyLinkSendOTP
Scenario: Verify Link Send OTP
   Given path 'auth/onboarding/verify-link-send-otp'
   * header authorization = authorization
   * request body
   When method POST

#----------------------------------
@SendOTPToVerifyUser
Scenario: Send OTP To Verify User
   Given path 'auth/onboarding/send-otp'
   * header authorization = authorization
   * request body
   When method POST

#----------------------------------
@VerifyOTPSendToUser
Scenario: Verify OTP Send To User
   Given path 'auth/onboarding/verify-otp'
   * header authorization = authorization
   * request body
   When method POST

#----------------------------------
@ResendEmailToUser
Scenario: Resend Email To User
   Given path 'auth/onboarding/resend-email/' + userId
   * header authorization = authorization
   When method GET

#----------------------------------
@CheckVersion
Scenario: Check Version
   Given path 'auth/onboarding/check-version'
   * header authorization = authorization
   * request body
   When method POST

#----------------------------------
@StoreVersion
Scenario: Store Version
   Given path 'auth/onboarding/store-version'
   * header authorization = authorization
   * request body
   When method POST

#----------------------------------
@GetListFeatureAccess
Scenario: Get List Feature Access
   Given path 'auth/features'
   * header authorization = authorization
   * params params
   When method GET

#----------------------------------
@GetFeatureDetail
Scenario: Get Feature Detail
   Given path 'auth/features/' + featureId
   * header authorization = authorization
   * params params
   When method GET

@InitUpdateFeatureRequest
Scenario: Init Update Feature Request
   Given path 'auth/features/' + featureId
   * header authorization = authorization
   * request body
   When method PUT

#----------------------------------
@GetListUser
Scenario: Get List User
   Given path 'auth/users'
   * header authorization = authorization
   * params params
   When method GET


