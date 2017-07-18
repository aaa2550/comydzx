package com.ydzx.pojo;

import com.ydzx.util.DataUtil;

/**
 * EasyUI 分页辅助类
 * @author shaoxiangfei
 *
 */
public class PageUnder extends Pager {

    public PageUnder() {}
    public PageUnder(int row) {
        setRows(row);
    }

    @Override
    public String getSort() {
        return underscoreName(super.getSort());
    }

    private String underscoreName(String name) {
        if (DataUtil.isEmpty(name))
            return null;
        StringBuilder result = new StringBuilder();
        result.append(name.substring(0, 1).toLowerCase());
        for (int i = 1; i < name.length(); i++) {
            String s = name.substring(i, i + 1);
            String slc = s.toLowerCase();
            if (!s.equals(slc)) {
                result.append("_").append(slc);
            } else {
                result.append(s);
            }
        }
        return result.toString();
    }

}
