Feature: Test net faucet 

    @DepositXRP
    Scenario: Deposit for XRP
        Given url 'https://test.xrplexplorer.com/api/cors/v2/faucet'
        And headers {"Content-Type": 'application/json', "origin":'https://test.xrplexplorer.com'}
        And request {"cf-turnstile-response":"0.1gF0OjAJLcI-u37vHdeyAEOCSgyQsU66CKBjORmgSU5QKhmsk7Kq-so2bDHHk7XDiPNiCK9CJTOnOQ3cTIul1c1lORxvbeZsZ-AjdqE6YiTaHz2lx6Px4YnsX8EUiOpeGeNEcUHRA-LdyNs6bx6_sIpSW_IuM4wY8TO-G_3eQWbhaiqtV6BEPx8crhX2eHQV5ZGNj5NT3n6CdZ3iUoI7U8W0YujMt-S3-xHJ2yCjQiIjMVzShzYmZiBl9y0Rl-KsYfwJ7fUe7d2kzPg1ofEIL7ay639NQToqojwBItf1LcxveVmPZr-aOJDAbOh5k3i_Xf4ED_DNoTS6c8HfGTl4dddMbFQl-e59OdMLMIdWb_iOePpRAB7f84sph-MBSE3DtCIxQtJSC_AhS2ppIseC_8ikS6uv-XzuBTmYAQtgFwhiaqrIKoLVs-T2CDjtmCxx61SBWzs_KTWYca4hDEvgvyLbAg4P6yunlpODpiA2qWMuli2UM8drBxtB7n5IHKWvfHOaXmo20z_3e4vZdCB48s5bSzV1ceqqHwEHJ9U2AfvHMCaqCq0uron5xnYqVcqYm63Sdx_oTI4EarU0KeGz8ZC3B2b_bsJ8nDwoNekEk1-qI5d9AGQivTK02WwVxpV_iJGzSpGRTczi_Se8V46UNEfEdW3l9m8SfXhqoV6JLKaE-_8W9yiKQvHOn56LP7Qjpvz3VPuVFDOS9BCjTG82_c0RQpdRdNS9WVXb_zM0EYWWUuB-CYz3Vg9jegdejS8K8O1nwcqwL4lS2agOZmLwDBR_cAcRZv3FNu8sbcTDrBYINmpC0zq9dQ_Tm4yrfFl3m7KGdG35s3ZrhJmfRMZAjXejY7hKBWXokf0UwOeFOEiGgfCWZRb9s6FdP0vI_V96lz34meoEUWncaWyaR2EB3w.cMOildpYfm_E_qFfNyndRw.818520ef257da909bc6ae923ce47269d89a7c6a2937bd081209dd385a971a310","address":"#(address)","destinationTag":"#(destinationTag)","amount":"100000000"}
        When method POST
        Then status 200

    @DepositADA
    Scenario: Deposit for ADA
        Given url 'https://faucet.tequ.dev/api/faucet'
        And header Content-Type = 'text/plain;charset=UTF-8'
        And request {"type":"XRP","account":"#(address)","network":"Testnet"}
        When method POST
        Then status 200
        
