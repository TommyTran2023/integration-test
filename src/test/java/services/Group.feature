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

    @CreateGroupUsers
  Scenario: Create Group Users
    * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
    * def data =
    """
    {
        "authorization":#(accessToken),
        body:{
            name : #(name), //string
            memberIds : #(memberIds) //array
        }
    }
    """
    * call read('this:advQuorumSvc.feature@CreateGroupUsers') data

    @ValidateGroupPolicy
  Scenario: Validate group policy
    * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
    * def data =
    """
    {
        "authorization":#(accessToken),
        body:{
            groupName : #(groupName), //string
            userIds : #(userIds), //array
            exceptGroupId : #(exceptGroupId) //string
        }
    }
    """
    * call read('this:advQuorumSvc.feature@ValidateGroupPolicy') data

    @EditGroupName
  Scenario: Edit group policy name
    * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
    * def data =
    """
    {
        "authorization":#(accessToken),
        body:{
            name : #(name) //string
        }
    }
    """
    * call read('this:advQuorumSvc.feature@EditGroupName') data
    
    @EditGroupMember
  Scenario: Edit group policy name
    * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
    * def data =
    """
    {
        "authorization":#(accessToken),
        body:{
            name : #(name), //string
            memberIds : #(memberIds) //array
        }
    }
    """
    * call read('this:advQuorumSvc.feature@EditGroupMember') data
    


