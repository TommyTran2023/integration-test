@Create @ignore
Feature: Create Vault data
    
  Background:
    * def svc = "classpath:services/"
    * callonce read(svc + 'ReadData.feature@ReadDataFile')
    * callonce read(svc + 'ReadData.feature@ReadEnumFile')
    * callonce read(svc + 'Auth.feature@GetRequesterInfo')
    * callonce read(svc + 'Auth.feature@GetListUsers')
    * def str_random = ' 100082'
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
    # 1. Create standard vault
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
        * def vaultId = response.data.id

    # 2. View vault detail to get requestId
        * call read(svc + 'Vault.feature@GetVaultDetail') {vaultId: '#(vaultId)'}
        Then match responseStatus == 200
        And match response.status == 'success'
    
    # 3. Approve request
        * call read('this:Create.feature@ApproveRequest') {requestId: #(response.data.requestId)}
    
    # 4. Add XRP Asset To Vault
        * call read('this:Create.feature@AddAsset') {symbol:'#(Const.Symbol.XRP)', vaultId: '#(vaultId)'}
    
    # 5. Deposit XRP to Vault
        * call read('this:Create.feature@DepositXRP') {vaultId: '#(vaultId)'}

    @CreateHotStandard1
    Scenario: Create Hot Vault 'AT - Warm Standard Vault 1'
        * call read('Create.feature@CreateStandardVault') {name: #(testData.standardWarmVault_1), type: #(Const.VaultType.HOT_WALLET)}

    @CreateHotStandard2
    Scenario: Create Hot Vault 'AT - Warm Standard Vault 2'
        * call read('Create.feature@CreateStandardVault') {name: #(testData.standardWarmVault_2), type: #(Const.VaultType.HOT_WALLET)}

    @CreateColdStandard1
    Scenario: Create Hot Vault 'AT - Cold Standard Vault 1'
        * call read('Create.feature@CreateStandardVault') {name: #(testData.standardColdVault_1), type: #(Const.VaultType.COLD_WALLET)}

    @CreateColdStandard2
    Scenario: Create Hot Vault 'AT - Cold Standard Vault 2'
        * call read('Create.feature@CreateStandardVault') {name: #(testData.standardColdVault_2), type: #(Const.VaultType.COLD_WALLET)}

    @CreateHotStandardForStake
    Scenario: Create Hot Vault 'AT - Standard Vault for Stake'
        * call read('Create.feature@CreateStandardVault') {name: #(testData.standardHotVaultForStake), type: #(Const.VaultType.HOT_WALLET)}
        # Add ADA Asset To Vault
        * call read('Create.feature@AddAsset') {symbol:#(Const.Symbol.ADA), vaultId: '#(vaultId)'}
    
    @CreateColdStandardForStake
    Scenario: Create Hot Vault 'AT - Standard Vault for Update Stake'
        * call read('Create.feature@CreateStandardVault') {name: #(testData.standardColdVaultForUpdateStake), type: #(Const.VaultType.COLD_WALLET)}
        # Add ADA Asset To Vault
        * call read('Create.feature@AddAsset') {symbol:#(Const.Symbol.ADA), vaultId: '#(vaultId)'}
    
#-----------------Advance Vault-----------------#
    @CreateAdvanceVault @ignore
    Scenario: Create Advance Vault
    # 1. Submit create advance vault from web
        * call getQuorumList
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
        * call read(svc + 'Vault.feature@RequestCreateAdvVault') {requestBody: '#(requestBody)', challengeAnswerRequest: '#(challengeAnswerRequest)', passcode: '#(requesterInfo.requesterPasscode)'}
        Then match responseStatus == 201
        And match response.status == 'success'
        * def notificationId = response.data.notificationId

    # 3. Submit request
        * call read(svc + 'Biometric.feature@RequesterDoBiometric')
        * call read(svc + 'Vault.feature@SubmitCreateAdvVault') {notificationId:'#(notificationId)'}
        Then match responseStatus == 201
        And match response.status == 'success'
        * def vaultId = response.data.vaultId

    # 4. View vault detail to get requestId
        * call read(svc + 'Vault.feature@GetVaultDetail') {vaultId: '#(vaultId)'}
        Then match responseStatus == 200
        And match response.status == 'success'

    # 5. Approve request
        * call read('Create.feature@ApproveRequest') {requestId: #(response.data.requestId)} 

    # 6. Add XRP Asset To Vault
        * call read('Create.feature@AddAsset') {symbol:#(Const.Symbol.XRP), vaultId: '#(vaultId)'}

    # 7. Deposit XRP to Vault
        * call read('this:Create.feature@DepositXRP') {vaultId: '#(vaultId)'}
        

    @CreateHotAdvanceVault
    Scenario: Create Cold Advance Vault AT - Hot Advance Vault 1
        * call read('Create.feature@CreateAdvanceVault') {name: #(testData.advanceHotVault), type: #(Const.VaultType.HOT_WALLET)}
    
    @CreateColdAdvanceVault
    Scenario: Create Cold Advance Vault AT - Cold Advance Vault 1
        * call read('Create.feature@CreateAdvanceVault') {name: #(testData.advanceColdVault), type: #(Const.VaultType.COLD_WALLET)}
        
    @CreateHotAdvanceVaultForStake
    Scenario: Create AT - Warm Advance Vault for Stake
        * call read('Create.feature@CreateAdvanceVault') {name: #(testData.advanceHotVaultForStake), type: #(Const.VaultType.HOT_WALLET)}
        
        # Add ADA Asset To Vault
        * call read('Create.feature@AddAsset') {symbol:#(Const.Symbol.ADA), vaultId: '#(vaultId)'}
    
#-----------------Skip Vault-----------------#
    @CreateSkipVault @ignore
    Scenario: Create Skip Vault
    # 1. Create skip vault
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
        * call read(svc + 'Vault.feature@CreateVault') {requestBody: '#(requestBody)', challengeAnswerRequest: '#(challengeAnswerRequest)', passcode: '#(requesterInfo.requesterPasscode)'}
        Then match responseStatus == 201
        And match response.status == 'success'
        * def vaultId = response.data.id

    # 2. Add XRP Asset To Vault
        * call read('Create.feature@AddAsset') {symbol:'#(Const.Symbol.XRP)', vaultId: '#(vaultId)'}
    
    # 3. Deposit XRP to Vault
        * call read('this:Create.feature@DepositXRP') {vaultId: '#(vaultId)'}

    @CreateHotSkipVault
    Scenario: Create Hot Skip Vault
        * call read('Create.feature@CreateSkipVault') {name: #(testData.skipHotVault), type: #(Const.VaultType.HOT_WALLET)}

    @CreateColdSkipVault
    Scenario: Create Cold Skip Vault
        * call read('Create.feature@CreateSkipVault') {name: #(testData.skipColdVault), type: #(Const.VaultType.COLD_WALLET)}

    @ignore @ApproveRequest 
    Scenario: Approve Request    
        * call read(svc + 'Biometric.feature@ApproverDoBiometric')
        * call read(svc + 'AdvanceQuorum.feature@ApproveRequest') {requestId: #(requestId)}

    @ignore @AddAsset
    Scenario: Add Testnet For Vault
    # 1. Get token 
        * call read('this:Create.feature@GetToken') {keyword: #(symbol)}

    # 2. Add XRP asset to Vault
        * call read(svc + 'Wallet.feature@AddAssets') {tokenIds: '#(token.id)', vaultId: '#(vaultId)'}
        Then match responseStatus == 201

    # 3. Get wallet address
        * eval java.lang.Thread.sleep(1000)
        * def walletId = response.data.success[0].id
        * call read(svc + 'Wallet.feature@GetWalletAddress') {vaultId: '#(vaultId)', walletId: '#(walletId)'}
        Then match responseStatus == 200
        * def address = response.data.address[0].address

    @ignore @DepositXRP
    Scenario: Deposit XRP to Vault
        * call read(svc + 'testnet.feature@DepositXRP') {address: '#(address)'}
        Then match responseStatus == 200

    @ignore @DepositADA
    Scenario: Deposit ADA to Vault
        * call read(svc + 'testnet.feature@DepositADA') {address: '#(address)'}
        Then match responseStatus == 200

    @ignore @GetToken
    Scenario: Get Token
        * call read(svc + 'Wallet.feature@GetWalletTransferTokens') {keyword:'#(keyword)'}
        Then match responseStatus == 200
        And match response.status == 'success'
        * def token = karate.jsonPath(response.data.tokens, "$..[?(@.symbol == '"+keyword+"')]")[0]    

    @CreateExternalWhitelistFolder
    Scenario: Create External Whitelist Folder
    # Pre. Get token 
        * call read('this:Create.feature@GetToken') {keyword: #(Const.Symbol.XRP)}

    # 1. Add whitelist folder
        * def name = testData.externalWhitelist + str_random + '5'
        * call read(svc + 'Whitelist.feature@CreateWhitelist') {name:'#(name)', type:#(Const.WhitelistType.EXTERNAL)}
        Then match responseStatus == 201
        * def folderId = response.data.id
    
    # 2. Add whitelist address (get from step 1)
        * call read(svc + 'Biometric.feature@RequesterDoBiometric')
        * call read(svc + 'Whitelist.feature@AddWhitelistAddress') {folderId:#(folderId), tokenId: #(token.id), note: 'AT Hot External Whitelist', address:#(testData.crossTenant.externalAddress)}
        Then match responseStatus == 201

    # 3. Get request Id
        * call read(svc + 'Biometric.feature@ApproverDoBiometric')
        * call read(svc + 'AdvanceQuorum.feature@Approver_GetApprovalList') {status:[#(Const.ApprovalStatus.PENDING)]}
        * def requestId = karate.jsonPath(response.data.records, "$..[?(@.displayName == '"+testData.externalAddress+"')]")[0].id
        
    # 4. Approve request
        * call read('Create.feature@ApproveRequest') {requestId: #(requestId)}

    @CreateNetworking
    Scenario: Create Networking
        # 1. Routing Setup - Get deposit routing
        * call read(svc + 'Vault.feature@GetAllVaults') {keyword: '#(testData.networkVault)'}
        * if (response.data.vaults.length == 0) karate.call('Create.feature@CreateStandardVault',{name: testData.networkVault,type: Const.VaultType.HOT_WALLET})
        * call read(svc + 'Vault.feature@GetDepositRouting') {keyword:'#(testData.networkVault)'}
        * def vault = response.data.vaults[0]
        
        # 2. Create network
        * call read(svc + 'Biometric.feature@RequesterDoBiometric')
        * call read(svc + 'Network.feature@CreateNetworkProfile') {profileName:'#(testData.networkVault + str_random)', vaultId:'#(vault.id)'}
        Then match responseStatus == 201
        * def profileId = response.data.id
        
        # 3. Get discovery network
        * call read(svc + 'Network.feature@GetDiscoverableNetwork') {keyword:'Rakkar', profileId:'#(profileId)', vaultId:'#(vaultId)'}
        * def counter = response.data.counterParties[0]
            
        # 4. Add connection
        * call read(svc + 'Biometric.feature@RequesterDoBiometric')
        * call read(svc + 'Network.feature@AddNetworkConnection') {profileId:'#(profileId)',vaultId:'#(vaultId)',counterId:'#(counter.id)', counterName:'#(counter.name)', vaultId:'#(vault.id)', vaultName:'#(vault.name)'}

        # 5. Get request to connect
        * call read(svc + 'Biometric.feature@ApproverDoBiometric')
        * call read(svc + 'AdvanceQuorum.feature@Approver_GetApprovalList') {status:[#(Const.ApprovalStatus.PENDING)]}
        * def requestId = karate.jsonPath(response.data.records, "$..[?(@.type.value == '"+Const.QuorumDataType.CREATE_NETWORK_CONNECTION+"')]")[0].id

        # 6. Approve request to connect
        * call read('Create.feature@ApproveRequest') {requestId: #(requestId)}
    

        
        

