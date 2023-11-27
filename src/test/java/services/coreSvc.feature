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
    * header Authorization = authorization
    * header challenge-answer = challengeAnswer
    * header passcode = passcode
    * request requestBody
    When method POST

    @GetAllVaults
  Scenario: Get all vaults 
    Given path '/core/vault/v2/accounts'
    * header Authorization = authorization
    * params params
    When method GET

    @GetVaultDetail
  Scenario: Get vault by id 
    Given path 'core/vault/accounts/' + vaultId
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

    @RequestCreateAdvVault
  Scenario: Request create vault
    Given path 'core/vault/request-create-vault'
    * header Authorization = authorization
    * request body
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
    * header Authorization = authorization
    * params params
    When method GET

    @RequestUpdateVaultPolicy
  Scenario: Request Update Vault Policy
    Given path 'core/vault/' + vaultId + '/policy/request-update'
    * header Authorization = authorization
    * request requestBody
    When method POST

    @ReadUpdateVaultRequest
  Scenario: Read Update Vault Request
    Given path 'core/vault/' + vaultId + '/policy/request-update/' + requestDraftId
    * header Authorization = authorization
    When method GET

    @SubmitUpdateVaultRequest
  Scenario: Submit Update Vault Request
    Given path 'core/vault/' + vaultId + '/policy/request-update/' + requestDraftId + '/submit'
    * header Authorization = authorization
    * header challenge-answer = challengeAnswer
    * header passcode = passcode
    When method PATCH

    @CancelUpdateVaultRequest
  Scenario: Cancel Update Vault Request
    Given path 'core/vault/' + vaultId + '/policy/request-update/' + requestDraftId + '/discard'
    * header Authorization = authorization
    * header challenge-answer = challengeAnswer
    When method PATCH

  #----------Wallet-----------#
    @AddAssets
  Scenario: Add asset to vault / Create wallet on vault
    Given path 'core/wallet', vaultId
    * header Authorization = authorization
    * request { tokenIds: "#(tokenIds)"} 
    When method POST
  
    @GetTokens
  Scenario: Add asset to vault / Create wallet on vault
    Given path 'core/wallet/tokens', vaultId
    * header Authorization = authorization
    * params params
    When method GET

    @GetWalletAddress
  Scenario: Get wallet address
    Given path 'core/wallet/get-address-wallet'
    * header Authorization = authorization
    * params { vaultId: #(vaultId), walletId: #(walletId) }
    When method GET

    @GetWalletTransferTokens
  Scenario: Get wallet transfer token
    Given path 'core/wallet/transfer-tokens'
    * header Authorization = authorization
    * params params
    When method GET

    @GetWallets
  Scenario: Get wallets
    Given path 'core/vault/account' , vaultId , 'wallets'
    * header Authorization = authorization
    And params params
    When method GET

  #----------Whitelist Folder-----------#
    @CreateWhitelistFolder
  Scenario: Create whitelist folder
    Given path 'core/folders'
    * header Authorization = authorization
    And request {"name" : '#(name)',"type": '#(type)' }
    When method POST

    @AddWhitelistAddress
  Scenario: Add whitelist address
    Given path 'core/folders', folderId, 'tokens'
    * header Authorization = authorization
    * header challenge-answer = challengeAnswer
    And request body
    When method POST

    @GetWhitelistFolders
  Scenario: Get Whitelist Folders
    Given path 'core/folders'
    * header Authorization = authorization
    * params params
    When method GET

#----------Customer Billings-----------#  
    @GetBillings
  Scenario: Get Whitelist Folders
    Given path 'core/customers/billings'
    * header Authorization = authorization
    * params params
    When method GET
