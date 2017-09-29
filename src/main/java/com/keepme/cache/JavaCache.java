package com.keepme.cache;

import java.util.concurrent.ConcurrentHashMap;

/**
 * Created by yanghailong on 2017/7/18.
 */
public class JavaCache implements CacheParent {

    public static final ConcurrentHashMap<String, Object> cacheMap = new ConcurrentHashMap<>();

    @Override
    public Object get(String key) {
        return cacheMap.get(key);
    }

    @Override
    public Object set(String key, Object value) {
        return cacheMap.put(key, value);
    }

    @Override
    public Object delete(String key) {
        return cacheMap.remove(key);
    }
}
