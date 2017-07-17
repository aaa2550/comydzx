<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
    <title>${internationalConfig.消费订单查询}</title>
    <%@ include file="/WEB-INF/views/inc/head.inc"%>
    <script type="text/javascript">
        /* <m:auth uri="/consume/open">
         $.canOpen = true;
        </m:auth> */
        <m:auth uri="/consume/close">
        $.canClose = true;
        </m:auth>
        <m:auth uri="/consume/refund.do">
        $.canRefund = true;
        </m:auth>
    </script>
    <style>
        .cont1{width:100%;}
        .cont2{border-bottom:1px dashed #aaa;margin:0 20px;padding:14px 20px;color:#444;position: relative;font-size: 12px;}
        .cont2:last-child{border-bottom:0px dashed #aaa;}
        .title{margin-bottom: 10px;font-weight: bold;text-decoration: underline;}
        td{height: 42px;}
        table tr td span{margin-right: 10px;display: inline-block;float: none;}
        table tr td input{margin-right: 30px;}
        .val-span{min-width:100px;color:#777;float: none;}
        .attention{color:#f00;float:left;margin-top: 54px;}
        .close-btn{margin: 20px 0 0 450px;padding: 2px 6px;}
        textarea{width: 724px;}
    </style>
</head>
<body>
<div class="cont1">
    <div class="cont2">
        <p class="title">01  ${internationalConfig.用户信息}</p>
        <table>
            <tr>
                <td><span class="name-span">${internationalConfig.用户ID}</span></td><td><input class="val-span" value="${detail.userId}" disabled/></td>
                <td><span class="name-span">用户IP</span></td><td><input class="val-span" value="${detail.userIp}" disabled/></td>
            </tr>
        </table>
    </div>
    <div class="cont2">
        <p class="title">02  订单信息</p>
        <table>
            <tr>
                <td><span class="name-span">商品订单号</span></td><td><input class="val-span" value="${detail.orderNo}" disabled/></td>
                <td><span class="name-span">订单名称</span></td><td><input class="val-span" value="${detail.orderName}" disabled/></td>
                <td><span class="name-span">订单状态</span></td><td><input class="val-span" value="${detail.statusName}" disabled/></td>
            </tr>
            <tr>
                <td><span class="name-span">订单创建时间</span></td><td><input class="val-span" value="<fmt:formatDate pattern='YYYY-MM-dd HH:mm:ss' value='${detail.createTime}'/>" disabled/></td>
                <td><span class="name-span">订单支付时间</span></td><td><input class="val-span" value="<fmt:formatDate pattern='YYYY-MM-dd HH:mm:ss' value='${detail.successTime}'/>" disabled/></td>
                <td><span class="name-span">支付通道ID</span></td><td><input class="val-span" value="${detail.payChannel}" disabled/></td>
            </tr>
            <tr>
                <td><span class="name-span">支付订单号</span></td><td><input class="val-span" value="${detail.payOrderId}" disabled/></td>
                <td><span class="name-span">支付退款号</span></td><td><input class="val-span" value="${refundDetail.refundNo}" disabled/></td>
                <td><span class="name-span">第三方支付退款流水</span></td><td><input class="val-span" value="${refundDetail.payRefundChannelNo}" disabled/></td>
            </tr>
            <tr>
                <td><span class="name-span">订单金额</span></td><td><input class="val-span" value="${detail.price}" disabled/></td>
                <td><span class="name-span">优惠额度</span></td><td><input class="val-span" value="${detail.deductions}" disabled/></td>
                <td><span class="name-span">实际付款金额</span></td><td><input class="val-span" value="${detail.payPrice}" disabled/></td>
            </tr>
            <tr>
                <td><span class="name-span">退款申请时间</span></td><td><input class="val-span" value="<fmt:formatDate pattern='YYYY-MM-dd HH:mm:ss' value='${refundDetail.createTime}'/>" disabled/></td>
                <td><span class="name-span">退款完成时间</span></td><td><input class="val-span" value="<fmt:formatDate pattern='YYYY-MM-dd HH:mm:ss' value='${refundDetail.payRefundTime}'/>" disabled/></td>
                <td><span class="name-span">退款金额</span></td><td><input class="val-span" value="${refundDetail.refundPrice}" disabled/></td>
            </tr>
            <tr>
                <td><span class="name-span">退款申请原因</span></td><td colspan="5"><textarea class="val-span"  disabled>${refundDetail.reason}</textarea></td>
            </tr>

            </tr>
        </table>
    </div>
    <div class="cont2 clearfix">
        <p class="title">03  商品信息</p>
        <table>
            <tr>
                <td><span class="name-span">SPUID</span></td><td><input class="val-span" value="${detail.spuId}" disabled/></td>
                <td><span class="name-span">SPU编码</span></td><td><input class="val-span" value="${detail.spuNo}" disabled/></td>
                <td><span class="name-span">SPU名称</span></td><td><input class="val-span" value="${detail.spuName}" disabled/></td>
            </tr>
            <tr>
                <td><span class="name-span">购买数量</span></td><td><input class="val-span" value="${detail.skuCnt}" disabled/></td>
                <td><span class="name-span">商品兑换码</span></td><td><input class="val-span" value="${detail.exchangeCode}" disabled/></td>
                <td><span class="name-span">商品优惠码</span></td><td><input class="val-span" value="${detail.couponCode}" disabled/></td>
            </tr>
            <tr>
                <td><span class="name-span">SKUID</span></td><td><input class="val-span" value="${detail.skuId}" disabled/></td>
                <td><span class="name-span">SKU编码</span></td><td><input class="val-span" value="${detail.skuNo}" disabled/></td>
                <td><span class="name-span">SKU名称</span></td><td><input class="val-span" value="${detail.skuName}" disabled/></td>
            </tr>
        </table>
    </div>
    <div class="cont2"><button class="close-btn" onclick="closeTab()">${internationalConfig.关闭}</button></div>

</div>
<script>
    parent.$.messager.progress('close');
    /*function addZero(data){
        if(parseInt(data)<10){
            return "0"+data;
        }else{
            return data;
        }
    }*/
    function closeTab(){
        parent.$('.tabs .tabs-selected .tabs-close').trigger("click");
    }
</script>
</body>
</html>