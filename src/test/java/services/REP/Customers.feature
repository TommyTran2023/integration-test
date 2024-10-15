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
        
