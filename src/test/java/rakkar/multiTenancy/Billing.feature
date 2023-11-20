@RAKCON-10583 @RAKCON-20140
Feature: Check Multi Tenancy for Billings
    Background:
        * callonce read(svc + 'ReadData.feature')
        * call read(svc + 'Auth.feature@GetUserAccessToken') {userName:#(userOtherCustomerInfor.userName)}
        * def token = 'Bearer ' + response.data.AuthenticationResult.AccessToken

    @RAKCON-21740
    Scenario: All Cross tenant billings have it's customer name
        * def accountPolicy = call read(svc + 'Quorums.feature@GetAccountPolicy') {accessToken:#(token)}
        * def getCrossBillings = call read(svc + 'Billing.feature@GetBillings') {accessToken:#(token)}
        * match each getCrossBillings.response.data.customerBillings[*].customerName == accountPolicy.response.data.organizationName

