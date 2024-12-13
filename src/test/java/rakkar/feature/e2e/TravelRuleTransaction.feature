@e2e @TravelRule @TravelRule_e2e
Feature: Travel rule transaction

    Background: Login as SG requester
        * print isRun
        * if (isRun == "false") karate.abort()

        * def env = karate.properties['karate.env']
        * def trData = karate.read('classpath:data/cross_workspace_data.json')
        * def trData = karate.jsonPath(trData, "$.." + env +"_workspace")[0].sg
        * callonce read(svc + 'Auth.feature@GetUserAccessToken') { userName: "#(sg_customer.admin1)" }
        * def accessToken = userAccessToken
        * def amountETH = "0.0001" + (new Date()).getTime().toString().slice(5,10)
        * def commonHandle = read('classpath:rakkar/common/CommonHandle.js')

    @WithdrawDiffVASP
    Scenario Outline: Withdraw Diff VASP - <flowName>
        * def sourceVaultId = "<sourceVaultId>"
        * def destinationFolderId = "<destinationFolderId>"
        * def destinationAddressId = "<destinationAddressId>"
        # 1. _VASP validate-init-transaction
        * def data =
        """
        {
            "transactionAsset": "ETH_TEST5",
            "transactionAmount": "#(amountETH)",
            "source": {
                "type": "VAULT_ID",
                "value": "#(sourceVaultId)"
            },
            "destination": {
                "type": "FOLDER_ID",
                "value": "#(destinationAddressId)"
            }
        }
        """
        * call read(svc + 'TravelRule.feature@POST_core_v2_TravelRule_VASP_validate-init-transaction') data
        Then match responseStatus == 201
        * def travelRuleTransactionID = response.data.travelRuleTransactionID

        # 2. _VASP validate-confirm-transaction
        * def data =
        """
        {
            "travelRuleTransactionID": "#(travelRuleTransactionID)"
        }
        """
        * call read(svc + 'TravelRule.feature@POST_core_v2_TravelRule_VASP_validate-confirm-transaction') data
        Then match responseStatus == 201

        # 3. Submit transaction
        * call read(svc + 'Biometric.feature@UserDoBiometric')
        * def body_transfer = 
        """
        {
            "challengeAnswerRequest": "#(userAnswerApprover)",
            "operation": "TRANSFER",
            "destination": {
                "id": "#(destinationFolderId)",
                "type": "EXTERNAL_WALLET"
            },
            "tokenId": "#(dataSet.eth5TokenId)",
            "amount": "#(amountETH)",
            "treatAsGrossAmount": true,
            "fee": 2.256,
            "source": {
                "type": "VAULT_ACCOUNT",
                "id": "#(sourceVaultId)"
            },
            "feeLevel": "HIGH",
            "totalEstimatedFee": 0.000047375999999999995,
            "feeType": "GWEI",
            "travelRuleTransactionID": "#(travelRuleTransactionID)"
        }
        """
        * call read(svc + 'Transaction.feature@CreateTravelRuleTransaction') body_transfer
        Then match responseStatus == 201
        * def requestId = response.data.requestId
        * def transactionId = response.data.id

        # 4. Approve transaction
        * def approverSG = karate.call(svc + 'Biometric.feature@UserDoBiometric', { userName: sg_customer.admin2} )
        * eval
        """
            var approverIv = sg_customer.admin2UserId.replaceAll('-','').slice(0, 16)
        """
        * def approverPasscode = karate.exec(`node aes.js encrypt ${sg_customer.passcode} ${privateKey.secret} ${approverIv}`);
        * def data = 
        """
        {
            requestId:"#(requestId)",
            approvalAccessToken: "#(approverSG.userAccessToken)",
            challengeAnswerApprover: "#(approverSG.userAnswerApprover)"
        }
        """
        * call read(svc + 'Quorums.feature@ApproveRequest') data

        # 5. Verify transaction detail
        # * call read(svc + 'Transaction.feature@ViewTransactionDetail') {transactionId:"#(transactionId)"}

        # 5. ACCEPT/CANCEL the withdraw from Notebene
        * eval
        """
            java.lang.Thread.sleep(5000); 
            if (notabeneAccept == "true")
                karate.call(svc + 'NotabeneAPI.feature@ApproveLatestTransfer',{ txDirection: "outgoing" }) 
            else
                karate.call(svc + 'NotabeneAPI.feature@CancelLatestTransfer',{ txDirection: "outgoing" }) 
        """

        # 6. Wait until transaction completed
        * def transaction = commonHandle().waitUntilTransactionCompleted(transactionId, null)

        # 7. Validate transaction details from RAK API - from get transaction details
        * def expectedRakObj = 
        """
        {
            "key": "#(expectedKey)",
            "path": "#(expectedPath)",
            "stage": "#(expectedStage)",
            "fbStatus": "#(expectedfbStatus)",
            "hookType": "#(expectedType)",
            "trReason": "#(expectedReason)",
            "trStatus": "#(expectedtrStatus)",
            "REPStatus": "#(expectedRepTxnStatus)",
            "fbSubStatus": "#(expectedfbSubStatus)",
            "unfreezeByAPI": "#present"
        }
        """
        * def expectedAdditionalData = 
        """
        {
            "url": "https://app.notabene.dev",
            "rakObj": "#object",
            "verdict": "#(expectedVerdict)",
            "provider": "NOTABENE",
            "quorumId": "#uuid",
            "rakStatus": "#(expectedRakTxnStatus)",
            "trTypeObjKey": "#(expectedKey)",
            "screeningTime": "#number",
            "rakDescription": "#(expectedReason)",
            "quorumRequestId": "#uuid"
            }
        """
        * match transaction.response.data.additionalData.rakObj == expectedRakObj
        * match transaction.response.data.additionalData == expectedAdditionalData

    Examples:
        |  read('classpath:data/TravelRule_e2e/dev_withdraw.csv')  |
    

    @DepositFromDiffVASP
    Scenario Outline: Deposit Diff VASP - <flowName>
        * def sourceVaultId = "<sourceVaultId>"
        * def destinationFolderId = "<destinationFolderId>"
        * def destinationFolderType = "<destinationFolderType>"

        # 1.1 Withdraw from whitelisted and approve in cross sg customer
        * eval 
        """
            var destEnv = env != 'dev' ? 'dev' : 'test';
            var crossData = karate.read('classpath:data/cross_workspace_data.json')
            crossData = karate.jsonPath(crossData, "$.." + destEnv +"_workspace")[0]
            var destUrl = crossData["url_" + destEnv]
            var crossApproverIv = crossData.sg.userInfo.admin2UserId.replaceAll('-','').slice(0, 16)
        """
        * def destUserBio = karate.call(svc + 'Biometric.feature@UserDoBiometric', { customUrl: destUrl, userName: crossData.sg.userInfo.admin1})
        * def data =
        """
        {
            "customUrl":"#(destUrl)",
            "accessToken":"#(destUserBio.userAccessToken)",
            "transactionAsset": "ETH_TEST5",
            "transactionAmount": "#(amountETH)",
            "source": {
                "type": "VAULT_ID",
                "value": "#(sourceVaultId)"
            },
            "destination": {
                "type": "FOLDER_ID",
                "value": "#(destinationAddressId)"
            }
        }
        """
        * call read(svc + 'TravelRule.feature@POST_core_v2_TravelRule_VASP_validate-init-transaction') data
        Then match responseStatus == 201
        * def travelRuleTransactionID = response.data.travelRuleTransactionID

        # 1.2. _VASP validate-confirm-transaction
        * def data =
        """
        {
            "travelRuleTransactionID": "#(travelRuleTransactionID)"
        }
        """
        * call read(svc + 'TravelRule.feature@POST_core_v2_TravelRule_VASP_validate-confirm-transaction') data
        Then match responseStatus == 201

        # 1.3 Create Withdraw from whitelisted 
        * def data = 
        """
        {
            "customUrl":"#(destUrl)",
            "accessToken":"#(destUserBio.userAccessToken)",
            "challengeAnswerRequest":"#(destUserBio.userAnswerApprover)",
            "treatAsGrossAmount": false,
            "feeLevel": "HIGH",
            "amount": "#(amountETH)",
            "feeType": "GWEI",
            "tokenId": "#(crossData.eth5TokenId)",
            "fee": 12.646000000000001,
            "operation": "TRANSFER",
            "totalEstimatedFee": 0.00026556600000000001,
            "destination": {
                "id": "#(destinationFolderId)",
                "type": "#(destinationFolderType)"
            },
            "source": {
                "id": "67fb51b6-d6bb-449a-9a09-c68d771c6a93",
                "type": "VAULT_ACCOUNT"
            },
            "travelRuleTransactionID": "#(travelRuleTransactionID)"
        }
        """
        * call read(svc + 'Transaction.feature@CreateTravelRuleTransaction') data
        * def requestId = response.data.requestId

        # 1.4 Approve in cross sg customer
        * def destApproverBio = karate.call(svc + 'Biometric.feature@UserDoBiometric', { customUrl: destUrl, userName: crossData.sg.userInfo.admin2})
        * def crossApproverPasscode = karate.exec(`node aes.js encrypt ${crossData.sg.userInfo.passcode} ${privateKey.secret} ${crossApproverIv}`);
        * def data = 
        """
        {
            customUrl:"#(destUrl)",
            requestId:"#(requestId)",
            approvalAccessToken: "#(destApproverBio.userAccessToken)",
            challengeAnswerApprover: "#(destApproverBio.userAnswerApprover)"
        }
        """
        * call read(svc + 'Quorums.feature@ApproveRequest') data
        * print destEnv
        # 2. Accept the withdraw from Notabene
        * eval
        """
            java.lang.Thread.sleep(5000); 
            karate.call(svc + 'NotabeneAPI.feature@ApproveLatestTransfer',{ txDirection: "outgoing", destEnv: destEnv }) 
        """

        # 3. ACCEPT/REJECT the deposit from Notabene
        * eval
        """
            java.lang.Thread.sleep(5000); 
            if (notabeneAccept == "true")
                karate.call(svc + 'NotabeneAPI.feature@ApproveLatestTransfer',{ txDirection: "incoming" }) 
            else
                karate.call(svc + 'NotabeneAPI.feature@CancelLatestTransfer',{ txDirection: "incoming" }) 
        """

        # Get transaction hash from withdraw txn
        
        
        # 4. Validate transaction details from RAK API - from get transaction details
        
    Examples:
        |  read('classpath:data/TravelRule_e2e/dev_deposit.csv')  |






