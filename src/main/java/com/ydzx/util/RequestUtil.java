package com.ydzx.util;

import com.sun.xml.internal.ws.resources.HttpserverMessages;

import javax.servlet.http.HttpServletRequest;

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

}
