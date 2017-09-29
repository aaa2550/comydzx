package com.keepme.pojo;

import com.keepme.enums.InvoiceInfoEnum;

import java.util.Collections;
import java.util.List;

/**
 * EasyUI DataGrid模型
 * @author shaoxiangfei
 *
 */
public class DataGrid<T> extends Pojo {

    //数据总条数
    private int total;

    //每页显示的数据列表
    private List<T> rows = Collections.emptyList();

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    public List<T> getRows() {
        return rows;
    }

    public void setRows(List<T> rows) {
        this.rows = rows;
    }
}
