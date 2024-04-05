Feature: walletConnect
	Background: 
		Given url baseURL
		
#----------------------------------
	@AppController_getIndex
	Scenario: App Controller get Index
		Given path 'walletConnect/'
		* headers headers
		When method GET

#----------------------------------
	@HealthController_check
	Scenario: Health Controller check
		Given path 'walletConnect/health'
		* headers headers
		When method GET

#----------------------------------
	@WcWeb3ConnectREPController_findOneByUId
	Scenario: Wc Web3Connect REPController find One By UId
		Given path `walletConnect/v2/rep/wcWeb3Connect/${id}`
		* headers headers
		When method GET

	@WcWeb3ConnectREPController_updateOneById
	Scenario: Wc Web3Connect REPController update One By Id
		Given path `walletConnect/v2/rep/wcWeb3Connect/${id}`
		* headers headers
		* request body
		When method PUT

	@WcWeb3ConnectREPController_delete
	Scenario: Wc Web3Connect REPController delete
		Given path `walletConnect/v2/rep/wcWeb3Connect/${id}`
		* headers headers
		When method DELETE

#----------------------------------
	@WcWeb3ConnectREPController_hardDelete
	Scenario: Wc Web3Connect REPController hard Delete
		Given path `walletConnect/v2/rep/wcWeb3Connect/${id}/hard`
		* headers headers
		When method DELETE

#----------------------------------
	@WcWeb3ConnectREPController_syncVaultConnect
	Scenario: Wc Web3Connect REPController sync Vault Connect
		Given path `walletConnect/v2/rep/wcWeb3Connect/sync-by-vaultId/${uid}`
		* headers headers
		When method PATCH

#----------------------------------
	@WcWeb3ConnectREPController_getPaginationConfig
	Scenario: Wc Web3Connect REPController get Pagination Config
		Given path 'walletConnect/v2/rep/wcWeb3Connect/pagination-config'
		* headers headers
		When method GET

#----------------------------------
	@WcWeb3ConnectREPController_getListEntity
	Scenario: Wc Web3Connect REPController get List Entity
		Given path 'walletConnect/v2/rep/wcWeb3Connect'
		* headers headers
		When method GET

	@WcWeb3ConnectREPController_saveEntity
	Scenario: Wc Web3Connect REPController save Entity
		Given path 'walletConnect/v2/rep/wcWeb3Connect'
		* headers headers
		* request body
		When method POST

#----------------------------------
	@WcApplicationController_findOneByUId
	Scenario: Wc Application Controller find One By UId
		Given path `walletConnect/v2/wcApplication/${id}`
		* headers headers
		When method GET

	@WcApplicationController_updateOneById
	Scenario: Wc Application Controller update One By Id
		Given path `walletConnect/v2/wcApplication/${id}`
		* headers headers
		* request body
		When method PUT

	@WcApplicationController_delete
	Scenario: Wc Application Controller delete
		Given path `walletConnect/v2/wcApplication/${id}`
		* headers headers
		When method DELETE

#----------------------------------
	@WcApplicationController_hardDelete
	Scenario: Wc Application Controller hard Delete
		Given path `walletConnect/v2/wcApplication/${id}/hard`
		* headers headers
		When method DELETE

#----------------------------------
	@WcApplicationController_getPaginationConfig
	Scenario: Wc Application Controller get Pagination Config
		Given path 'walletConnect/v2/wcApplication/pagination-config'
		* headers headers
		When method GET

#----------------------------------
	@WcApplicationController_getListEntity
	Scenario: Wc Application Controller get List Entity
		Given path 'walletConnect/v2/wcApplication'
		* headers headers
		When method GET

	@WcApplicationController_saveEntity
	Scenario: Wc Application Controller save Entity
		Given path 'walletConnect/v2/wcApplication'
		* headers headers
		* request body
		When method POST

#----------------------------------
	@WcWeb3ConnectController_getPaginationConfig
	Scenario: Wc Web3Connect Controller get Pagination Config
		Given path 'walletConnect/v2/wcWeb3Connect/pagination-config'
		* headers headers
		When method GET

#----------------------------------
	@WcWeb3ConnectController_getListEntity
	Scenario: Wc Web3Connect Controller get List Entity
		Given path 'walletConnect/v2/wcWeb3Connect'
		* headers headers
		When method GET

	@WcWeb3ConnectController_saveEntity
	Scenario: Wc Web3Connect Controller save Entity
		Given path 'walletConnect/v2/wcWeb3Connect'
		* headers headers
		When method POST

#----------------------------------
	@WcWeb3ConnectController_findOneByUId
	Scenario: Wc Web3Connect Controller find One By UId
		Given path `walletConnect/v2/wcWeb3Connect/${id}`
		* headers headers
		When method GET

	@WcWeb3ConnectController_updateOneById
	Scenario: Wc Web3Connect Controller update One By Id
		Given path `walletConnect/v2/wcWeb3Connect/${id}`
		* headers headers
		When method PUT

	@WcWeb3ConnectController_delete
	Scenario: Wc Web3Connect Controller delete
		Given path `walletConnect/v2/wcWeb3Connect/${id}`
		* headers headers
		When method DELETE

#----------------------------------
	@WcWeb3ConnectController_hardDelete
	Scenario: Wc Web3Connect Controller hard Delete
		Given path `walletConnect/v2/wcWeb3Connect/${id}/hard`
		* headers headers
		When method DELETE

#----------------------------------
	@WcRequestWeb3ConnectController_getListEntity
	Scenario: Wc Request Web3Connect Controller get List Entity
		Given path 'walletConnect/v2/wcRequestWeb3Connect'
		* headers headers
		When method GET

	@WcRequestWeb3ConnectController_saveEntity
	Scenario: Wc Request Web3Connect Controller save Entity
		Given path 'walletConnect/v2/wcRequestWeb3Connect'
		* headers headers
		* request body
		When method POST

#----------------------------------
	@WcRequestWeb3ConnectController_approveRequestWeb3Connect
	Scenario: Wc Request Web3Connect Controller approve Request Web3Connect
		Given path `walletConnect/v2/wcRequestWeb3Connect/${id}/submit`
		* headers headers
		When method PATCH

#----------------------------------
	@WcRequestWeb3ConnectController_findOneByUId
	Scenario: Wc Request Web3Connect Controller find One By UId
		Given path `walletConnect/v2/wcRequestWeb3Connect/${id}`
		* headers headers
		When method GET

	@WcRequestWeb3ConnectController_updateOneById
	Scenario: Wc Request Web3Connect Controller update One By Id
		Given path `walletConnect/v2/wcRequestWeb3Connect/${id}`
		* headers headers
		* request body
		When method PUT

	@WcRequestWeb3ConnectController_delete
	Scenario: Wc Request Web3Connect Controller delete
		Given path `walletConnect/v2/wcRequestWeb3Connect/${id}`
		* headers headers
		When method DELETE

#----------------------------------
	@WcRequestWeb3ConnectController_getPaginationConfig
	Scenario: Wc Request Web3Connect Controller get Pagination Config
		Given path 'walletConnect/v2/wcRequestWeb3Connect/pagination-config'
		* headers headers
		When method GET

#----------------------------------
	@WcRequestWeb3ConnectController_hardDelete
	Scenario: Wc Request Web3Connect Controller hard Delete
		Given path `walletConnect/v2/wcRequestWeb3Connect/${id}/hard`
		* headers headers
		When method DELETE

#----------------------------------
	@WcRequestWeb3ConnectREPController_getListEntity
	Scenario: Wc Request Web3Connect REPController get List Entity
		Given path 'walletConnect/v2/rep/wcRequestWeb3Connect'
		* headers headers
		When method GET

	@WcRequestWeb3ConnectREPController_saveEntity
	Scenario: Wc Request Web3Connect REPController save Entity
		Given path 'walletConnect/v2/rep/wcRequestWeb3Connect'
		* headers headers
		* request body
		When method POST

#----------------------------------
	@WcRequestWeb3ConnectREPController_submit
	Scenario: Wc Request Web3Connect REPController submit
		Given path `walletConnect/v2/rep/wcRequestWeb3Connect/${id}/submit`
		* headers headers
		When method PATCH

#----------------------------------
	@WcRequestWeb3ConnectREPController_findOneByUId
	Scenario: Wc Request Web3Connect REPController find One By UId
		Given path `walletConnect/v2/rep/wcRequestWeb3Connect/${id}`
		* headers headers
		When method GET

	@WcRequestWeb3ConnectREPController_updateOneById
	Scenario: Wc Request Web3Connect REPController update One By Id
		Given path `walletConnect/v2/rep/wcRequestWeb3Connect/${id}`
		* headers headers
		* request body
		When method PUT

	@WcRequestWeb3ConnectREPController_delete
	Scenario: Wc Request Web3Connect REPController delete
		Given path `walletConnect/v2/rep/wcRequestWeb3Connect/${id}`
		* headers headers
		When method DELETE

#----------------------------------
	@WcRequestWeb3ConnectREPController_hardDelete
	Scenario: Wc Request Web3Connect REPController hard Delete
		Given path `walletConnect/v2/rep/wcRequestWeb3Connect/${id}/hard`
		* headers headers
		When method DELETE

#----------------------------------
	@WcRequestWeb3ConnectREPController_getPaginationConfig
	Scenario: Wc Request Web3Connect REPController get Pagination Config
		Given path 'walletConnect/v2/rep/wcRequestWeb3Connect/pagination-config'
		* headers headers
		When method GET

#----------------------------------
	@WcAppEntityController_findOneByUId
	Scenario: Wc App Entity Controller find One By UId
		Given path `walletConnect/v2/wcAppEntity/${id}`
		* headers headers
		When method GET

	@WcAppEntityController_updateOneById
	Scenario: Wc App Entity Controller update One By Id
		Given path `walletConnect/v2/wcAppEntity/${id}`
		* headers headers
		* request body
		When method PUT

	@WcAppEntityController_delete
	Scenario: Wc App Entity Controller delete
		Given path `walletConnect/v2/wcAppEntity/${id}`
		* headers headers
		When method DELETE

#----------------------------------
	@WcAppEntityController_hardDelete
	Scenario: Wc App Entity Controller hard Delete
		Given path `walletConnect/v2/wcAppEntity/${id}/hard`
		* headers headers
		When method DELETE

#----------------------------------
	@WcAppEntityController_getPaginationConfig
	Scenario: Wc App Entity Controller get Pagination Config
		Given path 'walletConnect/v2/wcAppEntity/pagination-config'
		* headers headers
		When method GET

#----------------------------------
	@WcAppEntityController_getListEntity
	Scenario: Wc App Entity Controller get List Entity
		Given path 'walletConnect/v2/wcAppEntity'
		* headers headers
		When method GET

	@WcAppEntityController_saveEntity
	Scenario: Wc App Entity Controller save Entity
		Given path 'walletConnect/v2/wcAppEntity'
		* headers headers
		* request body
		When method POST

#----------------------------------
	@WcAppEntityREPController_findOneByUId
	Scenario: Wc App Entity REPController find One By UId
		Given path `walletConnect/v2/rep/wcAppEntity/${id}`
		* headers headers
		When method GET

	@WcAppEntityREPController_updateOneById
	Scenario: Wc App Entity REPController update One By Id
		Given path `walletConnect/v2/rep/wcAppEntity/${id}`
		* headers headers
		* request body
		When method PUT

	@WcAppEntityREPController_delete
	Scenario: Wc App Entity REPController delete
		Given path `walletConnect/v2/rep/wcAppEntity/${id}`
		* headers headers
		When method DELETE

#----------------------------------
	@WcAppEntityREPController_hardDelete
	Scenario: Wc App Entity REPController hard Delete
		Given path `walletConnect/v2/rep/wcAppEntity/${id}/hard`
		* headers headers
		When method DELETE

#----------------------------------
	@WcAppEntityREPController_getPaginationConfig
	Scenario: Wc App Entity REPController get Pagination Config
		Given path 'walletConnect/v2/rep/wcAppEntity/pagination-config'
		* headers headers
		When method GET

#----------------------------------
	@WcAppEntityREPController_getListEntity
	Scenario: Wc App Entity REPController get List Entity
		Given path 'walletConnect/v2/rep/wcAppEntity'
		* headers headers
		When method GET

	@WcAppEntityREPController_saveEntity
	Scenario: Wc App Entity REPController save Entity
		Given path 'walletConnect/v2/rep/wcAppEntity'
		* headers headers
		* request body
		When method POST

#----------------------------------
	@WcAdapterREPController_getPaginationConfig
	Scenario: Wc Adapter REPController get Pagination Config
		Given path 'walletConnect/v2/rep/wcAdapter/pagination-config'
		* headers headers
		When method GET

#----------------------------------
	@WcAdapterREPController_getListEntity
	Scenario: Wc Adapter REPController get List Entity
		Given path 'walletConnect/v2/rep/wcAdapter'
		* headers headers
		When method GET

	@WcAdapterREPController_saveEntity
	Scenario: Wc Adapter REPController save Entity
		Given path 'walletConnect/v2/rep/wcAdapter'
		* headers headers
		When method POST

#----------------------------------
	@WcAdapterREPController_findOneByUId
	Scenario: Wc Adapter REPController find One By UId
		Given path `walletConnect/v2/rep/wcAdapter/${id}`
		* headers headers
		When method GET

	@WcAdapterREPController_updateOneById
	Scenario: Wc Adapter REPController update One By Id
		Given path `walletConnect/v2/rep/wcAdapter/${id}`
		* headers headers
		When method PUT

	@WcAdapterREPController_delete
	Scenario: Wc Adapter REPController delete
		Given path `walletConnect/v2/rep/wcAdapter/${id}`
		* headers headers
		When method DELETE

#----------------------------------
	@WcAdapterREPController_hardDelete
	Scenario: Wc Adapter REPController hard Delete
		Given path `walletConnect/v2/rep/wcAdapter/${id}/hard`
		* headers headers
		When method DELETE

#----------------------------------
	@WcAppAdapterController_findOneByUId
	Scenario: Wc App Adapter Controller find One By UId
		Given path `walletConnect/v2/wcAppAdapter/${id}`
		* headers headers
		When method GET

	@WcAppAdapterController_updateOneById
	Scenario: Wc App Adapter Controller update One By Id
		Given path `walletConnect/v2/wcAppAdapter/${id}`
		* headers headers
		* request body
		When method PUT

	@WcAppAdapterController_delete
	Scenario: Wc App Adapter Controller delete
		Given path `walletConnect/v2/wcAppAdapter/${id}`
		* headers headers
		When method DELETE

#----------------------------------
	@WcAppAdapterController_hardDelete
	Scenario: Wc App Adapter Controller hard Delete
		Given path `walletConnect/v2/wcAppAdapter/${id}/hard`
		* headers headers
		When method DELETE

#----------------------------------
	@WcAppAdapterController_getPaginationConfig
	Scenario: Wc App Adapter Controller get Pagination Config
		Given path 'walletConnect/v2/wcAppAdapter/pagination-config'
		* headers headers
		When method GET

#----------------------------------
	@WcAppAdapterController_getListEntity
	Scenario: Wc App Adapter Controller get List Entity
		Given path 'walletConnect/v2/wcAppAdapter'
		* headers headers
		When method GET

	@WcAppAdapterController_saveEntity
	Scenario: Wc App Adapter Controller save Entity
		Given path 'walletConnect/v2/wcAppAdapter'
		* headers headers
		* request body
		When method POST

#----------------------------------
	@WcApplicationREPController_getListEntity
	Scenario: Wc Application REPController get List Entity
		Given path 'walletConnect/v2/rep/wcApplication'
		* headers headers
		When method GET

	@WcApplicationREPController_saveEntity
	Scenario: Wc Application REPController save Entity
		Given path 'walletConnect/v2/rep/wcApplication'
		* headers headers
		* request body
		When method POST

#----------------------------------
	@WcApplicationREPController_findOneByUId
	Scenario: Wc Application REPController find One By UId
		Given path `walletConnect/v2/rep/wcApplication/${id}`
		* headers headers
		When method GET

	@WcApplicationREPController_updateOneById
	Scenario: Wc Application REPController update One By Id
		Given path `walletConnect/v2/rep/wcApplication/${id}`
		* headers headers
		* request body
		When method PUT

	@WcApplicationREPController_delete
	Scenario: Wc Application REPController delete
		Given path `walletConnect/v2/rep/wcApplication/${id}`
		* headers headers
		When method DELETE

#----------------------------------
	@WcApplicationREPController_hardDelete
	Scenario: Wc Application REPController hard Delete
		Given path `walletConnect/v2/rep/wcApplication/${id}/hard`
		* headers headers
		When method DELETE

#----------------------------------
	@WcApplicationREPController_getPaginationConfig
	Scenario: Wc Application REPController get Pagination Config
		Given path 'walletConnect/v2/rep/wcApplication/pagination-config'
		* headers headers
		When method GET

