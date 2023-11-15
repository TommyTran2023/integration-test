@RAKCON-10583 @RAKCON-20140
Feature: Check Multi Tenancy for Stake
    Background:
        * callonce read(svc + 'ReadData.feature')
        * call read(svc + 'Auth.feature@GetUserAccessToken') {userName:#(userOtherCustomerInfor.userName)}
        * def token = 'Bearer ' + response.data.AuthenticationResult.AccessToken

    @RAKCON-21746
    Scenario: Check Listing Stake Records 
        # get Cross tenart CustomerId
        * def userInfo = call read(svc + 'Auth.feature@GetUserInfo') {accessToken:#(token)}
        * def customerId = userInfo.response.data.customerId
        * print customerId
        # check all stake records have the customer Id
        * call read(svc + 'Staking.feature@GetStakingRecords') {accessToken:#(token)}
        * def checkCustomerId = 
        """
            function(customerId){
                if (response.data.result.length > 0) 
                    for(var i=0; i<response.data.result.length; i++){
                        if (response.data.result[i].customerId != customerId){
                            throw new Error('Stake record is not customer data. expectedCustomerId: '+customerId)
                        }
                    }
            }
        """
        * eval checkCustomerId(customerId)

    @RAKCON-21747
    Scenario: View Stake record details of other customer
        # get a stake id of other customer
        * call read(svc + 'Auth.feature@GetRequesterAccessToken')
        * call read(svc + 'Staking.feature@GetStakingRecords')
        * def stakeId = response.data.result[0].id
        # View Stake record details of other customer
        * call read(svc + 'Staking.feature@GetStakingDetails') {accessToken:#(token),stakeId:#(stakeId)}
        * assert responseStatus == 400
        * assert response.code == 400
        * assert response.message == "STAKE_RECORD_NOT_FOUND"