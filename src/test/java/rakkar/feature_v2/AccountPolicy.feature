@RAKCON-10583
Feature: Account admin policy
    Background:
        * callonce read(svc + 'ReadData.feature')
        * callonce read(svc + 'Auth.feature@GetRequesterAccessToken')
        * def getRequesterInfo = callonce read(svc + 'Auth.feature@GetRequesterInfo')
        * def requestHandle = read('classpath:rakkar/common/RequestHandle.js')

    @ViewAccountPolicy
    Scenario: View account policy
        * call read(svc + 'Quorums.feature@ViewAccountPolicy')
        * match response.data.organizationName == '#string'
        * def quorumParticipantSchema = schemaBody.accountPolicy.schema_list
        * match response.data.quorumParticipants contains quorumParticipantSchema
        * def requestId = response.data.pendingRequestId

    @EditAccountPolicy
    Scenario: Edit account policy
        * def customerId = getRequesterInfo.response.data.customerId
        * call read('@ViewAccountPolicy')
        * requestHandle().cancelPendingRequest(requestId)
        * call read(svc + 'Biometric.feature@RequesterDoBiometric')
        * call read(svc + 'Customers.feature@EditAccountPolicy') {customerId:#(customerId)}
        * call read('@ViewAccountPolicy')
        * match requestId != null