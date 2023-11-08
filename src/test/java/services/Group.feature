Feature: Group Policies 
# /advance-quorum/group-policies

@GetGroupPolicies
Scenario: Get Group Policies
    * def keyword = karate.get('keyword','')
    * def data =
    """
    {
        "authorization":#(requesterAccessToken),
        "params": {
            "limit": 10,
            "offset": 0,
            "keyword": "#(keyword)"
        }
    }
    """
    * call read('this:advQuorumSvc.feature@GetGroupPolicies') data
    Then match responseStatus == 200
    * match response.status == 'success'
    
