Feature: Transfer of assets in same company
    
    Background:
        * url baseURL
        * def testData = read('classpath:data/data_test.json')

    @TransferInSameCompanyFromHotToHot 
        Scenario: Transfer money from one HOT to HOT wallet
        # Get asset externalAssetId
        * def externalAsset = call read('Transfer.feature@Get_asset_transfer')
        * def tokenSymbol = externalAsset.response.data.tokens[0].externalAssetId
        # Select source
        * def screenType = 'SOURCE_TRANSFER'
        * def source = call read('Vault.feature@SearchVaultForTransfer')
        * def sourceType = 'VAULT_ACCOUNT'
        # Select destination
        * def screenType = 'DESTINATION_TRANSFER'
        * def destination = call read('Vault.feature@SearchVaultForTransfer')
        * def destinationType = 'VAULT_ACCOUNT'
        # Estimated fee
        * def sourceId = source.response.data.vaults[0].id
        * def destinationId = destination.response.data.vaults[0].id
        * def body_estimate_fee = 
        """
            { 
                "assetId": '#(tokenSymbol)', 
                "destinationType": '#(destinationType)',, 
                "sourceType": '#(sourceType)', 
                "sourceId": '#(sourceId)',
                "amount": 11,
                "destinationId": '#(destinationId)'
            }
        """
        * call read('Common.feature@GetEstimateFee')
        # Total estimated fee
        * def body_total_estimate = 
        """
            {
                "assetId": '#(tokenSymbol)', 
                "destinationType": '#(destinationType)', 
                "sourceType":'#(sourceType)', 
                "sourceId": '#(sourceId)',
                "amount":#(amount_low),
                "destinationId":'#(destinationId)', 
                "fee":#(Number(testData.transfer.withdraw.fee)),
                "isNetAmount":false
            }
        """
        * call read('Transfer.feature@Total_estimate_fee_common')
        # Check existing asset
        * def destinationId = '#(destinationId)'
        * def destinationType = '#(destinationType)'
        * def externalAssetId = '#(tokenSymbol)'
        * def sourceId = '#(sourceId)'
        * def check_exist = call read('Asset.feature@CheckExistingAsset')
        Then check_exist.status 200
        * match check_exist.response.code == 200
        * match check_exist.response.status == 'success'
        # View transaction
        # Approve transaction
        # Check assets on source and destination

