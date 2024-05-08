@ignore
Feature: Connect to PostgreSQL

    Background:
        # use jdbc to validate
        * def dbUrl = "jdbc:postgresql://rds-nonprod.ceuskkmxcoeq.ap-southeast-1.rds.amazonaws.com:5432/" + dbName
        * def coreConfig = 
        """
        { 
            username: #(coreUserName), 
            password: #(corePass), 
            url: #(dbUrl), 
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
        * def result = coreDb.readRows(query)

    @SelectVaultsOfCustomer
    Scenario: Select all vaults of customer
        * def query = 
        """
            "SELECT * FROM vaults " +
            "WHERE \"customerId\" = '" + customerId + "' " +
            "AND id in (" + vaultIds + ") " + 
            "LIMIT 10"
        """
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
        * def result = coreDb.readRows(query)

    @SelectVaultOfUser
    Scenario: Select vault by user
        * def query =
        """
        "select a.\"assetExternalId\", a.total, qr.\"type\" as policyType, aw.\"walletId\"  ,v.*, " +
        "    case " +
        "        when \"uv\".\"id\" is not null then false " +
        "        else true " +
        "    end as \"isMasked\" " +
        "from vaults v  " +
        "left join \"userVaults\" uv  " +
        "on \"uv\".\"vaultId\" = \"v\".\"id\" AND \"uv\".\"userId\" = '"+ userId +"' " +
        "left join \"quorumRules\" qr  " +
        "on v.id = qr.\"objectId\" and qr.\"status\" = 'ACTIVE' " +
        "left join \"vaultWallets\" vw   " +
        "on v.id = vw.\"vaultId\"  " +
        "left join \"assetWallets\" aw  " +
        "on vw.\"walletId\" = aw.\"walletId\" " +
        "left join assets a " +
        "on aw.\"assetId\"  = a.id " +
        "where v.\"customerId\" = '"+customerId+"' " +
        "and v.\"hiddenOnUI\" = false  " +
        "order by a.total desc, v.name asc; "
        """
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
        * def result = coreDb.readRows(query)

    @SelectATransactionNotBelongToCustomer
    Scenario: Select a transaction not belong to customer
        * def query =
        """
        "select * from txn_transactions tt " +
        "where tt.\"customerId\" != '" + customerId + "' and tt.\"toCustomerId\" != '" + customerId + "' " +
        "order by tt.\"createdAt\" limit 1" 
        """
        * def result = coreDb.readRows(query)
