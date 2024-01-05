@ignore
Feature: Get Data From data.json
  Background:
    * callonce read(svc + 'ReadData.feature@ReadDataFile')
    * callonce read(svc + 'Auth.feature@GetRequesterInfo')
    * configure afterFeature = function(){ karate.call('this:WriteDataFile.feature'); }

    @Get_standardWarmVault_1
  Scenario: Get standardWarmVault_1
    * call read(svc + 'Vault.feature@GetListVault_v2') {searchText: '#(testData.standardWarmVault_1)', isShowSignificanceOnly: true}
    * def getVal = 
    """
        function(){
            if (response.data.list.length == 0) {
                karate.call('this:Create.feature@CreateHotStandard1')
                var newCreadtedVault = karate.call(svc + 'Vault.feature@GetListVault_v2', {searchText: testData.standardWarmVault_1, isShowSignificanceOnly: true})
                return newCreadtedVault.response.data.list[0].id
            }
            else {
                return response.data.list[0].id
            }
        }
    """
    * def vaultId =  getVal()
    * fileUtils.addData('sourceId_hot', vaultId)

    @Get_standardWarmVault_2
  Scenario: Get standardWarmVault_2
    * call read(svc + 'Vault.feature@GetListVault_v2') {searchText: '#(testData.standardWarmVault_2)'}
    * def getVal = 
    """
        function(){
            if (response.data.list.length == 0) {
                karate.call('this:Create.feature@CreateHotStandard2')
                var newCreadtedVault = karate.call(svc + 'Vault.feature@GetListVault_v2', {searchText: testData.standardWarmVault_2, isShowSignificanceOnly: true})
                return newCreadtedVault.response.data.list[0].id
            }
            else {
                return response.data.list[0].id
            }
        }
    """
    * def vaultId =  getVal()
    * fileUtils.addData('destinationId_hot',response.data.list[0].id)

    @Get_standardColdVault_1
  Scenario: Get standardColdVault_1
    * call read(svc + 'Vault.feature@GetListVault_v2') {searchText: '#(testData.standardColdVault_1)', isShowSignificanceOnly: true}
    * def getVal = 
    """
        function(){
            if (response.data.list.length == 0) {
                karate.call('this:Create.feature@CreateColdStandard1')
                var newCreadtedVault = karate.call(svc + 'Vault.feature@GetListVault_v2', {searchText: testData.standardColdVault_1, isShowSignificanceOnly: true})
                return newCreadtedVault.response.data.list[0].id
            }
            else {
                return response.data.list[0].id
            }
        }
    """
    * def vaultId =  getVal()
    * fileUtils.addData('sourceId_cold',response.data.list[0].id)

    @Get_standardColdVault_2
  Scenario: Get standardColdVault_2
    * call read(svc + 'Vault.feature@GetListVault_v2') {searchText: '#(testData.standardColdVault_2)', isShowSignificanceOnly: true}
    * def getVal = 
    """
        function(){
            if (response.data.list.length == 0) {
                karate.call('this:Create.feature@CreateColdStandard2')
                var newCreadtedVault = karate.call(svc + 'Vault.feature@GetListVault_v2', {searchText: testData.standardColdVault_2, isShowSignificanceOnly: true})
                return newCreadtedVault.response.data.list[0].id
            }
            else {
                return response.data.list[0].id
            }
        }
    """
    * def vaultId =  getVal()
    * fileUtils.addData('destinationId_cold',response.data.list[0].id)

    @Get_standardHotVaultForStake
  Scenario: Get standardHotVaultForStake
    * call read(svc + 'Vault.feature@GetListVault_v2') {searchText: '#(testData.standardHotVaultForStake)', isShowSignificanceOnly: true}
    * def getVal = 
    """
        function(){
            if (response.data.list.length == 0) {
                karate.call('this:Create.feature@CreateHotStandardForStake')
                var newCreadtedVault = karate.call(svc + 'Vault.feature@GetListVault_v2', {searchText: testData.standardHotVaultForStake, isShowSignificanceOnly: true})
                return newCreadtedVault.response.data.list[0].id
            }
            else {
                return response.data.list[0].id
            }
        }
    """
    * def vaultId =  getVal()
    * fileUtils.addData('vaultCreateStake',response.data.list[0].id)

    @Get_standardColdVaultForUpdateStake
  Scenario: Get standardColdVaultForUpdateStake
    * call read(svc + 'Vault.feature@GetListVault_v2') {searchText: '#(testData.standardColdVaultForUpdateStake)', isShowSignificanceOnly: true}
    * def getVal = 
    """
        function(){
            if (response.data.list.length == 0) {
                karate.call('this:Create.feature@CreateColdStandardForStake')
                var newCreadtedVault = karate.call(svc + 'Vault.feature@GetListVault_v2', {searchText: testData.standardColdVaultForUpdateStake, isShowSignificanceOnly: true})
                return newCreadtedVault.response.data.list[0].id
            }
            else {
                return response.data.list[0].id
            }
        }
    """
    * def vaultId =  getVal()
    * print response
    * fileUtils.addData('vaultUpdateStake',response.data.list[0].id)

    @Get_advanceHotVault
  Scenario: Get advanceHotVault
    * call read(svc + 'Vault.feature@GetListVault_v2') {searchText: '#(testData.advanceHotVault)', isShowSignificanceOnly: true}
    * def getVal = 
    """
        function(){
            if (response.data.list.length == 0) {
                karate.call('this:Create.feature@CreateHotAdvanceVault')
                var newCreadtedVault = karate.call(svc + 'Vault.feature@GetListVault_v2', {searchText: testData.standardColdVaultForUpdateStake, isShowSignificanceOnly: true})
                return newCreadtedVault.response.data.list[0].id
            }
            else {
                return response.data.list[0].id
            }
        }
    """
    * def vaultId =  getVal()
    * fileUtils.addData('advanceHotVaultId',response.data.list[0].id)

    @Get_advanceColdVault
  Scenario: Get advanceColdVault
    * call read(svc + 'Vault.feature@GetListVault_v2') {searchText: '#(testData.advanceColdVault)', isShowSignificanceOnly: true}
    * def getVal = 
    """
        function(){
            if (response.data.list.length == 0) {
                karate.call('this:Create.feature@CreateColdAdvanceVault')
                var newCreadtedVault = karate.call(svc + 'Vault.feature@GetListVault_v2', {searchText: testData.advanceColdVault, isShowSignificanceOnly: true})
                return newCreadtedVault.response.data.list[0].id
            }
            else {
                return response.data.list[0].id
            }
        }
    """
        * def vaultId =  getVal()
        * fileUtils.addData('advanceColdVaultId',vaultId)

    @Get_advanceHotVaultForStake
  Scenario: Get advanceHotVaultForStake
    * call read(svc + 'Vault.feature@GetListVault_v2') {searchText: '#(testData.advanceHotVaultForStake)', isShowSignificanceOnly: true}
    * def getVal = 
    """
        function(){
            if (response.data.list.length == 0) {
                karate.call('this:Create.feature@CreateHotAdvanceVaultForStake')
                var newCreadtedVault = karate.call(svc + 'Vault.feature@GetListVault_v2', {searchText: testData.advanceHotVaultForStake, isShowSignificanceOnly: true})
                return newCreadtedVault.response.data.list[0].id
            }
            else {
                return response.data.list[0].id
            }
        }
    """
    * def vaultId =  getVal()
    * fileUtils.addData('advanceHotVaultForStakeId',vaultId)

    @Get_skipHotVault
  Scenario: Get skipHotVault
    * call read(svc + 'Vault.feature@GetListVault_v2') {searchText: '#(testData.skipHotVault)', isShowSignificanceOnly: true}
    * def getVal = 
    """
        function(){
            if (response.data.list.length == 0) {
                karate.call('this:Create.feature@CreateHotSkipVault')
                var newCreadtedVault = karate.call(svc + 'Vault.feature@GetListVault_v2', {searchText: testData.skipHotVault, isShowSignificanceOnly: true})
                return newCreadtedVault.response.data.list[0].id
            }
            else {
                return response.data.list[0].id
            }
        }
    """
    * def vaultId =  getVal()
    * fileUtils.addData('skipHotVaultId',vaultId)

    @Get_skipColdVault
  Scenario: Get skipColdVault
    * call read(svc + 'Vault.feature@GetListVault_v2') {searchText: '#(testData.skipColdVault)', isShowSignificanceOnly: true}
    * def getVal = 
    """
        function(){
            if (response.data.list.length == 0) {
                karate.call('this:Create.feature@CreateColdSkipVault')
                var newCreadtedVault = karate.call(svc + 'Vault.feature@GetListVault_v2', {searchText: testData.skipColdVault, isShowSignificanceOnly: true})
                return newCreadtedVault.response.data.list[0].id
            }
            else {
                return response.data.list[0].id
            }
        }
    """
    * def vaultId =  getVal()
    * fileUtils.addData('skipColdVaultId',vaultId)

    @Get_externalWhitelist
  Scenario: Get externalWhitelist
    * call read(svc + 'Whitelist.feature@GetWhitelistFolders') {keyword: '#(testData.externalWhitelist)'}
    * def getVal = 
    """
        function(){
            if (response.data.folders.length == 0) {
                karate.call('this:Create.feature@CreateExternalWhitelistFolder')
                var newCreadtedFolder = karate.call(svc + 'Whitelist.feature@GetWhitelist', {keyword: testData.externalWhitelist})
                return newCreadtedFolder.response.data.folders[0].id
            }
            else {
                return response.data.folders[0].id
            } 
        }
    """
    * def folderId =  getVal()
    * fileUtils.addData('externalId',folderId)

    @Get_networkprofile
  Scenario: Get network profile
    * call read(svc + 'Network.feature@GetNetworkList') {keyword: '#(testData.networkVault)'}
    * def getVal = 
    """
        function(){
            if (response.data.networks.length == 0) {
                karate.call('this:Create.feature@CreateNetworking')
                var newCreadtedProfile = karate.call(svc + 'Network.feature@GetNetworkList', {keyword: testData.networkVault})
                return newCreadtedProfile.response.data.networks[0].id
            }
            else {
                return response.data.networks[0].id
            } 
        }
    """
    * def networkId =  getVal()
    * fileUtils.addData('networkID',networkId)

    @Get_tokenId
  Scenario: Get XRP token id
    * call read(svc + 'Wallet.feature@GetWalletTransferTokens') {keyword: #(testData.tokenId)}
    * fileUtils.addData('tokenId',response.data.tokens[0].id)

    @Get_stakeToken
  Scenario: Get ADA token id
    * call read(svc + 'Wallet.feature@GetWalletTransferTokens') {keyword: #(testData.stakeToken)}
    * fileUtils.addData('stakeToken',response.data.tokens[0].id)

    @Get_connectionID
  Scenario: Get connection id
    # 1. Get network profile
    * call read(svc + 'Network.feature@GetNetworkList') {keyword: '#(testData.networkVault)'}
    * def networkId = response.data.networks[0].id
    
    # 2. Get connection id
    * call read(svc + 'Network.feature@GetNetworkConnection') {networkId: '#(networkId)'}
    * fileUtils.addData('connectionID',response.data.networkConnections[0].id) 

    @Get_address
  Scenario: Get address
    # 1. Get a vault
    * call read(svc + 'Vault.feature@GetListVault_v2') {searchText: '#(testData.standardWarmVault_1)', isShowSignificanceOnly: true}
    * def vaultId = response.data.list[0].id

    # 2. Get wallet
    * call read(svc + 'Wallet.feature@GetWallets') {vaultId: '#(vaultId)', tokenSymbol: '#(testData.tokenId)'}
    * def walletId = response.data.wallets[0].id
    
    # 3. Get wallet address
    * call read(svc + 'Wallet.feature@GetWalletAddress') {vaultId: '#(vaultId)', walletId:'#(walletId)'}
    * fileUtils.addData('address',response.data.address[0].address) 

    @Get_advVaultWithAllUsers
  Scenario: Get advVaultWithAllUsers
    * call read(svc + 'Vault.feature@GetListVault_v2') {searchText: '#(testData.advVaultWithAllUsers)', isShowSignificanceOnly: true}
    * def getVal = 
    """
        function(){
            if (response.data.list.length == 0) {
                karate.call('this:Create.feature@CreateAdvanceVaultWithUsers')
                var newCreadtedVault = karate.call(svc + 'Vault.feature@GetListVault_v2', {searchText: testData.advVaultWithAllUsers, isShowSignificanceOnly: true})
                return newCreadtedVault.response.data.list[0].id
            }
            else {
                return response.data.list[0].id
            }
        }
    """
    * def vaultId =  getVal()
    * fileUtils.addData('advVaultWithAllUsers',vaultId)

    @Get_advVaultWithAllGroups
  Scenario: Get Advance Vault With Groups
    * call read(svc + 'Vault.feature@GetListVault_v2') {searchText: '#(testData.advVaultWithAllGroups)', isShowSignificanceOnly: true}
    * def getVal = 
    """
      function(){
          if (response.data.list.length == 0) {
              karate.call('this:Create.feature@CreateAdvanceVaultWithGroups')
              var newCreadtedVault = karate.call(svc + 'Vault.feature@GetListVault_v2', {searchText: testData.advVaultWithAllGroups, isShowSignificanceOnly: true})
              return newCreadtedVault.response.data.list[0].id
          }
          else {
              return response.data.list[0].id
          }
      }
    """
    * def vaultId =  getVal()
    * print response
    * fileUtils.addData('advVaultWithAllGroups',vaultId)

    @Get_advVaultWithAllGroupsAndUsers
  Scenario: Get Advance Vault With Groups and Users
    * call read(svc + 'Vault.feature@GetListVault_v2') {searchText: '#(testData.advVaultWithAllGroupsAndUsers)', isShowSignificanceOnly: true}
    * def getVal = 
    """
    function(){
        if (response.data.list.length == 0) {
            karate.call('this:Create.feature@CreateAdvanceVaultWithGroupsAndUsers')
            var newCreadtedVault = karate.call(svc + 'Vault.feature@GetListVault_v2', {searchText: testData.advVaultWithAllGroupsAndUsers, isShowSignificanceOnly: true})
            return newCreadtedVault.response.data.list[0].id
        }
        else {
            return response.data.list[0].id
        }
    }
    """
    * def vaultId =  getVal()
    * fileUtils.addData('advVaultWithAllGroupsAndUsers',vaultId)

    @Get_standardForEditPolicy
    Scenario: Get Advance Vault With Groups and Users
    * call read(svc + 'Vault.feature@GetListVault_v2') {searchText: '#(testData.standardForEditPolicy)', isShowSignificanceOnly: true}
    * def getVal = 
    """
    function(){
        if (response.data.list.length == 0) {
            karate.call('this:Create.feature@CreateStandardVaultForEditPolicy')
            var newCreadtedVault = karate.call(svc + 'Vault.feature@GetListVault_v2', {searchText: testData.standardForEditPolicy, isShowSignificanceOnly: true})
            return newCreadtedVault.response.data.list[0].id
        }
        else {
            return response.data.list[0].id
        }
    }
    """
    * def vaultId =  getVal()
    * fileUtils.addData('standardVaultForEditPolicy',vaultId)

    @Get_standardForEditPolicy
    Scenario: Get Advance Vault With Groups and Users
    * call read(svc + 'Vault.feature@GetListVault_v2') {searchText: '#(testData.skipVaultForAddPolicy)', isShowSignificanceOnly: true}
    * def getVal = 
    """
    function(){
        if (response.data.list.length == 0) {
            karate.call('this:Create.feature@CreateSkipVaultForAddPolicy')
            var newCreadtedVault = karate.call(svc + 'Vault.feature@GetListVault_v2', {searchText: testData.skipVaultForAddPolicy, isShowSignificanceOnly: true})
            return newCreadtedVault.response.data.list[0].id
        }
        else {
            return response.data.list[0].id
        }
    }
    """
    * def vaultId =  getVal()
    * fileUtils.addData('skipVaultForAddPolicy',vaultId)

    @Get_standardVaultForEditPolicyAndApprove
    Scenario: Get Advance Vault With Groups and Users
    * call read(svc + 'Vault.feature@GetAllVaults') {keyword: '#(testData.standardVaultForEditPolicy2)'}
    * def getVal = 
    """
    function(){
        if (response.data.vaults.length == 0) {
            karate.call('this:Create.feature@CreateStandardVaultForEditPolicyAndApprove')
            var newCreadtedVault = karate.call(svc + 'Vault.feature@GetAllVaults', {keyword: testData.skipVaultForAddPolicy2})
            return newCreadtedVault.response.data.vaults[0].id
        }
        else {
            return response.data.vaults[0].id
        }
    }
    """
    * def vaultId =  getVal()
    * fileUtils.addData('standardVaultForEditPolicy2',vaultId)
