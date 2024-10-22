Feature: Login app as Rakkar Admin user

@Login
Scenario: Login as Member Rakkar User
    * callonce read(svc + 'Auth.feature@GetUserAccessToken') { userName: '#(member1)', passcode: '#(requesterPasscode)'}
