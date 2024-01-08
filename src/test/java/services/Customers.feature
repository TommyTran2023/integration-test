Feature: Customers
# under core/customers

    @EditAccountPolicy
    Scenario: Edit Account Policy
        * def data =
        """
        {
            authorization: #(requesterAccessToken),
            customerId: #(customerId),
            challengeAnswer: #(challengeAnswerRequest),
            passcode: #(requesterInfo.requesterPasscode),
            body: {"note" : "AT Edit Account Policy Note",  "memberRequired" : [],  "quorumSize" : 2}
        }
        """
        * call read(svc + 'coreSvc.feature@EditAccountPolicy') data
        
    @GetProductSubscription
    Scenario: Get Product Subscription
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            customerId: #(customerId)
        }
        """
        * call read(svc + 'coreSvc.feature@GetProductSubscription') data
    
    @CreateProductSubscription
    Scenario: Create Product Subscription
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            customerId: #(customerId),
            body:{
                productType : #(productType), //string
                feeInformation : #(feeInformation), //null
            }
        }
        """
        * call read(svc + 'coreSvc.feature@CreateProductSubscription') data
          
    @UpdateProductSubscription
    Scenario: Update Product Subscription
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            customerId: #(customerId),
            feeInformationId: #(feeInformationId),
            body:{
                feeInformation : #(feeInformation), //null
            }
        }
        """
        * call read(svc + 'coreSvc.feature@UpdateProductSubscription') data
              
    @GetListCustomer
    Scenario: Get List Customer
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            params:{
                limit : 10,
                offset : 0,
                sort : 'ASC',
                keyword : '',
                sortBy : 'NAME',
                businessType : '',
                country : '',
                product : [],
                workspace : [],
                customerStatus : [],
                hasInvoicesReviewed : true,
                searchOnScreen : ''
            }
        }
        """
        * call read(svc + 'coreSvc.feature@GetListCustomer') data
         
    @CreateNewCustomer
    Scenario: Create New Customer
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body:{
                customerName : #(customerName), //string
                customerShortName : #(customerShortName), //string
                businessRegistrationId : #(businessRegistrationId), //string
                taxId : #(taxId), //string
                sourceOfWealth : #(sourceOfWealth), //string
                companyType : #(companyType), //string
                sourceOfWealthOther : #(sourceOfWealthOther), //string
                sourceOfFundOther : #(sourceOfFundOther), //string
                purposeOfRelationshipOther : #(purposeOfRelationshipOther), //string
                companyTypeOther : #(companyTypeOther), //string
                registrationDate : #(registrationDate), //string
                registrationAddress : #(registrationAddress), //null
                currentAddress : #(currentAddress), //null
                billingAddress : #(billingAddress), //null
                businessTypeId : #(businessTypeId), //number
                businessTypeOther : #(businessTypeOther), //string
                hotWalletId : #(hotWalletId), //number
                coldWalletId : #(coldWalletId), //number
                staking : #(staking), //null
                originOfFunds : #(originOfFunds), //string
                sourceOfFunds : #(sourceOfFunds), //string
                purposeOfRelationship : #(purposeOfRelationship), //string
                lastestRiskLevel : #(lastestRiskLevel), //string
                dateOfLastestRiskLevel : #(dateOfLastestRiskLevel), //string
                firstName : #(firstName), //string
                lastName : #(lastName), //string
                countryCode : #(countryCode), //string
                phoneNumber : #(phoneNumber), //string
                email : #(email), //string
                position : #(position), //string
                feeInformation : #(feeInformation), //null
                quorumSize : #(quorumSize), //integer
                adminQuorum : #(adminQuorum), //array
                creditTerm : #(creditTerm), //number
                entityRelationId : #(entityRelationId), //number
                additionalContacts : #(additionalContacts) //array
            }
        }
        """
        * call read(svc + 'coreSvc.feature@CreateNewCustomer') data
             
    @CheckCustomerBRIAndCountry
    Scenario: Check Customer BRI And Country
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            params:{
                businessRegistrationId: #(businessRegistrationId),
                country: #(country)
            }
        }
        """
        * call read(svc + 'coreSvc.feature@CheckCustomerBRIAndCountry') data
    
    @CheckCustomerShortName
    Scenario: Validate duplicate customer by short name
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            customerShortName: #(customerShortName)
        }
        """
        * call read(svc + 'coreSvc.feature@CheckCustomerShortName') data
           
    @Customer_GetCustomerDetail
    Scenario: Get Customer Detail
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            customerId: #(customerId),
            includeAdditionalContacts: false
        }
        """
        * call read(svc + 'coreSvc.feature@Customer_GetCustomerDetail') data
    
    @Customer_GetAccountAdminPolicy
    Scenario: Get account admin policy
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            ignoreStatus: true
        }
        """
        * call read(svc + 'coreSvc.feature@Customer_GetAccountAdminPolicy') data

    @Customer_GetCustomerWorkspace
    Scenario: Get Customer Workspace By User
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken)
        }
        """
        * call read(svc + 'coreSvc.feature@Customer_GetCustomerWorkspace') data

    @GenerateBillingByCustomerId
    Scenario: Generate Billing By Customer Id
        * def data = 
        """
        {
            authorization: #(accessToken),
            params: {
                customerId: #(customerId),
                yearMonth: #(yearMonth)
            }
        }
        """
        * call read(svc + 'coreSvc.feature@GenerateBillingByCustomerId') data

    @Customer_SyncTokenPriceByMonthYear
    Scenario: Sync Token Price By Month Year
        * def data = 
        """
        {
            authorization: #(accessToken),
            params: {
                customerId: #(customerId),
                yearMonth: #(yearMonth)
            }
        }
        """
        * call read(svc + 'coreSvc.feature@GenerateBillingByCustomerId') data