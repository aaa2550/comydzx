package com.ydzx.enums;

/**
 * 一键支付返回CODE枚举
 * @author liming
 *
 */
public enum CodeType {
    INVALID_QUANTITY(2, "invalid.item.quantity"), KEY_NOTFOUND(3, "key.notfound"), INVALID_SKU(4, "invalid.sku"), INVALID_PRODUCT_STATUS(
            5, "invalid.product.status"), MARKET_EMPTY(6, "marketName.empty"), INVALID_PRICE(7, "invalid.price"), NEED_SKU(
            8, "need.sku.externalProductId"), KEY_UNMATCH(9, "appkey.unmatch"), INVALID_PAYMENT(10,
            "http://gd.pay.cp21.ott.cibntv.net/pay/mobile/23回调出错"), ORDER_NOT_FOUND(21, "order.not.found"), LESS_PARAMETER(
            101, "缺少参数"), EXPIRED_VISIT(102, "过期访问"), CODE_INVALID(103, "验证码错误!"), SIGN_ERROR(104, "签名错误！"), USER_ERROR(
            105, "用户违法"), USER_NOT_LOGIN(106, "用户未登录");

    private int code;
    private String msg;

    public int getCode() {
        return code;
    }

    public void setCode(int value) {
        this.code = value;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String name) {
        this.msg = name;
    }

    CodeType(int value, String name) {
        this.code = value;
        this.msg = name;
    }

}
