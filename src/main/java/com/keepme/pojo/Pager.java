package com.keepme.pojo;

import lombok.Data;

/**
 * Created by yanghailong on 2017/7/18.
 */
@Data
public class Pager extends Pojo {

    private String order;
    private String sort;
    private int rows;
    private int start;


}
