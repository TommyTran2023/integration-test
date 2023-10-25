Feature: Read data files

@ReadDataFile
Scenario: Read data.json file
    * def testData = read('classpath:data/data.json')

@ReadEnumFile
Scenario: Read enum.json file
    * def Const = read('classpath:data/enum.json')

