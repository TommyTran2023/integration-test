@ignore
Feature: Connect to PostgreSQL

    Background:
        # use jdbc to validate
        * def coreConfig = { username: 'rak_svc_core_owner', password: 'Z@NOKWqfW1bT@dr3TOSV8#9nY1Dr*q71', url: 'jdbc:postgresql://rds-nonprod.ceuskkmxcoeq.ap-southeast-1.rds.amazonaws.com/rak_sit_svc_core', driverClassName: 'org.postgresql.Driver' }
        * def DbUtils = Java.type('util.DbUtils')
        * def coreDb = new DbUtils(coreConfig)  

    @SelectTransactionsOfCustomer
    Scenario: Select all transactions of customer
        * def query = 
        """
            "SELECT * " +
            "FROM txn_transactions " +
            "WHERE \"customerId\" = '" + customerId + "'" +
                "OR \"toCustomerId\" = '" + customerId + "'"
        """
        * def result = coreDb.readRows(query)
        * print result

    @SelectVaultsOfCustomer
    Scenario: Select all vaults of customer
        * def query = "SELECT * FROM vaults WHERE \"customerId\" = '" + customerId + "'"
        * def result = coreDb.readRows(query)
        * print result



