Feature: Assets
    # /core/assets

    @GetAssetsInAllAccountVaults
    Scenario: Get Assets In All Account Vaults
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
        {
            authorization: #(accessToken),
            type: #(type)
        }
        """
        * call read(svc + 'coreSvc.feature@GetAssetsInAllAccountVaults') data

    @GetAssetShortcuts
    Scenario: Get list asset shortcuts
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def keyword = karate.get('keyword','')
        * def sort = karate.get('sort','ASC')
        * def data =
        """
        {
            authorization: #(accessToken),
            data:{
            keyword: #(keyword),
            sort: #(sort)
            }
        }
        """
        * call read(svc + 'coreSvc.feature@GetAssetShortcuts') data
  
    @GetAssetShortcutDetail
    Scenario: Get detail asset shortcuts 
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
        {
            authorization: #(accessToken),
            shortcutId: #(shortcutId)
        }
        """
        * call read(svc + 'coreSvc.feature@GetAssetShortcutDetail') data
     
    @RenameShortcut
    Scenario: Get detail asset shortcuts 
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
        {
            authorization: #(accessToken),
            shortcutId: #(shortcutId),
            name: #(name)
        }
        """
        * call read(svc + 'coreSvc.feature@RenameShortcut') data
      
    @GetAssetsInterested
    Scenario: Get value assets of user interested
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * call read(svc + 'coreSvc.feature@GetAssetsInterested') {authorization:#(accessToken)}
    
    @UpdateAssetsInterested
    Scenario: Update value assets of user interested
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body:{
                externalAssetIds:#(externalAssetIds),
                unFavourite:#(unFavourite)
            }
        }
        """
        * call read(svc + 'coreSvc.feature@UpdateAssetsInterested') data
      
    @GetTokenPrices
    Scenario: Get value assets
        * def keyword = karate.get('keyword','')
        * def sort = karate.get('sort','ASC')
        * def favoriteOrder = karate.get('favoriteOrder',false)
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            params: {
                keyword: '#(keyword)',
                limit: 10,
                offset: 0,
                sort: #(sort),
                favoriteOrder: #(favoriteOrder)
            }
        }
        """
        * call read(svc + 'coreSvc.feature@GetTokenPrices') data
    
    @CreateShortcut
    Scenario: Create shortcut asset
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body: {
                externalAssetId : #(externalAssetId),
                sourceId : #(sourceId),
                destinationId : #(destinationId),
                destinationType : #(destinationType),
                name : #(name),
                isFromDetail : #(isFromDetail)
            }
        }
        """
        * call read(svc + 'coreSvc.feature@CreateShortcut') data
    
    @DeleteShortcut
    Scenario: Delete shortcut asset
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body:{
                shortcutIds:#(shortcutIds)
            }
        }
        """
        * call read(svc + 'coreSvc.feature@DeleteShortcut') data
    
    @GetShortcutName
    Scenario: Get name of shortcut asset
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            body:{
                externalAssetId : #(externalAssetId),
                sourceId : #(sourceId),
                destinationId : #(destinationId),
                destinationType : #(destinationType)
            }
        }
        """
        * call read(svc + 'coreSvc.feature@GetShortcutName') data
    
    @CheckShortcutNameExists
    Scenario: Get name of shortcut asset
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data = 
        """
        {
            authorization: #(accessToken),
            shortcutName: {shortcutName}
        }
        """
        * call read(svc + 'coreSvc.feature@CheckShortcutNameExists') data
    
    @DeleteShortcutById
    Scenario: Delete shortcut by Id
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
        {
            authorization: #(accessToken),
            shortcutId: #(shortcutId)
        }
        """
        * call read(svc + 'coreSvc.feature@DeleteShortcutById') data
    
    @CheckExistingShortcut
    Scenario: Check existing asset shortcuts
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def data =
        """
        {
            authorization: #(accessToken),
            params:{
                externalAssetId : #(externalAssetId),
                sourceId : #(sourceId),
                destinationId : #(destinationId),
                destinationType : #(destinationType)
            }
        }
        """
        * call read(svc + 'coreSvc.feature@CheckExistingShortcut') data
        
    @AllocationDetail
    Scenario: Get asset allocation detail 
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * def keyword = karate.get('keyword','')
        * def sort = karate.get('sort','ASC')
        * def data =
        """
        {
            authorization: #(accessToken),
            params:{
                keyword : #(keyword),
                sort : #(sort), 
                limit: 10,
                offset: 0,
                externalAssetId: #(externalAssetId),
                type: #(type)
            }
        }
        """
        * call read(svc + 'coreSvc.feature@AllocationDetail') data

    @GetListAssetsStaking
    Scenario: Get List Assets Staking
        * def accessToken = typeof accessToken == 'undefined' ? requesterAccessToken : accessToken
        * call read(svc + 'coreSvc.feature@AllocationDetail') {authorization:#(accessToken)}
