Feature: core/v2/TravelRule

    @POST_core_v2_TravelRule_VASP_validate-init-transaction
  Scenario: POST core v2 TravelRule VASP validate-init-transaction
    * def data =
    """
    {
        headers:{
		    Authorization: "#(typeof accessToken == 'undefined' ? requesterAccessToken : accessToken)"
        },
        body: {
            transactionAsset: "#(typeof transactionAsset != 'undefined' ? transactionAsset : null)",
            transactionAmount: "#(typeof transactionAmount != 'undefined' ? transactionAmount : null)",
            source: "#(typeof source != 'undefined' ? source : null)",
            destination: "#(typeof destination != 'undefined' ? destination : null)"
        }
    }
    """
    * call read(svc + 'coreSvc.feature@POST_core_v2_TravelRule_VASP_validate-init-transaction') data

    @POST_core_v2_TravelRule_VASP_validate-confirm-transaction
  Scenario: POST core v2 TravelRule VASP validate-confirm-transaction
    * def data =
    """
    {
        headers:{
  		    Authorization: "#(typeof accessToken == 'undefined' ? requesterAccessToken : accessToken)"
        },
        body: {
            travelRuleTransactionID: "#(typeof travelRuleTransactionID != 'undefined' ? travelRuleTransactionID : null)"
        }
    }
    """
    * call read(svc + 'coreSvc.feature@POST_core_v2_TravelRule_VASP_validate-confirm-transaction') data
