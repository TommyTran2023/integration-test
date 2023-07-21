@ignore
Feature: Open API - Read schema from external link
  Background:
    * url openAPI_doc
    * def testData = read('classpath:data/data_test.json')
    * def pathData = testData.common.openAPI_path

  @Get_schema_structure_common
  Scenario: Open API - Read schema from external link
    Given path pathData
    When method GET

  @Read_schema_balance
  Scenario: Open API - Read schema for balance api
    * def readSchema = call read('OpenAPI_ReadSchema.feature@Get_schema_structure_common')
    * def expectedSchema = readSchema.response.paths['/balances'].get.responses['200'].content['application/json'].examples['Example-1'].value