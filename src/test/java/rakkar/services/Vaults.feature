Feature: Quorum Vault 
# include all api tests for /core/vault
    Background:
        * url baseURL

    @CreateVault
    Scenario: Create vault 
        Given path '/core/vault'
        * request requestBody
        When method POST

    @GetAllVaults
    Scenario: Get all vaults 
        Given path '/core/vault/accounts'
        * params params
        When method GET

    @GetVaultById
    Scenario: Get vault by id 
        Given path '/core/vault/accounts', vaultId
        When method GET

    @EditVaultPolicy
    Scenario: Edit vault policy 
        Given path '/core/vault/accounts', vaultId, 'rules'
        * request requestBody
        When method PUT

    @HideVault
    Scenario: Hide a vault
      Given path '/core/vault/accounts', vaultId, 'hide'
      When method POST

    @UnhideVault
    Scenario: Unhide a vault
      Given path '/core/vault/accounts', vaultId, 'unhide'
      When method POST
