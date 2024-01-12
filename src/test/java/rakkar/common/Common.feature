Feature: Common Feature

    Background:
        * callonce read(svc + 'ReadData.feature')
        * callonce read(svc + 'Auth.feature@GetRequesterAccessToken')
        * callonce read(svc + 'Auth.feature@GetListUsers')

    @CancelAllRequests
    Scenario: Cancel all request
        * def requestHandle = read('classpath:rakkar/common/RequestHandle.js')
        * requestHandle().cancelAllMyPendingRequest(requesterUserID)

    @RejectAllRequests
    Scenario: Reject all request
        * def requestHandle = read('classpath:rakkar/common/RequestHandle.js')
        * requestHandle().rejectAllPendingRequest()
