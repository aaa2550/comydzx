package com.ydzx.pojo;

import com.alibaba.fastjson.JSON;

import java.io.Serializable;

/**
 * 统一pojo toString
 * @author xieweibo
 *  
 */
public class Pojo implements Serializable {

    @Override
    public String toString() {
        return JSON.toJSONString(this);
    }

}
