package rakkar;

import util.*;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import com.intuit.karate.core.ScenarioResult;

import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import org.apache.commons.io.FileUtils;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import java.io.File;
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
        String testSetKey = System.getProperty("testSetKey");
        System.out.println("Running tests with testSetKey: " + testSetKey);

        // Fetch test cases from Xray if testSetKey is provided
        List<String> testTags = new ArrayList<>();
        if (testSetKey != null && !testSetKey.isEmpty()) {
            testTags = XrayUtils.getTestCasesFromTestSet(testSetKey); // getTestCasesFromTestSet(testSetKey);
        }
        
        // Run tests with or without tags
        Results results;

        if (testTags.isEmpty()) {
            results = Runner.path("classpath:rakkar/feature")
                            .outputCucumberJson(true)
                            .outputJunitXml(true)
                            .parallel(threadCount);
        } else {
            String tagArray = String.join(", ", testTags);;
            System.out.println("Final Tags Array: " + tagArray);

            results = Runner.path("classpath:rakkar/feature")
                            .tags(tagArray)
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

}
