Feature:

Background:
    * callonce read(svc + 'Auth.feature@GetUserAccessToken') { userName: '#(sg_customer.admin1)' }
    * def accessToken = userAccessToken


@ValidateInitTransaction
Scenario: Validate Init transaction
    * call read(connectDB + 'SelectVaultIdAndFolderIdForTxnTravelRule')
    * print result
    * def sourceValue = result[0].vaultId
    * def destinationValue = result[0].folderAddressId
    # * def data = 
    # """
    # {
    #     transactionAsset: "ETH_TEST5",
    #     transactionAmount: "0.00324",
    #     source: 
    #     {
    #         "type": "VAULT_ID",
    #         "value": "#(sourceValue)"
    #     },
    #     destination: 
    #     {
    #         "type": "FOLDER_ID",
    #         "value": "#(destinationValue)"
    #     }
    # }
    # """
    * def data = 
    """
    {
        transactionAsset: "ETH_TEST5",
        transactionAmount: "0.00324",
        sourceType: "VAULT_ID",
        sourceValue: "#(sourceValue)",
        destinationType: "FOLDER_ID",
        destinationValue: "#(destinationValue)"
    }
    """
    * print data
    * call read(svc + 'TravelRule.feature@POST_core_v2_TravelRule_VASP_validate-init-transaction2') data
    Then match responseStatus == 201
    * def travelRuleTransactionID = response.data.travelRuleTransactionID









