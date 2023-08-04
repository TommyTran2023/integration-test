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

  @Read_schema_whitelist
  Scenario: Open API - Read schema for whiteList api
    * def readSchema = call read('OpenAPI_ReadSchema.feature@Get_schema_structure_common')
    * def expectedSchema = readSchema.response.components.schemas.resp_whitelist_list

  @Read_schema_balance
  Scenario: Open API - Read schema for balance api
    * def readSchema = call read('OpenAPI_ReadSchema.feature@Get_schema_structure_common')
    * def expectedSchema = readSchema.response.components.schemas.resp_balances

  @Read_schema_vault
  Scenario: Open API - Read schema for vault api
    * def readSchema = call read('OpenAPI_ReadSchema.feature@Get_schema_structure_common')
    * def expectedSchema = readSchema.response.components.schemas.resp_vaults_list

  @Read_schema_transaction
  Scenario: Open API - Read schema for transaction api
    * def readSchema = call read('OpenAPI_ReadSchema.feature@Get_schema_structure_common')
    * def expectedSchema = readSchema.response.components.schemas.resp_transactions_list



