package com.keepme.pojo;

import com.keepme.enums.CodeType;

/**
 * 用户后台向前台返回的JSON对象
 * @author shaoxiangfei
 *
 */
public class CodeMsg extends Pojo {

    //0表示正常
    public static final int SUCCESS_CODE = 0;

    //1表示失败
    public static final int ERROR_CODE = 1;
    


    public static final CodeMsg SUCCESS = new CodeMsg(SUCCESS_CODE, "SUCCESS");

    public static final CodeMsg ERROR = new CodeMsg(ERROR_CODE, "ERROR");


    //返回状态码
    private int code;

    //提示信息
    private String msg;

    //数据类型
    private Object data;

    public CodeMsg() {

    }

    public CodeMsg(CodeType type) {
        this.code = type.getCode();
        this.msg = type.getMsg();
    }

    public CodeMsg(int code, String msg) {
        this.code = code;
        this.msg = msg;
    }

    public CodeMsg(int code, String msg, Object data) {
        this.code = code;
        this.msg = msg;
        this.data = data;
    }

    public Object getData() {
        return data;
    }

    public CodeMsg setData(Object data) {
        this.data = data;
        return this;
    }

    public int getCode() {
        return code;
    }

    public String getMsg() {

        return msg;
    }

    public boolean isSuccess() {
        return code == SUCCESS_CODE;
    }

    public CodeMsg setCode(int code) {
        this.code = code;
        return this;
    }

    public CodeMsg setMsg(String msg) {
        this.msg = msg;
        return this;
    }

}
