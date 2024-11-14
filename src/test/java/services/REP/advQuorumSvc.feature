Feature: REP Advance Quorum Service
  Background:
    * url baseURL

    @REP_RejectRequest
    Scenario: Reject request
      * configure headers = null
      Given path 'advance-quorum/quorums/reject'
      * header Authorization = authorization
      * request {recordId : "#(requestId)", reason : "#(reason)"}
      When method PUT
