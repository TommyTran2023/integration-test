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
    * def data =
    """
    {
        "authorization":#(typeof accessToken == 'undefined' ? requesterAccessToken : accessToken),
        "params": {
            "limit": 10,
            "offset": 0,
            "searchText": "",
            "ids": #(ids),
            "where": #(typeof where == 'undefined' ? '' : where)
        }
    }
    """
    * call read('this:coreSvc.feature@GetGroupsWithDetailsByIds') data
    * match responseStatus == 200
    * match response.code == 200
    * match response.status == 'success'    

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
            name : #(name),
            memberIds : #(memberIds)
        }
    }
    """
    * call read('this:advQuorumSvc.feature@EditGroupMember') data

    @GetGroups
  Scenario: Get Groups
    * def data =
    """
    {
        authorization: #(typeof accessToken == 'undefined' ? requesterAccessToken : accessToken),
        params:{
            limit : #(typeof limit == 'undefined' ? null : limit),
            offset : #(typeof offset == 'undefined' ? 0 : limit),
            searchText : #(typeof searchText == 'undefined' ? '' : searchText),
            ids : #(typeof ids == 'undefined' ? [] : ids),
            where : #(typeof where == 'undefined' ? '' : where),
        }
    }
    """
    * call read('this:coreSvc.feature@GetGroups') data

    


