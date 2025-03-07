    @RAKCON-10583
Feature: Travel Rule 

  Background:
    * callonce read(svc + 'Auth.feature@GetUserAccessToken') { userName: '#(sg_customer.admin1)' }
    * def accessToken = userAccessToken

    @RAKCON-37364 @ValidateInitTransaction
  Scenario: Validate Init transaction
    * call read(connectDB + 'SelectVaultIdAndFolderIdForTxnTravelRule') {customerId: "#(sg_customer.customerId)"} 
    * print result
    * def sourceValue = result[0].vaultId
    * def destinationValue = result[0].folderAddressId
    * def data = 
    """
    {
        transactionAsset: "ETH_TEST5",
        transactionAmount: "0.342312",
        source: 
        {
            type: "VAULT_ID",
            value: '#(result[0].vaultId.toString())'
        },
        destination: 
        {
            type: "FOLDER_ID",
            value:"#(result[0].folderAddressId.toString())"
        }
    }
    """
    * call read(svc + 'TravelRule.feature@POST_core_v2_TravelRule_VASP_validate-init-transaction') data
    Then match responseStatus == 201
    * def travelRuleTransactionID = response.data.travelRuleTransactionID
    * def expectedSchema = 
    """
    {
    "travelRuleTransactionID": '#uuid',
    "originator": {
      "name": '#string'
    },
    "beneficiary": {
      "name": '#string',
      "geographicAddress": '#string',
      "vaspInfo": {
        "customerId": '#uuid',
        "isDeleted": '#boolean',
        "status": '#string',
        "createdBy": '#uuid',
        "updatedBy": '#uuid',
        "id": "#(result[0].vaspId)",
        "did": '#string', 
        "name": '#string',
        "website": '#string',
        "logo": '#string',
        "incorporationCountry": '#string',
        "jurisdictions": '#string',
        "forceFields": '#array',
        "createdAt": '#string',
        "updatedAt": '#string',
        "isRakkar": '#boolean'
      }
    },
    "missingFields": '#array',
    "isValid": '#boolean'
    }    
    """
    * match response.data contains expectedSchema 

    @RAKCON-37365 @ValidateConfirmTransaction
  Scenario: Validate Confirm transaction
    * call read('@ValidateInitTransaction')
    * print travelRuleTransactionID
    * def data =
    """
    {
        "travelRuleTransactionID": "#(travelRuleTransactionID)"
    }
    """
    * call read(svc + 'TravelRule.feature@POST_core_v2_TravelRule_VASP_validate-confirm-transaction') data
    Then match responseStatus == 201
    * def expectedSchema = 
    """
    {
      "isValid": '#boolean',
      "type": '#string',
      "infoValidate": {
      "originator": {
        "originatorPersons": [
          {
            "legalPerson": {
              "name": {
                "nameIdentifier": [
                  {
                    "legalPersonName": '#string'
                  }
                ]
              }
            }
          }
        ],
        "accountNumber": [
          '#string'
        ]
      },
      "beneficiary": {
        "beneficiaryPersons": [
          {
            "legalPerson": {
              "name": {
                "nameIdentifier": [
                  {
                    "legalPersonName": '#string'
                  }
                ]
              },
              "geographicAddress": [
                {
                  "addressLine": [
                    '#string'
                  ]
                }
              ]
            }
          }
        ],
        "accountNumber": [
          '#string'
        ]
      },
      "originatorVASPdid": '#string',
      "beneficiaryVASPdid": '#string',
      "originatorDid": '#string'
      },
      "originator": {
          "name": '#string'
        },
        "beneficiary": {
        "name": '#string',
        "geographicAddress": '#string',
        "vaspInfo": {
          "customerId": "09896980-675a-473a-adb6-a5e93de93b62",
          "isDeleted": '#boolean',
          "status": '#string',
          "createdBy": '#uuid',
          "updatedBy": '#uuid',
          "id": "#(result[0].vaspId)",
          "did": '#string', 
          "name": '#string',
          "website": '#string',
          "logo": '#string',
          "incorporationCountry": '#string',
          "jurisdictions": '#string',
          "forceFields": [],
          "createdAt": '#string',
          "updatedAt": '#string',
          "isRakkar": '#boolean'
        }
      }
    }
    """
    * match response.data contains expectedSchema 







