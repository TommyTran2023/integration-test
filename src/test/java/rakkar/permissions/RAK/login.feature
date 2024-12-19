Feature: Login app as Rakkar Admin user
Background:
  * def loginRAK = 
  """
  function(userName, pass, userId, secret) {
    var requestIv = userId.replaceAll('-','').slice(0, 16);
    var passcode = karate.exec(`node aes.js encrypt ${pass} ${secret} ${requestIv}`)

    var userAccessToken = karate.call(svc + 'Auth.feature@GetUserAccessToken', { userName: userName }).userAccessToken
    karate.set('userAccessToken', userAccessToken)
    karate.log(userAccessToken)
    karate.log(userName)
    karate.log(passcode)
    karate.set('user', { userName: userName, passcode: passcode })
  }
  """

    @LoginAsAdmin
  Scenario: Login as Admin Rakkar User
    * print permission.admin1, permission.passcode, permission.admin1UserId, privateKey.secret
    * eval loginRAK(permission.admin1, permission.passcode, permission.admin1UserId, privateKey.secret)

    @LoginAsMember
  Scenario: Login as Member Rakkar User
    * eval loginRAK(permission.member1, permission.passcode, permission.member1UserId, privateKey.secret)

    @LoginAsViewer
  Scenario: Login as Viewer Rakkar User
    * eval loginRAK(permission.viewer1, permission.passcode, permission.viewer1UserId, privateKey.secret)
