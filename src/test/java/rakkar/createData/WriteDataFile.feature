@ignore
Feature: Write Data Env file

Scenario: Write Data Env file
    * fileUtils.writeToFile(karate.get('dataEnv'), fileUtils.DataListMap)
