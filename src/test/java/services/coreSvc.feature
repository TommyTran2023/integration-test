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
    Given path 'core/vault/accounts', vaultId
    * header Authorization = authorization
    When method GET

    @EditVaultPolicy
  Scenario: Edit vault policy 
    Given path 'core/vault/accounts', vaultId, 'rules'
    * header Authorization = authorization
    * request requestBody
    When method PUT

    @HideVault
  Scenario: Hide a vault
    Given path 'core/vault/accounts', vaultId, 'hide'
    * header Authorization = authorization
    When method POST

    @UnhideVault
  Scenario: Unhide a vault
    Given path 'core/vault/accounts', vaultId, 'unhide'
    * header Authorization = authorization
    When method POST

    @RequestCreateVault
  Scenario: Request create vault
    Given path 'core/vault/request-create-vault'
    * header Authorization = authorization
    * request requestBody
    When method POST

    @SubmitRequestCreateVault
  Scenario: Submit Request Create Vault
    Given path 'core/vault/submit-request-create-vault'
    * header Authorization = data.authorization
    * header challenge-answer = data.challengeAnswer
    * header passcode = data.passcode
    * request data.requestBody
    When method POST

    @GetDepositRouting
  Scenario: Get Deposit Routing - Connection Setup
    Given path 'core/vault/deposit-routing'
    * header Authorization = data.authorization
    * params data.params
    When method GET

  #----------Wallet-----------#
    @AddAsset
  Scenario: Add asset to vault / Create wallet on vault
    Given path 'core/wallet', data.vaultId
    * header Authorization = data.authorization
    * request {"tokenIds": "#(data.tokenIds)"} 
    When method POST
  
    @GetTokens
  Scenario: Add asset to vault / Create wallet on vault
    Given path 'core/wallet/tokens', data.vaultId
    * header Authorization = data.authorization
    * params data.params
    When method GET

    @GetWalletAddress
  Scenario: Get wallet address
    Given path 'core/wallet/get-address-wallet'
    * header Authorization = data.authorization
    * params { vaultId: #(data.vaultId), walletId: #(data.walletId) }
    When method GET

    @GetWalletTransferTokens
  Scenario: Get wallet transfer token
    Given path 'core/wallet/transfer-tokens'
    * header Authorization = data.authorization
    * params data.params
    When method GET

  #----------Whitelist Folder-----------#
    @CreateWhitelistFolder
  Scenario: Create whitelist folder
    Given path 'core/folders'
    * header Authorization = data.authorization
    And request {"name" : '#(data.name)',"type": '#(data.type)' }
    When method POST

    @AddWhitelistAddress
  Scenario: Add whitelist address
    Given path 'core/folders', folderId, 'tokens'
    * header Authorization = data.authorization
    * header challenge-answer = challengeAnswerRequest
    And request data.body
    When method POST
