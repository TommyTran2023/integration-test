@RAKCON-31802 @REP
Feature: All API in REP - Customer Management page
    Background:
        * callonce read(repSvc + 'Auth.feature@LoginAsCustomerSuccess')

    @RAKCON-31804 @GetCustomerListing
    Scenario: Get list customers
        * call read(repSvc + 'Customers.feature@CustomerREPController_getListCustomer')
        Then match responseStatus == 200 
        Then assert response.data.customers.length > 0
        Then assert response.data.totalCount > 0
        * def expAddress = 
        """
        {
            "city": "#string",
            "address": "#string",
            "country": "#string",
            "postCode": "##string"
        }
        """
        * def expCustomerSchema = 
        """
        {
            "id": "#uuid",
            "status": "#string",
            "customerName": "#string",
            "businessRegistrationId": "#string",
            "businessType": "#string",
            "currentAddress": "#object",
            "currentCountryAddress": "#string",
            "hotWallet": "##string",
            "coldWallet": "##string"
        }
        """
        Then match responseStatus == 200 
        Then match each response.data.customers[*] contains expCustomerSchema
        Then match each response.data.customers[*].currentAddress contains expAddress

    @RAKCON-31805 @GetCustomerListing_Filters_SortByBUSINESS_REGISTRATION_ID
    Scenario: Get list customers - Add filters - sort by BUSINESS_REGISTRATION_ID DESC
        * def data = 
        """
        {
            sort: "DESC",
			sortBy : "BUSINESS_REGISTRATION_ID", 
			businessType : "DIGITAL_ASSET_ISSUER", 
			country : "Thailand", 
			product : "HOT_WALLET,COLD_WALLET", 
			customerStatus : "ACTIVE"
        }
        """
        * call read(repSvc + 'Customers.feature@CustomerREPController_getListCustomer') data
        Then match responseStatus == 200 
        Then match each response.data.customers[*].hotWallet == "#string"
        Then match each response.data.customers[*].coldWallet == "#string"
        * def actualBusinessList = response.data.customers.map(x => x.businessRegistrationId.toUpperCase())
        * copy expectedBusinessList = actualBusinessList
        Then match actualBusinessList == expectedBusinessList.sort().reverse()
        Then match each response.data.customers[*].businessType == "Digital asset issuer"
        Then match each response.data.customers[*].currentCountryAddress == "Thailand"
        Then match each response.data.customers[*].status == "ACTIVE"

    @RAKCON-31806 @RAKCON-31807 @GetWorkspace
    Scenario Outline: Get <type> workspace
        * call read(repSvc + 'Customers.feature@CustomerREPController_getListWorkspace') {type: <type>}
        Then match responseStatus == 200
        * def expSchema = 
        """
        {
            "id": "#number",
            "name": "#string",
            "type": <type>,
            "externalId": "#uuid"
        }
        """
        * match each response.data.workspaces contains expSchema
        Examples:
            | type |
            | warm |
            | cold |

    @GetEntityRelation
    Scenario: Get entity relation
        * call read(repSvc + 'Customers.feature@CustomerREPController_getListCustomerEntityRelation')
        Then match responseStatus == 200
            



