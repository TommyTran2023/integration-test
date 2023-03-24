# Karate-Rakkar Integration Testing

### Introduction
The project focus on function test by API testing which you can make GET, PUT, POST and DELETE requests.

### Prerequisites
The project is developed in Java with Maven, so it will install the following software:
* Oracle Java 11 SDK
* Apache Maven
* Node JS
* Your favorite IDE, including : Eclipse IDE, Intellij IDEA

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
To run specific test case or test execution, click on Run icon in specific scenario/feature