@parallel=false
Feature: Get Data From data.json
Background:
    * callonce read(svc + 'ReadData.feature@ReadDataFile')
    * callonce read(svc + 'Auth.feature@GetRequesterInfo')
    * configure afterFeature = function(){ karate.call('WriteDataFile.feature'); }

@Get_standardWarmVault_1
Scenario: Get standardWarmVault_1
    * call read(svc + 'Vault.feature@GetAllVaults') {keyword: '#(testData.standardWarmVault_1)'}
    * def getVal = 
    """
        function(){
            if (response.data.vaults.length == 0) {
                karate.call('Create.feature@CreateHotStandard1')
                var newCreadtedVault = karate.call(svc + 'Vault.feature@GetAllVaults', {keyword: testData.standardWarmVault_1})
                return newCreadtedVault.response.data.vaults[0].id
            }
            else {
                return response.data.vaults[0].id
            }
        }
    """
    * def vaultId =  getVal()
    * fileUtils.addData('standardWarmVault_1', vaultId)

@Get_standardWarmVault_2
Scenario: Get standardWarmVault_2
    * call read(svc + 'Vault.feature@GetAllVaults') {keyword: '#(testData.standardWarmVault_2)'}
    * def getVal = 
    """
        function(){
            if (response.data.vaults.length == 0) {
                karate.call('Create.feature@CreateHotStandard2')
                var newCreadtedVault = karate.call(svc + 'Vault.feature@GetAllVaults', {keyword: testData.standardWarmVault_2})
                return newCreadtedVault.response.data.vaults[0].id
            }
            else {
                return response.data.vaults[0].id
            }
        }
    """
    * def vaultId =  getVal()
    * fileUtils.addData('standardWarmVault_2',response.data.vaults[0].id)

@Get_standardColdVault_1
Scenario: Get standardColdVault_1
    * call read(svc + 'Vault.feature@GetAllVaults') {keyword: '#(testData.standardColdVault_1)'}
    * def getVal = 
    """
        function(){
            if (response.data.vaults.length == 0) {
                karate.call('Create.feature@CreateColdStandard1')
                var newCreadtedVault = karate.call(svc + 'Vault.feature@GetAllVaults', {keyword: testData.standardColdVault_1})
                return newCreadtedVault.response.data.vaults[0].id
            }
            else {
                return response.data.vaults[0].id
            }
        }
    """
    * def vaultId =  getVal()
    * fileUtils.addData('standardColdVault_1',response.data.vaults[0].id)

@Get_standardColdVault_2
Scenario: Get standardColdVault_2
    * call read(svc + 'Vault.feature@GetAllVaults') {keyword: '#(testData.standardColdVault_2)'}
    * def getVal = 
    """
        function(){
            if (response.data.vaults.length == 0) {
                karate.call('Create.feature@CreateColdStandard2')
                var newCreadtedVault = karate.call(svc + 'Vault.feature@GetAllVaults', {keyword: testData.standardColdVault_2})
                return newCreadtedVault.response.data.vaults[0].id
            }
            else {
                return response.data.vaults[0].id
            }
        }
    """
    * def vaultId =  getVal()
    * fileUtils.addData('standardColdVault_2',response.data.vaults[0].id)

@Get_standardHotVaultForStake
Scenario: Get standardHotVaultForStake
    * call read(svc + 'Vault.feature@GetAllVaults') {keyword: '#(testData.standardHotVaultForStake)'}
    * def getVal = 
    """
        function(){
            if (response.data.vaults.length == 0) {
                karate.call('Create.feature@CreateHotStandardForStake')
                var newCreadtedVault = karate.call(svc + 'Vault.feature@GetAllVaults', {keyword: testData.standardHotVaultForStake})
                return newCreadtedVault.response.data.vaults[0].id
            }
            else {
                return response.data.vaults[0].id
            }
        }
    """
    * def vaultId =  getVal()
    * fileUtils.addData('standardHotVaultForStake',response.data.vaults[0].id)

@Get_standardColdVaultForUpdateStake
Scenario: Get standardColdVaultForUpdateStake
    * call read(svc + 'Vault.feature@GetAllVaults') {keyword: '#(testData.standardColdVaultForUpdateStake)'}
    * def getVal = 
    """
        function(){
            if (response.data.vaults.length == 0) {
                karate.call('Create.feature@CreateColdStandardForStake')
                var newCreadtedVault = karate.call(svc + 'Vault.feature@GetAllVaults', {keyword: testData.standardColdVaultForUpdateStake})
                return newCreadtedVault.response.data.vaults[0].id
            }
            else {
                return response.data.vaults[0].id
            }
        }
    """
    * def vaultId =  getVal()
    * fileUtils.addData('standardColdVaultForUpdateStake',response.data.vaults[0].id)

@Get_advanceHotVault
Scenario: Get advanceHotVault
    * call read(svc + 'Vault.feature@GetAllVaults') {keyword: '#(testData.advanceHotVault)'}
    * def getVal = 
    """
        function(){
            if (response.data.vaults.length == 0) {
                karate.call('Create.feature@CreateHotAdvanceVault')
                var newCreadtedVault = karate.call(svc + 'Vault.feature@GetAllVaults', {keyword: testData.standardColdVaultForUpdateStake})
                return newCreadtedVault.response.data.vaults[0].id
            }
            else {
                return response.data.vaults[0].id
            }
        }
    """
    * def vaultId =  getVal()
    * fileUtils.addData('advanceHotVault',response.data.vaults[0].id)

@Get_advanceColdVault
Scenario: Get advanceColdVault
    * call read(svc + 'Vault.feature@GetAllVaults') {keyword: '#(testData.advanceColdVault)'}
    * def getVal = 
    """
        function(){
            if (response.data.vaults.length == 0) {
                karate.call('Create.feature@CreateColdAdvanceVault')
                var newCreadtedVault = karate.call(svc + 'Vault.feature@GetAllVaults', {keyword: testData.advanceColdVault})
                return newCreadtedVault.response.data.vaults[0].id
            }
            else {
                return response.data.vaults[0].id
            }
        }
    """
        * def vaultId =  getVal()
        * fileUtils.addData('advanceColdVault',vaultId)

@Get_advanceHotVaultForStake
Scenario: Get advanceHotVaultForStake
    * call read(svc + 'Vault.feature@GetAllVaults') {keyword: '#(testData.advanceHotVaultForStake)'}
    * def getVal = 
    """
        function(){
            if (response.data.vaults.length == 0) {
                karate.call('Create.feature@CreateHotAdvanceVaultForStake')
                var newCreadtedVault = karate.call(svc + 'Vault.feature@GetAllVaults', {keyword: testData.advanceHotVaultForStake})
                return newCreadtedVault.response.data.vaults[0].id
            }
            else {
                return response.data.vaults[0].id
            }
        }
    """
    * def vaultId =  getVal()
    * fileUtils.addData('advanceHotVaultForStake',vaultId)

@Get_skipHotVault
Scenario: Get skipHotVault
    * call read(svc + 'Vault.feature@GetAllVaults') {keyword: '#(testData.skipHotVault)'}
    * def getVal = 
    """
        function(){
            if (response.data.vaults.length == 0) {
                karate.call('Create.feature@CreateHotSkipVault')
                var newCreadtedVault = karate.call(svc + 'Vault.feature@GetAllVaults', {keyword: testData.skipHotVault})
                return newCreadtedVault.response.data.vaults[0].id
            }
            else {
                return response.data.vaults[0].id
            }
        }
    """
    * def vaultId =  getVal()
    * fileUtils.addData('skipHotVault',vaultId)

@Get_skipColdVault
Scenario: Get skipColdVault
    * call read(svc + 'Vault.feature@GetAllVaults') {keyword: '#(testData.skipColdVault)'}
    * def getVal = 
    """
        function(){
            if (response.data.vaults.length == 0) {
                karate.call('Create.feature@CreateColdSkipVault')
                var newCreadtedVault = karate.call(svc + 'Vault.feature@GetAllVaults', {keyword: testData.skipColdVault})
                return newCreadtedVault.response.data.vaults[0].id
            }
            else {
                return response.data.vaults[0].id
            }
        }
    """
    * def vaultId =  getVal()
    * fileUtils.addData('skipColdVault',vaultId)

@Get_externalWhitelist
Scenario: Get externalWhitelist
    * call read(svc + 'Whitelist.feature@GetWhitelistFolders') {keyword: '#(testData.externalWhitelist)'}
    * def getVal = 
    """
        function(){
            if (response.data.folders.length == 0) {
                karate.call('Create.feature@CreateExternalWhitelistFolder')
                var newCreadtedFolder = karate.call(svc + 'Whitelist.feature@GetWhitelist', {keyword: testData.externalWhitelist})
                return newCreadtedFolder.response.data.folders[0].id
            }
            else {
                return response.data.folders[0].id
            } 
        }
    """
    * def folderId =  getVal()
    * fileUtils.addData('externalWhitelist',folderId)

@Get_networkprofile
Scenario: Get network profile
    * call read(svc + 'Network.feature@GetNetworkList') {keyword: '#(testData.networkVault)'}
    * def getVal = 
    """
        function(){
            if (response.data.folders.length == 0) {
                karate.call('Create.feature@CreateNetworking')
                var newCreadtedFolder = karate.call(svc + 'Network.feature@GetNetworkList', {keyword: testData.networkVault})
                return newCreadtedFolder.response.data.folders[0].id
            }
            else {
                return response.data.folders[0].id
            } 
        }
    """
    * def folderId =  getVal()
    * fileUtils.addData('externalWhitelist',folderId)



