@RAKCON-10583
Feature: Approval Request

  Background:
    #@PRECOND_RAKCON-11369
        * callonce read(svc + 'ReadData.feature')
        * callonce read(svc + 'Auth.feature@GetApproverAccessToken')

  @RAKCON-10975 @ApproveNewVaultRequest
  Scenario: Approval - New vault policy request
    # Create new vault and get request ID of creating vault request
    * callonce read('this:Vault.feature@GetCreateVaultRequestID')
    * karate.call('this:ApprovalRequest.feature@ApproveRequestCommon')
