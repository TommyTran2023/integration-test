Feature:

  Background:
    * callonce read(svc + 'Auth.feature@GetUserAccessToken') { userName: '#(sg_customer.admin1)' }
    * def accessToken = userAccessToken


    @ValidateInitTransaction
  Scenario: Validate Init transaction
    * call read(connectDB + 'SelectVaultIdAndFolderIdForTxnTravelRule')
    * def sourceValue = result[0].vaultId
    * def destinationValue = result[0].folderAddressId
    * print result[0]
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









