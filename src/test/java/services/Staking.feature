Feature: Staking

    @GetStakingRecords
    Scenario: Get Staking Records
        * def keyword = karate.get('keyword','')
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
        {
            authorization: #(accessToken),
            params: {
                keyword: '#(keyword)',
                limit: 10,
                offset: 0
            }
        }
        """
        * call read('this:stakingSvc.feature@GetStakingRecords') data

        @GetStakingDetails
        Scenario: Get Staking Details
            * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
            * call read('this:stakingSvc.feature@GetStakingDetails') {authorization: #(accessToken), stakeId:#(stakeId)}
