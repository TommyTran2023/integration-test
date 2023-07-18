@ignore
Feature: Open API - Read schema from external link
  Background:
    * url openAPI_doc

  @Get_schema_structure_common
  Scenario: Open API - Read schema from external link
    Given path 'openapi/649a7c11ec5bf2001e31a3c7'
    When method GET

  @Read_schema_balance
  Scenario: Open API - Read schema for balance api
    * def readSchema = call read('OpenAPI_readSchema.feature@Get_schema_structure_common')
    * def expectedSchema = readSchema.response.paths['/balances'].get.responses['200'].content['application/json'].examples['Example-1'].value