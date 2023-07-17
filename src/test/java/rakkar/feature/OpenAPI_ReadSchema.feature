@ignore
Feature: Open API - Read schema from external link
  Background:
    * url 'https://developer.rakkardigital.com'

  @Get_schema_structure
  Scenario: Open API - Read schema from external link
    Given path 'openapi/649a7c11ec5bf2001e31a3c7'
    When method GET



