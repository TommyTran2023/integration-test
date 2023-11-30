Feature: OpenAPI Service
# /openApi

    @GetListApiKeyClients
    Scenario: Get List Api Key Clients
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            params:{
                limit : 10, //number
                offset : 0, //number
                sort : '', //string
                keyword : '', //string
                sortBy : '' //string
            }
        }
        """
        * call read(svc + 'openApiSvc.feature@GetListApiKeyClients') data
     
    @GenerateApiKey
    Scenario: Generate Api Key
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: 
            {
                name : #(name), //string
                permission : #(permission) //string
            }
        }
        """
        * call read(svc + 'openApiSvc.feature@GenerateApiKey') data
     
    @ValidateDuplicateName
    Scenario: Validate Duplicate Name
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            name : #(name) //string
        }
        """
        * call read(svc + 'openApiSvc.feature@ValidateDuplicateName') data
     
    @DeleteApiKey
    Scenario: Delete Api Key
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            apiKeyId : #(apiKeyId) //string
        }
        """
        * call read(svc + 'openApiSvc.feature@DeleteApiKey') data

    @GetCustomURL
    Scenario: Get Custom URL
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken)
        }
        """
        * call read(svc + 'openApiSvc.feature@GetCustomURL') data
     
    @GetListTransaction
    Scenario: Get List Transaction

   * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
   * def data = 
   """
   {
        authorization: #(accessToken),
        params:{
            limit : 10, //number
            offset : 0, //number
            source_id : #(source_id), //string
            transaction_id : #(transaction_id), //string
            source_address : #(source_address), //string
            asset_id : #(asset_id), //string
            start_date : #(start_date), //string
            end_date : #(end_date), //string
            transaction_type : #(transaction_type), //string
            destination_id : #(destination_id), //string
            destination_address : #(destination_address), //string
            status : #(status), //string
            network_id : #(network_id) //string
        }
   }
   """
   * call read(svc + 'openApiSvc.feature@GetListTransaction') data

   @GetTransactionDetail
   Scenario: Get Transaction Detail
    * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
    * def data = 
    """
    {
        authorization: #(accessToken),
        tx_id : #(tx_id) //string
    }
    """
    * call read(svc + 'openApiSvc.feature@GetTransactionDetail') data
 
    @GetListVault
    Scenario: Get List Vault
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            params:{
                limit : 10, //number
                offset : 0, //number
                asset_id : #(asset_id), //string
                vault_type : #(vault_type), //string
                network_id : #(network_id) //string
            }
        }
        """
        * call read(svc + 'openApiSvc.feature@GetListVault') data
     
    @GetVaultDetail
    Scenario: Get Vault Detail
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            vaultId : #(vaultId) //string
        }
        """
        * call read(svc + 'openApiSvc.feature@GetVaultDetail') data
     
    @GetWhitelist
    Scenario: Get Whitelist
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            params: {
                asset_id : #(asset_id), //string
                network_id : #(network_id), //string
                whitelist_type : #(whitelist_type) //string
            }
        }
        """
        * call read(svc + 'openApiSvc.feature@GetWhitelist') data

    @GetBalances
    Scenario: Get Balances
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken     
        * def data = 
        """
        {
            authorization: #(accessToken),
            params:{
                limit : 10, //number
                offset : 0, //number
                asset_id : #(asset_id), //string
                network_id : #(network_id) //string
            }
        }
        """
        * call read(svc + 'openApiSvc.feature@GetBalances') data

    @GetBalancesByVaultType
    Scenario: Get Balances By Vault Type
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            vault_type : #(vault_type), //string
            params:{
                limit : 10, //number
                offset : 0, //number
                asset_id : #(asset_id), //string
                network_id : #(network_id) //string
            }
        }
        """
        * call read(svc + 'openApiSvc.feature@GetBalancesByVaultType') data


