package com.keepme.commons;

import com.keepme.util.DataUtil;

/**
 * 乐视环境管理
 * @author xieweibo
 *
 */
public class Environment {

    private static  String ENVIRONMENT = "Environment";

    public static void setEnvironment(String env) {
        System.setProperty(ENVIRONMENT, env);
    }

    /**
     * 获取当前环境
     * @return
     */
    public static String getEnvironment() {
        // 优先 -DLETV_ENV=test
        String environment = System.getProperty(ENVIRONMENT);
        // export LETV_ENV=production
        if (DataUtil.isEmpty(environment))
            environment = System.getenv(ENVIRONMENT);
        // 再次 ，根据ip 判断
        if (DataUtil.isEmpty(environment)) {
            return "test";
        }
        return environment.toLowerCase();
    }

    /**
     *  是否测试环境,包含香港测试
     * @return
     */
    public static boolean isTest() {
        return getEnvironment().startsWith("test");
    }

}
