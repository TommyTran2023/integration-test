@ignore
Feature: All api call to core services
  Background:
    * url baseURL

#----------Biometric---------#
    @RequestChallenge
  Scenario: Biometric Request Challenge
    Given path 'core/biometric/request-challenge'
    * header Authorization = authorization
    When method POST

    @TestBiometric
  Scenario: Test Biometric
    Given path 'core/biometric/test-biometric'
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
    Given path 'core/vault/account/' + vaultId + '/rules'
    * header Authorization = authorization
    * request requestBody
    When method PUT

    @HideVault
  Scenario: Hide a vault
    Given path 'core/vault/accounts/' + vaultId + '/hide'
    * header Authorization = authorization
    When method POST

    @UnhideVault
  Scenario: Unhide a vault
    Given path 'core/vault/accounts/' + vaultId + '/unhide'
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

    @CancelReqTransactionCreateFromWeb
  Scenario: Cancel request create vault from web
      Given path 'core/vault/cancel-request-create-vault'
      * header Authorization = authorization
      * request body
      When method PUT

    @GetDepositRouting
  Scenario: Get Deposit Routing - Connection Setup
    Given path 'core/vault/deposit-routing'
    * header Authorization = authorization
    * params params
    When method GET

    @GetPortfolioValueChart
  Scenario: Get portfolio value chart 
    Given path 'core/vault/accounts/portfolio-chart'
    * header Authorization = authorization
    * params params
    When method GET

    @GetAccountChart
  Scenario: Get account chart
    Given path 'core/vault/accounts/chart'
    * header Authorization = authorization
    When method GET

    @CheckVaultName
  Scenario: Check Vault Name Exists
    Given path 'core/vault/check-vault-name'
    * header Authorization = authorization
    * param name = name
    When method GET

    @GetChartOfVault
  Scenario: Get chart of vault
    Given path 'core/vault/'+ vaultId + '/chart'
    * header Authorization = authorization
    When method GET

    @RenameVault
  Scenario: Rename vault 
    Given path 'core/vault/account/'+ vaultId
    * header Authorization = authorization
    * request { name: name } 
    When method GET

    @GetListUserForVaults
  Scenario: Get list user for Vaults
    Given path 'core/vault/list-user
    * header Authorization = authorization
    * request body 
    When method GET

    @GetListVaultUnassigned
  Scenario: Get list vault unassigned by user
    Given path 'core/vault/unassigned
    * header Authorization = authorization
    * request body 
    When method GET

    @GetVaultOnlyViewMemberAndQuorum
  Scenario: Detail vault info with info quorum
    Given path 'core/vault/accounts/'+ vaultId +'/view/'+ userId
    * header Authorization = authorization
    When method GET

    @CheckRequestWithdrawInVault
  Scenario: Detail vault info with info quorum
    Given path 'core/vault/request-withdraw-in-vault/'+ vaultId
    * header Authorization = authorization
    When method GET

    @ListVaultMissingPolicy
  Scenario: Listing Vault Missing Policy
    Given path 'core/vault/vault-missing-policy'
    * header Authorization = authorization
    * request body
    When method GET

    @GetListVaultStake
  Scenario: Get List Vault Stake
    Given path 'core/vault/stake'
    * header Authorization = authorization
    * request body
    When method GET

    @GetListStakingByToken
  Scenario: Get List Staking By Token
    Given path 'core/vault/stake' + tokenId
    * header Authorization = authorization
    * request body
    When method GET

    @RequestUpdateVaultPolicy
  Scenario: Request Update Vault Policy
    Given path 'core/vault/'+ vaultId + '/policy/request-update'
    * header Authorization = authorization
    * request body
    When method POST

    @GetRequestEditVaultPolicyByRequestDraftId
  Scenario: Get Request Edit Vault Policy By Request Draft Id
    Given path 'core/vault/'+ vaultId + '/policy/request-update/' + requestDraftId
    * header Authorization = authorization
    When method GET

    @SubmitRequestEditVaultPolicyByRequestDraftId
  Scenario: Submit Request Edit Vault Policy By Request Draft Id
    Given path 'core/vault/'+ vaultId + '/policy/request-update/' + requestDraftId + '/submit'
    * header Authorization = authorization
    When method PATCH
    When method GET

    @DiscardRequestEditVaultPolicyByRequestDraftId
  Scenario: Discard Request Edit Vault Policy By Request Draft Id
    Given path 'core/vault/'+ vaultId + '/policy/request-update/' + requestDraftId + '/discard'
    * header Authorization = authorization
    When method PATCH

#----------Wallet-----------#
    @AddAssets
  Scenario: Add asset to vault / Create wallet on vault
    Given path 'core/wallet/' + vaultId
    * header Authorization = authorization
    * request { tokenIds: "#(tokenIds)"} 
    When method POST
  
    @GetTokens
  Scenario: Get all tokens available in the wallet
    Given path 'core/wallet/tokens/' + vaultId
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

    @GetWalletTransferTokens_v2
  Scenario: Get wallet transfer token
    Given path 'core/wallet/v2/transfer-tokens'
    * header Authorization = authorization
    * params params
    When method GET

    @GetWallets
  Scenario: Get wallets
    Given path 'core/vault/account/' + vaultId + '/wallets'
    * header Authorization = authorization
    And params params
    When method GET

  @GetListToken
  Scenario: Get List Token
    Given path 'core/wallet'
    * header Authorization = authorization
    And request body
    When method GET

  @GetTokenDetails
  Scenario: Get Token Details
    Given path 'core/wallet/token-details'
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

#----------Customer-----------#  
    @GetBillings
  Scenario: Get Whitelist Folders
    Given path 'core/customers/billings'
    * header Authorization = authorization
    * params params
    When method GET

    @EditAccountPolicy
  Scenario: Edit Account Policy
    Given path '/core/customers/' + customerId
    * header Authorization = authorization
    * header challenge-answer = challengeAnswer
    * header passcode = passcode
    * request body
    When method PUT

#----------Country-----------#  
    @CheckRestrictedCountries
  Scenario: Check Restricted Countries
    Given path '/core/restricted/check-country'
    * header Authorization = authorization
    When method GET

#----------Assets-----------#  
    @GetAssetsInAllAccountVaults
  Scenario: Get Assets In All Account Vaults
    Given path '/core/assets/chart'
    * header Authorization = authorization
    * param type = type
    When method GET

    @GetAssetShortcuts
  Scenario: Get list asset shortcuts
    Given path '/core/assets/shortcuts'
    * header Authorization = authorization
    * params data
    When method GET

    @GetAssetShortcutDetail
  Scenario: Get detail asset shortcuts 
    Given path '/core/assets/shortcuts/' + shortcutId
    * header Authorization = authorization
    When method GET

    @RenameShortcut
  Scenario: Rename shortcut
    Given path '/core/assets/shortcuts/' + shortcutId
    * header Authorization = authorization
    * request { name: #(name) }
    When method PUT

    @GetAssetsInterested
  Scenario: Get value assets of user interested
    Given path '/core/assets/interested'
    * header Authorization = authorization
    When method GET

    @UpdateAssetsInterested
  Scenario: Update value assets of user interested
    Given path '/core/assets/interested'
    * header Authorization = authorization
    * request body
    When method GET

    @GetTokenPrices
  Scenario: Get value assets
    Given path '/core/assets/price'
    * header Authorization = authorization
    * params params
    When method GET

  @CreateShortcut
  Scenario: Create shortcut asset
    Given path '/core/assets/shortcut'
    * header Authorization = authorization
    * request body
    When method POST

  @DeleteShortcut
  Scenario: Delete shortcut asset
    Given path '/core/assets/shortcut'
    * header Authorization = authorization
    * request body
    When method DELETE

  @GetShortcutName
  Scenario: Get name of shortcut asset
    Given path '/core/assets/shortcut/name'
    * header Authorization = authorization
    * request body
    When method POST

  @CheckShortcutNameExists
  Scenario: Get name of shortcut asset
    Given path '/core/assets/check-shortcut-name-exist'
    * header Authorization = authorization
    * param shortcutName = shortcutName
    When method GET

  @DeleteShortcutById
  Scenario: Delete shortcut by Id
    Given path '/core/assets/shortcut/' + shortcutId
    * header Authorization = authorization
    When method DELETE

  @CheckExistingShortcut
  Scenario: Check existing asset shortcuts
    Given path '/core/assets/check-existing
    * header Authorization = authorization
    * params params
    When method GET

  @AllocationDetail
  Scenario: Get asset allocation detail 
    Given path '/core/assets/allocation-detail
    * header Authorization = authorization
    * params params
    When method GET

  @GetAllVaultOfAsset
  Scenario: Get all asset vault
    Given path '/core/assets/overview
    * header Authorization = authorization
    * params params
    When method GET

  @GetListAssetsStaking
  Scenario: Get List Assets Staking
    Given path '/core/assets/assets-staking
    * header Authorization = authorization
    When method GET

