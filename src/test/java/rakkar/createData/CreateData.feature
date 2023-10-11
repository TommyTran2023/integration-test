Feature: Create data
    
  Background:
    * url baseURL
    * def svc = "classpath:rakkar/services/"
    * def testData = read('classpath:data/data_test.json')
    * def enum = read('classpath:data/enum.json')
    * callonce read(svc + 'AuthCommon.feature@GetRequesterInfo')
    * callonce read(svc + 'AuthCommon.feature@GetAllUsers')

    Scenario: Create Vault
        
        * def requestBody = 
        """
            {
                "memberRequiredApprove":[],
                "name":#(vaultName),
                "hasRequiredApprover":false,
                "memberIds":[#(requesterUserID),#(approvalUserID),#(adminUserID)],
                "type":'#(enum.VaultType.HOT_WALLET)',
                "approverNumber":'#(testData.vault.approve_number)',
                "note":"AT Create Test Data"
            }
        """
        * print requestBody
        # * call read(svc + 'Vault.feature@CreateVault')
