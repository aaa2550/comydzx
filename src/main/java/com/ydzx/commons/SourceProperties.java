package com.ydzx.commons;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.HashMap;

/**
 * Created by yanghailong on 2017/7/17.
 */
public class SourceProperties extends HashMap<String, String> {

    Logger logger = (Logger) LoggerFactory.getLogger(SourceProperties.class);

    public SourceProperties(String fileName) {
        try (InputStream inputStream = SourceProperties.class.getClassLoader().getResourceAsStream("test.txt");
             BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(inputStream));) {
            String str = null;
            while ((str = bufferedReader.readLine()) != null) {
                String[] strs = str.split("=");
                put(strs[0].trim(), strs[1].trim());
            }
        } catch (Exception e) {
            logger.error(fileName + " load error", e);
            System.exit(-1);
        }

    }

}
