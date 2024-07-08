Feature: walletConnect
    #----------------------------------
   	@AppController_getIndex
 	Scenario: App Controller get Index
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			}
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@AppController_getIndex') data

    #----------------------------------
   	@HealthController_check
 	Scenario: Health Controller check
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			}
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@HealthController_check') data

    #----------------------------------
   	@WcWeb3ConnectREPController_findOneByUId
 	Scenario: Wc Web3Connect REPController find One By UId
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)"
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcWeb3ConnectREPController_findOneByUId') data

   	@WcWeb3ConnectREPController_updateOneById
 	Scenario: Wc Web3Connect REPController update One By Id
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)", 
 			body: 
 			{
				id : '#(id)',
				wcAppId : '#(wcAppId)',
				wcAppEntityId : '#(wcAppEntityId)',
				vaultId : '#(vaultId)',
				externalId : '#(externalId)',
				externalWorkspaceId : '#(externalWorkspaceId)',
				externalVaultId : '#(externalVaultId)',
				externalWalletType : '#(externalWalletType)',
				fbRaw : '#(fbRaw)',
				status : '#(status)',
				isDeleted : '#(isDeleted)'
 			}
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcWeb3ConnectREPController_updateOneById') data

   	@WcWeb3ConnectREPController_delete
 	Scenario: Wc Web3Connect REPController delete
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)"
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcWeb3ConnectREPController_delete') data

    #----------------------------------
   	@WcWeb3ConnectREPController_hardDelete
 	Scenario: Wc Web3Connect REPController hard Delete
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)"
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcWeb3ConnectREPController_hardDelete') data

    #----------------------------------
   	@WcWeb3ConnectREPController_syncVaultConnect
 	Scenario: Wc Web3Connect REPController sync Vault Connect
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			uid : "#(typeof uid == 'undefined' ? '' : uid)"
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcWeb3ConnectREPController_syncVaultConnect') data

    #----------------------------------
   	@WcWeb3ConnectREPController_getPaginationConfig
 	Scenario: Wc Web3Connect REPController get Pagination Config
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			}
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcWeb3ConnectREPController_getPaginationConfig') data

    #----------------------------------
   	@WcWeb3ConnectREPController_getListEntity
 	Scenario: Wc Web3Connect REPController get List Entity
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			params: 
 			{
				limit : "#(typeof limit == 'undefined' ? 10 : limit)", 
				offset : "#(typeof offset == 'undefined' ? 0 : offset)", 
				searchText : "#(typeof searchText == 'undefined' ? '' : searchText)", 
				ids : "#(typeof ids == 'undefined' ? null : ids)", 
				where : "#(typeof where == 'undefined' ? '' : where)", 
				order : "#(typeof order == 'undefined' ? 'ASC' : order)"
 			}
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcWeb3ConnectREPController_getListEntity') data

   	@WcWeb3ConnectREPController_saveEntity
 	Scenario: Wc Web3Connect REPController save Entity
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			body: 
 			{
				id : '#(id)',
				wcAppId : '#(wcAppId)',
				wcAppEntityId : '#(wcAppEntityId)',
				vaultId : '#(vaultId)',
				externalId : '#(externalId)',
				externalWorkspaceId : '#(externalWorkspaceId)',
				externalVaultId : '#(externalVaultId)',
				externalWalletType : '#(externalWalletType)',
				fbRaw : '#(fbRaw)',
				status : '#(status)',
				isDeleted : '#(isDeleted)'
 			}
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcWeb3ConnectREPController_saveEntity') data

    #----------------------------------
   	@WcApplicationController_findOneByUId
 	Scenario: Wc Application Controller find One By UId
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)"
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcApplicationController_findOneByUId') data

   	@WcApplicationController_updateOneById
 	Scenario: Wc Application Controller update One By Id
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)", 
 			body: 
 			{
				name : '#(name)',
				url : '#(url)',
				externalId : '#(externalId)',
				logo : '#(logo)',
				destinationNote : '#(destinationNote)'
 			}
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcApplicationController_updateOneById') data

   	@WcApplicationController_delete
 	Scenario: Wc Application Controller delete
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)"
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcApplicationController_delete') data

    #----------------------------------
   	@WcApplicationController_hardDelete
 	Scenario: Wc Application Controller hard Delete
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)"
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcApplicationController_hardDelete') data

    #----------------------------------
   	@WcApplicationController_getPaginationConfig
 	Scenario: Wc Application Controller get Pagination Config
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			}
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcApplicationController_getPaginationConfig') data

    #----------------------------------
   	@WcApplicationController_getListEntity
 	Scenario: Wc Application Controller get List Entity
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
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
  		* call read(svc + 'walletConnectSvc.feature@WcApplicationController_getListEntity') data

   	@WcApplicationController_saveEntity
 	Scenario: Wc Application Controller save Entity
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			body: 
 			{
				name : '#(name)',
				url : '#(url)',
				externalId : '#(externalId)',
				logo : '#(logo)',
				destinationNote : '#(destinationNote)'
 			}
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcApplicationController_saveEntity') data

    #----------------------------------
   	@WcWeb3ConnectController_getPaginationConfig
 	Scenario: Wc Web3Connect Controller get Pagination Config
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			}
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcWeb3ConnectController_getPaginationConfig') data

    #----------------------------------
   	@WcWeb3ConnectController_getListEntity
 	Scenario: Wc Web3Connect Controller get List Entity
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
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
  		* call read(svc + 'walletConnectSvc.feature@WcWeb3ConnectController_getListEntity') data

   	@WcWeb3ConnectController_saveEntity
 	Scenario: Wc Web3Connect Controller save Entity
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			}
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcWeb3ConnectController_saveEntity') data

    #----------------------------------
   	@WcWeb3ConnectController_findOneByUId
 	Scenario: Wc Web3Connect Controller find One By UId
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)"
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcWeb3ConnectController_findOneByUId') data

   	@WcWeb3ConnectController_updateOneById
 	Scenario: Wc Web3Connect Controller update One By Id
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)"
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcWeb3ConnectController_updateOneById') data

   	@WcWeb3ConnectController_delete
 	Scenario: Wc Web3Connect Controller delete
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)"
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcWeb3ConnectController_delete') data

    #----------------------------------
   	@WcWeb3ConnectController_hardDelete
 	Scenario: Wc Web3Connect Controller hard Delete
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)"
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcWeb3ConnectController_hardDelete') data

    #----------------------------------
   	@WcRequestWeb3ConnectController_getListEntity
 	Scenario: Wc Request Web3Connect Controller get List Entity
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
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
  		* call read(svc + 'walletConnectSvc.feature@WcRequestWeb3ConnectController_getListEntity') data

   	@WcRequestWeb3ConnectController_saveEntity
 	Scenario: Wc Request Web3Connect Controller save Entity
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			body: 
 			{
				id : '#(id)',
				wcAppId : '#(wcAppId)',
				wcAppEntityId : '#(wcAppEntityId)',
				vaultId : '#(vaultId)',
				externalReqId : '#(externalReqId)',
				externalWorkspaceId : '#(externalWorkspaceId)',
				externalVaultId : '#(externalVaultId)',
				externalWalletType : '#(externalWalletType)',
				fbRaw : '#(fbRaw)',
				status : '#(status)',
				isDeleted : '#(isDeleted)'
 			}
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcRequestWeb3ConnectController_saveEntity') data

	  @WcRequestWeb3ConnectController_validateQRCode
	Scenario: Wc Request Web3Connect Controller validate QR Code
		 * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
		 * def body = 'qrCode=' + qrCode + '&vaultId=' + vaultId
		 * def data = 
		 """
		 {
			headers: 
			{ 
			   authorization: '#(accessToken)',
			   "Content-Type":"application/x-www-form-urlencoded; charset=utf-8"
			},
			body: '#(body)'
		 }
		 """
		 * call read(svc + 'walletConnectSvc.feature@WcRequestWeb3ConnectController_saveEntity') data
   
    #----------------------------------
   	@WcRequestWeb3ConnectController_approveRequestWeb3Connect
 	Scenario: Wc Request Web3Connect Controller approve Request Web3Connect
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)"
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcRequestWeb3ConnectController_approveRequestWeb3Connect') data

    #----------------------------------
   	@WcRequestWeb3ConnectController_findOneByUId
 	Scenario: Wc Request Web3Connect Controller find One By UId
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)"
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcRequestWeb3ConnectController_findOneByUId') data

   	@WcRequestWeb3ConnectController_updateOneById
 	Scenario: Wc Request Web3Connect Controller update One By Id
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)", 
 			body: 
 			{
				id : '#(id)',
				wcAppId : '#(wcAppId)',
				wcAppEntityId : '#(wcAppEntityId)',
				vaultId : '#(vaultId)',
				externalReqId : '#(externalReqId)',
				externalWorkspaceId : '#(externalWorkspaceId)',
				externalVaultId : '#(externalVaultId)',
				externalWalletType : '#(externalWalletType)',
				fbRaw : '#(fbRaw)',
				status : '#(status)',
				isDeleted : '#(isDeleted)'
 			}
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcRequestWeb3ConnectController_updateOneById') data

   	@WcRequestWeb3ConnectController_delete
 	Scenario: Wc Request Web3Connect Controller delete
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)"
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcRequestWeb3ConnectController_delete') data

    #----------------------------------
   	@WcRequestWeb3ConnectController_getPaginationConfig
 	Scenario: Wc Request Web3Connect Controller get Pagination Config
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			}
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcRequestWeb3ConnectController_getPaginationConfig') data

    #----------------------------------
   	@WcRequestWeb3ConnectController_hardDelete
 	Scenario: Wc Request Web3Connect Controller hard Delete
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)"
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcRequestWeb3ConnectController_hardDelete') data

    #----------------------------------
   	@WcRequestWeb3ConnectREPController_getListEntity
 	Scenario: Wc Request Web3Connect REPController get List Entity
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			params: 
 			{
				limit : "#(typeof limit == 'undefined' ? '' : limit)", 
				offset : "#(typeof offset == 'undefined' ? '' : offset)", 
				searchText : "#(typeof searchText == 'undefined' ? '' : searchText)", 
				ids : "#(typeof ids == 'undefined' ? '' : ids)", 
				where : "#(typeof where == 'undefined' ? '' : where)", 
				order : "#(typeof order == 'undefined' ? '' : order)", 
 			}
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcRequestWeb3ConnectREPController_getListEntity') data

   	@WcRequestWeb3ConnectREPController_saveEntity
 	Scenario: Wc Request Web3Connect REPController save Entity
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			body: 
 			{
				qrCode : '#(qrCode)',
				vaultId : '#(vaultId)',
				createdBy : '#(createdBy)',
 			}
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcRequestWeb3ConnectREPController_saveEntity') data

    #----------------------------------
   	@WcRequestWeb3ConnectREPController_submit
 	Scenario: Wc Request Web3Connect REPController submit
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			}
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcRequestWeb3ConnectREPController_submit') data

    #----------------------------------
   	@WcRequestWeb3ConnectREPController_findOneByUId
 	Scenario: Wc Request Web3Connect REPController find One By UId
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)"
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcRequestWeb3ConnectREPController_findOneByUId') data

   	@WcRequestWeb3ConnectREPController_updateOneById
 	Scenario: Wc Request Web3Connect REPController update One By Id
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)", 
 			body: 
 			{
				qrCode : '#(qrCode)',
				vaultId : '#(vaultId)',
				createdBy : '#(createdBy)'
 			}
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcRequestWeb3ConnectREPController_updateOneById') data

   	@WcRequestWeb3ConnectREPController_delete
 	Scenario: Wc Request Web3Connect REPController delete
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)", 
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcRequestWeb3ConnectREPController_delete') data

    #----------------------------------
   	@WcRequestWeb3ConnectREPController_hardDelete
 	Scenario: Wc Request Web3Connect REPController hard Delete
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)"
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcRequestWeb3ConnectREPController_hardDelete') data

    #----------------------------------
   	@WcRequestWeb3ConnectREPController_getPaginationConfig
 	Scenario: Wc Request Web3Connect REPController get Pagination Config
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			}
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcRequestWeb3ConnectREPController_getPaginationConfig') data

    #----------------------------------
   	@WcAppEntityController_findOneByUId
 	Scenario: Wc App Entity Controller find One By UId
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)"
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcAppEntityController_findOneByUId') data

   	@WcAppEntityController_updateOneById
 	Scenario: Wc App Entity Controller update One By Id
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)", 
 			body: 
 			{
				wcAppId : '#(wcAppId)',
				entityId : '#(entityId)',
				entityCountryCode : '#(entityCountryCode)',
 			}
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcAppEntityController_updateOneById') data

   	@WcAppEntityController_delete
 	Scenario: Wc App Entity Controller delete
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)"
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcAppEntityController_delete') data

    #----------------------------------
   	@WcAppEntityController_hardDelete
 	Scenario: Wc App Entity Controller hard Delete
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)"
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcAppEntityController_hardDelete') data

    #----------------------------------
   	@WcAppEntityController_getPaginationConfig
 	Scenario: Wc App Entity Controller get Pagination Config
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			}
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcAppEntityController_getPaginationConfig') data

    #----------------------------------
   	@WcAppEntityController_getListEntity
 	Scenario: Wc App Entity Controller get List Entity
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
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
  		* call read(svc + 'walletConnectSvc.feature@WcAppEntityController_getListEntity') data

   	@WcAppEntityController_saveEntity
 	Scenario: Wc App Entity Controller save Entity
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			body: 
 			{
				wcAppId : '#(wcAppId)',
				entityId : '#(entityId)',
				entityCountryCode : '#(entityCountryCode)'
 			}
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcAppEntityController_saveEntity') data

    #----------------------------------
   	@WcAppEntityREPController_findOneByUId
 	Scenario: Wc App Entity REPController find One By UId
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)"
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcAppEntityREPController_findOneByUId') data

   	@WcAppEntityREPController_updateOneById
 	Scenario: Wc App Entity REPController update One By Id
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)", 
 			body: 
 			{
				wcAppId : '#(wcAppId)',
				entityId : '#(entityId)',
				entityCountryCode : '#(entityCountryCode)'
 			}
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcAppEntityREPController_updateOneById') data

   	@WcAppEntityREPController_delete
 	Scenario: Wc App Entity REPController delete
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)"
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcAppEntityREPController_delete') data

    #----------------------------------
   	@WcAppEntityREPController_hardDelete
 	Scenario: Wc App Entity REPController hard Delete
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)"
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcAppEntityREPController_hardDelete') data

    #----------------------------------
   	@WcAppEntityREPController_getPaginationConfig
 	Scenario: Wc App Entity REPController get Pagination Config
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			}
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcAppEntityREPController_getPaginationConfig') data

    #----------------------------------
   	@WcAppEntityREPController_getListEntity
 	Scenario: Wc App Entity REPController get List Entity
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
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
  		* call read(svc + 'walletConnectSvc.feature@WcAppEntityREPController_getListEntity') data

   	@WcAppEntityREPController_saveEntity
 	Scenario: Wc App Entity REPController save Entity
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			body: 
 			{
				wcAppId : '#(wcAppId)',
				entityId : '#(entityId)',
				entityCountryCode : '#(entityCountryCode)'
 			}
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcAppEntityREPController_saveEntity') data

    #----------------------------------
   	@WcAdapterREPController_getPaginationConfig
 	Scenario: Wc Adapter REPController get Pagination Config
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			}
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcAdapterREPController_getPaginationConfig') data

    #----------------------------------
   	@WcAdapterREPController_getListEntity
 	Scenario: Wc Adapter REPController get List Entity
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
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
  		* call read(svc + 'walletConnectSvc.feature@WcAdapterREPController_getListEntity') data

   	@WcAdapterREPController_saveEntity
 	Scenario: Wc Adapter REPController save Entity
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			}
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcAdapterREPController_saveEntity') data

    #----------------------------------
   	@WcAdapterREPController_findOneByUId
 	Scenario: Wc Adapter REPController find One By UId
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)"
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcAdapterREPController_findOneByUId') data

   	@WcAdapterREPController_updateOneById
 	Scenario: Wc Adapter REPController update One By Id
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)"
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcAdapterREPController_updateOneById') data

   	@WcAdapterREPController_delete
 	Scenario: Wc Adapter REPController delete
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)"
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcAdapterREPController_delete') data

    #----------------------------------
   	@WcAdapterREPController_hardDelete
 	Scenario: Wc Adapter REPController hard Delete
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)"
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcAdapterREPController_hardDelete') data

    #----------------------------------
   	@WcAppAdapterController_findOneByUId
 	Scenario: Wc App Adapter Controller find One By UId
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)"
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcAppAdapterController_findOneByUId') data

   	@WcAppAdapterController_updateOneById
 	Scenario: Wc App Adapter Controller update One By Id
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)", 
 			body: 
 			{
				wcAppId : '#(wcAppId)',
				wcAdapterId : '#(wcAdapterId)',
				effectiveDate : '#(effectiveDate)'
 			}
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcAppAdapterController_updateOneById') data

   	@WcAppAdapterController_delete
 	Scenario: Wc App Adapter Controller delete
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)"
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcAppAdapterController_delete') data

    #----------------------------------
   	@WcAppAdapterController_hardDelete
 	Scenario: Wc App Adapter Controller hard Delete
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)"
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcAppAdapterController_hardDelete') data

    #----------------------------------
   	@WcAppAdapterController_getPaginationConfig
 	Scenario: Wc App Adapter Controller get Pagination Config
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			}
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcAppAdapterController_getPaginationConfig') data

    #----------------------------------
   	@WcAppAdapterController_getListEntity
 	Scenario: Wc App Adapter Controller get List Entity
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
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
  		* call read(svc + 'walletConnectSvc.feature@WcAppAdapterController_getListEntity') data

   	@WcAppAdapterController_saveEntity
 	Scenario: Wc App Adapter Controller save Entity
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			body: 
 			{
				wcAppId : '#(wcAppId)',
				wcAdapterId : '#(wcAdapterId)',
				effectiveDate : '#(effectiveDate)'
 			}
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcAppAdapterController_saveEntity') data

    #----------------------------------
   	@WcApplicationREPController_getListEntity
 	Scenario: Wc Application REPController get List Entity
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
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
  		* call read(svc + 'walletConnectSvc.feature@WcApplicationREPController_getListEntity') data

   	@WcApplicationREPController_saveEntity
 	Scenario: Wc Application REPController save Entity
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			body: 
 			{
				name : '#(name)',
				url : '#(url)',
				externalId : '#(externalId)',
				destinationNote : '#(destinationNote)',
				logo : '#(logo)',
				isWarm : '#(isWarm)',
				isCold : '#(isCold)',
				allowedEntities : '#(allowedEntities)'
 			}
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcApplicationREPController_saveEntity') data

    #----------------------------------
   	@WcApplicationREPController_findOneByUId
 	Scenario: Wc Application REPController find One By UId
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)" 
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcApplicationREPController_findOneByUId') data

   	@WcApplicationREPController_updateOneById
 	Scenario: Wc Application REPController update One By Id
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)", 
 			body: 
 			{
				name : '#(name)',
				url : '#(url)',
				externalId : '#(externalId)',
				destinationNote : '#(destinationNote)',
				logo : '#(logo)',
				isWarm : '#(isWarm)',
				isCold : '#(isCold)'
 			}
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcApplicationREPController_updateOneById') data

   	@WcApplicationREPController_delete
 	Scenario: Wc Application REPController delete
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)"
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcApplicationREPController_delete') data

    #----------------------------------
   	@WcApplicationREPController_hardDelete
 	Scenario: Wc Application REPController hard Delete
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			},
 			id : "#(typeof id == 'undefined' ? '' : id)"
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcApplicationREPController_hardDelete') data

    #----------------------------------
   	@WcApplicationREPController_getPaginationConfig
 	Scenario: Wc Application REPController get Pagination Config
  		* def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
  		* def data = 
  		"""
  		{
 			headers: 
 			{ 
				authorization: '#(accessToken)'
 			}
  		}
  		"""
  		* call read(svc + 'walletConnectSvc.feature@WcApplicationREPController_getPaginationConfig') data

    #----------------------------------
    @VaultWcController_getPaginationConfig
  Scenario: Vault Wc Controller get Pagination Config
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
   	* call read(svc + 'coreSvc.feature@VaultWcController_getPaginationConfig') data

    #----------------------------------
    @VaultWcController_getListEntity
  Scenario: Vault Wc Controller get List Entity
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
 			limit : "#(typeof limit == 'undefined' ? 10 : limit)", 
 			offset : "#(typeof offset == 'undefined' ? 0 : offset)", 
 			where : "#(typeof where == 'undefined' ? '' : where)", 
 			order : "#(typeof order == 'undefined' ? '' : order)"
  		}
   	}
   	"""
   	* call read(svc + 'coreSvc.feature@VaultWcController_getListEntity') data

    @VaultWcController_saveEntity
  Scenario: Vault Wc Controller save Entity
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
   	* call read(svc + 'coreSvc.feature@VaultWcController_saveEntity') data

    #----------------------------------
    @VaultWcController_getListVaultSelection
  Scenario: Vault Wc Controller get List Vault Selection
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
 			limit : "#(typeof limit == 'undefined' ? 20 : limit)", 
 			offset : "#(typeof offset == 'undefined' ? 0 : offset)", 
 			searchText : "#(typeof searchText == 'undefined' ? '' : searchText)", 
 			ids : "#(typeof ids == 'undefined' ? '' : ids)", 
 			where : "#(typeof where == 'undefined' ? '{\"OR\":[{\"name\":{\"CONTAINS\":\"\"}}]}' : where)", 
 			order : "#(typeof order == 'undefined' ? '' : order)" 
  		}
   	}
   	"""
   	* call read(svc + 'coreSvc.feature@VaultWcController_getListVaultSelection') data

    #----------------------------------
    @VaultWcController_findOneByUId
  Scenario: Vault Wc Controller find One By UId
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
   	* call read(svc + 'coreSvc.feature@VaultWcController_findOneByUId') data

    @VaultWcController_updateOneById
  Scenario: Vault Wc Controller update One By Id
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
   	* call read(svc + 'coreSvc.feature@VaultWcController_updateOneById') data

    @VaultWcController_delete
  Scenario: Vault Wc Controller delete
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
   	* call read(svc + 'coreSvc.feature@VaultWcController_delete') data

    #----------------------------------
    @VaultWcController_hardDelete
  Scenario: Vault Wc Controller hard Delete
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
   	* call read(svc + 'coreSvc.feature@VaultWcController_hardDelete') data
