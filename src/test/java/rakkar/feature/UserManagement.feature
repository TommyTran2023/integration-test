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

    @RAKCON-11799 @User_listing
      Scenario: View user listing
      * def query = { limit:'10', offset: '0', sort:'ASC', sortBy: 'NAME'}
      Given path 'auth/account/users'
      When method GET
      Then status 200
      And match response.status == "success"
      * def name = response.data.users[0].name
      * def userId = response.data.users[0].userId
      * def schema = dataBody.userManagement.schema_list
      And match response.data.users contains schema

    @RAKCON-11017 @Search_user_list
    Scenario: Check search for user list
      * call read('UserManagement.feature@User_listing')
      * def query = { limit:'10', offset: '0', sort:'ASC', sortBy: 'NAME',keyword: '#(name)'}
      Given path 'auth/account/users'
      When method GET
      Then status 200
      And match response.status == "success"
      And match response.data.users[0].userId == '#(userId)'
      And match response.data.users[0].name == '#(name)'


