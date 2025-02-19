    @ignore
Feature: Connect to PostgreSQL

    Background:
        # use jdbc to validate
        * def coreConfig = 
        """
        { 
            username: '#(dbConfig["core-svc"].DATABASE_USERNAME)', 
            password: '#(dbConfig["core-svc"].DATABASE_PASSWORD)', 
            url: '#(dbConfig["core-svc"].DATABASE_HOST)', 
            driverClassName: 'org.postgresql.Driver' 
        }
        """
        * def DbUtils = Java.type('util.DbUtils')
        * def coreDb = new DbUtils(coreConfig)

    @SelectTransactionsOfCustomer
    Scenario: Select all transactions of customer
        * def query = 
        """
            "SELECT * " +
            "FROM txn_transactions " +
            "WHERE \"customerId\" = '" + customerId + "' " +
                "OR \"toCustomerId\" = '" + customerId + "' " +
            "ORDER BY \"createdAt\" DESC LIMIT 1000"
        """
        * print query
        * def result = coreDb.readRows(query)

    @SelectVaultsOfCustomer
    Scenario: Select all vaults of customer
        * def query = 
        """
            "SELECT * FROM vaults " +
            "WHERE \"customerId\" = '" + customerId + "' " +
            "AND id in (" + vaultIds + ") " + 
            "LIMIT 200"
        """
        * print query
        * def result = coreDb.readRows(query)

    @SelectBalanceOfCustomer
    Scenario: Select balance of customer
        * def query =
        """
        "select \"assetExternalId\", SUM(total::DECIMAL) as Total, SUM(available::DECIMAL) as Available " +
        "from assets " +
        "WHERE id in ( " +
        "    select \"assetId\" " +
        "    from \"assetWallets\" " +
        "    WHERE \"walletId\" in ( " +
        "        select id " +
        "        from \"wallets\"" +
        "        WHERE id in (" +
        "            SELECT \"walletId\" " +
        "            from \"vaultWallets\" " +
        "            WHERE \"vaultId\" in (" +
        "                SELECT id " +
        "                FROM vaults " +
        "                WHERE \"customerId\" = '" + customerId +"'" +
        "                and \"type\"='" + type + "'" +
        "            )" +
        "        )" +
        "    )" +
        ") " +
        "AND \"assetExternalId\" = '" + assetId + "' " +
        "GROUP BY \"assetExternalId\" "
        """
        * print query
        * def result = coreDb.readRows(query)

    @SelectVaultOfUser
    Scenario: Select vault by user
        * def query =
        """
        "select a.\"assetExternalId\", a.available, a.total, qr.\"type\" as policyType, aw.\"walletId\"  ,v.*, " +
        "    case " +
        "        when \"uv\".\"id\" is not null then false " +
        "        else true " +
        "    end as \"isMasked\" " +
        "from vaults v  " +
        "inner join \"userVaults\" uv  " +
        "on \"uv\".\"vaultId\" = \"v\".\"id\" AND \"uv\".\"userId\" = '"+ userId +"' " +
        "inner join \"quorumRules\" qr  " +
        "on v.id = qr.\"objectId\" and qr.\"status\" = 'ACTIVE' " +
        "inner join \"vaultWallets\" vw   " +
        "on v.id = vw.\"vaultId\"  " +
        "inner join \"assetWallets\" aw  " +
        "on vw.\"walletId\" = aw.\"walletId\" " +
        "inner join assets a " +
        "on aw.\"assetId\"  = a.id " +
        "where v.\"customerId\" = '"+customerId+"' " +
        "and v.\"hiddenOnUI\" = false  " +
        "order by a.available desc, v.name asc; "
        """
        * print query
        * def result = coreDb.readRows(query)

    @SelectAssignVault
    Scenario: Select assign vault 
        * def query =
        """
        "select a.total, qr.\"type\" as policyType ,v.* " +
        "from vaults v " +
        "inner join \"userVaults\" uv " +
        "on \"uv\".\"vaultId\" = \"v\".\"id\" AND \"uv\".\"userId\" = '"+ userId +"' " +
        "left join \"quorumRules\" qr " +
        "on v.id = qr.\"objectId\" " +
        "left join \"vaultWallets\" vw  " +
        "on v.id = vw.\"vaultId\" "+
        "left join \"assetWallets\" aw " +
        "on vw.\"walletId\" = aw.\"walletId\" "+
        "left join assets a " +
        "on aw.\"assetId\"  = a.id " +
        "where v.\"customerId\" = '" + customerId +"' " +
        "and a.\"assetExternalId\" = '"+ assetExternalId +"' " +
        "and v.\"hiddenOnUI\" = false " +
        "order by a.total desc;"
        """
        * print query
        * def result = coreDb.readRows(query)

    @SelectUnsupportedToken
    Scenario: Select assign vault 
        * def query =
        """
        "select * from \"unSupportTokens\" ust " + 
        "where \"countryCode\" in ( " +
        "    select ccer.\"countryCode\"  " +
        "    from cus_customers cc  " +
        "    left join \"cus_customerEntityRelations\" ccer  " +
        "        on cc.\"entityRelationId\" = ccer.id " +
        "    where cc.id = '" + customerId + "'); "
        """
        * print query
        * def result = coreDb.readRows(query)

    @SelectATransactionNotBelongToCustomer
    Scenario: Select a transaction not belong to customer
        * def query =
        """
        "select * from txn_transactions tt " +
        "where tt.\"customerId\" != '" + customerId + "' and tt.\"toCustomerId\" != '" + customerId + "' " +
        "order by tt.\"createdAt\" limit 1" 
        """
        * print query
        * def result = coreDb.readRows(query)

    @SelectDiscoverableNetwork
    Scenario: Select Discoverable Network   
        * def query =
        """
            "select * from \"net_networkProfiles\" nnp " +
            "where \"customerId\" ='" + customerId + "' " +
            "and \"isDiscoverable\" = true " +
            "and nnp.\"networkName\" like 'Profile%'" 
        """
        * print query
        * def result = coreDb.readRows(query)

    @SelectAssignedVaultDontHaveAsset
    Scenario: Select Assigned vault don't have asset
        * def query = 
        """
            "SELECT v2.* " +
            "FROM vaults v2 " +
            "INNER JOIN \"userVaults\" uv2 ON \"uv2\".\"vaultId\" = \"v2\".\"id\" " +
            "AND \"uv2\".\"userId\" = '"+ userId +"' " +
            "WHERE v2.\"customerId\" = '" + customerId + "' " +
            "AND v2.id NOT IN " +
            "    (SELECT v.id " +
            "    FROM vaults v " +
            "    INNER JOIN \"userVaults\" uv ON \"uv\".\"vaultId\" = \"v\".\"id\" " +
            "    AND \"uv\".\"userId\" = '"+ userId +"' " +
            "    INNER JOIN \"quorumRules\" qr ON v.id = qr.\"objectId\" " +
            "    AND qr.\"status\" = 'ACTIVE' " +
            "    INNER JOIN \"vaultWallets\" vw ON v.id = vw.\"vaultId\" " +
            "    INNER JOIN \"assetWallets\" aw ON vw.\"walletId\" = aw.\"walletId\" " +
            "    INNER JOIN assets a ON aw.\"assetId\" = a.id " +
            "    WHERE v.\"customerId\" = '" + customerId + "' " +
            "    AND v.\"hiddenOnUI\" = FALSE " +
            "    AND uv.id IS NOT NULL " +
            "    AND a.\"assetExternalId\" = '"+assetExternalId+"' " +
            "    GROUP BY v.id)"
        """
        * print query
        * def result = coreDb.readRows(query)
    
    @SelectWorkspace
    Scenario: Select Workspace
        * def query = 
        """
        "select * from cus_workspaces cw " + 
        "where \"externalId\" != '00000000-0000-0000-0000-000000000000'"
        """
        * print query
        * def result = coreDb.readRows(query)

    @SelectTxnByCurrency
    Scenario: Select transactions by type and currency
        * def query = 
        """
            "select tt.\"transactionId\", tt.\"feeCurrency\", wi.id as \"tokenId\",tt.\"source\", tt.destination, tt.\"externalWorkspaceId\" as \"workspaceId\", \"tea\".\"externalExchangeAccountId\", \"tea\".\"type\" , ff.\"name\" , ff.\"thirdPartyFolderName\" , tt.\"createdAt\" " +
            "from txn_transactions tt " +
            "left join \"txn_exchangeAccounts\" \"tea\" " +
            "on tt.source = \"tea\".id " +
            "left join fol_folders ff " +
            "on ff.\"folderExternalId\"::text = \"tea\".\"externalExchangeAccountId\" " +
            "left join \"walletInfos\" wi on wi.\"externalAssetId\" = tt.\"feeCurrency\" "+
            "where tt.\"type\" ='INCOMING' " +
            "and \"tea\".\"type\" ilike '%wallet%' " +
            "and ff.\"thirdPartyFolderName\" is not null " +
            "and tt.\"feeCurrency\" ilike '%" + assetToken + "%' " +
            "and tt.\"createdAt\" > '2024-10-07' " +
            "limit 10"
        """
        * print query
        * def result = coreDb.readRows(query) 

    @SelectTxnByCurrencyAndType
    Scenario: Select transactions by type
        * def query = 
        """
        "select tt.\"transactionId\", tt.\"feeCurrency\", wi.id as \"tokenId\", tt.\"source\", tt.destination, tt.\"externalWorkspaceId\" as \"workspaceId\", \"tea\".\"externalExchangeAccountId\", \"tea\".\"type\" , v.\"name\" , v.\"thirdPartyVaultName\" , tt.\"createdAt\" " +
        "from txn_transactions tt " +
        "left join \"txn_exchangeAccounts\" \"tea\" " +
   	    "on tt.source = \"tea\".id " +
        "left join vaults v " +
   	    "on v.\"vaultExternalId\"::text = \"tea\".\"externalExchangeAccountId\" and v.\"workSpaceId\" = tea.\"workSpaceId\" " +
        "left join \"walletInfos\" wi on wi.\"externalAssetId\" = tt.\"feeCurrency\" " +
        "where tt.\"type\" ='REBALANCING' " +
   	    "and \"tea\".\"type\" ilike '%VAULT_ACCOUNT%' " +
        "and v.\"thirdPartyVaultName\" is not null " +
   	    "and tt.\"feeCurrency\" ilike '%" + assetToken + "%' " +
        "and tt.\"createdAt\" > '2024-10-07' " +
        "limit 10"
        """
        * print query
        * def result = coreDb.readRows(query)

    @SelectTxnNotTravelRule   
    Scenario: Select transactions not travel rule
        * def query = 
        """
        "select \"transactionId\", \"additionalData\" , * from txn_transactions tt " +
        "where (tt.\"customerId\" is not null or \"toCustomerId\" is not null) " +
        "and \"fireblocksStatus\" = 'COMPLETED' " +
        "and \"type\" ='OUTGOING' " +
        "and \"additionalData\"::text not like '%notabene%' " +
        "order by \"createdAt\" desc "
        """
        * print query
        * def result = coreDb.readRows(query)

    @SelectTxnNotScreeningThroughFireblocks
    Scenario: Select transactions not screening through Fireblocks
        * def query = 
        """
        "select \"transactionId\", \"additionalData\", * from txn_transactions tt " +
        "WHERE \"customerId\" = '" + customerId + "' " +
        "and \"fireblocksStatus\" is null " +
        "and \"type\" ='OUTGOING' " +
        "order by \"createdAt\" DESC "
        """
        * print query
        * def result = coreDb.readRows(query)

    @SelectDepositTxnNotTravelRule   
    Scenario: Select deposit transactions not travel rule
        * def query = 
        """
        "select \"transactionId\", \"additionalData\" , * from txn_transactions tt " +
        "where (tt.\"customerId\" is not null or \"toCustomerId\" is not null) " +
        "and \"fireblocksStatus\" = 'COMPLETED' " +
        "and \"type\" ='INCOMING' " +
        "and \"additionalData\"::text not like '%notabene%' " +
        "order by \"createdAt\" desc " +
        "limit 10"
        """
        * print query
        * def result = coreDb.readRows(query)



    @SelectDepositTxnTravelRule
    Scenario: Select deposit transactions not screening through Fireblocks
        * def query = 
        """
        "select \"transactionId\" ,* from txn_transactions tt " +
        "where \"toCustomerId\" = '" + customerId + "' " +
        "and \"type\" in ('INCOMING') " +
        "and status in ('COMPLETED') " +
        "order by \"createdAt\" desc " +
        "limit 10"
        """
        * print query
        * def result = coreDb.readRows(query)


        @SelectTxnDepositWithChecklist

    Scenario: Select deposit transactions with checklist
        * def query = 
        
        """
        "select \"transactionId\" ,* from txn_transactions " +
        "where \"toCustomerId\" = '" + customerId + "' " +
        "and \"fireblocksStatus\" in  ('REJECTED') " +
        "and \"type\" in ('INCOMING') " +
        "order by \"createdAt\" desc "
        """
        * print query
        * def result = coreDb.readRows(query)

        @SelectTxnHaveCreatedAtDiffToExternalLastUpdated
    Scenario: Select deposit transactions with checklist
        * def query = 
        """
        "select cc.\"customerName\", cc.id , tt.\"createdAt\" , tt.\"updatedAt\", tt.\"externalCreatedAt\" ,to_timestamp(tt.\"externalLastUpdated\"  /1000) " +
        "from txn_transactions tt " + 
        "inner join cus_customers cc on tt.\"customerId\" = cc.id " +
        "where to_timestamp(tt.\"externalLastUpdated\" / 1000) > tt.\"createdAt\" + INTERVAL '1 day' " +
        "and cc.id ='" + customerId + "' " +
        "order by tt.\"createdAt\" desc " + 
        "limit 10"
        """
        * print query
        * def result = coreDb.readRows(query)
