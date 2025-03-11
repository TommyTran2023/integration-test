package util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.json.JSONArray;
import org.json.JSONObject;

public class XrayUtils {
    private static final String XRAY_URL = "https://xray.cloud.getxray.app/api/v2/graphql";
    private static final String XRAY_AUTH_URL = "https://xray.cloud.getxray.app/api/v2/authenticate";
    
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
