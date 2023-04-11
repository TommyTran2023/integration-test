@RAKCON-10950 @ignore
Feature: Home Page

  Background:
    * url baseURL
    * call read('RequesterAuthenticator.feature@RequesterAccessToken')

  @RAKCON-11657 @AssetAllocationChart
  Scenario: View chart of Asset Allocation
    Given path 'core/assets/chart'
    * param type = 'ALL'
    When method GET
    Then status 200
    * def assetsSchema = {"id":"#string", "symbol":"#string", "totalUSD":#number, "image":"##string", "network":"#string"}
    * def responseSchema = {"assets":"#[]assetsSchema", "totalUSD":#number}
    * match response.data == responseSchema

  @RAKCON-10977 @AssetAllocationDetail
  Scenario: View Asset Allocation detail at Home Page
    Given path '/core/assets/allocation-detail'
    * param offset = 0
    When method GET
    Then status 200
    * def tokenSchema = {"symbol":"#string", "networkImage":"##string", "id":"#string", "totalUSD":#number, "image":"##string", "type":"#string", "name":"#string"}
    * def responseSchema = {"total":#number, "tokens":"#[]tokenSchema"}
    * match response.data == responseSchema

  @RAKCON-10978 @PortfolioView
  Scenario: Portfolio view
    Given path '/core/vault/accounts/portfolio-chart'
    * def getDate =
      """
      function(numberOfDays){
        var date = new Date();
        date.setDate(date.getDate() + (numberOfDays));
        return date.toISOString()
      }
      """
    #Default date from and date to is previous 7 days
    * param dateFrom = getDate(-7)
    * param dateTo = getDate(-1)
    When method GET
    Then status 200
    * def chartDataSchema = {"date":#? getDate(_)", "value":#number}
    * def responseSchema = {"chartData":"#[]chartDataSchema", "percentageDifference":#number}