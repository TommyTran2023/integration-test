@RAKCON-10583
Feature: Account admin policy
    Background:
        * callonce read(svc + 'ReadData.feature')
        * callonce read(svc + 'Auth.feature@GetRequesterAccessToken')
        * def getRequesterInfo = callonce read(svc + 'Auth.feature@GetRequesterInfo')
        * def requestHandle = read('classpath:rakkar/common/RequestHandle.js')

    @ViewAccountPolicy
    Scenario: View account policy
        * call read(svc + 'Quorums.feature@GetAccountPolicy')
        * match response.data.organizationName == '#string'
        * def quorumParticipantSchema = schemaBody.accountPolicy.schema_list
        * match response.data.quorumParticipants contains quorumParticipantSchema
        * def requestId = response.data.pendingRequestId
        

    @EditAccountPolicy
    Scenario: Edit account policy
        * def customerId = getRequesterInfo.response.data.customerId
        * callonce read('@ViewAccountPolicy')
        * requestHandle().cancelPendingRequest(requestId)
        * call read(svc + 'Biometric.feature@RequesterDoBiometric')
        * call read(svc + 'Customers.feature@EditAccountPolicy') {customerId:#(customerId)}
        Then match responseStatus == 200
        * match response.status == 'success'
        * call read('@ViewAccountPolicy')
        * match requestId != null

    @EditAccountPolicyHasPending
    Scenario: Edit account policy when has pending request
        * callonce read('@EditAccountPolicy')
        * call read(svc + 'Biometric.feature@RequesterDoBiometric')
        * call read(svc + 'Customers.feature@EditAccountPolicy') {customerId:#(customerId)}
        Then match responseStatus == 400
        * match response.errorCode == Const.ErrorCode.EXISTS_PENDING_REQUEST

    @ViewAccountPolicyRequest
    Scenario: View account policy request
        * call read('@EditAccountPolicy')
        * call read(svc + 'Quorums.feature@ViewAccountPolicyRequest')
        * match response.data.id == requestId
        * match response.data.action == Const.Action.EDIT_ACCOUNT_POLICY
        * def approvalLogs = response.data.approvalLogs
        * def initiator = karate.jsonPath(approvalLogs,"$.[?(@.status=='INITIATED')].userId")
        * requestHandle().cancelPendingRequest(requestId)