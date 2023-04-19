@RAKCON-10949
  Feature: User Management
    Background:
      * url baseURL
      * call read('RequesterAuthenticator.feature@RequesterAccessToken')
      * def dataBody = read('classpath:data/schema.json')
      * def Collections = Java.type('java.util.Collections')

    @ignore @GetAccountMe
    Scenario: Get basic information
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

     @RAKCON-11020 @Edit_own_profile
      Scenario: Check edit own profile - edit avatar
      * call read('UserManagement.feature@GetAccountMe')
      * def query_upload_link = { contentType: 'image/jpg', fileName:'image_test.jpg', userId: '#(userId)'}
      * call read('Common.feature@UPLOAD_LINK')
      * call read('UploadFile.feature@PUT_VIDEO')
      * def body = { "uploadToken":'#(uploadToken)'}
      Given path 'auth/account/users/'+ userId + '/avatar'
      And request body
      When method PUT
      Then status 200
      And match response.status == "success"

       @ignore @Review_edit_user
       Scenario: Change Role - Review role change
         * call read('UserManagement.feature@User_listing')
         * def body = { "reason":'',"roleWillUpdate":'ADMIN',"vaultsWillRemoveAccess":[], "vaultsWillAddAccess": []}
         Given path 'auth/account/check-quorum/' + userId
         And request body
         When method PUT
         Then status 200
         And match response.status == "success"
#         And match response.data.accountLVCheck.isValidNumUserInQuorum == true

       @RAKCON-11021 @Change_role
       Scenario: Change Role - Check submit change
         * call read('UserManagement.feature@Review_edit_user')
         * def body = { "reason":'Note',"roleWillUpdate":'ADMIN',"vaultsWillRemoveAccess":[], "vaultsWillAddAccess": []}
         * call read('Common.feature@FIDO-Requester')
         * header challenge-answer = challengeAnswerRequest
         Given path 'auth/account/users/' + userId
         And request body
         When method PUT
         Then status 200
         And match response.status == "success"
         * call read('UserManagement.feature@View_user_detail')
         * def requestId = response.data.pendingRequestId

     @RAKCON-11929 @Cancel_Change_role
     Scenario: Edit user - Cancel change role
       * def value = call read('UserManagement.feature@View_My_Request_Edit_User')
       * def requestId = value.response.data.records[0].id
       * call read('CancelRequest.feature@CancelRequestCommon')

    @ignore @View_My_Request_Edit_User
    Scenario: View my request for type transfer
      * call read('UserManagement.feature@GetAccountMe')
      Given path 'core/quorums'
      * def body = { offset : '0',limit : '10',keyword : '',requestCategories:["USER"],createdBy: '#(userId)',status : ["PENDING"],isHistory : true }
      And request body
      When method POST
      Then status 201
      And match response.data.records[0].type.value == 'UPDATE_USER'
      And match response.data.records[0].type.nameDisplay == 'Edit User'
#      * def requestId = response.data.records[0].id
#      * print 'requestId',