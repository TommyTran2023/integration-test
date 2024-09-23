@ignore
Feature: Common call from Auth services
    
    @GetAccessTokenForLogin
    Scenario: Get token for login
        # 1. Get session
        * def responseTest1 = call read(svc + 'authSvc.feature@GetSession') {userName: '#(userName)'}
        * def Session1 = responseTest1.response.data.Session
        
        # 2. Get access token
        * call read(svc + 'authSvc.feature@GetAccessToken') {userName: '#(userName)', session: '#(Session1)', answer: '#(answer)'}
        Then match response.status == "success"

    @GetApproverAccessToken
    Scenario: Get Approver Access Token
        * call read('this:Auth.feature@GetAccessTokenForLogin') {userName: '#(approverInfo.approvalUsername)', answer: '#(approverInfo.challengeAnswerAuth)'}
        * def approvalAuthToken = response.data.AuthenticationResult.AccessToken
        * def approvalAccessToken = 'Bearer ' + approvalAuthToken

    @GetRequesterAccessToken
    Scenario: Get Requester Access Token
        * call read('this:Auth.feature@GetAccessTokenForLogin') {userName: '#(requesterInfo.requesterUsername)', answer: '#(requesterInfo.challengeAnswerAuth)'}
        * def requesterAuthToken = response.data.AuthenticationResult.AccessToken
        * def requesterAccessToken = 'Bearer ' + requesterAuthToken

    @GetUserAccessToken
    Scenario: Get Requester Access Token
        * def testData = read('classpath:data/data_test.json')
        * def answer = typeof customAnswer != 'undefined' ? customAnswer : testData.common.challengeAnswerAuth
        * call read('this:Auth.feature@GetAccessTokenForLogin') {userName: '#(userName)', answer: '#(answer)'}
        * def userAccessToken = 'Bearer ' + response.data.AuthenticationResult.AccessToken
    
    @GetRequesterInfo
    Scenario: Get Requester Info
        * call read('this:Auth.feature@GetRequesterAccessToken')
        * call read('this:authSvc.feature@GetUserInfo') {authorization: '#(requesterAccessToken)'}
        * match responseStatus == 200
        * def userId = response.data.id
        * def requesterID = response.data.id
        * def requesterEmail = response.data.email
        * def requesterName = response.data.name

    @GetUserInfo
    Scenario: Get User Info
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * call read('this:authSvc.feature@GetUserInfo') {authorization: '#(accessToken)'}

    @GetListUsers
    Scenario: Get All Users
        * def data =
        """
        {
            authorization: '#(requesterAccessToken)',
            body: {"isGetAll":true}
        }
        """
        * call read('this:authSvc.feature@GetListUsers') data
        * match responseStatus == 201
        * def allUsers = response.data.users
        # Add requester, approver and admin to vault member list
        * def requesterUserID = karate.jsonPath(allUsers, "$[?(@.username=='"+ requesterInfo.requesterUsername +"')].userId")[0]
        * def approvalUserID = karate.jsonPath(allUsers, "$[?(@.username=='"+ approverInfo.approvalUsername +"')].userId")[0]
        * def adminUserID = karate.jsonPath(allUsers, "$[?(@.username=='"+ adminUsername +"')].userId")[0]
        * def adminUserID2 = karate.jsonPath(allUsers, "$[?(@.username=='"+ adminUsername2 +"')].userId")[0]
        * def vaultMemberList = [#(requesterUserID), #(approvalUserID), #(adminUserID), #(adminUserID2)]
    
    @GetUsers
    Scenario: Get users
        * def keyword = karate.get('keyword','')
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
        {
            authorization: '#(accessToken)',
            params: {
                keyword:#(keyword),
                limit: 10,
                offet: 0,
                sort: ASC,
                sortBy: NAME,
                status: ACTIVE
            }
        }
        """
        * call read('this:authSvc.feature@GetUsers') data
        * match responseStatus == 200
        * match response.code == 200
        * match response.status == 'success'
        * karate.set('keyword',null)
        * karate.set('accessToken',null)
    
    @GetUserDetails
    Scenario: Get User Details
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
        {
            authorization: '#(accessToken)',
            params:{
                userIds: '#(userIds)',
                limit: 20,
                offset: 0,
                searchText: ''
            }
        }
        """
        * call read('this:authSvc.feature@GetUserDetail') data
        * match responseStatus == 200
        * match response.code == 200
        * match response.status == 'success'

    @GetUserDetailById
    Scenario: Get user details
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
        {
            authorization: '#(accessToken)',
            userId: #(userId)
        }
        """
        * call read('this:authSvc.feature@GetUserDetailById') data
        * match responseStatus == 200
        * match response.code == 200
        * match response.status == 'success'

        
    @GetMyPermissions
    Scenario: Get My Permissions
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            target : #(target) //string
        }
        """
        * call read(svc + 'authSvc.feature@GetMyPermissions') data
        
    @SignOut
    Scenario: Sign Out
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken)
        }
        """
        * call read(svc + 'authSvc.feature@SignOut') data
        
    @AcceptDeviceAuth
    Scenario: Accept Device Auth
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken)
        }
        """
        * call read(svc + 'authSvc.feature@AcceptDeviceAuth') data
     
    @GetDeviceInfo
    Scenario: Get Device Info
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                data : #(data), //string
                actionType : #(actionType) //string
            }
        }
        """
        * call read(svc + 'authSvc.feature@GetDeviceInfo') data

    @RepInitialReplaceDevice
    Scenario: Rep Initial Replace Device
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                userId : #(userId) //string
            }
        }
        """
        * call read(svc + 'authSvc.feature@RepInitialReplaceDevice') data
     
    @ReplaceDevice
    Scenario: Replace Device
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken)
        }
        """
        * call read(svc + 'authSvc.feature@ReplaceDevice') data
     
    @AcceptRequestReplaceDevice
    Scenario: Accept Request Replace Device
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                data : #(data), //string
                actionType : #(actionType), //string
                publicKey : #(publicKey), //string
                deviceId : #(deviceId), //string
                device : #(device), //string
                deviceOs : #(deviceOs) //string
            }
        }
        """
        * call read(svc + 'authSvc.feature@AcceptRequestReplaceDevice') data
     
    @RevokeAccessTokens
    Scenario: Revoke Access Tokens
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                refreshToken : #(refreshToken)
            }
        }
        """
        * call read(svc + 'authSvc.feature@RevokeAccessTokens') data
     
    @ExchangeToken
    Scenario: Exchange Token
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                token : #(token)
            }
        }
        """
        * call read(svc + 'authSvc.feature@ExchangeToken') data
     
    @GetSignedUrl
    Scenario: Get Signed Url
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            params:{
                fileName : #(typeof fileName == 'undefined' ? 'video.mp4' : fileName),
                contentType : #(typeof contentType == 'undefined' ? 'video/mp4' : contentType),
                userId : #(userId),
                type : #(typeof type == 'undefined' ? 'VIDEO' : type)
            }
        }
        """
        * call read(svc + 'authSvc.feature@GetSignedUrl') data

    @UpdateUser
    Scenario: Update User
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            challenge-answer: #(challengeAnswerRequest)
            userId : #(userId), 
            body: 
            {
                roleWillUpdate : #(roleWillUpdate), 
                vaultsWillRemoveAccess : #(vaultsWillRemoveAccess), 
                vaultsWillAddAccess : #(vaultsWillAddAccess), 
                isRemoveAccountAccess : #(isRemoveAccountAccess), 
                reason : #(reason)
            }
        }
        """
        * call read(svc + 'authSvc.feature@UpdateUser') data
        Then match responseStatus == 200
        * match response.status == "success"
        * match response.code == 200
     
    @GetListUsersByCustomerId
    Scenario: Get List Users By Customer Id
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            customerId : #(customerId), //string
            params:{
                keyword : #(keyword), //string
                sortBy : #(sortBy), //string
                limit : 10, //number
                offset : 0, //number
                sort : #(sort), //string
                type : #(type), //string
                status : #(status), //string
                role : #(role) //string
            }
        }
        """
        * call read(svc + 'authSvc.feature@GetListUsersByCustomerId') data
     
    @CreateUserRak
    Scenario: Create User Rak

        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            customerId : #(customerId), //string
            body: 
            {
                firstName : #(firstName), //string
                middleName : #(middleName), //string
                lastName : #(lastName), //string
                passportNumber : #(passportNumber), //string
                passportIssuedCountry : #(passportIssuedCountry), //string
                idCardNumber : #(idCardNumber), //string
                idCardIssuedCountry : #(idCardIssuedCountry), //string
                documentType : #(documentType), //string
                countryCode : #(countryCode), //string
                email : #(email), //string
                phoneNumber : #(phoneNumber), //string
                requiredApprover : #(requiredApprover), //boolean
                dateOfBirth : #(dateOfBirth), //string
                address : #(address), //null
                nationality : #(nationality), //string
                userRole : #(userRole), //string
                vaultIds : #(vaultIds) //array
            }
        }
        """
        * call read(svc + 'authSvc.feature@CreateUserRak') data
     
    @GetListUsersGroupByCustomer
    Scenario: Get List Users Group By Customer
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            params:{
                limit : #(limit), //number
                offset : #(offset), //number
                sort : #(sort), //string
                keyword : #(keyword), //string
                customerIds : #(customerIds) //string
            }
        }
        """
        * call read(svc + 'authSvc.feature@GetListUsersGroupByCustomer') data
        
    @UpdateUserFromREP
    Scenario: Update User From REP
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            userId : #(userId), //string
            body: 
            {
                roleWillUpdate : #(roleWillUpdate), //string
                vaultsWillRemoveAccess : #(vaultsWillRemoveAccess), //array
                vaultsWillAddAccess : #(vaultsWillAddAccess), //array
                newUser : #(newUser), //null
                isRemoveAccountAccess : #(isRemoveAccountAccess) //boolean
            }
        }
        """
        * call read(svc + 'authSvc.feature@UpdateUserFromREP') data

    @CheckUpdateUser
    Scenario: Check Update User
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            userId : #(userId), //string
            body: 
            {
                roleWillUpdate : #(roleWillUpdate), //string
                vaultsWillRemoveAccess : #(vaultsWillRemoveAccess), //array
                vaultsWillAddAccess : #(vaultsWillAddAccess), //array
                isRemoveAccountAccess : #(isRemoveAccountAccess), //boolean
                reason : #(reason) //string
            }
        }
        """
        * call read(svc + 'authSvc.feature@CheckUpdateUser') data
     
    @UpdateUserAvatar
    Scenario: Update User Avatar
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: '#(accessToken)',
            userId : '#(userId)', 
            body: 
            {
                uploadToken : '#(uploadToken)'
            }
        }
        """
        * call read(svc + 'authSvc.feature@UpdateUserAvatar') data
     
    @SignUp
    Scenario: Sign Up
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                data : #(data), //string
                publicKey : #(publicKey), //string
                passcode : #(passcode), //string
                deviceId : #(deviceId), //string
                deviceName : #(deviceName), //string
                deviceOS : #(deviceOS) //string
            }
        }
        """
        * call read(svc + 'authSvc.feature@SignUp') data
        
    @GenerateQrCode
    Scenario: Generate Qr Code
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                userId : #(userId), //string
                type : #(type), //string
                action : #(action), //string
                clientId : #(clientId), //string
                deviceName : #(deviceName) //string
            }
        }
        """
        * call read(svc + 'authSvc.feature@GenerateQrCode') data
     
    @MarkAsLostDevice
    Scenario: Mark As Lost Device
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                userId : #(userId) //string
            }
        }
        """
        * call read(svc + 'authSvc.feature@MarkAsLostDevice') data

    @ConfirmLostDevice
    Scenario: Confirm Lost Device
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                data : #(data), //string
                actionType : #(actionType), //string
                publicKey : #(publicKey), //string
                deviceId : #(deviceId), //string
                device : #(device), //string
                deviceOs : #(deviceOs), //string
                deviceToken : #(deviceToken), //string
                isGeneratedFromREP : #(isGeneratedFromREP) //boolean
            }
        }
        """
        * call read(svc + 'authSvc.feature@ConfirmLostDevice') data
        
    @UpdateDeviceStatus
    Scenario: Update Device Status
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                jailbreak : #(jailbreak) //string
            }
        }
        """
        * call read(svc + 'authSvc.feature@UpdateDeviceStatus') data
     
    @VerifyPasscode
    Scenario: Verify Passcode
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                passcode : #(passcode) //string
            }
        }
        """
        * call read(svc + 'authSvc.feature@VerifyPasscode') data
        
    @CheckNewPasscode
    Scenario: Check New Passcode
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                passcode : #(passcode) //string
            }
        }
        """
        * call read(svc + 'authSvc.feature@CheckNewPasscode') data
        
    @ChangePasscode
    Scenario: Change Passcode
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                passcode : #(passcode), //string
                isForgotPasscode : #(isForgotPasscode), //boolean
                securityAnswer : #(securityAnswer) //null
            }
        }
        """
        * call read(svc + 'authSvc.feature@ChangePasscode') data
    
    @IsStartJourney
    Scenario: Is Start Journey
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                userId : #(userId), //string
                deviceId : #(deviceId) //string
            }
        }
        """
        * call read(svc + 'authSvc.feature@IsStartJourney') data
     
    @VerifyQuestion
    Scenario: Verify Question
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                identityType : #(identityType), //number
                identityNumber : #(identityNumber), //string
                nationalityOrCountry : #(nationalityOrCountry), //string
                dateOfBirth : #(dateOfBirth), //string
                phoneNumber : #(phoneNumber) //string
            }
        }
        """
        * call read(svc + 'authSvc.feature@VerifyQuestion') data
     
    @CheckIdCardNumber
    Scenario: Check Id Card Number
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            idCardNumber : #(idCardNumber) //string
        }
        """
        * call read(svc + 'authSvc.feature@CheckIdCardNumber') data
     
    @CheckPassportNumber
    Scenario: Check Passport Number
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            passportNumber : #(passportNumber) //string
        }
        """
        * call read(svc + 'authSvc.feature@CheckPassportNumber') data
     
    @ValidateDuplicateUser
    Scenario: Validate Duplicate User
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            params:{
                number : #(number), //string
                country : #(country), //string
                documentType : #(documentType), //string
                email : #(email), //string
                phoneNumber : #(phoneNumber), //string
                userId : #(userId) //string
            }
        }
        """
        * call read(svc + 'authSvc.feature@ValidateDuplicateUser') data
     
    @UserStatus
    Scenario: User Status
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            userId : #(userId), //string
            getStatusLiveness : #(getStatusLiveness) //boolean
        }
        """
        * call read(svc + 'authSvc.feature@UserStatus') data
     
    @VerifyInfoOCR
    Scenario: Verify Info OCR
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            userId : #(userId), //string
            body: 
            {
                firstName : #(firstName), //string
                lastName : #(lastName), //string
                numberOfCardOrPassport : #(numberOfCardOrPassport), //string
                countryIssued : #(countryIssued), //string
                birthday : #(birthday), //string
                nationality : #(nationality) //string
            }
        }
        """
        * call read(svc + 'authSvc.feature@VerifyInfoOCR') data
    
    @ConfirmReplaceDevice
    Scenario: Confirm Replace Device
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                note : #(note), //string
                data : #(data), //string
                clientId : #(clientId) //string
            }
        }
        """
        * call read(svc + 'authSvc.feature@ConfirmReplaceDevice') data
     
    @CancelReplaceDevice
    Scenario: Cancel Replace Device
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                note : #(note), //string
                data : #(data), //string
                clientId : #(clientId) //string
            }
        }
        """
        * call read(svc + 'authSvc.feature@CancelReplaceDevice') data

    @SendDownloadLink
    Scenario: Send Download Link
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken)
        }
        """
        * call read(svc + 'authSvc.feature@SendDownloadLink') data
     
    @GetVerifyLinkLiveNessCheck
    Scenario: Get Verify Link Live Ness Check
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            userId : #(userId) //string
        }
        """
        * call read(svc + 'authSvc.feature@GetVerifyLinkLiveNessCheck') data
     
    @VerifyRegTankData
    Scenario: Verify Reg Tank Data
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                status : #(status), //string
                timestamp : #(timestamp), //string
                systemId : #(systemId), //string
                confidence : #(confidence) //number
            }
        }
        """
        * call read(svc + 'authSvc.feature@VerifyRegTankData') data
        
    @CheckVerifyOcr
    Scenario: Check Verify Ocr
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                systemId : #(systemId) //string
            }
        }
        """
        * call read(svc + 'authSvc.feature@CheckVerifyOcr') data
     
    @UnlockUserFromREP
    Scenario: Unlock User From REP
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            userId : #(userId) //string
        }
        """
        * call read(svc + 'authSvc.feature@UnlockUserFromREP') data
    
    @AcceptDeviceAuthForAction
    Scenario: Accept Device Auth For Action
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken)
        }
        """
        * call read(svc + 'authSvc.feature@AcceptDeviceAuthForAction') data
     
    @VerifyQRcodeLogin
    Scenario: Verify QRcode Login
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                data : #(data), //string
                actionType : #(actionType) //string
            }
        }
        """
        * call read(svc + 'authSvc.feature@VerifyQRcodeLogin') data
     
    @VerifyQRcode
    Scenario: Verify QRcode
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                data : #(data), //string
                actionType : #(actionType), //string
                clientId : #(clientId) //string
            }
        }
        """
        * call read(svc + 'authSvc.feature@VerifyQRcode') data
        
    @VerifyQRCodeWithAuth
    Scenario: Verify QRCode With Auth
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                data : #(data), //string
                actionType : #(actionType), //string
                clientId : #(clientId) //string
            }
        }
        """
        * call read(svc + 'authSvc.feature@VerifyQRCodeWithAuth') data
     
    @VerifyUserInformation
    Scenario: Verify User Information
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                passportIssuedCountry : #(passportIssuedCountry), //string
                passportNumber : #(passportNumber) //string
            }
        }
        """
        * call read(svc + 'authSvc.feature@VerifyUserInformation') data
     
    @VerifyLinkSendOTP
    Scenario: Verify Link Send OTP
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                sessionId : #(sessionId) //string
            }
        }
        """
        * call read(svc + 'authSvc.feature@VerifyLinkSendOTP') data
     
    @SenOTPToVerifyUser
    Scenario: Send OTP To Verify User
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                sessionId : #(sessionId) //string
            }
        }
        """
        * call read(svc + 'authSvc.feature@SendOTPToVerifyUser') data
     
    @VerifyOTPSendToUser
    Scenario: Verify OTP Send To User
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                sessionId : #(sessionId), //string
                code : #(code) //string
            }
        }
        """
        * call read(svc + 'authSvc.feature@VerifyOTPSendToUser') data
     
    @ResendEmailToUser
    Scenario: Resend Email To User
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            userId : #(userId) //string
        }
        """
        * call read(svc + 'authSvc.feature@ResendEmailToUser') data
     
    @CheckVersion
    Scenario: Check Version
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                version : #(version) //string
            }
        }
        """
        * call read(svc + 'authSvc.feature@CheckVersion') data
     
    @StoreVersion
    Scenario: Store Version
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                version : #(version) //string
            }
        }
        """
        * call read(svc + 'authSvc.feature@StoreVersion') data

    @GetListFeatureAccess
    Scenario: Get List Feature Access
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            params:{
                limit : #(limit), //number
                offset : #(offset), //number
                sort : #(sort), //string
                keyword : #(keyword), //string
                sortBy : #(sortBy) //string
            }
        }
        """
        * call read(svc + 'authSvc.feature@GetListFeatureAccess') data
     
    @GetFeatureDetail
    Scenario: Get Feature Detail
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            featureId : #(featureId), //string
            params:{
                limit : #(limit), //number
                offset : #(offset), //number
                sort : #(sort), //string
                keyword : #(keyword) //string
            }
        }
        """
        * call read(svc + 'authSvc.feature@GetFeatureDetail') data
     
    @InitUpdateFeatureRequest
    Scenario: Init Update Feature Request
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            featureId : #(featureId), //string
            body: 
            {
                groups : #(groups) //array
            }
        }
        """
        * call read(svc + 'authSvc.feature@InitUpdateFeatureRequest') data
     
    @GetListUser
    Scenario: Get List User
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            params: {
                limit : #(limit), //number
                offset : #(offset), //number
                searchText : #(searchText), //string
                ids : #(ids) //string
            }
        }
        """
        * call read(svc + 'authSvc.feature@GetListUser') data
     
    @GetAccountConfig
    Scenario: Get Account Config
        * def data =
        """
        {
            headers:{
                Authorization: "#(typeof accessToken == 'undefined' ? requesterAccessToken : accessToken)"
            }
        }
        """
        * call read(svc + 'authSvc.feature@GetAccountConfig') data
        Then match responseStatus == 200

    @ValidatePrerequisitesEditUser
    Scenario: Validate Prerequisites Edit User
        * def data =
        """
        {
            headers:{
                Authorization: "#(typeof accessToken == 'undefined' ? requesterAccessToken : accessToken)"
            },
            body: {
                userId: "#(userId)"
            }
        }
        """
        * call read(svc + 'authSvc.feature@ValidatePrerequisitesEditUser') data

