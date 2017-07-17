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
        .cont2{margin:0 20px;padding:14px 20px;color:#444;position: relative;font-size: 12px;}
        .cont2:last-child{border-bottom:0px dashed #aaa;}
        .title{margin-bottom: 10px;font-weight: bold;text-decoration: underline;}
        td{height: 42px;}
        table tr td span{margin-right: 10px;display: inline-block;float: none;}
        table tr td input{margin-right: 30px;}
        .val-span{min-width:100px;color:#777;float: none;}
        .attention{color:#f00;float:left;margin-top: 54px;}
        .close-btn{margin: 20px 0 0 450px;padding: 2px 6px;}
        textarea{width: 724px;}
        .detail{font-family: "Microsoft YaHei", arial;font-size: 14px;}
        .detail p{line-height: 25px;color: #333;}
        .detail p b{color: #333}
        .detail p span{color: #00a9d5;}
        .detail input{margin-left: 10px;border-radius: 0;width: 174px;padding: 2px 5px;}
        .detail table{border:1px solid #ddd;width: 100%;margin: 10px 0}
        .detail table td,.detail table th{text-align: center;padding: 3px 0;height: 24px;}
        .detail table th{background: #00a9d5}
    </style>
</head>
<body>
<div class="cont1">
    <div class="cont2" style="border-bottom:1px dashed #aaa;">
        <p class="title">订单信息</p>
        <table>
            <tr>
                <td><span class="name-span">商品订单号</span></td><td><input class="val-span" value="${order.orderNo}" disabled/></td>
                <td><span class="name-span">订单名称</span></td><td><input class="val-span" value="${order.orderName}" disabled/></td>
            </tr>
        </table>
    </div>

    <div class="cont2 detail">
        <p class="title">支付成功通知状态</p>
        <table border="1">
            <tr>
                <th>商户ID</th>
                <th>商户名称</th>
                <th>通知次数</th>
                <th>最新通知时间</th>
                <th>最新通知状态</th>
            </tr>
            <c:forEach var="paid" items="${paids}">
            <tr>
                <td>${paid.vendorId}</td>
                <td>${paid.vendorName}</td>
                <td>${paid.notifyCnt}</td>
                <td><fmt:formatDate pattern='YYYY-MM-dd HH:mm:ss' value='${paid.notifyTime}'/></td>
                <td>${paid.statusName}</td>
            </tr>
            </c:forEach>

        </table>
    </div>

<c:if test="${not empty refunds}">
    <div class="cont2 detail">
        <p class="title">退款通知记录</p>
        <table border="1">
            <tr>
                <th>商户ID</th>
                <th>商户名称</th>
                <th>通知次数</th>
                <th>最新通知时间</th>
                <th>最新通知状态</th>
            </tr>
            <c:forEach var="refund" items="${refunds}">
            <tr>
                <td>${refund.vendorId}</td>
                <td>${refund.vendorName}</td>
                <td>${refund.notifyCnt}</td>
                <td><fmt:formatDate pattern='YYYY-MM-dd HH:mm:ss' value='${refund.notifyTime}'/></td>
                <td>${refund.statusName}</td>
            </tr>
            </c:forEach>
        </table>
    </div>
</c:if>
    <div class="cont2 clearfix">
        <p class="title">备注</p>
        <p>1、用户购买商品支付成功（或申请退款成功）后，系统会分别调取每个商户的【支付成功回调地址】（或【退款成功回调地址】向商户发出商品信息通知，商品信息包括：商品订单号、商品订单最新状态、商户商品类型ID、商户商品ID、服务时长等，各商户需反馈接收结果，并自行处理开通服务（或关闭服务）。</p>
        <p>2、当通知多次商户均未反馈结果后，将不再通知，并会将最新通知状态更新为【放弃通知】。</p>
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