Feature: Group Policies 
# /advance-quorum/group-policies

@GetGroupPolicies
Scenario: Get Group Policies
    * def keyword = karate.get('keyword','')
    * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
    * def data =
    """
    {
        "authorization":#(accessToken),
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
    
@GetGroupDetails
Scenario: Get Group Details
    * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
    * def data =
    """
    {
        "authorization":#(accessToken),
        "groupId":#(groupId)
    }
    """
    * call read('this:advQuorumSvc.feature@GetGroupDetails') data

@GetGroupsWithDetailsByIds
Scenario: Get Groups With Details By Ids
    * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
    * def data =
    """
    {
        "authorization":#(accessToken),
        "params": {
            "limit": 10,
            "offset": 0,
            "searchText": "",
            "ids": #(ids)
        }
    }
    """
    * call read('this:coreSvc.feature@GetGroupsWithDetailsByIds') data
    * match responseStatus == 200
    * match response.code == 200
    * match response.status == 'success'