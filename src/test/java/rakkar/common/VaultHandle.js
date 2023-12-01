function fn(){
    function generateVaultName(){
        var now = java.lang.System.currentTimeMillis()
        return 'AT-VRAK-'+now
    }

    return {
        generateVaultName: function(){
            return generateVaultName()
        },

        createStandardVault: function(memberIds, type){
            var data = {
                "memberRequiredApprove":[],
                "name": generateVaultName(),
                "hasRequiredApprover":false,
                "memberIds":memberIds,
                "type":type,
                "approverNumber": memberIds.length,
                "note":"AT Create Test Data"
            }

            var vault = karate.call(svc + 'Vault.feature@CreateVault', {requestBody:data})
            vault = karate.call(svc + 'Vault.feature@GetVaultDetail', {vaultId:vault.response.data.id})
            
            // return vault detail
            return vault.response
        },

        archiveVault: function(vaultId){
            karate.call(svc + 'Vault.feature@UnhideVault', {vaultId:vaultId})
        }
    }
}