    @TestRequesterDoBiometric
Feature: Accessing Jenkins secrets

@ignore
  Scenario: Read secrets from JSON file
    * def secretFilePath = karate.env('rakkar_auto_secret')
    * def secrets = read(secretFilePath)
    * print secrets

  
  Scenario: TestRequesterDoBiometric
    * print privateKey
    * call read(svc + 'Biometric.feature@RequesterDoBiometric')
    * call read(svc + 'Biometric.feature@ApproverDoBiometric')
    * def data = 
    """
    {
      userName: "#(requesterInfo.requesterUsername)",
      customAnswer: "#(privateKey.challengeAnswerAuth)"
    }
    """
    * call read(svc + 'Auth.feature@GetUserAccessToken') data