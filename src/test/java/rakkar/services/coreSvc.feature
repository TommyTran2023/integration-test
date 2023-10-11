Feature: All api call to core services
Background:
    * url baseURL

#--------Biometric---------#
@RequestChallenge
Scenario: Biometric Request Challenge
    Given path 'core/biometric/request-challenge'
    * header Authorization = authorization
    When method POST
