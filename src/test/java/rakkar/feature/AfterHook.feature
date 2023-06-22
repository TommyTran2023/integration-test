Feature: Handle request after each scenario or feature
  Background:
    * url baseURL
    * call read('RequesterAuthenticator.feature@RequesterAccessToken')

    @Handle_Pending_Request_Transfer
    Scenario: Handle Request Transfer
      * def body = { offset : '0',limit : '10',keyword : '',requestCategories:["TRANSFER"],createdBy: '#(userId)',status : ["PENDING"],isHistory : true }
      * call read('AfterHook.feature@Cancel_Pending_Request')


  @Cancel_Pending_Request
    Scenario: View my request common
      Given path 'core/quorums'
      And request body
      When method POST
      Then status 201
      * def dataList = response.data.records
      * def cancelRequest =
      """
      function(){
        for(var i = 0; i < dataList.length; i++) {
         var requestId = dataList[i].id
         karate.set('requestId',requestId)
         karate.call('CancelRequest.feature@CancelRequestCommon')
       }
      }
      """
     * call cancelRequest

