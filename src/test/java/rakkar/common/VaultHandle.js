function fn(){
    return {
        generateVaultName: function(){
            var now = java.lang.System.currentTimeMillis()
            return 'AT-RAK-'+now
        }
    }
}