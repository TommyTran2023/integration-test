Feature: Login REP

@Login_REP
Scenario: Login REP to get token
    * def repAccessToken = karate.exec(`node loginREP.js ${repURL} ${email} ${privateKey.repPassword}`)
    * match repAccessToken == "#regex ey.*"
    * print repAccessToken
    * karate.set('repAccessToken', `Bearer ${repAccessToken}`)
