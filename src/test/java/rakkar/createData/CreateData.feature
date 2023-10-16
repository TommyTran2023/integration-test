@CreateData
Feature: Create data
    
  Background:
    * def svc = "classpath:services/"
    * callonce read(svc + 'ReadData.feature@ReadDataFile')
    * callonce read(svc + 'ReadData.feature@ReadEnumFile')
    * callonce read(svc + 'Auth.feature@GetRequesterInfo')
    * callonce read(svc + 'Auth.feature@GetAllUsers')
    * def str_random = ' 100030'
    * def getQuorumList = 
    """
        function(){
            var list = new Array()
            list.push(karate.jsonPath(allUsers, "$..[?(@.username == '"+requesterInfo.requesterUsername+"')]")[0])
            list.push(karate.jsonPath(allUsers, "$..[?(@.username == '"+adminUsername+"')]")[0])
            list.push(karate.jsonPath(allUsers, "$..[?(@.username == '"+approverInfo.approvalUsername+"')]")[0])
            list.push(karate.jsonPath(allUsers, "$..[?(@.username == '"+adminUsername2+"')]")[0])

            list.forEach(function(item){
                item.type = "user"
            })

            karate.set('quorumList', list)
        }
    """ 
#-----------------Standard Vault-----------------#
    @CreateStandardVault @ignore
    Scenario: Create Standard Vault
        * call read(svc + 'Biometric.feature@RequesterDoBiometric')
        * def requestBody = 
        """
            {
                "memberRequiredApprove":[],
                "name":"#(name + str_random)",
                "hasRequiredApprover":false,
                "memberIds":[#(requesterID),#(approvalUserID),#(adminUserID)],
                "type":'#(type)',
                "approverNumber": 3,
                "note":"AT Create Test Data"
            }
        """
        * print requestBody
        * call read(svc + 'Vault.feature@CreateVault') {requestBody: '#(requestBody)', challengeAnswerRequest: '#(challengeAnswerRequest)', passcode: '#(requesterInfo.requesterPasscode)'}
        Then match responseStatus == 201
        And match response.status == 'success'

    @CreateHotStandard1
    Scenario: Create Hot Vault 'AT - Warm Standard Vault 1'
        * call read('CreateData.feature@CreateStandardVault') {name: #(testData.standardWarmVault_1), type: #(Const.VaultType.HOT_WALLET)}

    @CreateHotStandard2
    Scenario: Create Hot Vault 'AT - Warm Standard Vault 2'
        * call read('CreateData.feature@CreateStandardVault') {name: #(testData.standardWarmVault_2), type: #(Const.VaultType.HOT_WALLET)}

    @CreateColdStandard1
    Scenario: Create Hot Vault 'AT - Cold Standard Vault 1'
        * call read('CreateData.feature@CreateStandardVault') {name: #(testData.standardColdVault_1), type: #(Const.VaultType.COLD_WALLET)}

    @CreateColdStandard2
    Scenario: Create Hot Vault 'AT - Cold Standard Vault 2'
        * call read('CreateData.feature@CreateStandardVault') {name: #(testData.standardColdVault_2), type: #(Const.VaultType.COLD_WALLET)}

    @CreateHotStandardForStake
    Scenario: Create Hot Vault 'AT - Standard Vault for Stake'
        * call read('CreateData.feature@CreateStandardVault') {name: #(testData.standardHotVaultForStake), type: #(Const.VaultType.HOT_WALLET)}

    @CreateColdStandardForStake
    Scenario: Create Hot Vault 'AT - Standard Vault for Update Stake'
        * call read('CreateData.feature@CreateStandardVault') {name: #(testData.standardColdVaultForUpdateStake), type: #(Const.VaultType.COLD_WALLET)}

#-----------------Advance Vault-----------------#
    @CreateAdvanceVault @ignore
    Scenario: Create Hot Advance Vault
    # 1. Submit create advance vault from web
        * call getQuorumList
        * print quorumList
        * def requestBody =
        """
        {
            "name":"#(name + str_random)",
            "approverNumber":2,
            "type":"#(type)",
            "clientId":"#(testData.clientId)",
            "quorums":[{
                "members":[ "#(quorumList[0])","#(quorumList[1])" ],
                "quorumApprovals":1,
                "isRequired":false
            },
            {
                "members":[ "#(quorumList[2])","#(quorumList[3])" ],
                "quorumApprovals":1,
                "isRequired":false
            }],
            "policyType":"#(Const.VaultPolicyType.ADVANCED)",
        }
        """
        * print requestBody
        * call read(svc + 'Vault.feature@RequestCreateAdvVault') {requestBody: '#(requestBody)', challengeAnswerRequest: '#(challengeAnswerRequest)', passcode: '#(requesterInfo.requesterPasscode)'}
        Then match responseStatus == 201
        And match response.status == 'success'
        * def notificationId = response.data.notificationId

    # 3. Submit request
        * call read(svc + 'Biometric.feature@RequesterDoBiometric')
        * call read(svc + 'Vault.feature@SubmitCreateAdvVault') {notificationId:'#(notificationId)'}
        Then match responseStatus == 201
        And match response.status == 'success'

    # 4. View vault detail to get requestId
        * call read(svc + 'Vault.feature@GetVaultDetail') {vaultId: '#(response.data.vaultId)'}
        Then match responseStatus == 200
        And match response.status == 'success'

    # 5. Approve request
        * call read('CreateData.feature@ApproveRequest') {requestId: #(response.data.requestId)}
        

    @CreateHotAdvanceVault
    Scenario: Create Cold Advance Vault AT - Hot Advance Vault 1
        * call read('CreateData.feature@CreateAdvanceVault') {name: #(testData.advanceHotVaultId), type: #(Const.VaultType.HOT_WALLET)}
    
    @CreateColdAdvanceVault
    Scenario: Create Cold Advance Vault AT - Cold Advance Vault 1
        * call read('CreateData.feature@CreateAdvanceVault') {name: #(testData.advanceColdVaultId), type: #(Const.VaultType.COLD_WALLET)}
        
    @CreateHotAdvanceVaultForStake
    Scenario: Create AT - Warm Advance Vault for Stake
        * call read('CreateData.feature@CreateAdvanceVault') {name: #(testData.advanceHotVaultForStakeId), type: #(Const.VaultType.HOT_WALLET)}
    
#-----------------Skip Vault-----------------#
    @CreateSkipVault @ignore
    Scenario: Create Skip Vault
        * call read(svc + 'Biometric.feature@RequesterDoBiometric')
        * def requestBody = 
        """
            {
                "memberRequiredApprove":[],
                "name":"#(name + str_random)",
                "hasRequiredApprover":false,
                "memberIds":[#(requesterID),#(approvalUserID),#(adminUserID)],
                "type":'#(type)',
                "approverNumber": 0,
                "note":"AT Create Test Data"
            }
        """
        * print requestBody
        * call read(svc + 'Vault.feature@CreateVault') {requestBody: '#(requestBody)', challengeAnswerRequest: '#(challengeAnswerRequest)', passcode: '#(requesterInfo.requesterPasscode)'}
        Then match responseStatus == 201
        And match response.status == 'success'

    @CreateHotSkipVault
    Scenario: Create Hot Skip Vault
        * call read('CreateData.feature@CreateSkipVault') {name: #(testData.skipHotVaultId), type: #(Const.VaultType.HOT_WALLET)}

    @CreateColdSkipVault
    Scenario: Create Cold Skip Vault
        * call read('CreateData.feature@CreateSkipVault') {name: #(testData.skipColdVaultId), type: #(Const.VaultType.COLD_WALLET)}

    @ApproveRequest @ignore
    Scenario: Approve Request    
        * call read(svc + 'Biometric.feature@ApproverDoBiometric')
        * call read(svc + 'AdvanceQuorum.feature@ApproveRequest') {requestId: #(requestId)}
        Then match responseStatus == 201
        And match response.status == 'success'


