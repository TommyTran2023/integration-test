Feature: Open API

    @GetTransactions
  Scenario: Get transactions list
    * def data =
    """
    {
        apiKey : #(apiKey),
        accountId: #(accountId),
        params:{
            limit: #(typeof limit == 'undefined' ? null : limit),
            offset: #(typeof offset == 'undefined' ? 0 : offset),
            transaction_id: #(typeof transaction_id == 'undefined' ? null : transaction_id),
            source_id: #(typeof source_id == 'undefined' ? null : source_id),
            source_address: #(typeof source_address == 'undefined' ? null : source_address),
            asset_id: #(typeof asset_id == 'undefined' ? null : asset_id),
            network_id: #(typeof network_id == 'undefined' ? null : network_id),
            start_date: #(typeof start_date == 'undefined' ? null : start_date),
            end_date: #(typeof end_date == 'undefined' ? null : end_date),
            transaction_type: #(typeof transaction_type == 'undefined' ? null : transaction_type),
            destination_id: #(typeof destination_id == 'undefined' ? null : destination_id),
            destination_address: #(typeof destination_address == 'undefined' ? null : destination_address),
            status: #(typeof status == 'undefined' ? null : status),
        }
    }
    """
    * call read(svc + 'openApiSvc.feature@GetTransactions') data

    @GetTransactionById
  Scenario: Get transaction detail by tx id
    * def data =
    """
    {
        apiKey : #(apiKey),
        accountId: #(accountId),
        txnId: #(txnId)
    }
    """
    * call read(svc + 'openApiSvc.feature@GetTransactionById') data

    @GetVaults
  Scenario: Get vaults list
    * def data =
    """
    {
        apiKey : #(apiKey),
        accountId: #(accountId),
        params:{
            limit: #(typeof limit == 'undefined' ? null : limit),
            offset: #(typeof offset == 'undefined' ? 0 : offset),
            vault_type: #(typeof vault_type == 'undefined' ? null : vault_type),
            asset_id: #(typeof asset_id == 'undefined' ? null : asset_id),
            network_id: #(typeof network_id == 'undefined' ? null : network_id)
        }
    }
    """
    * call read(svc + 'openApiSvc.feature@GetVaults') data

    @GetVaultById
  Scenario: Get vault detail by vault id
    * def data =
    """
    {
        apiKey : #(apiKey),
        accountId: #(accountId),
        vaultId: #(vaultId)
    }
    """
    * call read(svc + 'openApiSvc.feature@GetVaultById') data

    @GetBalances
  Scenario: Return all balances or by asset id
    * def data =
    """
    {
        apiKey : #(apiKey),
        accountId: #(accountId),
        params:{
            limit: #(typeof limit == 'undefined' ? null : limit),
            offset: #(typeof offset == 'undefined' ? 0 : offset),
            asset_id: #(typeof asset_id == 'undefined' ? null : asset_id)
        }
    }
    """
    * call read(svc + 'openApiSvc.feature@GetBalances') data

    @GetBalancesByVaultType
  Scenario: Return balances by vault type and asset id
    * def data =
    """
    {
        apiKey : #(apiKey),
        accountId: #(accountId),
        vaultType: #(vaultType),
        params:{
            limit: #(typeof limit == 'undefined' ? null : limit),
            offset: #(typeof offset == 'undefined' ? 0 : offset),
            asset_id: #(typeof asset_id == 'undefined' ? null : asset_id)
        }
    }
    """
    * call read(svc + 'openApiSvc.feature@GetBalancesByVaultType') data

    @GetWhitelisted
  Scenario: Get a list of whitelisted destinations * def data =
    """
    {
        apiKey : #(apiKey),
        accountId: #(accountId),
        vaultType: #(vaultType),
        params:{
            limit: #(typeof limit == 'undefined' ? null : limit),
            offset: #(typeof offset == 'undefined' ? 0 : offset),
            whitelist_type: #(typeof whitelist_type == 'undefined' ? null : whitelist_type),
            asset_id: #(typeof asset_id == 'undefined' ? null : asset_id),
            network_id: #(typeof network_id == 'undefined' ? null : network_id)
        }
    }
    """
    * call read(svc + 'openApiSvc.feature@GetWhitelisted') data


