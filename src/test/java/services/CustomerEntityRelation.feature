Feature: Customer Entity Relation

#----------------------------------
@CustomerEntityRelationsController_getPaginationConfig
Scenario: Customer Entity Relations Controller get Pagination Config
    * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
    * def data = 
    """
    {
        headers: 
        { 
            authorization: "#(accessToken)"
        }
    }
    """
    * call read(svc + 'coreSvc.feature@CustomerEntityRelationsController_getPaginationConfig') data

#----------------------------------
@CustomerEntityRelationsController_getListEntity
Scenario: Customer Entity Relations Controller get List Entity
    * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
    * def data = 
    """
    {
        headers: 
        { 
            authorization: "#(accessToken)"
        },
        params: 
        {
            limit : "#(typeof limit == 'undefined' ? '' : limit)", 
            offset : "#(typeof offset == 'undefined' ? '' : offset)", 
            searchText : "#(typeof searchText == 'undefined' ? '' : searchText)", 
            ids : "#(typeof ids == 'undefined' ? '' : ids)", 
            where : "#(typeof where == 'undefined' ? '' : where)", 
            order : "#(typeof order == 'undefined' ? '' : order)"
        }
    }
    """
    * call read(svc + 'coreSvc.feature@CustomerEntityRelationsController_getListEntity') data

@CustomerEntityRelationsController_saveEntity
Scenario: Customer Entity Relations Controller save Entity
    * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
    * def data = 
    """
    {
        headers: 
        { 
            authorization: "#(accessToken)"
        },
        body: 
        {
            id : '#(id)',
            countryCode : '#(countryCode)'
        }
    }
    """
    * call read(svc + 'coreSvc.feature@CustomerEntityRelationsController_saveEntity') data

#----------------------------------
@CustomerEntityRelationsController_findOneByUId
Scenario: Customer Entity Relations Controller find One By UId
    * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
    * def data = 
    """
    {
        headers: 
        { 
            authorization: "#(accessToken)"
        },
        id : "#(typeof id == 'undefined' ? '' : id)"
    }
    """
    * call read(svc + 'coreSvc.feature@CustomerEntityRelationsController_findOneByUId') data

@CustomerEntityRelationsController_updateOneById
Scenario: Customer Entity Relations Controller update One By Id
    * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
    * def data = 
    """
    {
        headers: 
        { 
            authorization: "#(accessToken)"
        },
        id : "#(typeof id == 'undefined' ? '' : id)", 
        body: 
        {
            id : '#(id)',
            countryCode : '#(countryCode)'
        }
    }
    """
    * call read(svc + 'coreSvc.feature@CustomerEntityRelationsController_updateOneById') data

@CustomerEntityRelationsController_delete
Scenario: Customer Entity Relations Controller delete
    * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
    * def data = 
    """
    {
        headers: 
        { 
            authorization: "#(accessToken)"
        },
        id : "#(typeof id == 'undefined' ? '' : id)"
    }
    """
    * call read(svc + 'coreSvc.feature@CustomerEntityRelationsController_delete') data

#----------------------------------
@CustomerEntityRelationsController_hardDelete
Scenario: Customer Entity Relations Controller hard Delete
    * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
    * def data = 
    """
    {
        headers: 
        { 
            authorization: "#(accessToken)"
        },
        id : "#(typeof id == 'undefined' ? '' : id)"
    }
    """
    * call read(svc + 'coreSvc.feature@CustomerEntityRelationsController_hardDelete') data
