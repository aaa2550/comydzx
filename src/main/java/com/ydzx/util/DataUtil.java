package com.ydzx.util;

import com.ydzx.commons.Consts;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.Arrays;
import java.util.Collection;
import java.util.Map;

/**
 * Created by yanghailong on 2017/7/18.
 */
public class DataUtil {

    public static boolean isEmpty(String str) {
        return StringUtils.isEmpty(str);
    }

    public static boolean isEmpty(String... str) {
        return str != null && Arrays.asList(str).stream().allMatch(e->isEmpty(e));
    }

    public static boolean isEmpty(Collection collection) {
        return CollectionUtils.isEmpty(collection);
    }

    public static boolean isEmpty(Map map) {
        return CollectionUtils.isEmpty(map);
    }

    public static String decode(String str) {
        try {
            return URLDecoder.decode(str, Consts.ENCODE);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static String encode(String str) {
        try {
            return URLEncoder.encode(str, Consts.ENCODE);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static Long toLong(String sLong) {
        try {
            return Long.parseLong(sLong);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static Integer toInteger(String sInteger) {
        try {
            return Integer.parseInt(sInteger);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static String join(String separator, String... str) {
        return String.join(separator, str);
    }

}
