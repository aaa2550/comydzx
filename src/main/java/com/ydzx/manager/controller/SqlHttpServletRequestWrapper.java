package com.ydzx.manager.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;

/**
 * 过滤输入内容中的的特殊符号，防Sql注入攻击.<br/>
 * 对请求参数进行过滤，如果包含select insert等sql关键字，或者% * 这种sql危险字，则参数置为空
 * 方法是实现一个自定义的HttpServletRequestWrapper，然后在Filter里面调用它，替换掉getParameter函数.<br/>
 * 参考：http://www.cnblogs.com/Mainz/archive/2012/11/01/2749874.html
 */
public class SqlHttpServletRequestWrapper extends HttpServletRequestWrapper {


    public SqlHttpServletRequestWrapper(HttpServletRequest servletRequest) {
        super(servletRequest);
    }

    public String[] getParameterValues(String parameter) {
        String[] values = super.getParameterValues(parameter);
        if (values == null) {
            return null;
        }
        cleanSql(values); // 传引用
        return values;
    }

    /**
     * 对单一参数值进行过滤.
     */
    public String getParameter(String parameter) {
        String value = super.getParameter(parameter);
        return isParamLegal(value) ? value : null;
    }

    /**
     * 对字符串数组进行过滤
     *
     * @param values
     */
    private void cleanSql(String[] values) {
        if (values != null) {
            for (int num = 0; num < values.length; num++) {
                values[num] = isParamLegal(values[num]) ? values[num] : null;
            }
        }
    }

    /**
     * 对输入的参数进行sql防注入处理
     * 如果输入参数合法，则返回true，否则返回false
     *
     * @param value
     * @return
     */
    public boolean isParamLegal(String value) {
        if (value == null || "".equals(value)) return true;
        value = value.toLowerCase();
        String pattern = "select |%|\\*|and |or |insert |delete |update |count |chr |mid |master |truncate |char |declare |_ |in |order by |group by |>|<|>=|<=|!=|<>|between|exec";
        String[] patterns = pattern.split("\\|");
        for (String key : patterns) {
            if (value.contains(key)) return false;
        }
        return true;
    }

}