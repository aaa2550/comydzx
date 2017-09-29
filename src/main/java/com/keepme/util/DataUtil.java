package com.keepme.util;

import com.keepme.commons.Consts;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.Field;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Created by yanghailong on 2017/7/18.
 */
public class DataUtil {

    public static int toInt(Object obj) {
        try {
            return Integer.parseInt(obj.toString());
        } catch (Exception e) {
            return 0;
        }
    }

    public static String likeParam(String s) {
        return isEmpty(s) ? null : "%" + s.trim() + "%";
    }

    /**
     * 将当前对象中所有属性类型为String并且值为""或"  "的值变为null
     */
    public static <T> T transEmptyPropertyToNull(T o) {
        for (Field f : getAllField(o)) {
            try {
                if (String.class.equals(f.getType())) {
                    f.setAccessible(true);
                    Object v = f.get(o);
                    f.set(emptyToNull((String)v), null);
                }
            } catch (IllegalAccessException e) {
                throw new IllegalStateException();
            }
        }
        return o;
    }

    private static List<Field> getAllField(Object o) {
        List<Field> fields = new ArrayList<>();
        Class<?> clazz = o.getClass();
        do {
            fields.addAll(Arrays.asList(clazz.getDeclaredFields()));
            clazz = clazz.getSuperclass();
        } while (!clazz.equals(Object.class));
        return fields;
    }

    public static String emptyToNull(String str) {
        return isEmpty(str) ? null : str;
    }

    public static List<Integer> asIntListGtZero(String str) {
        if (isEmpty(str)) {
            return Collections.emptyList();
        }
        return Arrays.asList(str.split(",")).stream().map(Integer::valueOf).collect(Collectors.toList());

    }

    public static <K, V> String getValues(List<K> list, Map<K, V> map) {
        if (DataUtil.isEmpty(list))
            return "";
        StringBuilder sb = new StringBuilder();
        for (K key : list) {
            sb.append(",");
            sb.append(map.get(key));
        }
        return sb.substring(1);
    }

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
