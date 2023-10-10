@PT
Feature: Open API for PT
    
    Background:
    * def classpath = 'classpath:rakkar/feature/'

    Scenario: Get balance by asset ID
        * call read(classpath + 'OpenAPI.feature@Get_balance_by_assetId')

    Scenario: Get balance by vault type
    * call read(classpath + 'OpenAPI.feature@Get_balance_by_vaultType')

    Scenario: Get list Whitelist
    * call read(classpath + 'OpenAPI.feature@Get_whitelist')

    Scenario: Get list Vaults
    * call read(classpath + 'OpenAPI.feature@GetVaultList')

    Scenario: Get Vault details
    * call read(classpath + 'OpenAPI.feature@GetVaultDetail')

    Scenario: Get transactions by source id
    * call read(classpath + 'OpenAPI.feature@Transaction_by_sourceId')

    Scenario: Get transactions by asset id
    * call read(classpath + 'OpenAPI.feature@Transaction_by_assetId')

    Scenario: Get transactions by date
    * call read(classpath + 'OpenAPI.feature@Transaction_by_date')

    Scenario: Get transactions by transaction type
    * call read(classpath + 'OpenAPI.feature@Transaction_by_type')

    Scenario: Get transactions by destination id
    * call read(classpath + 'OpenAPI.feature@Transaction_by_destinationId')

    Scenario: Get transactions by destination address
    * call read(classpath + 'OpenAPI.feature@Transaction_by_destination_address')

    Scenario: Get transactions by status
    * call read(classpath + 'OpenAPI.feature@Transaction_by_status')

    Scenario: Get transactions by network id
    * call read(classpath + 'OpenAPI.feature@Transaction_by_networkId')

    Scenario: Get transactions, no filters
    * def query = { limit: 10, offset: 0 }
    * call read(classpath + 'OpenAPI.feature@Transaction_common') 

    Scenario: Get transaction details
    * call read(classpath + 'OpenAPI.feature@Transaction_detail')
