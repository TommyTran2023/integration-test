Feature: Cfg


#----------------------------------
@Cfg_purposesController_getListEntity
Scenario: Invalid Input Format
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
    * call read(svc + 'coreSvc.feature@Cfg_purposesController_getListEntity') data

@Cfg_purposesController_saveEntity
Scenario: Invalid Input Format
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
    * call read(svc + 'coreSvc.feature@Cfg_purposesController_saveEntity') data

#----------------------------------
@Cfg_purposesController_findOneByUId
Scenario: Invalid Input Format
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
    * call read(svc + 'coreSvc.feature@Cfg_purposesController_findOneByUId') data

@Cfg_purposesController_updateOneById
Scenario: Invalid Input Format
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
    * call read(svc + 'coreSvc.feature@Cfg_purposesController_updateOneById') data

@Cfg_purposesController_delete
Scenario: Invalid Input Format
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
    * call read(svc + 'coreSvc.feature@Cfg_purposesController_delete') data

#----------------------------------
@Cfg_purposesController_hardDelete
Scenario: Invalid Input Format
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
    * call read(svc + 'coreSvc.feature@Cfg_purposesController_hardDelete') data

#----------------------------------
@Cfg_purposesController_getPaginationConfig
Scenario: Invalid Input Format
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
    * call read(svc + 'coreSvc.feature@Cfg_purposesController_getPaginationConfig') data

#----------------------------------
@Cfg_relationshipsController_getListEntity
Scenario: Invalid Input Format
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
    * call read(svc + 'coreSvc.feature@Cfg_relationshipsController_getListEntity') data

@Cfg_relationshipsController_saveEntity
Scenario: Invalid Input Format
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
    * call read(svc + 'coreSvc.feature@Cfg_relationshipsController_saveEntity') data

#----------------------------------
@Cfg_relationshipsController_findOneByUId
Scenario: Invalid Input Format
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
    * call read(svc + 'coreSvc.feature@Cfg_relationshipsController_findOneByUId') data

@Cfg_relationshipsController_updateOneById
Scenario: Invalid Input Format
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
    * call read(svc + 'coreSvc.feature@Cfg_relationshipsController_updateOneById') data

@Cfg_relationshipsController_delete
Scenario: Invalid Input Format
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
    * call read(svc + 'coreSvc.feature@Cfg_relationshipsController_delete') data

#----------------------------------
@Cfg_relationshipsController_hardDelete
Scenario: Invalid Input Format
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
    * call read(svc + 'coreSvc.feature@Cfg_relationshipsController_hardDelete') data

#----------------------------------
@Cfg_relationshipsController_getPaginationConfig
Scenario: Invalid Input Format
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
    * call read(svc + 'coreSvc.feature@Cfg_relationshipsController_getPaginationConfig') data

#----------------------------------
@Cfg_relationshipsREPController_getPaginationConfig
Scenario: Invalid Input Format
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
    * call read(svc + 'coreSvc.feature@Cfg_relationshipsREPController_getPaginationConfig') data

#----------------------------------
@Cfg_relationshipsREPController_getListEntity
Scenario: Invalid Input Format
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
    * call read(svc + 'coreSvc.feature@Cfg_relationshipsREPController_getListEntity') data

@Cfg_relationshipsREPController_saveEntity
Scenario: Invalid Input Format
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
            name : '#(name)',
            status : '#(status)',
            isDeleted : '#(isDeleted)'
        }
    }
    """
    * call read(svc + 'coreSvc.feature@Cfg_relationshipsREPController_saveEntity') data

#----------------------------------
@Cfg_relationshipsREPController_findOneByUId
Scenario: Invalid Input Format
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
    * call read(svc + 'coreSvc.feature@Cfg_relationshipsREPController_findOneByUId') data

@Cfg_relationshipsREPController_updateOneById
Scenario: Invalid Input Format
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
            name : '#(name)',
            status : '#(status)',
            isDeleted : '#(isDeleted)'
        }
    }
    """
    * call read(svc + 'coreSvc.feature@Cfg_relationshipsREPController_updateOneById') data

@Cfg_relationshipsREPController_delete
Scenario: Invalid Input Format
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
    * call read(svc + 'coreSvc.feature@Cfg_relationshipsREPController_delete') data

#----------------------------------
@Cfg_relationshipsREPController_hardDelete
Scenario: Invalid Input Format
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
    * call read(svc + 'coreSvc.feature@Cfg_relationshipsREPController_hardDelete') data

#----------------------------------
@CustomersController_getPaginationConfig
Scenario: Customers Controller get Pagination Config
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
    * call read(svc + 'coreSvc.feature@CustomersController_getPaginationConfig') data
