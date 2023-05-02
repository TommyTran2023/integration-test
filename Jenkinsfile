def SLACK_CHANNEL = "rakkar-alert-automation-test"
def TEAM_URL = "https://rakkardigital.webhook.office.com/webhookb2/52be9657-ee4e-4e80-b129-ff3321a59709@201a91bf-99c5-4514-99f9-725c381f0f8f/JenkinsCI/4cce63699dd64472878a3bc7d767d694/98b4bffe-269c-449b-8152-e60965a8c794"
// def ENV = "SIT" // will be passed as parameter
def KARATE_ENV = "qa"
def testSummary
def failedTestMsg = []
def failedScenarios = []

pipeline {
    agent any
    parameters {
        choice(name: 'ENV', choices: 'SIT\nUAT', description: 'Test Environment [SIT, UAT, PROD]')
    }
    stages {
        stage ('Git Checkout') {
            steps {
                git branch: 'develop',
                credentialsId: 'github',
                url: 'https://github.com/rakkar-digital-org/integration-test.git'
            }
        }

        stage ('Test Execution') {
            steps {
                script {
                    //default KARATE_ENV = qa
                    if (params.ENV == "PROD") {
                        KARATE_ENV = "prod"
                    } else if (params.ENV == "UAT") {
                        KARATE_ENV = "uat"
                    }
                    echo "KARATE_ENV = ${KARATE_ENV}"
                    withMaven(maven: 'Maven') {
                        sh "mvn test -Dkarate.env=${KARATE_ENV}"
                    }
                }
            }
        }
    }

    post {

        always {
            script {
                testSummary = junit testResults: 'target/karate-reports/**/*.xml'

                def testResultAction = currentBuild.rawBuild.getAction(hudson.tasks.junit.TestResultAction.class)
                if (testResultAction != null) {
                    failingTests = testResultAction.getResult().getResultInRun(currentBuild.rawBuild).getFailedTests()
                    // remove karate testParallel()
                    for (test in failingTests[0..-2]) {
                        failedTestMsg.push("Scenario: " + test.getName() + "\n Error: " + test.getErrorDetails())
                        failedScenarios.push(test.getName())
                    }
                } else {
                    // No tests were run in this build, nothing left to do.
                    failingTests = []
                    failedTestMsg = []
                    failedScenarios = []
                }
            }

            archiveArtifacts artifacts: 'target/karate-reports/**/*'
            publishHTML(target : [allowMissing: false,
                alwaysLinkToLastBuild: true,
                keepAll: true,
                reportDir: './target/karate-reports',
                reportFiles: 'karate-summary.html',
                reportName: 'HTML Report',
                reportTitles: 'Test Report'])

            script {
                for (file in findFiles(glob: 'target/karate-reports/**/rakkar.feature*.json')) {
                    def testName = "${ENV} (#${BUILD_NUMBER}) Integration Test results - ${file}"
                    step([$class: 'XrayImportBuilder',
                        endpointName: '/cucumber/multipart',
                        importFilePath: "${file}",
                        importInParallel: 'false',
                        testImportInfo: """{
                          "fields": {
                              "project": {
                                 "key": "RAKCON"
                              },
                              "summary": "${testName}",
                              "issuetype": {
                                "id": "10035"
                              }
                          },
                          "xrayFields": {
                              "testPlanKey": "RAKCON-10583",
                              "environments": ["${ENV}"]
                          }
                        }""",
                        inputTestInfoSwitcher: 'fileContent',
                        importInfo: """{
                            "fields": {
                                "project": {
                                    "key": "RAKCON"
                                },
                              "summary": "${testName}",
                              "issuetype": {
                                "id": "10035"
                              },
                              "labels" : ["${ENV}"]
                            },
                          "xrayFields": {
                              "testPlanKey": "RAKCON-10583",
                              "environments": ["${ENV}"]
                          }
                        }""",
                        inputInfoSwitcher: 'fileContent',
                        serverInstance: 'CLOUD-1b5e32d0-990a-47a2-8b27-a7b839848221'])
                }
            }
        }

        changed {
            script {
                def successMsg = "${ENV} Integration Test #${env.BUILD_NUMBER} back to PASSED"
                def passedSummary = "*Test Summary* - ${testSummary.totalCount}\n" +
                "Failures: ${testSummary.failCount}, Skipped: ${testSummary.skipCount}, Passed: ${testSummary.passCount}"
                if (currentBuild.currentResult  == "SUCCESS") {
                    slackSend(channel: "${SLACK_CHANNEL}",
                        color: 'good',
                        message: "${successMsg} (<${env.BUILD_URL}|Open>)\n${passedSummary}")

                    office365ConnectorSend color: '#4b8869',
                        message: "${successMsg}<br>${passedSummary}",
                        status: 'PASSED',
                        webhookUrl: "${TEAM_URL}"
                }
            }
        }

        failure {
            script {
                def buildSummary = "${ENV} Integration Test #${env.BUILD_NUMBER} FAILED"
                def failedSummary = "*Test Summary* - ${testSummary.totalCount}\n" +
                "Failures: ${testSummary.failCount}, Skipped: ${testSummary.skipCount}, Passed: ${testSummary.passCount}"
                def failedScenarios = "*Failed Scenarios*\n" +
                "${failedScenarios.join(', ')}"
                def failedDetails = "*Failed Test:*\n" +
                "${failedTestMsg.join('\n\n')}"

                slackSend(channel: "${SLACK_CHANNEL}",
                    color: 'danger',
                    message: "${buildSummary} (<${env.BUILD_URL}|Open>)\n${failedSummary}\n\n${failedDetails}")

                office365ConnectorSend color: '#a82e2e',
                    message: "${buildSummary}<br>${failedSummary}",
                    status: 'FAILED',
                    webhookUrl: "${TEAM_URL}",
                    factdefinitions:[
                        [ name: "Failed Scenarios", template: "${failedScenarios.join(', ')}"],
                        [ name: "Error", template: "${failedTestMsg.join('<br><br>')}"]
                    ]
            }
        }
    }
}
