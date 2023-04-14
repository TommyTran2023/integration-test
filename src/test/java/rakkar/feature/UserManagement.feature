@RAKCON-10949 @ignore
  Feature: User Management
    Background:
      * url baseURL
      * call read('RequesterAuthenticator.feature@RequesterAccessToken')
      * def dataBody = read('classpath:data/schema.json')
      * def Collections = Java.type('java.util.Collections')

    @ignore @GetAccountMe
    Scenario: User Infor - Get basic user infor afer login
      * call read('RequesterAuthenticator.feature@RequesterAccessToken')
      Given path 'auth/account/me'
      When method GET
      Then status 200
      * def userId = response.data.id

    @RAKCON-11799 @User_listing
      Scenario: View user listing
      * def query = { limit:'10', offset: '0'}
      Given path 'auth/account/users'
      And params query
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
      * def query = { limit:'10', offset: '0',keyword: '#(name)'}
      Given path 'auth/account/users'
      And params query
      When method GET
      Then status 200
      And match response.status == "success"
      And match response.data.users[0].userId == '#(userId)'
      And match response.data.users[0].name == '#(name)'

    @RAKCON-11018 @Sort_user_asc_by_name
    Scenario: View user list - sort ASC by Name
      * def query = { limit:'10', offset: '0', sort:'ASC', sortBy: 'NAME'}
      Given path 'auth/account/users'
      And params query
      When method GET
      Then status 200
      And match response.status == "success"
      * def actualListUsers = response.data.users
      * def listUserName = $actualListUsers[*].name
      * def expectedUserList = listUserName
      * eval Collections.sort(expectedUserList, java.lang.String.CASE_INSENSITIVE_ORDER)
      * match listUserName == expectedUserList

    @RAKCON-11802 @Sort_user_desc_by_name
    Scenario: View user list - sort DESC by Name
      * def query = { limit:'10', offset: '0', sort:'DESC', sortBy: 'NAME'}
      Given path 'auth/account/users'
      And params query
      When method GET
      Then status 200
      And match response.status == "success"
      * def actualListUsers = response.data.users
      * def listUserName = $actualListUsers[*].name
      * def expectedUserList = listUserName
      * eval Collections.sort(expectedUserList, Collections.reverseOrder())
      * match listUserName == expectedUserList

    @RAKCON-11803 @Sort_user_asc_by_role
    Scenario: View user list - sort ASC by Role
      * def query = { limit:'10', offset: '0', sort:'ASC', sortBy: 'ROLE'}
      Given path 'auth/account/users'
      And params query
      When method GET
      Then status 200
      And match response.status == "success"
      * def actualListUsers = response.data.users
      * def listUserName = $actualListUsers[*].role
      * def expectedUserList = listUserName
      * eval Collections.sort(expectedUserList, java.lang.String.CASE_INSENSITIVE_ORDER)
      * match listUserName == expectedUserList

    @RAKCON-11804 @Sort_user_desc_by_role
    Scenario: View user list - sort DESC by Role
      * def query = { limit:'10', offset: '0', sort:'DESC', sortBy: 'ROLE'}
      Given path 'auth/account/users'
      And params query
      When method GET
      Then status 200
      And match response.status == "success"
      * def actualListUsers = response.data.users
      * def listUserName = $actualListUsers[*].role
      * def expectedUserList = listUserName
      * eval Collections.sort(expectedUserList, Collections.reverseOrder())
      * match listUserName == expectedUserList

    @RAKCON-11019 @View_user_detail
    Scenario: View user detail
      * def user = call read('UserManagement.feature@User_listing')
      * def userId = user.response.data.users[0].userId
      * def userName = user.response.data.users[0].userName
      * def role = user.response.data.users[0].role
      * def name = user.response.data.users[0].name
      * def email = user.response.data.users[0].email
      Given path 'auth/account/users/' + userId
      When method GET
      Then status 200
      And match response.status == "success"
      And match response.data.userName == "#(userName)"
      And match response.data.roleName == "#(role)"
      And match response.data.name == "#(name)"
      And match response.data.email == "#(email)"

