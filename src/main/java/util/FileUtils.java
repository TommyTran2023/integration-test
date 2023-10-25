package util;

import java.io.File;
import java.io.FileWriter;
import java.util.HashMap;
import java.util.Map;

public class FileUtils {
    public static Map<String, Object> DataListMap = new HashMap<>();
    public static String filePath;

    public static void addData(String key, Object value) {
        FileUtils.DataListMap.put(key, value);
    }

    public static boolean isFileExist(String filePath) {
        File file = new File(filePath);
        return file.exists();
    }

    public static void writeToFile(String filePath, Map<String, Object> data) throws Exception {
        File file = new File(filePath);
        if (!file.exists()) {
            file.createNewFile();
        }

        String jsonString = StringUtils.simplifiedJsonString(data);

        FileWriter writer = new FileWriter(file);
        writer.write(jsonString);
        writer.close();
    }

}
