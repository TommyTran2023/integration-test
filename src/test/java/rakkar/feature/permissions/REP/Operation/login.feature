Feature: Login app as Rakkar Admin user

@Login
Scenario: Login as Customer Success REP User
    * def repUser = read('classpath:data/rep_account.json').find(x => x.role == 'CustomerSuccess')
    * callonce read(repSvc + 'Auth.feature@Login_REP') {email: '#(repUser.email)'}
