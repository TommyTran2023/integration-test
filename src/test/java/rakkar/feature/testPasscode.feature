Feature: test passcode

@test_passcode
Scenario: test passcode
  * print approverPasscode
  * def accessToken = karate.call(svc + 'Biometric.feature@ApproverDoBiometric').approvalAccessToken
  * call read(svc + 'Auth.feature@VerifyPasscode') { passcode : #(approverPasscode), accessToken: #(accessToken) }
  * match response.data.verify == true


@test_passcode
Scenario: test passcode
  * print requesterPasscode
  * def accessToken = karate.call(svc + 'Biometric.feature@RequesterDoBiometric').requesterAccessToken
  * call read(svc + 'Auth.feature@VerifyPasscode') { passcode : #(requesterPasscode), accessToken: #(accessToken) }
  * match response.data.verify == true