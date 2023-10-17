Feature: Test net faucet 

    @DepositXRP
    Scenario: Deposit for XRP
        Given url 'https://faucet.tequ.dev/api/faucet'
        And header Content-Type = 'text/plain;charset=UTF-8'
        And request {"type":"XRP","account":"#(address)","network":"Testnet"}
        When method POST
        Then status 200
        
