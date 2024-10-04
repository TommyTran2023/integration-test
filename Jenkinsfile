def SLACK_CHANNEL = "rakkar-alert-automation-test"
// def TEAM_URL = "https://rakkardigital.webhook.office.com/webhookb2/52be9657-ee4e-4e80-b129-ff3321a59709@201a91bf-99c5-4514-99f9-725c381f0f8f/JenkinsCI/4cce63699dd64472878a3bc7d767d694/98b4bffe-269c-449b-8152-e60965a8c794"
// def ENV = "SIT" // will be passed as parameter
def KARATE_ENV = "qa"
def BRANCH = "develop"
def HEALTH_CHECK_PATH
def testSummary
def testType
def failedTestMsg = []
def failedScenarios = []
def serviceStatus
def PASSWORD
def USERNAME
def DBNAME

pipeline {
    agent {
        label "gcp-slave-agent-jmeter"
    }

    environment {
        DB_SIT = credentials('rakkar-db-credentials-sit')
        DB_UAT = credentials('rakkar-db-credentials-uat')
        DB_DEV = credentials('rakkar-db-credentials-dev')
    }

    parameters {
        choice(name: 'ENV', choices: 'SIT\nUAT\nDEV', description: 'Test Environment [SIT, UAT, DEV]')
        booleanParam(name: 'XRAY', defaultValue: true, description: 'Record result to Xray')
        booleanParam(name: 'E2E', defaultValue: false, description: 'Select this to run E2E flow (Tests with @e2e tag)')
    }

    triggers {
        cron(env.BRANCH_NAME == 'uat' ? '00 10 * * 1' : env.BRANCH_NAME == 'sit' ? '00 19 * * 1-5' : '')
    }

    stages {
        stage ('Initialize settings') {
            steps {
                // update branch and test environment
                script {
                    def credentials = null

                    if (env.BRANCH_NAME == 'main'){
                            BRANCH = "main"
                            KARATE_ENV = "prod"
                            HEALTH_CHECK_PATH = "prod"
                    }
                    else if (env.BRANCH_NAME == 'uat' || params.ENV == 'UAT'){
                            BRANCH = "uat"
                            KARATE_ENV = "uat"
                            HEALTH_CHECK_PATH = "uat"   
                            credentials = readJSON file: DB_UAT
                    }
                    else if (env.BRANCH_NAME == 'develop' || params.ENV == 'DEV'){
                            BRANCH = "develop"
                            KARATE_ENV = "dev"
                            HEALTH_CHECK_PATH = "dev"
                            credentials = readJSON file: DB_DEV
                    }
                    else {
                            BRANCH = "sit"
                            KARATE_ENV = "qa"
                            HEALTH_CHECK_PATH = "sit"
                            credentials = readJSON file: DB_SIT
                    }

                    env.BRANCH = BRANCH
                    env.KARATE_ENV = KARATE_ENV
                    env.testType = params.E2E ? "E2E Integration Test" : "Integration Test"

                    USERNAME = credentials['core-svc']['DATABASE_USERNAME']
                    PASSWORD = credentials['core-svc']['DATABASE_PASSWORD']
                    DBNAME = credentials['core-svc']['DATABASE_NAME']
                }
            }
        }

        // stage ('Git Checkout') {
        //     steps {

        //         git branch: "${BRANCH}",
        //             credentialsId: 'github',
        //             url: 'https://github.com/rakkar-digital-org/integration-test.git'
        //     }
        // }

        stage ('Check Service Status') {
            steps {
                script {
                    serviceStatus = sh(script: "/bin/bash checkService.sh ${HEALTH_CHECK_PATH} > status.txt", returnStatus: true)
                    
                    // Aborting build if checkService error
                    if (serviceStatus != 0) {
                        def serviceStatusMsg = readFile('status.txt').trim()
                        currentBuild.result = 'FAILED'

                        slackSend(channel: "${SLACK_CHANNEL}",
                            color: 'danger',
                            message: "${BRANCH} ${env.testType} #${env.BUILD_NUMBER}: ABORTED\n${serviceStatusMsg}")

                        // office365ConnectorSend color: '#a82e2e',
                        //     message: "${ENV} ${testType} #${env.BUILD_NUMBER}: ABORTED<br>${serviceStatusMsg}",
                        //     status: 'FAILED',
                        //     webhookUrl: "${TEAM_URL}"

                        error("Abort the build because services healthcheck return error")
                    }
                }
            }
        }

        stage ('Build Image') {
            steps {
                script {
                    sh "make clean"
                    sh "make build"
                }
            }
        }
    
        stage ('Test Execution') {
            steps {
                script {
                    // This step will only be executed if the serviceStatus = 0
                    echo "KARATE_ENV = ${KARATE_ENV}"
                    def tag = params.E2E ? "@e2e" : "~@e2e"
                    env.COMMAND = "mvn clean test -Dkarate.env=${KARATE_ENV} -Dkarate.options='--tags @TestRequesterDoBiometric' -D userName='${USERNAME}' -D pass='${PASSWORD}' -D dbName='${DBNAME}' -D rerun='true' -D runMode='JENKINS'"
                    
                    env.JENKINS_USER = sh(script: "id -u", returnStdout: true).trim()
                    env.JENKINS_GROUP = sh(script: "id -g", returnStdout: true).trim()
                    env.JENKINS_PWD = pwd()
                    
                    sh "make run"
                    
                }
            }
        }
    }

    // post {

    //     always {

    //         script {

    //             //continue gather the result if checkService pass and the test was executed
    //             testSummary = junit testResults: 'target/karate-reports/**/*.xml'

    //             def testResultAction = currentBuild.rawBuild.getAction(hudson.tasks.junit.TestResultAction.class)
    //             if (testResultAction != null) {
    //                 failingTests = testResultAction.getResult().getResultInRun(currentBuild.rawBuild).getFailedTests()
    //                 for (test in failingTests) {
    //                 // skip testParallel from Karate
    //                     if (!test.getName().contains("testParallel")) {
    //                         failedTestMsg.push("Scenario: " + test.getName() + "\n Error: " + test.getErrorDetails())
    //                         failedScenarios.push(test.getName())
    //                     }
    //                 }
    //             } else {
    //                 // No tests were run in this build, nothing left to do.
    //                 failingTests = []
    //                 failedTestMsg = []
    //                 failedScenarios = []
    //             }
    //         }

    //         // Jenkins report
    //         archiveArtifacts artifacts: 'target/karate-reports/**/*,target/cucumber-html-reports/**/*'
    //         publishHTML(target : [allowMissing: false,
    //             alwaysLinkToLastBuild: true,
    //             keepAll: true,
    //             reportDir: './target/karate-reports',
    //             reportFiles: 'karate-summary.html',
    //             reportName: 'HTML Report',
    //             reportTitles: 'Test Report'])

    //         // record test result to Xray
    //         script {
    //             if (params.XRAY) {
    //                 for (file in findFiles(glob: 'target/karate-reports/**/rakkar.feature*.json')) {
    //                     def testName = "${BRANCH} (#${BUILD_NUMBER}) ${env.testType} results - ${file}"
    //                     step([$class: 'XrayImportBuilder',
    //                         endpointName: '/cucumber/multipart',
    //                         importFilePath: "${file}",
    //                         importInParallel: 'false',
    //                         testImportInfo: """{
    //                           "fields": {
    //                               "project": {
    //                                  "key": "RAKCON"
    //                               },
    //                               "summary": "${testName}",
    //                               "issuetype": {
    //                                 "id": "10035"
    //                               }
    //                           },
    //                           "xrayFields": {
    //                               "testPlanKey": "RAKCON-10583",
    //                               "environments": ["${ENV}"]
    //                           }
    //                         }""",
    //                         inputTestInfoSwitcher: 'fileContent',
    //                         importInfo: """{
    //                             "fields": {
    //                                 "project": {
    //                                     "key": "RAKCON"
    //                                 },
    //                               "summary": "${testName}",
    //                               "issuetype": {
    //                                 "id": "10035"
    //                               },
    //                               "labels" : ["${ENV}"]
    //                             },
    //                           "xrayFields": {
    //                               "testPlanKey": "RAKCON-10583",
    //                               "environments": ["${ENV}"]
    //                           }
    //                         }""",
    //                         inputInfoSwitcher: 'fileContent',
    //                         serverInstance: 'CLOUD-1b5e32d0-990a-47a2-8b27-a7b839848221'])
    //                 }
    //             }
    //         }
    //     }

    //     success {
    //         script {
    //             // Passed notification
    //             def successMsg = "${BRANCH} ${env.testType} #${env.BUILD_NUMBER} PASSED"
    //             def passedSummary = "*Test Summary* - ${testSummary.totalCount}\n" +
    //             "Failures: ${testSummary.failCount}, Skipped: ${testSummary.skipCount}, Passed: ${testSummary.passCount}"
    //             slackSend(channel: "${SLACK_CHANNEL}",
    //                 color: 'good',
    //                 message: "${successMsg} (<${env.BUILD_URL}|Open>)\n${passedSummary}")

    //             // office365ConnectorSend color: '#4b8869',
    //             //     message: "${successMsg}<br>${passedSummary}",
    //             //     status: 'PASSED',
    //             //     webhookUrl: "${TEAM_URL}"
    //         }
    //     }

    //     failure {
    //         script {
    //             // Failure details
    //             def buildSummary = "${BRANCH} ${env.testType} #${env.BUILD_NUMBER} FAILED"
    //             def failedSummary = "*Test Summary* - ${testSummary.totalCount}\n" +
    //             "Failures: ${testSummary.failCount}, Skipped: ${testSummary.skipCount}, Passed: ${testSummary.passCount}"
    //             def failedScenariosMsg = "*Failed Scenarios*\n" +
    //             "${failedScenarios.join(', ')}"
    //             def failedDetails = "*Failed Test:*\n" +
    //             "${failedTestMsg.join('\n\n')}"

    //             slackSend(channel: "${SLACK_CHANNEL}",
    //                 color: 'danger',
    //                 message: "${buildSummary} (<${env.BUILD_URL}|Open>)\n${failedSummary}\n\n${failedScenariosMsg}\n\n${failedDetails}")

    //             // MS Teams limitation
    //             def failedDetailsTeams = "${failedTestMsg.join('<br><br>')}".take(15000 - failedScenariosMsg.length())

    //             echo "Failed Scenarios: " + failedScenariosMsg.take(15000)
    //             echo "Failed Details: " + failedDetailsTeams

    //             // office365ConnectorSend color: '#a82e2e',
    //             //     message: "${buildSummary}<br>${failedSummary}",
    //             //     status: 'FAILED',
    //             //     webhookUrl: "${TEAM_URL}",
    //             //     factDefinitions:[
    //             //         [ name: "Failed Scenarios", template: "${failedScenariosMsg.take(15000)}"],
    //             //         [ name: "Error", template: "${failedDetailsTeams}"]
    //             //     ]
    //         }
    //     }
    // }
}
