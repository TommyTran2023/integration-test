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
    private static final int PAGE_SIZE = 100; // Maximum number of results per page
    
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

            // Get total count first
            int totalTestCases = getTotalTestCaseCount(testSetKey, authToken);
            System.out.println("Total test cases in test set " + testSetKey + ": " + totalTestCases);
            
            // Fetch all test cases using pagination
            int start = 0;
            while (start < totalTestCases) {
                List<String> pageTestCases = getTestCasesPage(testSetKey, authToken, start, PAGE_SIZE);
                testCases.addAll(pageTestCases);
                start += PAGE_SIZE;
                
                if (pageTestCases.isEmpty()) {
                    // Safety check in case the API returns fewer results than expected
                    break;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return testCases;
    }
    
    private static int getTotalTestCaseCount(String testSetKey, String authToken) {
        try {
            String query = constructCountQuery(testSetKey);
            
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
                return jsonResponse.getJSONObject("data")
                                  .getJSONObject("getTestSets")
                                  .getJSONArray("results")
                                  .getJSONObject(0)
                                  .getJSONObject("tests")
                                  .getInt("total");
            } else {
                System.out.println("Failed to fetch test case count. HTTP Code: " + conn.getResponseCode());
                BufferedReader errorReader = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
                String errorResponse = errorReader.lines().collect(Collectors.joining());
                System.out.println("Error Response: " + errorResponse);
            }
            conn.disconnect();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    private static List<String> getTestCasesPage(String testSetKey, String authToken, int start, int limit) {
        List<String> pageTestCases = new ArrayList<>();
        try {
            String query = constructPaginatedQuery(testSetKey, start, limit);
            
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

                System.out.println("Xray API Response (page starting at " + start + "): " + response.toString());

                JSONObject jsonResponse = new JSONObject(response.toString());
                JSONArray testCasesArray = jsonResponse.getJSONObject("data")
                                       .getJSONObject("getTestSets")
                                       .getJSONArray("results")
                                       .getJSONObject(0)
                                       .getJSONObject("tests")
                                       .getJSONArray("results");

                for (int i = 0; i < testCasesArray.length(); i++) {
                    JSONObject testCase = testCasesArray.getJSONObject(i);
                    pageTestCases.add("@" + testCase.getJSONObject("jira").getString("key"));
                }
            } else {
                System.out.println("Failed to fetch test cases page. HTTP Code: " + conn.getResponseCode());
                BufferedReader errorReader = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
                String errorResponse = errorReader.lines().collect(Collectors.joining());
                System.out.println("Error Response: " + errorResponse);
            }
            conn.disconnect();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return pageTestCases;
    }

    private static String constructCountQuery(String testSetKey) {
        return String.format(
            "{\"query\":\"query { " +
            "getTestSets(jql: \\\"key=%s\\\", limit: 1) { " +
                "results { " +
                    "tests (limit: 1) { " +
                        "total " +
                    "} " +
                "} " +
            "} }\", " +
            "\"variables\":{}}", 
            testSetKey
        );
    }

    private static String constructPaginatedQuery(String testSetKey, int start, int limit) {
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
                    "tests(limit: %d, start: %d) { " +
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
            testSetKey, limit, start
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