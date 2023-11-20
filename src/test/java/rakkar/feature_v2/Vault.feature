@RAKCON-10583
Feature: Vault
    Background:
        * callonce read(svc + 'ReadData.feature')
        * callonce read(svc + 'Auth.feature@GetRequesterAccessToken')
        * def getRequesterInfo = callonce read(svc + 'Auth.feature@GetRequesterInfo')
    
    @CheckVaultNameCommon
    Scenario: Check vault name common
