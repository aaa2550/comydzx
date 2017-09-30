package com.keepme.util;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Arrays;

/**
 * Created by yanghailong on 2017/7/18.
 */
public class CookieUtil {

    public static void removeCookies(HttpServletRequest request, HttpServletResponse response, String domain) {
        Cookie[] cookies = request.getCookies();
        for (int i = 0; i < cookies.length; i++) {
            removeCookie(response, cookies[0].getName(), domain);
        }
    }

    public static void removeCookie(HttpServletResponse response, String key, String domain) {
        setCookie(response, key, null, domain, 0);
    }

    public static void setCookie(HttpServletResponse response, String key, String value, String domain, int expiry) {
        Cookie cookie = new Cookie(key, value);
        cookie.setDomain(domain);
        cookie.setMaxAge(expiry);
        response.addCookie(cookie);
    }

    public static void setCookie(HttpServletResponse response, String key, String value, String domain) {
        setCookie(response, key, value, domain, -1);
    }

    public static String getCookie(HttpServletRequest request, String name) {
        Cookie[] cookies = request.getCookies();
        if (cookies == null)  {
            return null;
        }
        for (int i = 0; i < cookies.length; i++) {
            if (cookies[i].getName().equals(name)) {
                return cookies[i].getValue();
            }
        }
        return null;
    }

}
