package com.keepme.enums;

import lombok.AllArgsConstructor;

/**
 * Created by yanghailong on 2017/9/29.
 */
@AllArgsConstructor
public enum InvoiceInfoEnum {

    我司(0),
    客户(1),
    供应商(2);

    public int type;

}
