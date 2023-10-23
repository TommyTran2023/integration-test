# Karate-Rakkar Integration Testing

### Introduction
The project focus on function test by API testing which you can make GET, PUT, POST and DELETE requests.

### Prerequisites
The project is developed in Java with Maven, so it will install the following software:
* Oracle Java 11 JDK
* Apache Maven
* Node JS
* Your favorite IDE, including : Eclipse IDE, Intellij IDEA, VS Code
* Onboarding account manually in REP site with corresponding environment (for example: https://uat-rep.rakkardigital.com/login) and add Username in /data/env_data.json

### Installation
_Below is the instruction to install and setting the project._
1. Clone the repo https://github.com/rakkar-digital-org/integration-test.git
2. Enter the environment which you want to integration test (Default: UAT, Available environment: UAT, QA) in "RunnerTest.java" file below the tag @BeforeAll

### Execute test locally
To run the test script in the local system, enter the root folder and execute the one of following commands:
```agsl
mvn clean install
mvn clean compile test
mvn test
```
To run the test script in the specific environment, enter following commands:
```agsl
mvn test -Dkarate.env=uat
mvn test -Dkarate.env=qa
```

To run the test script in parallel, number of thread can be passed from command line:
```
mvn test -Dkarate.env=qa -Dthread=4
```

To run only specific feature file:
```
mvn test -Dkarate.env=qa -Dkarate.options="classpath:rakkar/feature/Wallet.feature"
```

To run only specific tag:
```
mvn test -Dkarate.env=qa -Dkarate.options="--tags @VIEW-LIST-ASSET"
```

You can also click on Run icon in specific scenario/feature to run specific test case or test execution

### Execute performance test
`mvn clean gatling:test -Dkarate.env=pt -Dgatling.simulationClass=rakkar.pt.FeederSimulation`
`mvn clean gatling:test -Dkarate.env=pt`

### Setup user and data 
For each environment, it should have at least 5 users in the company using for test.There are 2 users need to get detailed information: 
1 user for send request, 1 user do approve. 
1. Create at least 5 users. Input the passcode of 2 specific users in env_data.json > {env} > passcode.
2. Add 2 specific data user in env_data.json
Note: In UAT, add users in "AT Rakkar" customer. In QA (SIT), add users in "RakkaR" customer

### Setup data transfer
For each environment, it should have specific vaults for transfer.
1. Create new vault with the name has the same vault's name in data_test.json > tranfer > withdraw, 
2. Add wallet = "XRP" for each vault. Deposit for all.
3. Add all infor needed to env_data.json: 
- VaultId
- TokenId
- Address
### Setup data for network management
For each enviroment, it should have specific profile and connection already approved manually by fire block.
### Setup data staking
Staking feature is focus on ADA token now. So for each enviroment, it should have ADA tokenId, config on env
1. Add ADA token into a specific vault
2. Get the tokenId, add into env file with field "stakeToken"
3. Prepare a vault already has staking,add vaultId to env file, to support for run unstake and change pool feature.

### Setup data for muti tenancy testing
For each enviroment,
1. It should have specific data on another customer. Describe in env_data.json > {env} > crossTenant
2. crossTenant customer should have a Vault name "Cross Tenant Vault"

### Run script for setup data
At the first time, GetData.feature under rakkar/createData folder should be run to get all data needed for test.
1. To get data for UAT
```
mvn clean test -Dkarate.env=uat -Dkarate.options="--tags @tags"
```
2. To get data for QA
```
mvn clean test -Dkarate.env=qa -Dkarate.options="--tags @tags"
```
3. New data_{env}.json file will be created under data folder. And data is stored by ```dataSet``` variable
Usage: ```dataSet.advanceHotVaultId```


