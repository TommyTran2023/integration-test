    @ignore
Feature: Login REP
  Background:
    * def repUsers = read('classpath:data/rep_account.json')

    @Login_REP
  Scenario: Login REP to get token
    * def repAccessToken = karate.exec(`node loginREP.js ${repURL} ${email} ${privateKey.repPassword}`)
    * match repAccessToken == "#regex ey.*"
    * print repAccessToken
    * def repAccessToken = `Bearer ${repAccessToken}`

    @LoginAsCustomerSuccess
  Scenario: Login REP as Customer Success
    * def repUser = repUsers.find(x => x.role == 'CustomerSuccess')
    * call read('@Login_REP') {email: '#(repUser.email)'}

    @LoginAsOperation
  Scenario: Login REP as Operation
    * def repUser = repUsers.find(x => x.role == 'Operation')
    * call read('@Login_REP') {email: '#(repUser.email)'}

    @LoginAsCompliance
  Scenario: Login REP as Compliance
    * def repUser = repUsers.find(x => x.role == 'Compliance')
    * call read('@Login_REP') {email: '#(repUser.email)'}

    @LoginAsFinance
  Scenario: Login REP as Finance
    * def repUser = repUsers.find(x => x.role == 'Finance')
    * call read('@Login_REP') {email: '#(repUser.email)'}

    @LoginAsProductReviewTransaction
  Scenario: Login REP as Product Review Transaction
    * def repUser = repUsers.find(x => x.role == 'ProductReviewTransaction')
    * call read('@Login_REP') {email: '#(repUser.email)'}

    @LoginAsSecurity
  Scenario: Login REP as Security
    * def repUser = repUsers.find(x => x.role == 'Security')
    * call read('@Login_REP') {email: '#(repUser.email)'}
