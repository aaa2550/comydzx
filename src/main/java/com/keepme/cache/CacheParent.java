package com.keepme.cache;

/**
 * Created by yanghailong on 2017/7/18.
 */
public interface CacheParent {

    Object get(String key);

    Object set(String key, Object value);

    Object delete(String key);

}
