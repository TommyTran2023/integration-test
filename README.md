# Karate-Rakkar Integration Testing

### Introduction
The project focus on function test by API testing which you can make GET, PUT, POST and DELETE requests.

### Prerequisites
The project is developed in Java with Maven, so it will install the following software:
* Oracle Java 11 SDK
* Apache Maven
* Node JS
* Your favorite IDE, including : Eclipse IDE, Intellij IDEA
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

### Setup user and data 
For each environment, it should have at least 5 user in the company using for test.There are 2 users need to get detailed information: 
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

