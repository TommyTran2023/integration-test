@ignore
Feature: Travel rule transactions

Background: Login as SG requester
    * if (isRun == "false") karate.abort()

    * def env = karate.properties['karate.env']
    * def trData = karate.read('classpath:data/cross_workspace_data.json')
    * def trData = karate.jsonPath(trData, "$.." + env +"_workspace")[0].sg.userInfo
    * callonce read(svc + 'Auth.feature@GetUserAccessToken') { userName: "#(trData.admin1)" }
    * def accessToken = userAccessToken
    * def amountETH = "0.0001" + (new Date()).getTime().toString().slice(5,10)
    * def commonHandle = read('classpath:rakkar/common/CommonHandle.js')

@setup
Scenario: Environment Setup
    * def env = karate.properties['karate.env']
        * def testWithdraw = read(`classpath:data/TravelRule_e2e/${env}_withdraw.csv`) 
        * def testDeposit = read(`classpath:data/TravelRule_e2e/${env}_deposit.csv`) 

@withdrawTravelRule

Scenario: Withdraw travel rule
    def sourceVaultId = "<sourceVaultId>"
    * def destinationFolderId = "<destinationFolderId>"
    * def destinationAddressId = "<destinationAddressId>"
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
        * def data =
        """
        {
            "travelRuleTransactionID": "#(travelRuleTransactionID)"
        }
        """
        * call read(svc + 'TravelRule.feature@POST_core_v2_TravelRule_VASP_validate-confirm-transaction') data
        Then match responseStatus == 201
        * call read(svc + 'Biometric.feature@UserDoBiometric')
        * def body_transfer = 
        """
        {
            "challengeAnswerRequest": "#(userAnswerApprover)",
            "operation": "TRANSFER",
            "destination": {
                "id": "#(destinationFolderId)",
                "type": "#(folderType)"
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
        * print 'requestId value:', requestId

        # Validate request detail
        * call read(svc + 'Quorums.feature@ViewRequestDetails') { requestId: '#(requestId)' }
        Then match responseStatus == 200
        * match response.status == "success"
    
        # Validate Transaction Basic Info
        * def data = response.data
        And match data.transactionType == '#? _ == "OUTGOING" || _ == "INCOMING"'
        And match data.tokenNetwork == 'Ethereum Testnet (Sepolia)'
        And match data.tokenSymbol == 'ETH'
        
        # Validate Amount and Fees
        And match data.amount == '#number'
        And match data.amountUSD == '#number'
        And match data.fee == 2.256
        And match data.totalEstimatedFee == 0.000047375999999999995
        And match data.amountLevel == '#? _ == "LOW" || _ == "MEDIUM" || _ == "HIGH"'
    
        # VASP Information Integration
        * def vaspInfo = data.validateVaspInfo.beneficiary.vaspInfo
        And match vaspInfo.id == data.vasp.id
        And match vaspInfo.did == data.vasp.did
        And match vaspInfo.status == 'ACTIVE'
        
        # Address Validation Integration
        * def destAddress = data.destination.destinationAddress
        * def whitelistAddress = data.whitelistAddress.address
        And match destAddress == whitelistAddress
        And match data.whitelistAddress.verificationStatus == 'VERIFIED'

        # Travel Rule Validation
        * def travelRule = data.validateVaspInfo
        And match travelRule.type == 'TRAVELRULE'
        And match travelRule.isValid == true
        And match travelRule.infoValidate.beneficiaryVASPdid == travelRule.beneficiary.vaspInfo.did
        
        # Source and Destination Integration
        * def sourceInfo = data.source
        * def destInfo = data.destination
        And match sourceInfo.type == 'VAULT_ACCOUNT'
        And match destInfo.type == 'EXTERNAL_WALLET'
        And match destInfo.objectDestinationAddress.vaspId == data.vasp.id
        
        # Business Information Integration
        * def businessInfo = data.destinationFolder.businessInfo
        #And match businessInfo.businessName == data.destination.name
        #And match businessInfo.businessAddress contains businessInfo.countryCode