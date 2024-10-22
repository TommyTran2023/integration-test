Feature: Login app as Rakkar Admin user

@Login
Scenario: Login as Viewer Rakkar User
    * callonce read(svc + 'Auth.feature@GetUserAccessToken') { userName: '#(viewer1)', passcode: '#(requesterPasscode)'}
