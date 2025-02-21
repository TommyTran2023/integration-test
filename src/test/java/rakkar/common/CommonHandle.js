function fn(){
    return {
        checkQuorumsValid: function(quorums){

            for (var i=0; i < quorums.length; i++){
                var q = quorums[i]
    
                if (typeof q.quorumApprovals != "number"){
                    throw Error("quorumApprovals should be number")
                }
    
                if (typeof q.isRequired != "boolean"){
                    throw Error("isRequired should be boolean")
                }
    
                for (var x; x < q.members.length; i++){
                    var member = q.members[x]
        
                    if (member.type == Const.QuorumMemberType.USER) {
                        if (typeof member.userId != "uuid"){
                            return { result: false, message: "userId should be uuid" }
                        }
                    } else if (member.type == Const.QuorumMemberType.GROUP){
                        if (typeof member.groupId != "uuid"){
                            return { result: false, message: "groupId should be uuid" }
                        }
                    } else {
                        return { result: false, message: "type should GROUP or USER" }
                    }
                }
            }

            return true
        },

        checkAllUsersExpected: function(actualUsers, expectedUsers){
            for(var i = 0; i < expectedUsers.length; i++) { 
                var isUserInList = actualUsers.some(item => (expectedUsers[i].userId === item.userId 
                                                       && expectedUsers[i].email === item.email 
                                                       && expectedUsers[i].name === item.name 
                                                       && expectedUsers[i].enabled === item.enabled 
                                                       && expectedUsers[i].role === item.role 
                                                       && expectedUsers[i].roleDisplayName === item.roleDisplayName 
                                                       && expectedUsers[i].requiredApprover === item.requiredApprover 
                                                       && expectedUsers[i].isApprover === item.isApprover) )
                
                if (isUserInList == false) {
                    karate.log("Expected User: ", expectedUsers[i])
                    karate.log("Actual user list: ", actualUsers)
                    return {result: false, message:"User not in list"}
                }
            }

            return true
        },

        shuffleArr: function(arr) {
            const shuffledArr = arr.sort(() => Math.random() - 0.5);
            return shuffledArr
        },
        
        waitUntilTransactionCompleted: function(transactionId, expectedStatus) { 
            var completedStatus = ["COMPLETED", "FAILED", expectedStatus?.toUpperCase()]
            var retry = 18
            do {
                java.lang.Thread.sleep(10000); 
                var getTransactionDetail = karate.call(svc + 'Transaction.feature@ViewTransactionDetail', { transactionId: transactionId })
                retry--
            }
            while (!completedStatus.includes(getTransactionDetail.response.data.status) && retry > 0)

            if (retry <= 0 && !completedStatus.includes(getTransactionDetail.response.data.status))
                karate.fail("Transaction cannot be completed: " + transactionId + (expectedStatus == null ? "" : ". Expected status: " + expectedStatus))
  
            return getTransactionDetail
        },

        waitUntilFireblocksStatusCompleted: function(transactionId, expectedStatus) { 
            var completedStatus = ["COMPLETED", "REJECTED", expectedStatus?.toUpperCase()]
            var retry = 10
            do {
                java.lang.Thread.sleep(30000); 
                var getTransactionDetail = karate.call(svc + 'Transaction.feature@ViewTransactionDetail', { transactionId: transactionId })
                retry--
            }
            while (!completedStatus.includes(getTransactionDetail.response.data.fireblocksStatus) && retry > 0)

            if (retry <= 0 && !completedStatus.includes(getTransactionDetail.response.data.fireblocksStatus))
                karate.fail("Fireblocks transaction cannot be completed: " + transactionId + (expectedStatus == null ? "" : ". Expected status: " + expectedStatus))
  
            return getTransactionDetail
        }
    }
}
