@RAKCON-10583 @ignore
  Feature: User Management
    Background:
      * url baseURL
      * call read('RequesterAuthenticator.feature@RequesterAccessToken')
      * def Collections = Java.type('java.util.Collections')
      * def schemaJson = read('classpath:data/schema.json')

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
      And match response.data.users[0].name == schemaJson.userManagement.name
      And match response.data.users[0].role == schemaJson.userManagement.role
      And match response.data.users[0].isLostDevice == schemaJson.userManagement.isLostDevice
      * def name = response.data.users[0].name
      * def userId = response.data.users[0].userId

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

    # EDIT OWN PROFILE
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

    # CHANGE ROLE
    @RAKCON-12903 @Review_change_role
       Scenario: Change Role - Check review change role
         * call read('UserManagement.feature@User_listing')
         * def body = { "reason":'',"roleWillUpdate":'ADMIN',"vaultsWillRemoveAccess":[], "vaultsWillAddAccess": []}
         * call read('UserManagement.feature@Review_update_user_common')
         And match response.data contains schemaJson.userManagement.review_edit_user


    @RAKCON-11021 @Change_role
       Scenario: Change Role - Check submit change
      * call read('UserManagement.feature@User_listing')
      * def body = { "reason":'Note',"roleWillUpdate":'ADMIN',"vaultsWillRemoveAccess":[], "vaultsWillAddAccess": []}
      * call read('UserManagement.feature@Submit_edit_user_common')

    @RAKCON-11929 @Cancel_Change_role
     Scenario: Edit user - Cancel change role
      * call read('UserManagement.feature@Cancel_edit_user_common')

    # ADD VAULT ACCESS
    @ignore @List_vault_unassign
    Scenario: Get list vault unassign
      * call read('UserManagement.feature@User_listing')
      * def query = { limit:'10', offset: '0', userId:'#(userId)'}
      Given path 'core/vault/unassigned'
      And params query
      When method GET
      Then status 200
      And match response.status == "success"
      * def vaultId = response.data.vaults[0].id

    @RAKCON-13107 @Review_add_vault_access
    Scenario: Change vault access - Review add vault access
      * call read('UserManagement.feature@List_vault_unassign')
      * def body = { "reason":'',"roleWillUpdate":'ADMIN',"vaultsWillRemoveAccess":[], "vaultsWillAddAccess": ['#(vaultId)']}
      * call read('UserManagement.feature@Review_update_user_common')
      And match response.data contains schemaJson.userManagement.review_edit_user


    @RAKCON-11035 @Add_vault_access
    Scenario: Check add vault access - Submit request
      * call read('UserManagement.feature@List_vault_unassign')
      * def body = { "reason":'Note',"roleWillUpdate":'ADMIN',"vaultsWillRemoveAccess":[], "vaultsWillAddAccess": ['#(vaultId)']}
      * call read('UserManagement.feature@Submit_edit_user_common')

    @RAKCON-11052 @Cancel_add_vault_access
    Scenario: Cancel request - Add vault access
      * call read('UserManagement.feature@Cancel_edit_user_common')

    # REMOVE VAULT ACCESS
    @RAKCON-13108 @Review_remove_vault_access
    Scenario: Change vault access - Review remove vault access
      * call read('UserManagement.feature@List_vault_unassign')
      * def body = { "reason":'',"roleWillUpdate":'ADMIN',"vaultsWillRemoveAccess":['#(vaultId)'], "vaultsWillAddAccess": []}
      * call read('UserManagement.feature@Review_update_user_common')
      And match response.data contains schemaJson.userManagement.review_edit_user

    @RAKCON-11039 @Remove_vault_access
    Scenario: Check remove vault access - Submit request
      * call read('UserManagement.feature@List_vault_unassign')
      * def body = { "reason":'Note',"roleWillUpdate":'ADMIN',"vaultsWillRemoveAccess":['#(vaultId)'], "vaultsWillAddAccess": []}
      * call read('UserManagement.feature@Submit_edit_user_common')

    @RAKCON-11053 @Cancel_remove_access
    Scenario: Cancel request - Remove vault access
      * call read('UserManagement.feature@Cancel_edit_user_common')

    # REMOVE ACCOUNT ACCESS
    @RAKCON-13135 @Review_remove_account_access
    Scenario: Review remove account access
      * call read('UserManagement.feature@User_listing')
      * def body = { "reason":'',"isRemoveAccountAccess":true}
      * call read('UserManagement.feature@Review_update_user_common')
      And match response.data contains schemaJson.userManagement.review_remove_account

    @RAKCON-11025 @Remove_account_access
    Scenario: Check remove account access - Submit
      * call read('UserManagement.feature@User_listing')
      * def body = { "reason":'Note',"isRemoveAccountAccess":true}
      * call read('UserManagement.feature@Submit_edit_user_common')

    @RAKCON-11051 @Cancel_Remove_Account_Access
    Scenario: Cancel request - Remove Account access
      * def value = call read('UserManagement.feature@View_My_Request_Remove_User')
      * def requestId = value.response.data.records[0].id
      * call read('CancelRequest.feature@CancelRequestCommon')

    # COMMON
    @ignore @Review_update_user_common
    Scenario: Review change common
      Given path 'auth/account/check-quorum/' + userId
      And request body
      When method PUT
      Then status 200
      And match response.status == "success"

    @ignore @Submit_edit_user_common
    Scenario: Submit edit request common
      * call read('Common.feature@FIDO-Requester')
      * header challenge-answer = challengeAnswerRequest
      Given path 'auth/account/users/' + userId
      And request body
      When method PUT
      Then status 200
      And match response.status == "success"
      * call read('UserManagement.feature@View_user_detail')
      * def requestId = response.data.pendingRequestId

    @ignore @View_My_Request_Edit_User
    Scenario: View my request for type edit user
      * call read('UserManagement.feature@GetAccountMe')
      Given path 'core/quorums'
      * def body = { offset : '0',limit : '10',keyword : '',requestCategories:["USER"],createdBy: '#(userId)',status : ["PENDING"],isHistory : true }
      And request body
      When method POST
      Then status 201
      And match response.data.records[0].type.value == 'UPDATE_USER'
      And match response.data.records[0].type.nameDisplay == 'Edit User'

    @ignore @View_My_Request_Remove_User
    Scenario: View my request for remove transfer
      * call read('UserManagement.feature@GetAccountMe')
      Given path 'core/quorums'
      * def body = { offset : '0',limit : '10',keyword : '',requestCategories:["USER"],createdBy: '#(userId)',status : ["PENDING"],isHistory : true }
      And request body
      When method POST
      Then status 201
      And match response.data.records[0].type.value == 'DEACTIVATE_USER'
      And match response.data.records[0].type.nameDisplay == 'Remove User'

    @ignore @Cancel_edit_user_common
    Scenario: Cancel edit user common
      * def value = call read('UserManagement.feature@View_My_Request_Edit_User')
      * def requestId = value.response.data.records[0].id
      * call read('CancelRequest.feature@CancelRequestCommon')