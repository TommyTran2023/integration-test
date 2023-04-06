@RAKCON-10943 @ignore
Feature: Approval View
  # Login by approver account
  Background:
    * url baseURL
    * call read('ApprovalAuthenticator.feature')
    * def challengeApprover = call read('Common.feature@FIDO-Approver')
    * def dataBody = read('classpath:data/data_test.json')

    @RAKCON-10983 @ViewListPendingRequest
  Scenario: View list pending request to approve
      Given path '/core/quorums'
      * request {"offset":0, "limit": 10, "status": [PENDING]}
      When method POST
      Then status 201