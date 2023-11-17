Feature: Quorums
# under core/quorums

@ViewAccountPolicy
Scenario: View Account Policy
    * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
    * call read(svc + 'coreSvc.feature@ViewAccountPolicy') {authorization:#(accessToken)}
    Then match responseStatus == 200
    * match response.status == 'success'