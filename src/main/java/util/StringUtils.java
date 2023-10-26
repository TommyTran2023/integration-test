package util;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

import java.util.Map;

public class StringUtils {
    
    public static String simplifiedJsonString(Map<String, Object> data) throws Exception {
        ObjectMapper mapper = new ObjectMapper();
        mapper.enable(SerializationFeature.INDENT_OUTPUT);
        String jsonMap = mapper.writeValueAsString(data);
        return jsonMap;
    }
}
