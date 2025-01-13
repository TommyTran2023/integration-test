    @ignore
Feature: Travel rule - VASP

    @GET_core_v2_rep_TravelRule_VASP
  Scenario: GET core v2 rep TravelRule VASP
    * def data =
    """
    {
        headers:{
  		    Authorization: "#(typeof accessToken == 'undefined' ? repAccessToken : accessToken)"
        }

    }
    """
    * call read('this:coreSvc.feature@GET_core_v2_rep_TravelRule_VASP') data
