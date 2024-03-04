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
        "authorization": "#(accessToken)",
        "groupId": "#(groupId)"
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
      headers:{
        authorization:"#(accessToken)",
        challenge-answer: "#(challengeAnswerRequest)",
      },
      body:{
        name : "#(name)",
        memberIds : "#(memberIds)"
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
        authorization :"#(accessToken)",
        body:{
            groupName : "#(groupName)",
            userIds : "#(typeof userIds == 'undefined' ? null : userIds)",
            exceptGroupId : "#(typeof exceptGroupId == 'undefined' ? null : exceptGroupId )"
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
            name : #(name)
        }
    }
    """
    * call read('this:advQuorumSvc.feature@EditGroupName') data
    
    @EditGroupMember
  Scenario: Edit group
    * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
    * def data =
    """
    { 
      groupId: "#(groupId)",
      headers:{
        authorization: "#(accessToken)",
        challenge-answer: "#(challengeAnswerRequest)",
		    passcode: "#(typeof passcode != 'undefined' ? passcode: requesterInfo.requesterPasscode)"
      },
      body:{
          name : "#(name)",
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

    @ValidateDeleteGroup
  Scenario: Validate Delete Group
    * def data =
    """
    {
        headers:{
            Authorization: "#(typeof accessToken == 'undefined' ? requesterAccessToken : accessToken)"
        }
    }
    """
    * call read(svc + 'advQuorumSvc.feature@ValidateDeleteGroup') data

    @DeleteGroup
  Scenario: Delete Group
    * def data =
    """
    {
      headers:{
        Authorization: "#(typeof accessToken == 'undefined' ? requesterAccessToken : accessToken)",
        challenge-answer: "#(challengeAnswerRequest)"
      },
      groupId: "#(groupId)"
    }
    """
    * call read(svc + 'advQuorumSvc.feature@DeleteGroup') data


