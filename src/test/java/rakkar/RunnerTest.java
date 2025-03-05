package rakkar;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import com.intuit.karate.core.ScenarioResult;

import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import org.apache.commons.io.FileUtils;
import org.json.JSONArray;
import org.json.JSONObject;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class RunnerTest {
    private static final String XRAY_URL = "https://xray.cloud.getxray.app/api/v2/graphql";
    private static final String XRAY_AUTH_URL = "https://xray.cloud.getxray.app/api/v2/authenticate";

    @BeforeAll
    public static void before(){
        System.setProperty("karate.env", "sandbox");
    }

    @Test
    public void testParallel() {
        int threadCount = 1;

        if (System.getProperty("thread") != null) {
            threadCount = Integer.parseInt(System.getProperty("thread"));
        }

        System.out.println("Running in " + threadCount + " threads");

        // Get the testSetKey from system properties
        String testSetKey = System.getProperty("karate.testSetKey");
        System.out.println("Running tests with testSetKey: " + testSetKey);

        // Fetch test cases from Xray if testSetKey is provided
        List<String> testTags = new ArrayList<>();
        if (testSetKey != null && !testSetKey.isEmpty()) {
            testTags = getTestCasesFromTestSet(testSetKey);
        }
        
        // Run tests with or without tags
        Results results;

        if (testTags.isEmpty()) {
            results = Runner.path("classpath:rakkar/feature/OpenAPI.feature")
                            .outputCucumberJson(true)
                            .outputJunitXml(true)
                            .parallel(threadCount);
        } else {
            String tagArray = String.join(", ", testTags);;
            System.out.println("Final Tags Array: " + tagArray);

            results = Runner.path("classpath:rakkar/feature/OpenAPI.feature")
                            .tags(tagArray)
                            .dryRun(true)
                            .outputCucumberJson(true)
                            .outputJunitXml(true)
                            .parallel(threadCount);
        }

        // Rerun failed script
        var rerun = System.getProperty("rerun");
        if (Boolean.parseBoolean(rerun)  == true) {
            for (ScenarioResult scenarioResult : results.getScenarioResults().collect(Collectors.toList())) {

                System.out.println(scenarioResult);
                if (scenarioResult.isFailed()) {
                    ScenarioResult retryScenarioResult = results.getSuite().retryScenario(scenarioResult.getScenario());
                    results = results.getSuite().updateResults(retryScenarioResult);
                }
            }
        }

        assertEquals(0, results.getFailCount(), results.getErrorMessages());

        System.out.println("dir--" + results.getReportDir());
        generateReport(results.getReportDir());
        
    }
    
    public static void generateReport(String karateOutputPath){
        Collection <File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[] {"json"}, true);
        List<String> jsonPath = new ArrayList<String>(jsonFiles.size());
        jsonFiles.forEach(file -> jsonPath.add(file.getAbsolutePath()));
        Configuration config = new Configuration(new File("target"), "feature");
        ReportBuilder reportBuilder = new ReportBuilder(jsonPath, config);
        reportBuilder.generateReports();
    }

    public static List<String> getTestCasesFromTestSet(String testSetKey) {
        List<String> testCases = new ArrayList<>();
        Map<String, String> cred = getXrayCredential(System.getProperty("secret"));

        String clientId = cred.get("clientId");
        String clientSecret = cred.get("clientSecret");

        try {
            String authToken = getXrayAuthToken(clientId, clientSecret);
            if (authToken == null) {
                System.out.println("Failed to obtain Xray authentication token.");
                return testCases;
            }

            // Get test cases from test set, test plan
            String query = constructGraphQLQuery(testSetKey);

            URL url = new URL(XRAY_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Authorization", "Bearer " + authToken);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("Accept", "application/json");
            conn.setDoOutput(true);

            try (var os = conn.getOutputStream()) {
                byte[] input = query.getBytes("utf-8");
                os.write(input, 0, input.length);
            }

            if (conn.getResponseCode() == 200) {
                BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                StringBuilder response = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    response.append(line);
                }
                reader.close();

                System.out.println("Xray API Response: " + response.toString());

                JSONObject jsonResponse = new JSONObject(response.toString());
                JSONArray testCasesArray = jsonResponse.getJSONObject("data")
                                       .getJSONObject("getTestSets")
                                       .getJSONArray("results")
                                       .getJSONObject(0)
                                       .getJSONObject("tests")
                                       .getJSONArray("results");

                for (int i = 0; i < testCasesArray.length(); i++) {
                    JSONObject testCase = testCasesArray.getJSONObject(i);
                    testCases.add("@" + testCase.getJSONObject("jira").getString("key"));
                }

            } else {
                System.out.println("Failed to fetch test cases. HTTP Code: " + conn.getResponseCode());
                BufferedReader errorReader = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
                String errorResponse = errorReader.lines().collect(Collectors.joining());
                System.out.println("Error Response: " + errorResponse);
            }
            conn.disconnect();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return testCases;
    }

    private static String constructGraphQLQuery(String testSetKey) {
        return String.format(
            "{\"query\":\"query { " +
            "getTestSets(jql: \\\"key=%s\\\", limit: 1) { " +
                "total " +
                "start " +
                "limit " +
                "results { " +
                    "issueId " +
                    "jira(fields: [\\\"key\\\"]) " +
                    "projectId " +
                    "tests(limit: 100) { " +
                        "total " +
                        "start " +
                        "limit " +
                        "results { " +
                            "issueId " +
                            "jira(fields: [\\\"key\\\"]) " +
                            "projectId " +
                            "testType { " +
                                "name " +
                                "kind " +
                            "} " +
                        "} " +
                    "} " +
                "} " +
            "} }\", " +
            "\"variables\":{}}", 
            testSetKey
        );
    }

    private static String getXrayAuthToken(String clientId, String clientSecret) {
        try {
            URL url = new URL(XRAY_AUTH_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);
    
            String payload = String.format("{\"client_id\": \"%s\", \"client_secret\": \"%s\"}", clientId, clientSecret);
            conn.getOutputStream().write(payload.getBytes());
    
            if (conn.getResponseCode() == 200) {
                BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                String token = reader.readLine().replaceAll("\"", "");
                reader.close();
                return token;
            } else {
                System.out.println("Failed to authenticate with Xray. HTTP Code: " + conn.getResponseCode());
            }
            conn.disconnect();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static Map<String, String> getXrayCredential(String filePath) {
        try {
            String content = new String(Files.readAllBytes(Paths.get(filePath)));

            JSONObject json = new JSONObject(content);

            Map<String, String> credentials = new HashMap<>();
            credentials.put("clientId", json.getString("XRAY_client_id"));
            credentials.put("clientSecret", json.getString("XRAY_client_secret"));

            return credentials;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
