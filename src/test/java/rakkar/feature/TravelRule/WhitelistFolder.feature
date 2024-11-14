    @TravelRule
Feature: Travel rule whitelist folder 

  Background:
    * callonce read(svc + 'Auth.feature@GetUserAccessToken') { userName: '#(sg_customer.admin)' }
    * callonce read(svc + 'ReadData.feature')

    @TravelRule_CreateWhitelistFolder
  Scenario: Create whitelist folder
    * call read(svc + 'Whitelist.feature@CreateWhitelistFolder') { accessToken : "#(userAccessToken)"}
    Then match responseStatus == 201

    @TravelRule_AddWhitelistAddress
  Scenario: Create whitelist folder address
    * def body_submit = 
    """
    {
        requesterAccessToken: "#(userAccessToken)",
        "tag" : '',
        "isRequiredTag": false,
        "tokenId" : '',
        "note" : 'Note test',
        "address" : '0x720b43Cb2AD865EAe6c0ADc23898FBf91A0B0A02',
        "walletHost" : '#(Const.WalletHostOptions.SELF_HOSTED)',
        "walletMethod" : '#(Const.WalletMethodOptions.SELF_ATTESTATION)'
    }
    """
    * call read(svc + 'Whitelist.feature@ViewDetailFolder') { folderId: '#(folderId)'}
    * call read(svc + 'Biometric.feature@UserDoBiometric')
    * call read(svc + 'Whitelist.feature@AddWhitelistAddress') body_submit
