package com.ydzx.cache;

/**
 * Created by yanghailong on 2017/7/18.
 */
public abstract class CacheManager {

    private static CacheParent cacheParent;

    public void setCacheManager(CacheParent cacheParent) {
        CacheManager.cacheParent = cacheParent;
    }

    public static Object get(String key) {
        return cacheParent.get(key);
    }

    public static Object set(String key, Object value) {
        return cacheParent.set(key, value);
    }

    public static Object delete(String key) {
        return cacheParent.delete(key);
    }

}
