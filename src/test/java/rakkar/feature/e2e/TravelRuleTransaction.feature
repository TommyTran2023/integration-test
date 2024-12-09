@e2e
Feature: Travel rule transaction

    Background: Login as SG requester
        * def env = karate.properties['karate.env']
        * def crossData = karate.read('classpath:data/cross_workspace_data.json')
        * def crossData = karate.jsonPath(crossData, "$.." + env +"_workspace")[0].sg
        * callonce read(svc + 'Auth.feature@GetUserAccessToken') { userName: "#(sg_customer.admin1)" }
        * def accessToken = userAccessToken
        * def amountETH = "0.00001" + (new Date()).getTime().toString().slice(5,10)
        * def commonHandle = read('classpath:rakkar/common/CommonHandle.js')

    @WithdrawDiffVASP
    Scenario Outline: Withdraw Diff VASP - <flowName>
        * def sourceVaultId = <sourceVaultId>
        * def destinationFolderId = <destinationFolderId>
        * def destinationAddressId = <destinationAddressId>
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
            challengeAnswerApprover: "#(approverSG.userAnswerApprover)",
            passcode: "#(approverPasscode)",
        }
        """
        * call read(svc + 'Quorums.feature@ApproveRequest') data

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
        * def transaction = commonHandle().waitUntilTransactionCompleted(transactionId)

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
            "url": "https://app.notabene.id",
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
        |flowName        |sourceVaultId                                      |destinationFolderId                                      |destinationAddressId                                      |notabeneAccept|expectedRepTxnStatus|expectedRakTxnStatus|expectedfbStatus|expectedfbSubStatus             |expectedPath|expectedStage          |expectedType|expectedKey  |expectedReason                     |expectedtrStatus|expectedVerdict|
        |Notabene accept |crossData.DiffVASP_ValidWhitelist.eth5SourceVaultId|crossData.DiffVASP_ValidWhitelist.eth5DestinationFolderId|crossData.DiffVASP_ValidWhitelist.eth5DestinationAddressId|true          |Completed           |Completed           |COMPLETED       |CONFIRMED                       |Complete    |Complete without Frozen|OUTGOING    |tr.OUTGOING.4|-                                  |Completed       |ACCEPT         |
        |Notabene cancel |crossData.DiffVASP_ValidWhitelist.eth5SourceVaultId|crossData.DiffVASP_ValidWhitelist.eth5DestinationFolderId|crossData.DiffVASP_ValidWhitelist.eth5DestinationAddressId|false         |Processing          |Processing          |REJECTED        |REJECTED_AML_SCREENING          |Freeze      |Post-screening         |OUTGOING    |tr.OUTGOING.2|Travel Rule rejected on Notabene   |Frozen          |REJECT         |
        
    @DepositDiffVASP
    Scenario: Deposit Diff VASP - from valid whitelisted
        # 1. Withdraw from whitelisted
        

        # 2. Accept the withdraw from Notabene

        # 3. ACCEPT/REJECT the deposit from Notabene

        # 4. Validate transaction details from RAK API - from get transaction details





