    @RAKCON-10583
  Feature: User Management
    Background:
      * url baseURL
      * call read('this:RequesterAuthenticator.feature@RequesterAccessToken')
      * def Collections = Java.type('java.util.Collections')
      * def schemaJson = read('classpath:data/schema.json')
      * def requestHandle = read('classpath:rakkar/common/RequestHandle.js')
      * configure afterScenario =
        """
        function(){
           karate.call('this:AfterHook.feature@Handle_Pending_Request_Edit_User');
        }
         """

    @RAKCON-11799 @User_listing
      Scenario: View user listing
      * def query = { limit:'10', offset: '0', status: 'ACTIVE'}
      Given path 'auth/account/users'
      And params query
      When method GET
      Then status 200
      And match response.status == "success"
      * match each $response.data.users[*].name == schemaJson.userManagement.name
      * match each $response.data.users[*].role == schemaJson.userManagement.role
      * match each $response.data.users[*].isLostDevice == schemaJson.userManagement.isLostDevice

    @RAKCON-11017 @Search_user_list
    Scenario: Check search for user list
      * def user = call read('this:UserManagement.feature@User_listing')
      * def name = user.response.data.users[0].name
      * def userId = user.response.data.users[0].userId
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

    @RAKCON-11019 @Check_View_user_detail
    Scenario: Verification view user detail
      * def user = call read('this:UserManagement.feature@User_listing')
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

    @ignore @View_user_detail
    Scenario: View user detail to get id request
      * def user = call read('this:UserManagement.feature@User_listing')
      * def userId = user.response.data.users[0].userId
      Given path 'auth/account/users/' + userId
      When method GET
      Then status 200
      * def userId = response.data.userId
      * def isPendingRequest = response.data.isPendingRequest
      * def pendingRequest = response.data.pendingRequestId

    # EDIT OWN PROFILE
    @RAKCON-11020 @Edit_own_profile
      Scenario: Check edit own profile - edit avatar
      * call read('this:GetUserInfo.feature@GetUserInfo')
      * def query_upload_link = { contentType: 'image/jpg', fileName:'image_test.jpg', userId: '#(userId)'}
      * call read('this:Common.feature@UPLOAD_LINK')
      * call read('this:UploadFile.feature@PUT_VIDEO')
      * def body = { "uploadToken":'#(uploadToken)'}
      Given path 'auth/account/users/'+ userId + '/avatar'
      And request body
      When method PUT
      Then status 200
      And match response.status == "success"

    # CHANGE ROLE
    @RAKCON-12903 @Review_change_role
       Scenario: Change Role - Check review change role
         * def data = call read('this:UserManagement.feature@User_listing')
         * def userId = data.response.data.users[1].userId
         * def body = { "reason":'',"roleWillUpdate":'ADMIN',"vaultsWillRemoveAccess":[], "vaultsWillAddAccess": []}
         * call read('this:UserManagement.feature@Review_update_user_common')
         And match response.data contains schemaJson.userManagement.review_edit_user

    @RAKCON-11021 @Change_role
       Scenario: Change Role - Check submit change
      * call read('this:UserManagement.feature@View_user_detail')
      * def body = { "reason":'Note',"roleWillUpdate":'ADMIN',"vaultsWillRemoveAccess":[], "vaultsWillAddAccess": []}
      * requestHandle().cancelPendingRequest(pendingRequest)
      * call read('this:UserManagement.feature@Submit_edit_user_common')

    # ADD VAULT ACCESS
    @ignore @List_vault_unassign
    Scenario: Get list vault unassign
      * def query = { limit:'10', offset: '0', userId:'#(userId)'}
      Given path 'core/vault/unassigned'
      And params query
      When method GET
      Then status 200
      And match response.status == "success"
      * def vaultId = response.data.vaults[0].id

    @RAKCON-13107 @Review_add_vault_access
    Scenario: Change vault access - Review add vault access
      * def data = call read('this:UserManagement.feature@User_listing')
      * def userId = data.response.data.users[2].userId
      * call read('this:UserManagement.feature@List_vault_unassign')
      * def body = { "reason":'',"roleWillUpdate":'ADMIN',"vaultsWillRemoveAccess":[], "vaultsWillAddAccess": ['#(vaultId)']}
      * call read('this:UserManagement.feature@Review_update_user_common')
      And match response.data contains schemaJson.userManagement.review_edit_user


    @RAKCON-11035 @Add_vault_access
    Scenario: Check add vault access - Submit request
      * call read('this:UserManagement.feature@View_user_detail')
      * call read('this:UserManagement.feature@List_vault_unassign')
      * def body = { "reason":'Note',"roleWillUpdate":'ADMIN',"vaultsWillRemoveAccess":[], "vaultsWillAddAccess": ['#(vaultId)']}
      * requestHandle().cancelPendingRequest(pendingRequest)
      * call read('this:UserManagement.feature@Submit_edit_user_common')

    # REMOVE VAULT ACCESS
    @RAKCON-13108 @Review_remove_vault_access
    Scenario: Change vault access - Review remove vault access
      * def data = call read('UserManagement.feature@User_listing')
      * def userId = data.response.data.users[3].userId
      * call read('UserManagement.feature@List_vault_unassign')
      * def body = { "reason":'',"roleWillUpdate":'ADMIN',"vaultsWillRemoveAccess":['#(vaultId)'], "vaultsWillAddAccess": []}
      * call read('UserManagement.feature@Review_update_user_common')
      And match response.data contains schemaJson.userManagement.review_edit_user

    @RAKCON-11039 @Remove_vault_access
    Scenario: Check remove vault access - Submit request
      * call read('this:UserManagement.feature@View_user_detail')
      * call read('this:UserManagement.feature@List_vault_unassign')
      * def body = { "reason":'Note',"roleWillUpdate":'ADMIN',"vaultsWillRemoveAccess":['#(vaultId)'], "vaultsWillAddAccess": []}
      * requestHandle().cancelPendingRequest(pendingRequest)
      * call read('this:UserManagement.feature@Submit_edit_user_common')

    # REMOVE ACCOUNT ACCESS
    @RAKCON-13135 @Review_remove_account_access
    Scenario: Review remove account access
      * def data = call read('this:UserManagement.feature@User_listing')
      * def userId = data.response.data.users[1].userId
      * def body = { "reason":'',"isRemoveAccountAccess":true}
      * call read('this:UserManagement.feature@Review_update_user_common')
      And match response.data.accountLVCheck contains schemaJson.userManagement.review_remove_account.accountLVCheck
      And match response.data.vaultLVCheck contains schemaJson.userManagement.review_remove_account.vaultLVCheck

    @RAKCON-11025 @Remove_account_access
    Scenario: Check remove account access - Submit
      * call read('this:UserManagement.feature@View_user_detail')
      * def body = { "reason":'Note',"isRemoveAccountAccess":true}
      * requestHandle().cancelPendingRequest(pendingRequest)
      * call read('this:UserManagement.feature@Submit_edit_user_common')

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
      * call read('this:Common.feature@FIDO-Requester')
      * header challenge-answer = challengeAnswerRequest
      Given path 'auth/account/users/' + userId
      And request body
      When method PUT
      Then status 200
      And match response.status == "success"

    @ignore @View_My_Request_Edit_User
    Scenario: View my request for type edit user
      * call read('this:GetUserInfo.feature@GetUserInfo')
      Given path 'core/quorums'
      * def body = { offset : '0',limit : '10',keyword : '',requestCategories:["USER"],createdBy: '#(userId)',status : ["PENDING"],isHistory : true }
      And request body
      When method POST
      Then status 201
      * def total = response.data.total

    @ignore @Handle_existing_pending_request
    Scenario: Handle existing pending request for change role
      * call read('this:UserManagement.feature@View_My_Request_Edit_User')
      * def toTal = total == 0 ? karate.call('RejectRequest.feature@RejectRequestCommon') : karate.call('CancelRequest.feature@CancelRequestEditUserCommon')

    
    @ignore @ListUsers
    Scenario: List users
      Given path 'auth/account/list-users'
      And request { name : "",  isGetAll : true }
      When method POST
      Then status 201
      * def listUsers = response.data.users

    @RAKCON-26024 @MOB-130 @EditAdminInvolvingPendingPolicyRequest
    Scenario: Edit user - Vault have pending request
      * def groupHandle = read('classpath:rakkar/common/GroupHandle.js')
      * def group = groupHandle().selectGroupForChangePolicy()
      * def admin = group.memberInfos.find(x => x.role == "ADMIN").userId
      * call read(svc + 'Auth.feature@ValidatePrerequisitesEditUser') {userId: "#(admin)"}
      Then match responseStatus == 400
      * def expectedError = 
      """
      {
          "status":"error",
          "errorCode":"msg-edit-user:EDIT_USER_VAULT_POLICY_ADVANCED",
          "message":"msg-edit-user:EDIT_USER_VAULT_POLICY_ADVANCED",
          "code":400,
          "params":{
              "VAULTS_NAME":"#string"
          }
      }
      """
      And match response == expectedError

    
