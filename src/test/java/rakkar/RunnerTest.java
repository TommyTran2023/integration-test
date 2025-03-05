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
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

import static org.junit.jupiter.api.Assertions.assertEquals;
public class RunnerTest {
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
            System.out.println("Running tests with tags: " + testTags);
        }
        /* 
        // Run tests with or without tags
        Results results;

        if (testTags.isEmpty()) {
            results = Runner.path("classpath:rakkar/feature/APILimit_OpenAPI.feature")
                            .outputCucumberJson(true)
                            .outputJunitXml(true)
                            .parallel(threadCount);
        } else {
            results = Runner.path("classpath:rakkar/feature/APILimit_OpenAPI.feature")
                            .tags(testTags.toArray(new String[0]))
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
        */
    }
    
    public static void generateReport(String karateOutputPath){
        Collection <File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[] {"json"}, true);
        List<String> jsonPath = new ArrayList<String>(jsonFiles.size());
        jsonFiles.forEach(file -> jsonPath.add(file.getAbsolutePath()));
        Configuration config = new Configuration(new File("target"), "feature");
        ReportBuilder reportBuilder = new ReportBuilder(jsonPath, config);
        reportBuilder.generateReports();
    }

    public static List<String> getTestCasesFromTestSet(String testSetKey){
        String XRAY_URL = "https://xray.cloud.getxray.app/api/v2";
        String CLIENT_ID = "BC3A1FA4AD6F47D99BA27B8A0917F4CD"; 
        String CLIENT_SECRET = "e4f86aeff528178b6180581a1bf82f398b15fd97f6bd06df17e5ca6f4833cb87"; 

        List<String> testCases = new ArrayList<>();
        try {
            String authToken = getXrayAuthToken(CLIENT_ID, CLIENT_SECRET);
            if (authToken == null) {
                System.out.println("Failed to obtain Xray authentication token.");
                return testCases;
            }

            // Construct the API URL
            URL url = new URL(XRAY_URL + "/testset/" + testSetKey + "/test");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            
            // Set request method and headers
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "Bearer " + authToken);
            conn.setRequestProperty("Accept", "application/json");

            // Read response
            if (conn.getResponseCode() == 200) {
                BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                StringBuilder response = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    response.append(line);
                }
                reader.close();

                // Parse JSON response
                JSONArray jsonArray = new JSONArray(response.toString());
                for (int i = 0; i < jsonArray.length(); i++) {
                    JSONObject obj = jsonArray.getJSONObject(i);
                    testCases.add(obj.getString("key"));
                }
            } else {
                System.out.println("Failed to fetch test cases. HTTP Code: " + conn.getResponseCode());
                System.out.println(conn.getResponseMessage());
                
            }
            conn.disconnect();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return testCases;
    }

    private static String getXrayAuthToken(String clientId, String clientSecret) {
        String XRAY_AUTH_URL = "https://xray.cloud.getxray.app/api/v2/authenticate";
        try {
            URL url = new URL(XRAY_AUTH_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);
    
            // Prepare JSON payload
            String payload = String.format("{\"client_id\": \"%s\", \"client_secret\": \"%s\"}", clientId, clientSecret);
            conn.getOutputStream().write(payload.getBytes());
    
            if (conn.getResponseCode() == 200) {
                BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                String token = reader.readLine().replaceAll("\"", ""); // Token is returned as a plain string
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
}
