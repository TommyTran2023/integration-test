Feature: All Core REP API 
Background:
    Given url typeof customUrl != 'undefined' ? customUrl : baseURL

    #----------------------------------
    @CustomerREPController_getListCustomer
Scenario: Customer REPController get List Customer
  Given path 'core/rep/customers'
  * headers headers
  * params params
  When method GET

  @CustomerREPController_createNewCustomer
Scenario: Customer REPController create New Customer
  Given path 'core/rep/customers'
  * headers headers
  * request requestBody
  When method POST

  #----------------------------------
  @CustomerREPController_getListAssetsStaking
Scenario: Customer REPController get List Assets Staking
  Given path 'core/rep/customers/assets-staking'
  * headers headers
  When method GET

  #----------------------------------
  @CustomerREPController_getTotalActiveCustomer
Scenario: Customer REPController get Total Active Customer
  Given path 'core/rep/customers/total-active'
  * headers headers
  When method GET

  #----------------------------------
  @CustomerREPController_getListBusinessType
Scenario: Customer REPController get List Business Type
  Given path 'core/rep/customers/business-type'
  * headers headers
  When method GET

  #----------------------------------
  @CustomerREPController_getListWorkspace
Scenario: Customer REPController get List Workspace
  Given path 'core/rep/customers/workspace'
  * headers headers
  * params params
  When method GET

  #----------------------------------
  @CustomerREPController_getListCustomerEntityRelation
Scenario: Customer REPController get List Customer Entity Relation
  Given path 'core/rep/customers/entity-relation'
  * headers headers
  When method GET

  #----------------------------------
  @CustomerREPController_checkCustomerBRIAndCountry
Scenario: Customer REPController check Customer BRIAnd Country
  Given path 'core/rep/customers/check-bri-and-country'
  * headers headers
  * params params
  When method GET

  #----------------------------------
  @CustomerREPController_checkCustomerShortName
Scenario: Customer REPController check Customer Short Name
  Given path 'core/rep/customers/check-short-name'
  * headers headers
  * params params
  When method GET

  #----------------------------------
  @CustomerREPController_getAccountTotalPendingRequest
Scenario: Customer REPController get Account Total Pending Request
  Given path 'core/rep/customers/total-pending-request'
  * headers headers
  When method GET

  #----------------------------------
  @CustomerREPController_getCustomerDetail
Scenario: Customer REPController get Customer Detail
  Given path `core/rep/customers/${customerId}`
  * headers headers
  * params params
  When method GET

  @CustomerREPController_updateCustomerQuorum
Scenario: Customer REPController update Customer Quorum
  Given path `core/rep/customers/${customerId}`
  * headers headers
  * params params
  * request body
  When method PUT

  @CustomerREPController_deleteProfile
Scenario: Customer REPController delete Profile
  Given path `core/rep/customers/${customerId}`
  * headers headers
  * params params
  When method DELETE

  #----------------------------------
  @CustomerREPController_getAccountAdminPolicy
Scenario: Customer REPController get Account Admin Policy
  Given path `core/rep/customers/${customerId}/account-policy`
  * headers headers
  * params params
  When method GET

  #----------------------------------
  @CustomerREPController_getListVaultByCustomerId
Scenario: Customer REPController get List Vault By Customer Id
  Given path `core/rep/customers/${customerId}/vaults`
  * headers headers
  * params params
  When method GET

  #----------------------------------
  @CustomerREPController_changeSubscribeStakingOfCustomer
Scenario: Customer REPController change Subscribe Staking Of Customer
  Given path `core/rep/customers/${customerId}/subscribe-staking`
  * headers headers
  * params params
  * request body
  When method PUT

  #----------------------------------
  @CustomerREPController_checkPassportNumber
Scenario: Customer REPController check Passport Number
  Given path `core/rep/customers/check/${passportNumber}`
  * headers headers
  * params params
  When method GET

  #----------------------------------
  @CustomerREPController_getWorkspaceByUser
Scenario: Customer REPController get Workspace By User
  Given path 'core/rep/customers/workspace/user'
  * headers headers
  When method GET

  #----------------------------------
  @CustomerREPController_getWorkspaceNameByUser
Scenario: Customer REPController get Workspace Name By User
  Given path 'core/rep/customers/workspace-name/user'
  * headers headers
  When method GET

  #----------------------------------
  @CustomerREPController_isTokenRequestedStakeSubscription
Scenario: Customer REPController is Token Requested Stake Subscription
  Given path `core/rep/customers/stake/${externalAssetId}/request-subscription`
  * headers headers
  * params params
  When method GET

  #----------------------------------
  @CustomerREPController_createStakingSubscriptionTicket
Scenario: Customer REPController create Staking Subscription Ticket
  Given path `core/rep/customers/${customerId}/subscribe-staking/tickets`
  * headers headers
  * params params
  * request body
  When method POST


#----------------------------------
  @RepWalletController_getListToken
Scenario: Rep Wallet Controller get List Token
Given path 'core/rep/wallet'
* headers headers
* params params
When method GET

#----------------------------------
@RepWalletController_getListTokenByVault
Scenario: Rep Wallet Controller get List Token By Vault
Given path `core/rep/wallet/tokens/${vaultId}`
* headers headers
* params params
When method GET

#----------------------------------
@RepWalletController_createWallets
Scenario: Rep Wallet Controller create Wallets
Given path `core/rep/wallet/${vaultId}`
* headers headers
* params params
* request body
When method POST

#----------------------------------
@RepWalletController_getListTransferToken
Scenario: Rep Wallet Controller get List Transfer Token
Given path 'core/rep/wallet/transfer-tokens'
* headers headers
* params params
When method GET

#----------------------------------
@RepWalletController_getListTransferTokenV2
Scenario: Rep Wallet Controller get List Transfer Token V2
Given path 'core/rep/wallet/v2/transfer-tokens'
* headers headers
* params params
When method GET

#----------------------------------
@RepWalletController_getAddressWallet
Scenario: Rep Wallet Controller get Address Wallet
Given path 'core/rep/wallet/get-address-wallet'
* headers headers
* params params
When method GET

#----------------------------------
@RepWalletController_viewTokenDetail
Scenario: Rep Wallet Controller view Token Detail
Given path 'core/rep/wallet/token-details'
* headers headers
* params params
When method GET

#----------------------------------
@RepWalletController_hideAssest
Scenario: Rep Wallet Controller hide Assest
Given path `core/rep/wallet/${walletId}/hide`
* headers headers
* params params
When method POST

#----------------------------------
@RepWalletController_unhideAssest
Scenario: Rep Wallet Controller unhide Assest
Given path `core/rep/wallet/${walletId}/unhide`
* headers headers
* params params
When method POST

#----------------------------------
@RepWalletController_checkAssetPreRequisite
Scenario: Rep Wallet Controller check Asset Pre Requisite
Given path `core/rep/wallet/assets-pre-requisite/${vaultId}`
* headers headers
* params params
* request body
When method POST

#----------------------------------
@RepWalletController_getListTokenStake
Scenario: Rep Wallet Controller get List Token Stake
Given path 'core/rep/wallet/token-stake'
* headers headers
* params params
When method GET

#----------------------------------
@RepWalletController_getListTokenStakeSubscription
Scenario: Rep Wallet Controller get List Token Stake Subscription
Given path 'core/rep/wallet/stake-subscription/tokens'
* headers headers
* params params
When method GET
#----------------------------------
  @RepCustomerController_getListCustomerBillings
  Scenario: Rep Customer Controller get List Customer Billings
      Given path 'core/rep/customers/billings'
      * headers headers
      * params params
      When method GET

#----------------------------------
  @RepCustomerController_getCustomerBillingDetail
  Scenario: Rep Customer Controller get Customer Billing Detail
      Given path `core/rep/customers/billings/${billingId}`
      * headers headers
      * params params
      When method GET

#----------------------------------
  @RepCustomerController_getPathInvoicePdf
  Scenario: Rep Customer Controller get Path Invoice Pdf
      Given path `core/rep/customers/billings/${billingId}/view-pdf`
      * headers headers
      * params params
      When method GET

#----------------------------------
  @RepCustomerController_getProductSubscription
  Scenario: Rep Customer Controller get Product Subscription
      Given path `core/rep/customers/${customerId}/fee`
      * headers headers
      * params params
      When method GET

#----------------------------------
  @RepCustomerController_createProductSubscription
  Scenario: Rep Customer Controller create Product Subscription
      Given path `core/rep/customers/${customerId}/fee`
      * headers headers
      * params params
      * request body
      When method POST

#----------------------------------
  @RepCustomerController_exportBillingDetail
  Scenario: Rep Customer Controller export Billing Detail
      Given path 'core/rep/customers/billings/export'
      * headers headers
      * request body
      When method POST

#----------------------------------
  @RepCustomerController_exportInvoicesAsPDF
  Scenario: Rep Customer Controller export Invoices As PDF
      Given path 'core/rep/customers/billings/invoice'
      * headers headers
      * request body
      When method POST

#----------------------------------
@RepCustomerController_getListCustomerBillings
Scenario: Rep Customer Controller get List Customer Billings
Given path 'core/rep/customers/billings'
* headers headers
* params params
When method GET

#----------------------------------
@RepCustomerController_getCustomerBillingDetail
Scenario: Rep Customer Controller get Customer Billing Detail
Given path `core/rep/customers/billings/${billingId}`
* headers headers
* params params
When method GET

#----------------------------------
@RepCustomerController_getPathInvoicePdf
Scenario: Rep Customer Controller get Path Invoice Pdf
Given path `core/rep/customers/billings/${billingId}/view-pdf`
* headers headers
* params params
When method GET

#----------------------------------
@RepCustomerController_getProductSubscription
Scenario: Rep Customer Controller get Product Subscription
Given path `core/rep/customers/${customerId}/fee`
* headers headers
* params params
When method GET

@RepCustomerController_createProductSubscription
Scenario: Rep Customer Controller create Product Subscription
Given path `core/rep/customers/${customerId}/fee`
* headers headers
* params params
* request body
When method POST

#----------------------------------
@RepCustomerController_exportBillingDetail
Scenario: Rep Customer Controller export Billing Detail
Given path 'core/rep/customers/billings/export'
* headers headers
* request body
When method POST

#----------------------------------
@RepCustomerController_exportInvoicesAsPDF
Scenario: Rep Customer Controller export Invoices As PDF
Given path 'core/rep/customers/billings/invoice'
* headers headers
* request body
When method POST

