Feature: Login app as Rakkar Admin user

    @LoginAsAdmin
  Scenario: Login as Admin Rakkar User
    * callonce read(svc + 'Auth.feature@GetUserAccessToken') { userName: '#(requesterInfo.requesterUsername)', passcode: '#(requesterPasscode)'}

    @LoginAsMember
  Scenario: Login as Member Rakkar User
    * callonce read(svc + 'Auth.feature@GetUserAccessToken') { userName: '#(member1)', passcode: '#(requesterPasscode)'}

    @LoginAsViewer
  Scenario: Login as Viewer Rakkar User
    * callonce read(svc + 'Auth.feature@GetUserAccessToken') { userName: '#(viewer1)', passcode: '#(requesterPasscode)'}
