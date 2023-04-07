@RAKCON-10949 @ignore
  Feature: User Management
    Background:
      * url baseURL
      * call read('RequesterAuthenticator.feature@RequesterAccessToken')
      * def dataBody = read('classpath:data/data_test.json')

    @ignore @GetAccountMe
    Scenario: User Infor - Get basic user infor afer login
      * call read('RequesterAuthenticator.feature@RequesterAccessToken')
      Given path 'auth/account/me'
      When method GET
      Then status 200
      * def userId = response.data.id
