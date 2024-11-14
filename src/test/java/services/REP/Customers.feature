Feature: REP - Customers

    @CustomerREPController_getListCustomer
 	Scenario: Customer REPController get List Customer
  		* def accessToken = typeof accessToken == 'undefined' ? repAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: "#(accessToken)"
 			},
 			params: 
 			{
				limit : "#(typeof limit == 'undefined' ? 10 : limit)", 
				page : "#(typeof page == 'undefined' ? 1 : page)", 
				offset : "#(typeof offset == 'undefined' ? null : offset)", 
				sort : "#(typeof sort == 'undefined' ? 'ASC' : sort)", 
				keyword : "#(typeof keyword == 'undefined' ? null : keyword)", 
				sortBy : "#(typeof sortBy == 'undefined' ? 'CUSTOMER_NAME' : sortBy)", 
				businessType : "#(typeof businessType == 'undefined' ? null : businessType)", 
				country : "#(typeof country == 'undefined' ? null : country)", 
				product : "#(typeof product == 'undefined' ? null : product)", 
				workspace : "#(typeof workspace == 'undefined' ? null : workspace)", 
				customerStatus : "#(typeof customerStatus == 'undefined' ? null : customerStatus)", 
				hasInvoicesReviewed : "#(typeof hasInvoicesReviewed == 'undefined' ? null : hasInvoicesReviewed)", 
				searchOnScreen : "#(typeof searchOnScreen == 'undefined' ? null : searchOnScreen)"
 			}
  		}
  		"""
  		* call read('this:coreSvc.feature@CustomerREPController_getListCustomer') data

    #----------------------------------
    @CustomerREPController_createNewCustomer
  Scenario: Customer REPController create New Customer
    * def accessToken = typeof accessToken == 'undefined' ? repAccessToken : accessToken
    * def data = 
    """
    {
        headers: 
        { 
            authorization: "#(accessToken)"
        },
        requestBody: '#(requestBody)', 
    }
    """
    * call read('this:coreSvc.feature@CustomerREPController_createNewCustomer') data

    #----------------------------------
    @CustomerREPController_getListAssetsStaking
  Scenario: Customer REPController get List Assets Staking
    * def accessToken = typeof accessToken == 'undefined' ? repAccessToken : accessToken
    * def data = 
    """
    {
        headers: 
        { 
            authorization: "#(accessToken)"
        },
    }
    """
    * call read('this:coreSvc.feature@CustomerREPController_getListAssetsStaking') data

    #----------------------------------
    @CustomerREPController_getTotalActiveCustomer
  Scenario: Customer REPController get Total Active Customer
    * def accessToken = typeof accessToken == 'undefined' ? repAccessToken : accessToken
    * def data = 
    """
    {
        headers: 
        { 
            authorization: "#(accessToken)"
        },
    }
    """
    * call read('this:coreSvc.feature@CustomerREPController_getTotalActiveCustomer') data

    #----------------------------------
    @CustomerREPController_getListBusinessType
  Scenario: Customer REPController get List Business Type
    * def accessToken = typeof accessToken == 'undefined' ? repAccessToken : accessToken
    * def data = 
    """
    {
        headers: 
        { 
            authorization: "#(accessToken)"
        },
    }
    """
    * call read('this:coreSvc.feature@CustomerREPController_getListBusinessType') data

    #----------------------------------
    @CustomerREPController_getListWorkspace
  Scenario: Customer REPController get List Workspace
    * def accessToken = typeof accessToken == 'undefined' ? repAccessToken : accessToken
    * def data = 
    """
    {
        headers: 
        { 
            authorization: "#(accessToken)"
        },
        params: 
        {
            type : "#(typeof type == 'undefined' ? '' : type)", 
        }
    }
    """
    * call read('this:coreSvc.feature@CustomerREPController_getListWorkspace') data

    #----------------------------------
    @CustomerREPController_getListCustomerEntityRelation
  Scenario: Customer REPController get List Customer Entity Relation
    * def accessToken = typeof accessToken == 'undefined' ? repAccessToken : accessToken
    * def data = 
    """
    {
        headers: 
        { 
            authorization: "#(accessToken)"
        },
    }
    """
    * call read('this:coreSvc.feature@CustomerREPController_getListCustomerEntityRelation') data

    #----------------------------------
    @CustomerREPController_checkCustomerBRIAndCountry
  Scenario: Customer REPController check Customer BRIAnd Country
    * def accessToken = typeof accessToken == 'undefined' ? repAccessToken : accessToken
    * def data = 
    """
    {
        headers: 
        { 
            authorization: "#(accessToken)"
        },
        params: 
        {
            businessRegistrationId : "#(typeof businessRegistrationId == 'undefined' ? '' : businessRegistrationId)", 
            country : "#(typeof country == 'undefined' ? '' : country)", 
        }
    }
    """
    * call read('this:coreSvc.feature@CustomerREPController_checkCustomerBRIAndCountry') data

    #----------------------------------
    @CustomerREPController_checkCustomerShortName
  Scenario: Customer REPController check Customer Short Name
    * def accessToken = typeof accessToken == 'undefined' ? repAccessToken : accessToken
    * def data = 
    """
    {
        headers: 
        { 
            authorization: "#(accessToken)"
        },
        params: 
        {
            customerShortName : "#(typeof customerShortName == 'undefined' ? '' : customerShortName)", 
        }
    }
    """
    * call read('this:coreSvc.feature@CustomerREPController_checkCustomerShortName') data

    #----------------------------------
    @CustomerREPController_getAccountTotalPendingRequest
  Scenario: Customer REPController get Account Total Pending Request
    * def accessToken = typeof accessToken == 'undefined' ? repAccessToken : accessToken
    * def data = 
    """
    {
        headers: 
        { 
            authorization: "#(accessToken)"
        },
    }
    """
    * call read('this:coreSvc.feature@CustomerREPController_getAccountTotalPendingRequest') data

    #----------------------------------
    @CustomerREPController_getCustomerDetail
  Scenario: Customer REPController get Customer Detail
    * def accessToken = typeof accessToken == 'undefined' ? repAccessToken : accessToken
    * def data = 
    """
    {
        headers: 
        { 
            authorization: "#(accessToken)"
        },
        customerId : "#(typeof customerId == 'undefined' ? '' : customerId)", 
        params: 
        {
            includeAdditionalContacts : "#(typeof includeAdditionalContacts == 'undefined' ? '' : includeAdditionalContacts)", 
        }
    }
    """
    * call read('this:coreSvc.feature@CustomerREPController_getCustomerDetail') data

    @CustomerREPController_updateCustomerQuorum
  Scenario: Customer REPController update Customer Quorum
    * def accessToken = typeof accessToken == 'undefined' ? repAccessToken : accessToken
    * def data = 
    """
    {
        headers: 
        { 
            authorization: "#(accessToken)"
        },
        customerId : "#(typeof customerId == 'undefined' ? '' : customerId)", 
        body: 
        {
            quorumSize : '#(quorumSize)',
            memberRequired : '#(memberRequired)',
            note : '#(note)',
        }
    }
    """
    * call read('this:coreSvc.feature@CustomerREPController_updateCustomerQuorum') data

    @CustomerREPController_deleteProfile
  Scenario: Customer REPController delete Profile
    * def accessToken = typeof accessToken == 'undefined' ? repAccessToken : accessToken
    * def data = 
    """
    {
        headers: 
        { 
            authorization: "#(accessToken)"
        },
        customerId : "#(typeof customerId == 'undefined' ? '' : customerId)", 
    }
    """
    * call read('this:coreSvc.feature@CustomerREPController_deleteProfile') data

    #----------------------------------
    @CustomerREPController_getAccountAdminPolicy
  Scenario: Customer REPController get Account Admin Policy
    * def accessToken = typeof accessToken == 'undefined' ? repAccessToken : accessToken
    * def data = 
    """
    {
        headers: 
        { 
            authorization: "#(accessToken)"
        },
        customerId : "#(typeof customerId == 'undefined' ? '' : customerId)", 
        params: 
        {
            ignoreStatus : "#(typeof ignoreStatus == 'undefined' ? '' : ignoreStatus)", 
        }
    }
    """
    * call read('this:coreSvc.feature@CustomerREPController_getAccountAdminPolicy') data

    #----------------------------------
    @CustomerREPController_getListVaultByCustomerId
  Scenario: Customer REPController get List Vault By Customer Id
    * def accessToken = typeof accessToken == 'undefined' ? repAccessToken : accessToken
    * def data = 
    """
    {
        headers: 
        { 
            authorization: "#(accessToken)"
        },
        customerId : "#(typeof customerId == 'undefined' ? '' : customerId)", 
    }
    """
    * call read('this:coreSvc.feature@CustomerREPController_getListVaultByCustomerId') data

    #----------------------------------
    @CustomerREPController_changeSubscribeStakingOfCustomer
  Scenario: Customer REPController change Subscribe Staking Of Customer
    * def accessToken = typeof accessToken == 'undefined' ? repAccessToken : accessToken
    * def data = 
    """
    {
        headers: 
        { 
            authorization: "#(accessToken)"
        },
        customerId : "#(typeof customerId == 'undefined' ? '' : customerId)", 
        body: 
        {
            editSubscribeStaking : '#(editSubscribeStaking)',
        }
    }
    """
    * call read('this:coreSvc.feature@CustomerREPController_changeSubscribeStakingOfCustomer') data

    #----------------------------------
    @CustomerREPController_checkPassportNumber
  Scenario: Customer REPController check Passport Number
    * def accessToken = typeof accessToken == 'undefined' ? repAccessToken : accessToken
    * def data = 
    """
    {
        headers: 
        { 
            authorization: "#(accessToken)"
        },
        passportNumber : "#(typeof passportNumber == 'undefined' ? '' : passportNumber)", 
    }
    """
    * call read('this:coreSvc.feature@CustomerREPController_checkPassportNumber') data

    #----------------------------------
    @CustomerREPController_getWorkspaceByUser
  Scenario: Customer REPController get Workspace By User
    * def accessToken = typeof accessToken == 'undefined' ? repAccessToken : accessToken
    * def data = 
    """
    {
        headers: 
        { 
            authorization: "#(accessToken)"
        },
    }
    """
    * call read('this:coreSvc.feature@CustomerREPController_getWorkspaceByUser') data

    #----------------------------------
    @CustomerREPController_getWorkspaceNameByUser
  Scenario: Customer REPController get Workspace Name By User
    * def accessToken = typeof accessToken == 'undefined' ? repAccessToken : accessToken
    * def data = 
    """
    {
        headers: 
        { 
            authorization: "#(accessToken)"
        },
    }
    """
    * call read('this:coreSvc.feature@CustomerREPController_getWorkspaceNameByUser') data

    #----------------------------------
    @CustomerREPController_isTokenRequestedStakeSubscription
  Scenario: Customer REPController is Token Requested Stake Subscription
    * def accessToken = typeof accessToken == 'undefined' ? repAccessToken : accessToken
    * def data = 
    """
    {
        headers: 
        { 
            authorization: "#(accessToken)"
        },
        externalAssetId : "#(typeof externalAssetId == 'undefined' ? '' : externalAssetId)", 
    }
    """
    * call read('this:coreSvc.feature@CustomerREPController_isTokenRequestedStakeSubscription') data

    #----------------------------------
    @CustomerREPController_createStakingSubscriptionTicket
  Scenario: Customer REPController create Staking Subscription Ticket
    * def accessToken = typeof accessToken == 'undefined' ? repAccessToken : accessToken
    * def data = 
    """
    {
        headers: 
        { 
            authorization: "#(accessToken)"
        },
        customerId : "#(typeof customerId == 'undefined' ? '' : customerId)", 
        body: 
        {
            tokens : '#(tokens)',
        }
    }
    """
    * call read('this:coreSvc.feature@CustomerREPController_createStakingSubscriptionTicket') data

        
