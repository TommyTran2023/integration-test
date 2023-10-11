Feature: Create data
    
  Background:
    * url baseURL
    * def svc = "classpath:rakkar/services/"
    * callonce read(svc + 'ReadData.feature@GetDataFile')
    * callonce read(svc + 'ReadData.feature@GetEnumFile')
    * callonce read(svc + 'Auth.feature@GetRequesterInfo')
    * callonce read(svc + 'Auth.feature@GetAllUsers')

    Scenario: Create Hot Vault 'AT - Warm Standard Vault 1'
        * def requestBody = 
        """
            {
                "memberRequiredApprove":[],
                "name":#(testData.standardWarmVault_1),
                "hasRequiredApprover":false,
                "memberIds":[#(requesterID),#(approvalUserID),#(adminUserID)],
                "type":'#(Const.VaultType.HOT_WALLET)',
                "approverNumber": 3,
                "note":"AT Create Test Data"
            }
        """
        * call read(svc + 'Vault.feature@CreateVault')
        Then match responseStatus == 200
