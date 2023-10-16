    @ignore
Feature: All api call to core services
  Background:
    * url baseURL

    #--------Biometric---------#
    @RequestChallenge
  Scenario: Biometric Request Challenge
    Given path 'core/biometric/request-challenge'
    * header Authorization = authorization
    When method POST

    #----------Vault-----------#

    @CreateVault
  Scenario: Create vault 
    Given path '/core/vault'
    * header Authorization = data.authorization
    * header challenge-answer = data.challengeAnswer
    * header passcode = data.passcode
    * request data.requestBody
    When method POST

    @GetAllVaults
  Scenario: Get all vaults 
    Given path '/core/vault/accounts'
    * header Authorization = authorization
    * params params
    When method GET

    @GetVaultById
  Scenario: Get vault by id 
    Given path '/core/vault/accounts', vaultId
    * header Authorization = authorization
    When method GET

    @EditVaultPolicy
  Scenario: Edit vault policy 
    Given path '/core/vault/accounts', vaultId, 'rules'
    * header Authorization = authorization
    * request requestBody
    When method PUT

    @HideVault
  Scenario: Hide a vault
    Given path '/core/vault/accounts', vaultId, 'hide'
    * header Authorization = authorization
    When method POST

    @UnhideVault
  Scenario: Unhide a vault
    Given path '/core/vault/accounts', vaultId, 'unhide'
    * header Authorization = authorization
    When method POST

    @RequestCreateVault
  Scenario: Request create vault
    Given path '/core/vault/request-create-vault'
    * header Authorization = authorization
    * request requestBody
    When method POST

    @SubmitRequestCreateVault
  Scenario: Submit Request Create Vault
    Given path '/core/vault/submit-request-create-vault'
    * header Authorization = data.authorization
    * header challenge-answer = data.challengeAnswer
    * header passcode = data.passcode
    * request data.requestBody
    When method POST
