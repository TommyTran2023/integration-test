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
        * print coreConfig
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
        * print result

    @SelectVaultsOfCustomer
    Scenario: Select all vaults of customer
        * def query = 
        """
            "SELECT * FROM vaults " +
            "WHERE \"customerId\" = '" + customerId + "' " +
            "AND id in (" + vaultIds + ") " + 
            "LIMIT 10"
        """
        * print query
        * def result = coreDb.readRows(query)
        * print result

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
        * print result

