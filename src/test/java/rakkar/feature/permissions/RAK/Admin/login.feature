Feature: Login app as Rakkar Admin user

@Login
Scenario: Login as Admin Rakkar User
    * def user = 
    """
    {
        userName: '#(requesterInfo.requesterUsername)',
        passcode: '#(requesterPasscode)'
    }
    """
    * callonce read(svc + 'Auth.feature@GetUserAccessToken') { userName: '#(user.userName)'}
