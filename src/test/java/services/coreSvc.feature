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
    Given path 'core/v2/vault/' + vaultId
    * header Authorization = authorization
    When method GET

    @UpdateVaultDetail
  Scenario: Update vault by id 
    Given path 'core/v2/vault/' + vaultId
    * header Authorization = authorization
    * request body
    When method PUT

    @DeleteVault
  Scenario: Delete vault by id 
    Given path 'core/v2/vault/' + vaultId
    * header Authorization = authorization
    When method DELETE

    @EditVaultPolicy
  Scenario: Edit vault policy 
    Given path 'core/vault/accounts/' + vaultId + 'rules'
    * header Authorization = authorization
    * request body
    When method PUT

    @ArchiveVault
  Scenario: Archive Vault
    Given path 'core/v2/vault/' + vaultId + '/archive'
    * header Authorization = authorization
    When method PATCH

    @UnarchiveVault
  Scenario: Unarchive Vault
    Given path 'core/v2/vault/' + vaultId + '/unarchive'
    * header Authorization = authorization
    When method PATCH

    @RequestCreateAdvVault
  Scenario: Request create vault
    Given path 'core/vault/request-create-vault'
    * header Authorization = authorization
    * request body
    When method POST

    @SubmitRequestCreateVault
  Scenario: Submit Request Create Vault
    Given path 'core/vault/submit-request-create-vault'
    * header Authorization = authorization
    * header challenge-answer = challengeAnswer
    * header passcode = passcode
    * request body
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
    Given path 'core/vault/list-user'
    * header Authorization = authorization
    * request body 
    When method GET

    @GetListVaultUnassigned
  Scenario: Get list vault unassigned by user
    Given path 'core/vault/unassigned'
    * header Authorization = authorization
    * params params 
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
    * request body
    When method PATCH

    @RequestUpdateVaultPolicy
  Scenario: Request Update Vault Policy
    Given path 'core/vault/' + vaultId + '/policy/request-update'
    * header Authorization = authorization
    * request body
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

  @GetListVault_v2
  Scenario: Get List Vault v2
    Given path '/core/v2/vault'
    * header Authorization = authorization
    * params params
    When method GET

  @CreateVault_v2
  Scenario: Create Vault v2
    Given path '/core/v2/vault'
    * header Authorization = authorization
    * request body
    When method POST

  @GetVaultsSummary
  Scenario: Get Vaults Summary
    Given path '/core/v2/vault/summary'
    * header Authorization = authorization
    When method GET

  @GetVaultFromSourceScreen
  Scenario: Get Vault from Transfer Source screen 
    Given path '/core/v2/vault/source'
    * header Authorization = authorization
    * params params
    When method GET

  @GetVaultFromDestinationScreen
  Scenario: Get Vault from Transfer Destination screen 
    Given path '/core/v2/vault/destination'
    * header Authorization = authorization
    * params params
    When method GET


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

    @HideAsset
  Scenario: Hide Asset
    Given path 'core/wallet/' + walletId + '/hide'
    * header Authorization = authorization
    When method POST

    @UnhideAsset
  Scenario: Hide Asset
    Given path 'core/wallet/' + walletId + '/unhide'
    * header Authorization = authorization
    When method POST

    @CheckAssetPreRequisite
  Scenario: Check Asset Pre Requisite
    Given path 'core/wallet/assets-pre-requisite/'+vaultId
    * header Authorization = authorization
    * request tokenIds = tokenIds
    When method POST

    @GetListTokenStake
  Scenario: Get List Token Stake
    Given path 'core/wallet/token-stake'
    * header Authorization = authorization
    * request body
    When method GET

    @GetListTokenStakeSubscription
  Scenario: Get List Token Stake Subscription
    Given path 'core/wallet/stake-subscription/tokens'
    * header Authorization = authorization
    * params params
    When method GET

    @GetCustomerWalletPrice
  Scenario: Get Customer Wallet Price
    Given path '/core/v2/walletPrices'
    * headers headers
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
    Given path 'core/folders/' + folderId + '/tokens'
    * header Authorization = authorization
    * header challenge-answer = challengeAnswer
    And request body
    When method POST

    @GetWhitelistTokens
  Scenario: Get whitelist Tokens
    Given path 'core/folders/' + folderId + '/tokens'
    * header Authorization = authorization
    And request body
    When method GET

    @GetWhitelistFolders
  Scenario: Get Whitelist Folders
    Given path 'core/folders'
    * header Authorization = authorization
    * params params
    When method GET

    @DeleteWhitelistFolders
  Scenario: Delete Whitelist Folders
    Given path 'core/folders'
    * header Authorization = authorization
    * request {folderIds:folderIds}
    When method DELETE

    @DeleteWhitelistFolderById
  Scenario: Delete Whitelist Folder By Id
    Given path 'core/folders/' + folderId
    * header Authorization = authorization
    When method DELETE

    @DeleteWhitelistAddress
  Scenario: Delete Whitelist Address
    Given path 'core/folders/' + folderId + '/address'
    * header Authorization = authorization
    * request { addressIds: addressIds }
    When method DELETE

    @GetFolderAddressDetail
  Scenario: Get Folder Address Detail
    Given path 'core/folders/addresses/' + folderAddressId
    * header Authorization = authorization
    When method GET

    @GetListAddress
  Scenario: Get list address
    Given path 'core/folders/list-address
    * header Authorization = authorization
    * request body
    When method GET

    @ValidateAddress
  Scenario: Validate Address
    Given path 'core/folders/addresses/validate'
    * header Authorization = authorization
    When method POST

    @GetFormInput
  Scenario: Get Form Input
    Given path 'core/folders/tokens/form-input'
    * header Authorization = authorization
    When method GET

    @CheckFolderName
  Scenario: Check Folder Name
    Given path 'core/folders/check-folder-name'
    * header Authorization = authorization
    * param name = name
    When method GET

    @CheckAddressDeactivate
  Scenario: Check Address Deactivate
    Given path 'core/folders/check-address-deactivate'
    * header Authorization = authorization
    * param address = address
    When method GET

#----------Customer-----------#  

    @EditAccountPolicy
  Scenario: Edit Account Policy
    Given path '/core/customers/' + customerId
    * header Authorization = authorization
    * header challenge-answer = challengeAnswer
    * header passcode = passcode
    * request body
    When method PUT

    @Customer_GetCustomerDetail
  Scenario: Get Customer Detail
    Given path '/core/customers/' + customerId
    * header Authorization = authorization
    * param includeAdditionalContacts = includeAdditionalContacts
    When method PUT

    @Customer_DeleteCustomerProfile
  Scenario: Customer - Delete Customer Profile
    Given path '/core/customers/' + customerId
    * header Authorization = authorization
    When method DELETE

    @Customer_GetAccountAdminPolicy
  Scenario: Customer - Get account admin policy
    Given path 'core/customers/' + customerId + '/account-policy'
    * header Authorization = authorization
    * param ignoreStatus = ignoreStatus
    When method GET

    @Customer_GetListVaultByCustomerId
  Scenario: Customer - Get List Vault By Customer Id
    Given path 'core/customers/' + customerId + '/vaults'
    * header Authorization = authorization
    When method GET

    @Customer_ChangeSubscribeStakingOfCustomer
  Scenario: Customer - Change Subscribe Staking Of Customer
    Given path 'core/customers/' + customerId + '/subscribe-staking'
    * header Authorization = authorization
    * request {editSubscribeStaking: #(editSubscribeStaking)} //array
    When method PUT

    @Customer_CheckPassportNumber
  Scenario: Customer - Check Passport Number
    Given path 'core/customers/check/' + passportNumber
    * header Authorization = authorization
    When method GET

    @Customer_GetCustomerWorkspace
  Scenario: Get Customer Workspace By User
    Given path 'core/customers/workspace/user'
    * header Authorization = authorization
    When method GET

    @Customer_GetCustomerWorkspaceName
  Scenario: Get Customer Workspace Name By User
    Given path 'core/customers/workspace-name/user'
    * header Authorization = authorization
    When method GET

    @Customer_IsTokenRequestedStakeSubscription
  Scenario: Get Customer Workspace Name By User
    Given path 'core/customers/stake/'+externalAssetId+'/request-subscription'
    * header Authorization = authorization
    When method GET

    @Customer_CreateStakingSubscriptionTicket
  Scenario: Customer - Create Staking Subscription Ticket
    Given path 'core/customers/' + customerId + '/subscribe-staking/tickets'
    * header Authorization = authorization
    * request {tokens:#(tokens)} //array
    When method POST

    @GetBillings
  Scenario: Get Whitelist Folders
    Given path 'core/customers/billings'
    * header Authorization = authorization
    * params params
    When method GET

    @GetCustomerBillingDetail
  Scenario: Get customer billing detail
    Given path 'core/customers/billings/' + billingId
    * header Authorization = authorization
    * param isHistory = #(isHistory)

    @GetPathInvoicePdf
  Scenario: Get Path Invoice Pdf
    Given path 'core/customers/billings/' + billingId + '/view-pdf'
    * header Authorization = authorization
    * param isHistory = #(isHistory)

    @ExportBillingDetail
  Scenario: Export billing detail, returned as a CSV file
    Given path 'core/customers/billings/export'
    * header Authorization = authorization
    * request body
    When method POST

    @ExportInvoicesAsPDF
  Scenario: Export Invoices As PDF
    Given path 'core/customers/billings/invoice'
    * header Authorization = authorization
    * request body
    When method POST

    @MarkAsReviewedInvoice
  Scenario: Mark as reviewed invoice
    Given path 'core/customers/billings/'+ billingId + '/review'
    * header Authorization = authorization
    When method POST
    
    @MarkAsPaidInvoice
  Scenario: Mark as paid invoice
    Given path 'core/customers/billings/'+ billingId + '/paid'
    * header Authorization = authorization
    When method POST

    @GetProductSubscription
  Scenario: Get Product Subscription
    Given path 'core/customers/' + customerId + '/fee'
    * header Authorization = authorization
    When method GET

    @CreateProductSubscription
  Scenario: Create Product Subscription
    Given path 'core/customers/' + customerId + '/fee'
    * header Authorization = authorization
    * request body
    When method POST

    @UpdateProductSubscription
  Scenario: Update Product Subscription
    Given path 'core/customers/' + customerId + '/fee/' + feeInformationId
    * header Authorization = authorization
    * request body
    When method POST

    @GetListCustomer
  Scenario: Get List Customer
    Given path '/core/customers
    * header Authorization = authorization
    * params params
    When method GET

    @CreateNewCustomer
  Scenario: Create New Customer
    Given path '/core/customers
    * header Authorization = authorization
    * request body
    When method POST

    @Customer_GetListAssetsStaking
  Scenario: Customer - Get List Assets Staking
    Given path 'core/customers/assets-staking'
    * header Authorization = authorization
    When method GET

    @Customer_GetTotalActiveCustomer
  Scenario: Customer - Get Total Active Customer
    Given path 'core/customers/total-active'
    * header Authorization = authorization
    When method GET

    @Customer_GetListBusinessType
  Scenario: Customer - Get List Business Type
    Given path 'core/customers/business-type'
    * header Authorization = authorization
    When method GET

    @Customer_GetListWorkspace
  Scenario: Customer - Get List Workspace
    Given path 'core/customers/workspace'
    * header Authorization = authorization
    When method GET

    @Customer_GetListEntityRelation
  Scenario: Customer - Get List Entity Relation
    Given path 'core/customers/entity-relation'
    * header Authorization = authorization
    When method GET

    @CheckCustomerBRIAndCountry
  Scenario: Check Customer BRI And Country
    Given path 'core/customers/check-bri-and-country'
    * header Authorization = authorization
    * params params
    When method GET

    @CheckCustomerShortName
  Scenario: Validate duplicate customer by short name
    Given path 'core/customers/check-short-name'
    * header Authorization = authorization
    * param customerShortName = customerShortName
    When method GET

    @Customer_GetTotalPendingRequest
  Scenario: Customer - Get Total Pending Request
    Given path 'core/customers/total-pending-request'
    * header Authorization = authorization
    When method GET

    @GenerateBillingByCustomerId
  Scenario: Generate Billing By Customer Id
    Given path 'core/customers/' + customerId + '/billing/' + yearMonth
    * header Authorization = authorization
    * params params
    When method PATCH

    @Customer_SyncTokenPriceByMonthYear
  Scenario: Sync Token Price By Month Year
    Given path 'core/customers/' + customerId + '/billing/' + yearMonth + '/sync-price'
    * header Authorization = authorization
    * params params
    When method PATCH

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

#----------Comments-----------#  
    @GetComments
  Scenario: Get Comments
    Given path entityType + '/' + entityId + '/comments'
    * header Authorization = authorization
    When method GET
  
    @CreateComment
  Scenario: Create Comment
    Given path entityType + '/' + entityId + '/comments'
    * header Authorization = authorization
    * request {content:content}
    When method POST

    @UpdateComment
  Scenario: Update Comment
    Given path entityType + '/' + entityId + '/comments/' + commentId 
    * header Authorization = authorization
    * request {content:content}
    When method POST

    @DeleteComment
  Scenario: Update Comment
    Given path entityType + '/' + entityId + '/comments/' + commentId 
    * header Authorization = authorization
    When method DELETE

#----------Address-----------#  
    @CreateAddress
  Scenario: Create Deposit Address
    Given path 'core/address' 
    * header Authorization = authorization
    * request body
    When method POST

    @UpdateAddress
  Scenario: Update Deposit Address
    Given path 'core/address' 
    * header Authorization = authorization
    * request body
    When method PUT

#----------REP Currency Convert-----------#  
    @CurrencyConvert_GetListEntity
  Scenario: Get List Entity Currency Convert
    Given path 'core/v2/rep/currencyConvert'
    * header Authorization = authorization
    * params params
    When method GET

    @CurrencyConvert_SaveEntity
  Scenario: Save Entity Currency Convert
    Given path 'core/v2/rep/currencyConvert'
    * header Authorization = authorization
    * request body
    When method POST

    @CurrencyConvert_FindByUid
  Scenario: Find Currency Convert By Uid
    Given path 'core/v2/rep/currencyConvert/' + id
    * header Authorization = authorization
    When method GET

    @CurrencyConvert_UpdateByUid
  Scenario: Update Currency Convert
    Given path 'core/v2/rep/currencyConvert/' + id
    * header Authorization = authorization
    * request body
    When method PUT

    @CurrencyConvert_DeleteByUid
  Scenario: Delete Currency Convert By Uid
    Given path 'core/v2/rep/currencyConvert/' + id
    * header Authorization = authorization
    When method DELETE

    @CurrencyConvert_DeleteByUid_hard
  Scenario: Hard Delete Currency Convert By Uid
    Given path 'core/v2/rep/currencyConvert/' + id + '/hard'
    * header Authorization = authorization
    When method DELETE

#----------REP Currency-----------#  
    @Currency_GetListEntity
  Scenario: Get List Entity Currency
    Given path 'core/v2/rep/currency'
    * header Authorization = authorization
    * params params
    When method GET

    @Currency_SaveEntity
  Scenario: Save Entity Currency
    Given path 'core/v2/rep/currency'
    * header Authorization = authorization
    * request body
    When method POST

    @Currency_FindByUid
  Scenario: Find Currency By Uid
    Given path 'core/v2/rep/currency/' + id
    * header Authorization = authorization
    When method GET

    @Currency_UpdateByUid
  Scenario: Update Currency
    Given path 'core/v2/rep/currency/' + id
    * header Authorization = authorization
    * request body
    When method PUT

    @Currency_DeleteByUid
  Scenario: Delete Currency By Uid
    Given path 'core/v2/rep/currency/' + id
    * header Authorization = authorization
    When method DELETE

    @Currency_DeleteByUid_hard
  Scenario: Hard Delete Currency By Uid
    Given path 'core/v2/rep/currency/' + id + '/hard'
    * header Authorization = authorization
    When method DELETE

#----------REP Wallet Info-----------#  
    @WalletInfo_GetListEntity
  Scenario: Get List Entity WalletInfo
    Given path 'core/v2/rep/walletInfo'
    * header Authorization = authorization
    * params params
    When method GET

    @WalletInfo_SaveEntity
  Scenario: Save Entity WalletInfo
    Given path 'core/v2/rep/walletInfo'
    * header Authorization = authorization
    * request body
    When method POST

    @WalletInfo_FindByUid
  Scenario: Find WalletInfo By Uid
    Given path 'core/v2/rep/walletInfo/' + id
    * header Authorization = authorization
    When method GET

    @WalletInfo_DeleteByUid
  Scenario: Delete WalletInfo By Uid
    Given path 'core/v2/rep/walletInfo/' + id
    * header Authorization = authorization
    When method DELETE

    @WalletInfo_DeleteByUid_hard
  Scenario: Hard Delete WalletInfo By Uid
    Given path 'core/v2/rep/walletInfo/' + id + '/hard'
    * header Authorization = authorization
    When method DELETE

    @GetCustomerBillingDetail
  Scenario: Get customer billing detail
    Given path 'core/customers/billings/' + billingId
    * header Authorization = authorization
    * param isHistory = #(isHistory)

    @GetPathInvoicePdf
  Scenario: Get Path Invoice Pdf
    Given path 'core/customers/billings/' + billingId + '/view-pdf'
    * header Authorization = authorization
    * param isHistory = #(isHistory)

    @ExportBillingDetail
  Scenario: Export billing detail, returned as a CSV file
    Given path 'core/customers/billings/export'
    * header Authorization = authorization
    * request body
    When method POST

    @ExportInvoicesAsPDF
  Scenario: Export Invoices As PDF
    Given path 'core/customers/billings/invoice'
    * header Authorization = authorization
    * request body
    When method POST

    @MarkAsReviewedInvoice
  Scenario: Mark as reviewed invoice
    Given path 'core/customers/billings/'+ billingId + '/review'
    * header Authorization = authorization
    When method POST
    
    @MarkAsPaidInvoice
  Scenario: Mark as paid invoice
    Given path 'core/customers/billings/'+ billingId + '/paid'
    * header Authorization = authorization
    When method POST

    @GetProductSubscription
  Scenario: Get Product Subscription
    Given path 'core/customers/' + customerId + '/fee'
    * header Authorization = authorization
    When method GET

    @CreateProductSubscription
  Scenario: Create Product Subscription
    Given path 'core/customers/' + customerId + '/fee'
    * header Authorization = authorization
    * request body
    When method POST

    @UpdateProductSubscription
  Scenario: Update Product Subscription
    Given path 'core/customers/' + customerId + '/fee/' + feeInformationId
    * header Authorization = authorization
    * request body
    When method POST

    @GetListCustomer
  Scenario: Get List Customer
    Given path '/core/customers'
    * header Authorization = authorization
    * params params
    When method GET

    @CreateNewCustomer
  Scenario: Create New Customer
    Given path '/core/customers'
    * header Authorization = authorization
    * request body
    When method POST

    @Customer_GetListAssetsStaking
  Scenario: Customer - Get List Assets Staking
    Given path 'core/customers/assets-staking'
    * header Authorization = authorization
    When method GET

    @Customer_GetTotalActiveCustomer
  Scenario: Customer - Get Total Active Customer
    Given path 'core/customers/total-active'
    * header Authorization = authorization
    When method GET

    @Customer_GetListBusinessType
  Scenario: Customer - Get List Business Type
    Given path 'core/customers/business-type'
    * header Authorization = authorization
    When method GET

    @Customer_GetListWorkspace
  Scenario: Customer - Get List Workspace
    Given path 'core/customers/workspace'
    * header Authorization = authorization
    When method GET

    @Customer_GetListEntityRelation
  Scenario: Customer - Get List Entity Relation
    Given path 'core/customers/entity-relation'
    * header Authorization = authorization
    When method GET

    @CheckCustomerBRIAndCountry
  Scenario: Check Customer BRI And Country
    Given path 'core/customers/check-bri-and-country'
    * header Authorization = authorization
    * params params
    When method GET

    @CheckCustomerShortName
  Scenario: Validate duplicate customer by short name
    Given path 'core/customers/check-short-name'
    * header Authorization = authorization
    * param customerShortName = customerShortName
    When method GET

    @Customer_GetTotalPendingRequest
  Scenario: Customer - Get Total Pending Request
    Given path 'core/customers/total-pending-request'
    * header Authorization = authorization
    When method GET

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
    Given path '/core/assets/check-existing'
    * header Authorization = authorization
    * params params
    When method GET

    @AllocationDetail
  Scenario: Get asset allocation detail 
    Given path '/core/assets/allocation-detail'
    * header Authorization = authorization
    * params params
    When method GET

    @GetAllVaultOfAsset
  Scenario: Get all asset vault
    Given path '/core/assets/overview'
    * header Authorization = authorization
    * params params
    When method GET

    @GetListAssetsStaking
  Scenario: Get List Assets Staking
    Given path '/core/assets/assets-staking'
    * header Authorization = authorization
    When method GET

#----------Comments-----------#  
    @GetComments
  Scenario: Get Comments
    Given path entityType + '/' + entityId + '/comments'
    * header Authorization = authorization
    When method GET
  
    @CreateComment
  Scenario: Create Comment
    Given path entityType + '/' + entityId + '/comments'
    * header Authorization = authorization
    * request {content:content}
    When method POST

    @UpdateComment
  Scenario: Update Comment
    Given path entityType + '/' + entityId + '/comments/' + commentId 
    * header Authorization = authorization
    * request {content:content}
    When method POST

    @DeleteComment
  Scenario: Update Comment
    Given path entityType + '/' + entityId + '/comments/' + commentId 
    * header Authorization = authorization
    When method DELETE

#----------Address-----------#  
    @CreateAddress
  Scenario: Create Deposit Address
    Given path 'core/address' 
    * header Authorization = authorization
    * request body
    When method POST

    @UpdateAddress
  Scenario: Update Deposit Address
    Given path 'core/address' 
    * header Authorization = authorization
    * request body
    When method PUT

#----------REP Currency Convert-----------#  
    @CurrencyConvert_GetListEntity
  Scenario: Get List Entity Currency Convert
    Given path 'core/v2/rep/currencyConvert'
    * header Authorization = authorization
    * params params
    When method GET

    @CurrencyConvert_SaveEntity
  Scenario: Save Entity Currency Convert
    Given path 'core/v2/rep/currencyConvert'
    * header Authorization = authorization
    * request body
    When method POST

    @CurrencyConvert_FindByUid
  Scenario: Find Currency Convert By Uid
    Given path 'core/v2/rep/currencyConvert/' + id
    * header Authorization = authorization
    When method GET

    @CurrencyConvert_UpdateByUid
  Scenario: Update Currency Convert
    Given path 'core/v2/rep/currencyConvert/' + id
    * header Authorization = authorization
    * request body
    When method PUT

    @CurrencyConvert_DeleteByUid
  Scenario: Delete Currency Convert By Uid
    Given path 'core/v2/rep/currencyConvert/' + id
    * header Authorization = authorization
    When method DELETE

    @CurrencyConvert_DeleteByUid_hard
  Scenario: Hard Delete Currency Convert By Uid
    Given path 'core/v2/rep/currencyConvert/' + id + '/hard'
    * header Authorization = authorization
    When method DELETE

#----------REP Currency-----------#  
    @Currency_GetListEntity
  Scenario: Get List Entity Currency
    Given path 'core/v2/rep/currency'
    * header Authorization = authorization
    * params params
    When method GET

    @Currency_SaveEntity
  Scenario: Save Entity Currency
    Given path 'core/v2/rep/currency'
    * header Authorization = authorization
    * request body
    When method POST

    @Currency_FindByUid
  Scenario: Find Currency By Uid
    Given path 'core/v2/rep/currency/' + id
    * header Authorization = authorization
    When method GET

    @Currency_UpdateByUid
  Scenario: Update Currency
    Given path 'core/v2/rep/currency/' + id
    * header Authorization = authorization
    * request body
    When method PUT

    @Currency_DeleteByUid
  Scenario: Delete Currency By Uid
    Given path 'core/v2/rep/currency/' + id
    * header Authorization = authorization
    When method DELETE

    @Currency_DeleteByUid_hard
  Scenario: Hard Delete Currency By Uid
    Given path 'core/v2/rep/currency/' + id + '/hard'
    * header Authorization = authorization
    When method DELETE

#----------REP Wallet Info-----------#  
    @WalletInfo_GetListEntity
  Scenario: Get List Entity WalletInfo
    Given path 'core/v2/rep/walletInfo'
    * header Authorization = authorization
    * params params
    When method GET

    @WalletInfo_SaveEntity
  Scenario: Save Entity WalletInfo
    Given path 'core/v2/rep/walletInfo'
    * header Authorization = authorization
    * request body
    When method POST

    @WalletInfo_FindByUid
  Scenario: Find WalletInfo By Uid
    Given path 'core/v2/rep/walletInfo/' + id
    * header Authorization = authorization
    When method GET

    @WalletInfo_DeleteByUid
  Scenario: Delete WalletInfo By Uid
    Given path 'core/v2/rep/walletInfo/' + id
    * header Authorization = authorization
    When method DELETE

    @WalletInfo_DeleteByUid_hard
  Scenario: Hard Delete WalletInfo By Uid
    Given path 'core/v2/rep/walletInfo/' + id + '/hard'
    * header Authorization = authorization
    When method DELETE

#----------REP Vault-----------#  
    @REP_GetVaults
  Scenario: REP - Get Vaults
    Given path 'core/v2/rep/vault'
    * header Authorization = authorization
    * params params
    When method GET

    @REP_CreateVault
  Scenario: REP - Create Vault
    Given path 'core/v2/rep/vault'
    * header Authorization = authorization
    * request body
    When method POST

    @REP_GetVaultById
  Scenario: REP - Get Vault By Id
    Given path 'core/v2/rep/vault/' + vaultId
    * header Authorization = authorization
    When method GET

    @REP_UpdateVaultDetail
  Scenario: Update vault by id 
    Given path 'core/v2/rep/vault/' + vaultId
    * header Authorization = authorization
    * request body
    When method PUT

    @REP_DeleteVault
  Scenario: Delete vault by id 
    Given path 'core/v2/rep/vault/' + vaultId
    * header Authorization = authorization
    When method DELETE

#----------REP Snapshot Token Price-----------#  
@REP_GetSnapshotTokenPrice
Scenario: REP - Get Snapshot Token Price
  Given path 'core/v2/rep/snapshotTokenPrice'
  * header Authorization = authorization
  * params params
  When method GET

  @REP_CreateSnapshotTokenPrice
Scenario: REP - Create Snapshot Token Price
  Given path 'core/v2/rep/snapshotTokenPrice'
  * header Authorization = authorization
  * request body
  When method POST

  @REP_GetSnapshotTokenPriceById
Scenario: REP - Get Snapshot Token Price By Id
  Given path 'core/v2/rep/snapshotTokenPrice/' + id
  * header Authorization = authorization
  When method GET

  @REP_UpdateSnapshotTokenPrice
Scenario: Update Snapshot Token Price by id 
  Given path 'core/v2/rep/snapshotTokenPrice/' + id
  * header Authorization = authorization
  * request body
  When method PUT

  @REP_DeleteSnapshotTokenPrice
Scenario: Delete Snapshot Token Price by id 
  Given path 'core/v2/rep/snapshotTokenPrice/' + id
  * header Authorization = authorization
  When method DELETE

  #----------REP Daily Journal Customers-----------#  
@REP_GetDailyJournalCustomers
Scenario: REP - Get Daily Journal Customers
  Given path 'core/v2/rep/dailyJournalCustomers'
  * header Authorization = authorization
  * params params
  When method GET

  @REP_CreateDailyJournalCustomers
Scenario: REP - Create Daily Journal Customers
  Given path 'core/v2/rep/dailyJournalCustomers'
  * header Authorization = authorization
  * request body
  When method POST

  @REP_GetDailyJournalCustomersById
Scenario: REP - Get Daily Journal Customers By Id
  Given path 'core/v2/rep/dailyJournalCustomers/' + id
  * header Authorization = authorization
  When method GET

  @REP_UpdateDailyJournalCustomers
Scenario: Update Daily Journal Customers by id 
  Given path 'core/v2/rep/dailyJournalCustomers/' + id
  * header Authorization = authorization
  * request body
  When method PUT

  @REP_DeleteDailyJournalCustomers
Scenario: Delete Daily Journal Customers by id 
  Given path 'core/v2/rep/dailyJournalCustomers/' + id
  * header Authorization = authorization
  When method DELETE

#----------Groups-----------#  
  @GetGroupsWithDetailsByIds
  Scenario: Get Groups With Details By Ids
    Given path 'core/groups/with-detail'
    * header Authorization = authorization
    * params params
    When method GET

  @GetGroups
  Scenario: Get Groups
    Given path 'core/groups'
    * header Authorization = authorization
    * params params
    When method GET
