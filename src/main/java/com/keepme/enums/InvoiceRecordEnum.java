package com.keepme.enums;

import lombok.AllArgsConstructor;

/**
 * Created by yanghailong on 2017/9/29.
 */
@AllArgsConstructor
public enum InvoiceRecordEnum {

    销售发票(0),
    媒介发票(1);

    public int type;
}
