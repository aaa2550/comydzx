package com.keepme.util;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * Created by yanghailong on 2017/7/18.
 */
public class RequestUtil {

    public static String getURL(HttpServletRequest httpServletRequest) {
        return httpServletRequest.getServletPath();
    }

    public static String getQueryString(HttpServletRequest httpServletRequest) {
        return httpServletRequest.getQueryString();
    }

    public static Map<String, String[]> getParameterMap(HttpServletRequest httpServletRequest) {
        return httpServletRequest.getParameterMap();
    }

}
