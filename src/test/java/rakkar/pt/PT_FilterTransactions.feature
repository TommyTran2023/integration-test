@PT
Feature: Filter transactions
  Background:
    * url baseURL
    * def svc = 'classpath:rakkar/services/'
    * def testData = read('classpath:data/data_test.json')

  @test
  Scenario: Filter transaction
    # Pre: Login
    * def body = 
    """
      { 
        "initiateAuthRequest": {
           "AuthFlow": "CUSTOM_AUTH", 
           "AuthParameters": { 
            "USERNAME": '#(requesterUserName)' 
          } 
        } 
      }
    """
    * def requesterSession = call read(svc + 'Auth.feature@GetSession') {body: '#(body)'}
    * def requesterToken = requesterSession.response.data.Session
    * def body = 
    """
      { 
        "respondToAuthChallengeRequest": { 
          "ChallengeName": "CUSTOM_CHALLENGE", 
          "ChallengeResponses": { 
            "USERNAME": '#(requesterUserName)', 
            "ANSWER": '#(testData.common.challengeAnswerAuth)' 
          }, 
          "Session": '#(requesterToken)' 
        }, 
        "deviceName": "AT PT" 
      }
    """
    * call read(svc + 'Auth.feature@GetAccessTokenForLogin') {body: '#(body)'}

    # 1. List transaction with no filter
    * def query = 
    """
      {
        "limit" : 10,
        "keyword" : "",
        "offset" : 0
      }
    """
    * call read(svc + 'Transaction.feature@GetTransactionsList') {query: '#(query)'}
    * match response.code == 200

    # 2. Filter transaction by value
    * def query = 
    """
      {
        "limit" : 20,
        "keyword" : "",
        "offset" : 0,
        "priceFrom":"100",
        "priceTo":"1000"
      }
    """
    * call read(svc + 'Transaction.feature@GetTransactionsList') {query: '#(query)'}
    * match response.code == 200

    # 3. Filter transaction by type
    * def query = 
    """
      {
        "limit" : 10,
        "keyword" : "",
        "offset" : 0,
        "type":[
          "OUTGOING"
        ]
      }
    """
    * call read(svc + 'Transaction.feature@GetTransactionsList') {query: '#(query)'}
    * match response.code == 200

    # 4. Filter transaction by status
    * def query = 
    """
      {
        "limit" : 20,
        "keyword" : "",
        "offset" : 0,
        "status":[
         "REJECTED"
        ]
      }
    """
    * call read(svc + 'Transaction.feature@GetTransactionsList') {query: '#(query)'}
    * match response.code == 200

    # 5. Filter transaction by date
    * def query = 
    """
      {
        "limit" : 20,
        "dateTo" : "2023-07-19T13:16:12.436Z",
        "dateFrom" : "2023-07-12T13:16:12.429Z",
        "keyword" : "",
        "offset" : 0
      }
    """
    * call read(svc + 'Transaction.feature@GetTransactionsList') {query: '#(query)'}
    * match response.code == 200

    # 6. Filter transaction by user created
    * call read(svc + 'Auth.feature@GetUserInfo')
    * def query = 
    """
      {
        "limit" : 20,
        "keyword" : "",
        "offset" : 0,
        "createdById":'#(response.data.id)'
      }
    """
    * call read(svc + 'Transaction.feature@GetTransactionsList') {query: '#(query)'}
    * match response.code == 200

    # 7. Filter transaction by source
    * def query = 
    """
      { 
        "limit" : 20,
        "keyword" : "",
        "offset" : 0,
        "sourceData":[
          {
            "sourceType":"#(testData.whitelist.type_internal)",
            "sourceId":"#(sourceVault)"
          }
        ]
      }
    """
    * call read(svc + 'Transaction.feature@GetTransactionsList') {query: '#(query)'}
    * match response.code == 200

    # 8. Filter transaction by destination
    * def query = 
    """
      {
        "limit" : 20,
        "keyword" : "",
        "offset" : 0,
        "destinationData":[
          {
            "destinationType":"#(testData.whitelist.type_internal)",
            "destinationId":"#(destinationVault)"
          }
        ]
     }
    """
    * call read(svc + 'Transaction.feature@GetTransactionsList') {query: '#(query)'}

    # 9. View transaction detail
    * call read(svc + 'Transaction.feature@ViewTransactionDetail') {transactionId: '#(response.data.transactions[0].id)'}
