@REP
Feature: Create Customer Quorum Validation
    Background:
        * callonce read(repSvc + 'Auth.feature@LoginAsOperation')
        * configure afterScenario = 
        """
        function() {
            //cancel create customer request
            var responseBody = karate.call(svc + 'Quorums.feature@GetRequestByKeyword', { "keyword": "autotest", "accessToken": repAccessToken }).response.data
            if (responseBody.total > 0) {
                karate.call(repSvc + 'Auth.feature@LoginAsCustomerSuccess')
                karate.call(repSvc + 'Quorums.feature@REP_RejectRequest', { "requestId": responseBody.records[0].id, "approvalAccessToken": repAccessToken })
            }
        }
        """
        * def admin1 = 
        """
        {
            "firstName": "Admin1",
            "lastName": "AutoTest",
            "userRole": "ADMIN",
            "documentType": "ID_CARD",
            "nationality": "TH",
            "address":
            {
                "address": "Admin1 Address",
                "city": "Admin1 City",
                "country": "Singapore"
            },
            "phoneNumber": "+6598798787",
            "email": "admin1@rakkardigital.com",
            "requiredApprover": false,
            "idCardNumber": "1212312121",
            "idCardIssuedCountry": "TH",
            "countryCode": "+65",
            "dateOfBirth": "2024-11-01"
        }        
        """
        * def admin2 =
        """
        {
            "firstName": "Admin2",
            "lastName": "AutoTest",
            "userRole": "ADMIN",
            "documentType": "PASSPORT",
            "nationality": "TH",
            "address":
            {
                "address": "Admin2 address",
                "city": "admin2 city",
                "country": "Singapore"
            },
            "phoneNumber": "+6598779878",
            "email": "admin2@rakkardigital.com",
            "requiredApprover": false,
            "passportNumber": "1235345234",
            "passportIssuedCountry": "SG",
            "countryCode": "+65",
            "dateOfBirth": "2024-11-01"
        }        
        """
        * def member = 
        """
        {
            "firstName": "Member1",
            "lastName": "AutoTest",
            "userRole": "MEMBER",
            "documentType": "PASSPORT",
            "nationality": "HK",
            "address":
            {
                "address": "Member1 Address",
                "city": "Member1 City",
                "country": "Singapore"
            },
            "phoneNumber": "+6590098889",
            "email": "member1@rakkardigital.com",
            "passportNumber": "qamember1",
            "passportIssuedCountry": "HK",
            "countryCode": "+65",
            "requiredApprover": false,
            "dateOfBirth": "2024-11-01"
        }        
        """
        * def viewer =
        """
        {
            "firstName": "Viewer",
            "lastName": "AutoTest",
            "userRole": "VIEWER",
            "documentType": "PASSPORT",
            "nationality": "TH",
            "address":
            {
                "address": "Viewer address",
                "city": "viewer city",
                "country": "Singapore"
            },
            "phoneNumber": "+6598788777",
            "email": "viewer1@rakkardigital.com",
            "passportNumber": "viewertest",
            "passportIssuedCountry": "TH",
            "countryCode": "+65",
            "requiredApprover": false,
            "dateOfBirth": "2024-11-01"
        }        
        """
        * def requestBody =
        """
            {
                "registrationAddress":
                {
                    "address": "company address",
                    "city": "raccoon city",
                    "country": "Singapore"
                },
                "currentAddress":
                {
                    "address": "company address",
                    "city": "raccoon city",
                    "country": "Singapore"
                },
                "billingAddress":
                {
                    "address": "company address",
                    "city": "raccoon city",
                    "country": "Singapore"
                },
                "customerName": "AUTOTEST",
                "customerShortName": "ATTT",
                "businessRegistrationId": "AUTOTEST",
                "taxId": "AUTOTEST",
                "businessTypeId": 3,
                "companyType": "PRIVATE_CO_LTD",
                "registrationDate": "2024-11-01",
                "originOfFunds": "Singapore",
                "purposeOfRelationship": "QUALIFIED_CUSTODIAN_PER_REGULATION",
                "sourceOfWealth": "BUSINESS_OPERATIONS",
                "sourceOfFunds": "BUSINESS_OPERATIONS",
                "lastestRiskLevel": "HIGH",
                "dateOfLastestRiskLevel": "2024-11-01",
                "creditTerm": 15,
                "entityRelationId": 1,
                "firstName": "Contact",
                "lastName": "Test",
                "phoneNumber": "90098889",
                "email": "natsiree+testcus@rakkardigital.com",
                "position": "test",
                "countryCode": "+65",
                "coldWalletId": #(dataSet.coldWorkspaceId),
                "hotWalletId": #(dataSet.warmWorkspaceId),
                "feeInformation":
                {
                    "hotWallet":
                    {
                        "initialSetupFee": 0,
                        "minimumMonthlyFee": 0,
                        "minimumAUCBalance": 0,
                        "assetUnderCustody":
                        [
                            {
                                "key": "0",
                                "from": 0,
                                "to": 10000000,
                                "point": 30
                            },
                            {
                                "key": "1",
                                "from": 10000000,
                                "to": 50000000,
                                "point": 25
                            },
                            {
                                "key": "2",
                                "from": 50000000,
                                "to": 100000000,
                                "point": 20
                            },
                            {
                                "key": "3",
                                "from": 100000000,
                                "to": null,
                                "point": 15
                            }
                        ]
                    },
                    "coldWallet":
                    {
                        "initialSetupFee": 0,
                        "minimumMonthlyFee": 0,
                        "minimumAUCBalance": 0,
                        "assetUnderCustody":
                        [
                            {
                                "key": "0",
                                "from": 0,
                                "to": 10000000,
                                "point": 30
                            },
                            {
                                "key": "1",
                                "from": 10000000,
                                "to": 50000000,
                                "point": 25
                            },
                            {
                                "key": "2",
                                "from": 50000000,
                                "to": 100000000,
                                "point": 20
                            },
                            {
                                "key": "3",
                                "from": 100000000,
                                "to": null,
                                "point": 15
                            }
                        ]
                    }
                },
                "quorumSize": 2,
                "adminQuorum":
                [],
                "additionalContacts":
                [
                    {
                        "firstName": "Contact",
                        "lastName": "Test",
                        "countryCode": "+65",
                        "phoneNumber": "90098889",
                        "email": "natsiree+testcus@rakkardigital.com",
                        "position": "-",
                        "type": "BILLING"
                    }
                ]
            }
        """

@RAKCON-33795
Scenario: Create Customer with 1 admin, size = 1
    * copy data = requestBody
    * set data.quorumSize = 1
    * set data.adminQuorum = [#(admin1)]
    * print data.quorumSize
    * print data.adminQuorum
    * call read(repSvc + 'Customers.feature@CustomerREPController_createNewCustomer') { requestBody: '#(data)' }
    Then match responseStatus == 400
    Then match response.errorCode == "QUORUM_SIZE < USER_APPROVAL_LIMIT"

@RAKCON-33796
Scenario: Create Customer with 2 admin, size = 1
    * copy data = requestBody
    * set data.quorumSize = 1
    * set data.adminQuorum = [#(admin1), #(admin2)]
    * print data.quorumSize
    * print data.adminQuorum
    * call read(repSvc + 'Customers.feature@CustomerREPController_createNewCustomer') { requestBody: '#(data)' }
    Then match responseStatus == 400
    Then match response.errorCode == "QUORUM_SIZE < USER_APPROVAL_LIMIT"

@RAKCON-33797
Scenario: Create Customer with 2 admin, size = 3
    * copy data = requestBody
    * set data.quorumSize = 3
    * set data.adminQuorum = [#(admin1), #(admin2)]
    * print data.quorumSize
    * print data.adminQuorum
    * call read(repSvc + 'Customers.feature@CustomerREPController_createNewCustomer') { requestBody: '#(data)' }
    Then match responseStatus == 400
    Then match response.errorCode == "QUORUM_SIZE > distinctQuorum"

@RAKCON-33798
Scenario: Create Customer with 1 admin, size = 2
    * copy data = requestBody
    * set data.quorumSize = 2
    * set data.adminQuorum = [#(admin1)]
    * print data.quorumSize
    * print data.adminQuorum
    * call read(repSvc + 'Customers.feature@CustomerREPController_createNewCustomer') { requestBody: '#(data)' }
    Then match responseStatus == 400
    Then match response.errorCode == "QUORUM_SIZE > distinctQuorum"

@RAKCON-33799
Scenario: Create Customer with 2 duplicated admin
    * copy admin1x = admin1
    * set admin1x.firstName = "Admin1x"
    * copy data = requestBody
    * set data.quorumSize = 2
    * set data.adminQuorum = [#(admin1), #(admin1x)]
    * print data.quorumSize
    * print data.adminQuorum
    * call read(repSvc + 'Customers.feature@CustomerREPController_createNewCustomer') { requestBody: '#(data)' }
    Then match responseStatus == 400
    Then match response.errorCode == "DOUBLE_USERS"

@RAKCON-33800
Scenario: Create Customer with 1 admin, 1 member, size = 2
    * copy data = requestBody
    * set data.quorumSize = 2
    * set data.adminQuorum = [#(admin1), #(member)]
    * print data.quorumSize
    * print data.adminQuorum
    * call read(repSvc + 'Customers.feature@CustomerREPController_createNewCustomer') { requestBody: '#(data)' }
    Then match responseStatus == 400
    Then match response.errorCode == "USER_ADMIN_REQUIRED"

@RAKCON-33801
Scenario: Create Customer with 2 admins, size = 2
    * copy admin1x = admin1
    * copy data = requestBody
    * set data.quorumSize = 2
    * set data.adminQuorum = [#(admin1), #(admin2)]
    * print data.quorumSize
    * print data.adminQuorum
    * call read(repSvc + 'Customers.feature@CustomerREPController_createNewCustomer') { requestBody: '#(data)' }
    Then match responseStatus == 201

