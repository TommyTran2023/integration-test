Feature: Read data files

@ReadDataFile
Scenario: Read data.json file
    * def testData = read('classpath:data/data.json')

@ReadEnumFile
Scenario: Read enum.json file
    * def Const = read('classpath:data/enum.json')

@ReadSchemaFile
Scenario: Read schema.json file
    * def schemaBody = read('classpath:data/schema.json')

@ReadOldDataFile
Scenario: Read schema.json file
    * def oldDataFile = read('classpath:data/dataTest.json')


