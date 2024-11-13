@ignore
Feature: Login app as Rakkar Admin user
  Background:
    * def repUsers = read('classpath:data/rep_account.json')

    @LoginAsCompliance
  Scenario: Login as Compliance REP User
    * def repUser = repUsers.find(x => x.role == 'Compliance')
    * callonce read(repSvc + 'Auth.feature@Login_REP') {email: '#(repUser.email)'}

    @LoginAsCustomerSuccess
  Scenario: Login as Customer Success REP User
    * def repUser = repUsers.find(x => x.role == 'CustomerSuccess')
    * callonce read(repSvc + 'Auth.feature@Login_REP') {email: '#(repUser.email)'}

    @LoginAsFinance
  Scenario: Login as Finance REP User
    * def repUser = repUsers.find(x => x.role == 'Finance')
    * callonce read(repSvc + 'Auth.feature@Login_REP') {email: '#(repUser.email)'}

    @LoginAsOperation
  Scenario: Login as Operation REP User
    * def repUser = repUsers.find(x => x.role == 'Operation')
    * callonce read(repSvc + 'Auth.feature@Login_REP') {email: '#(repUser.email)'}

    @LoginAsProduct
  Scenario: Login as Product REP User
    * def repUser = repUsers.find(x => x.role == 'Product')
    * callonce read(repSvc + 'Auth.feature@Login_REP') {email: '#(repUser.email)'}

    @LoginAsProductReviewTransaction
  Scenario: Login as Product Review Transaction REP User
    * def repUser = repUsers.find(x => x.role == 'ProductReviewTransaction')
    * callonce read(repSvc + 'Auth.feature@Login_REP') {email: '#(repUser.email)'}

    @LoginAsSecurity
  Scenario: Login as Security REP User
    * def repUser = repUsers.find(x => x.role == 'Security')
    * callonce read(repSvc + 'Auth.feature@Login_REP') {email: '#(repUser.email)'}
