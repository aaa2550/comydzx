<%@page import="com.letv.boss.LetvEnv"%>
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
		td{height: 34px;}
		table tr td span{margin-right: 10px;display: inline-block;float: none;}
		table tr td input{margin-right: 30px;}
		.val-span{min-width:100px;color:#777;float: none;}
		.attention{color:#f00;float:left;margin-top: 54px;}
		.close-btn{margin: 20px 0 0 450px;padding: 2px 6px;}
	</style>
</head>
<body>
<div class="cont1">
	<div class="cont2">
		<p class="title">${internationalConfig.用户信息}</p>
		<table>
			<tr>
				<td><span class="name-span">${internationalConfig.用户ID}：</span><span class="val-span">${consumeInfo.userId}</span></td>
				<td><span class="name-span">${internationalConfig.昵称}：</span><span class="val-span">${consumeInfo.nickname}</span></td>
				<td><span class="name-span">${internationalConfig.手机号}:</span><span class="val-span">${consumeInfo.mobile}</span></td>
				<td><span class="name-span">${internationalConfig.邮箱}:</span><span class="val-span">${consumeInfo.email}</span></td>
			</tr>
		</table>
	</div>
	<div class="cont2">
		<p class="title">${internationalConfig.商品信息}</p>
		<table>
			<tr>
				<td><span class="name-span">${internationalConfig.商品ID}:</span><span class="val-span">${consumeInfo.productId}</span></td>
				<td><span class="name-span">${internationalConfig.订阅套餐}ID:</span><span class="val-span">${consumeInfo.subscribePackageId=='0'?"":consumeInfo.subscribePackageId}</span></td>
				<td><span class="name-span">${internationalConfig.商品名称}:</span><span class="val-span">${consumeInfo.orderName}</span></td>

				<td><span class="name-span">${internationalConfig.商品周期}:</span><span class="val-span">
                    <c:choose>
                        <c:when test="${consumeInfo.productDurationType==1}">${consumeInfo.productDuration}${internationalConfig.年}</c:when>
                        <c:when test="${consumeInfo.productDurationType==2}">${consumeInfo.productDuration}${internationalConfig.月}</c:when>
                        <c:when test="${consumeInfo.productDurationType==5}">${consumeInfo.productDuration}${internationalConfig.日}</c:when>
                        <c:otherwise>${consumeInfo.productDurationType}</c:otherwise>
                    </c:choose>
				</span></td>
			</tr>

			<tr>
                <td><span class="name-span">${internationalConfig.商品类型}：</span><span class="val-span">
                    <c:choose>
                        <c:when test="${consumeInfo.productType==1}">${internationalConfig.专辑}</c:when>
                        <c:when test="${consumeInfo.productType==2}">${internationalConfig.轮播台}</c:when>
                        <c:when test="${consumeInfo.productType==3}">${internationalConfig.视频}</c:when>
                        <c:when test="${consumeInfo.productType==4}">${internationalConfig.直播场次}</c:when>
                        <c:when test="${consumeInfo.productType==100}">${internationalConfig.会员}</c:when>
                        <c:when test="${consumeInfo.productType==200}">${internationalConfig.直播劵}</c:when>
                        <c:otherwise>${consumeInfo.productType}</c:otherwise>
                    </c:choose>
				</span></td>

				<td><span class="name-span">${internationalConfig.商品详情}：</span><span class="val-span">
					<c:choose>
						<c:when test="${consumeInfo.payChannel=='-1'}">${consumeInfo.cardNum}</c:when>
						<c:when test="${consumeInfo.payChannel=='-4'}">${consumeInfo.cardNum}</c:when>
						<c:when test="${consumeInfo.payChannel=='-7'}">${consumeInfo.cardNum}</c:when>
						<c:otherwise>${consumeInfo.payChannelDesc}</c:otherwise>
					</c:choose>
				</span></td>

				<td><span class="name-span">${internationalConfig.购买套餐}ID:</span><span class="val-span">${consumeInfo.packageId}</span></td>

			</tr>
		</table>
	</div>
	<div class="cont2 clearfix">
		<p class="title">${internationalConfig.价格信息}</p>
		<table style="float: left;margin-right: 20px;">
			<tr>
				<td><span class="name-span">${internationalConfig.商品价格}：</span><span class="val-span">${consumeInfo.sellingPrice}</span></td>
				<td><span class="name-span">${internationalConfig.优惠额度}：</span><span class="val-span">${consumeInfo.deductions}</span></td>
				<td><span class="name-span">${internationalConfig.支付价格}：</span><span class="val-span">${consumeInfo.payPrice}</span></td>
			</tr>
			<tr>
				<td><span class="name-span">${internationalConfig.订阅商品价格}：</span><span class="val-span">${consumeInfo.subscribePrice}</span></td>
				<td><span class="name-span">${internationalConfig.税码}：</span><span class="val-span">${consumeInfo.taxCode}</span></td>
				<td><span class="name-span">${internationalConfig.税金}：</span><span class="val-span">${consumeInfo.tax}</span></td>
			</tr>
		</table>
		<div class="attention">${internationalConfig.注单位元}</div>
	</div>
	<div class="cont2">
		<p class="title">${internationalConfig.订单信息}</p>
		<table>
			<tr>
				<td><span class="name-span">${internationalConfig.来源平台}：</span><span class="val-span">
					<c:choose>
						<c:when test="${consumeInfo.platform==0}">${internationalConfig.乐视}</c:when>
						<c:when test="${consumeInfo.platform==1}">${internationalConfig.乐视}</c:when>
						<c:when test="${consumeInfo.platform==10}">${internationalConfig.乐视平台运营商}</c:when>
						<c:when test="${consumeInfo.platform==11}">${internationalConfig.乐视平台酷派}</c:when>
						<c:when test="${consumeInfo.platform==12}">${internationalConfig.乐视平台夏普}</c:when>
						<c:when test="${consumeInfo.platform==13}">${internationalConfig.乐视平台商城}</c:when>
						<c:when test="${consumeInfo.platform==2}">${internationalConfig.国广平台乐视}</c:when>
						<c:when test="${consumeInfo.platform==20}">${internationalConfig.国广平台TCL}</c:when>
						<c:when test="${consumeInfo.platform==21}">${internationalConfig.国广平台华数}</c:when>
						<c:when test="${consumeInfo.platform==3}">${internationalConfig.华数平台乐视}</c:when>
						<c:otherwise>${consumeInfo.platform}</c:otherwise>
					</c:choose>
				</span></td>
				<td><span class="name-span">${internationalConfig.消费订单号}：</span><span class="val-span">${consumeInfo.orderid}</span></td>
				<td><span class="name-span" class="name-span">${internationalConfig.支付订单ID}：</span><span class="val-span">${consumeInfo.payOrderid=='0'?"":consumeInfo.payOrderid}</span></td>
			</tr>
			<tr>
				<td><span class="name-span" class="name-span">${internationalConfig.支付通道ID}：</span><span class="val-span">${consumeInfo.payChannel}</span></td>
				<c:if test="${consumeInfo.status!=0}">
				<td><span class="name-span">${internationalConfig.支付通道名称}：</span><span class="val-span">
					<c:choose>
						<c:when test="${consumeInfo.payChannel=='0'}">${internationalConfig.机卡领取}</c:when>
						<c:when test="${consumeInfo.payChannel=='-1'}">${internationalConfig.乐卡兑换}</c:when>
						<c:when test="${consumeInfo.payChannel=='-2'}">${internationalConfig.渠道赠送}(${consumeInfo.presentChannel})</c:when>
						<c:when test="${consumeInfo.payChannel=='-3'}">${internationalConfig.观影券}</c:when>
						<c:when test="${consumeInfo.payChannel=='-4'}">${internationalConfig.直播券兑换码}</c:when>
						<c:when test="${consumeInfo.payChannel=='-5'}">${internationalConfig.活动赠送}</c:when>
						<c:when test="${consumeInfo.payChannel=='-6'}">${internationalConfig.直转点赠送}</c:when>
						<c:when test="${consumeInfo.payChannel=='-7'}">${internationalConfig.机卡兑换码}</c:when>
						<c:when test="${consumeInfo.payChannel=='-8'}">${internationalConfig.消费查询设备赠送}</c:when>
						<c:when test="${consumeInfo.payChannel=='-100'}">${internationalConfig.消费查询2B合作通道}</c:when>
						<c:when test="${consumeInfo.payChannel=='-101'}">${internationalConfig.大屏商业平台}</c:when>
						<c:when test="${consumeInfo.payChannel>0}">
							<c:choose>
								<c:when test="${currentCountry==86}">
									${consumeInfo.payChannelName}
								</c:when>
								<c:otherwise>${internationalConfig.用户购买}</c:otherwise>
							</c:choose>
						</c:when>
						<c:otherwise>${consumeInfo.payChannel}</c:otherwise>
					</c:choose>
				</span></td>
				</c:if>
				<td><span class="name-span">${internationalConfig.下单时间}：</span><span class="val-span" id="data1"><fmt:formatDate value="${consumeInfo.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/></span></td>
			</tr>

			<tr>
				<td><span class="name-span">${internationalConfig.实际支付时间}：</span><span class="val-span" id="data2"><fmt:formatDate value="${consumeInfo.successTime}" pattern="yyyy-MM-dd HH:mm:ss"/></span></td>
				<td><span class="name-span">${internationalConfig.服务开始时间}：</span><span class="val-span" id="data3"><fmt:formatDate value="${consumeInfo.startTime}" pattern="yyyy-MM-dd HH:mm:ss"/></span></td>
				<td><span class="name-span">${internationalConfig.服务结束时间}：</span><span class="val-span" id="data4"><fmt:formatDate value="${consumeInfo.endTime}" pattern="yyyy-MM-dd HH:mm:ss"/></span></td>
			</tr>
			<tr>
				<td><span class="name-span">${internationalConfig.订单标识}：</span><span class="val-span">
					<c:choose>
						<c:when test="${consumeInfo.orderFlag==0}">${internationalConfig.普通}</c:when>
						<c:when test="${consumeInfo.orderFlag==1}">${internationalConfig.试用}</c:when>
						<c:when test="${consumeInfo.orderFlag==2}">${internationalConfig.超级影视不送乐次元}</c:when>
						<c:when test="${consumeInfo.orderFlag==3}">${internationalConfig.转移赠送}</c:when>
						<c:otherwise>${consumeInfo.orderFlag}</c:otherwise>
					</c:choose>
				</span></td>
				<td><span class="name-span">${internationalConfig.下单终端}：</span><span class="val-span">
					<c:choose>
						<c:when test="${consumeInfo.terminal==141001}">Web(${consumeInfo.terminal})</c:when>
						<c:when test="${consumeInfo.terminal==141002}">PC(Client)(${consumeInfo.terminal})</c:when>
						<c:when test="${consumeInfo.terminal==141003}">Mobile(Android)(${consumeInfo.terminal})</c:when>
						<c:when test="${consumeInfo.terminal==141004}">SuperMobile(${consumeInfo.terminal})</c:when>
						<c:when test="${consumeInfo.terminal==141005}">PAD(Android)(${consumeInfo.terminal})</c:when>
						<c:when test="${consumeInfo.terminal==141006}">MWeb(${consumeInfo.terminal})</c:when>
						<c:when test="${consumeInfo.terminal==141007}">SuperTV(${consumeInfo.terminal})</c:when>
						<c:when test="${consumeInfo.terminal==141008}">IPAD(${consumeInfo.terminal})</c:when>
						<c:when test="${consumeInfo.terminal==141009}">IPhone(${consumeInfo.terminal})</c:when>
						<c:when test="${consumeInfo.terminal==141010}">TV(${consumeInfo.terminal})</c:when>
						<c:otherwise>${consumeInfo.terminal==0?"":consumeInfo.terminal}</c:otherwise>
					</c:choose>
				</span></td>

				<td><span class="name-span">${internationalConfig.订单类型}：</span><span class="val-span">
					<c:choose>
						<c:when test="${consumeInfo.isRenew==0}">${internationalConfig.普通}</c:when>
						<c:when test="${consumeInfo.isRenew==1}">${internationalConfig.订阅自续费}</c:when>
						<c:when test="${consumeInfo.isRenew==2}">${internationalConfig.系统自扣费}</c:when>
						<c:otherwise>${consumeInfo.isRenew}</c:otherwise>
					</c:choose>
				</span></td>

			</tr>
			<tr>
				<td><span class="name-span">${internationalConfig.订单状态}：</span><span class="val-span">
					<c:choose>
						<c:when test="${consumeInfo.status==0}">${internationalConfig.未开通}</c:when>
						<c:when test="${consumeInfo.status==1}">${internationalConfig.已开通}</c:when>
						<c:when test="${consumeInfo.status==2}">${internationalConfig.已关闭}</c:when>
						<c:otherwise>${consumeInfo.status}</c:otherwise>
					</c:choose>
				</span></td>
				<td><span class="name-span">${internationalConfig.退款状态}：</span><span class="val-span">
					<c:choose>
						<c:when test="${consumeInfo.isRefund==1}">${internationalConfig.已退款}</c:when>
						<c:when test="${consumeInfo.isRefund==0}">${internationalConfig.未退款}</c:when>
						<c:otherwise>${consumeInfo.isRefund}</c:otherwise>
					</c:choose>
				</span></td>

				<td><span class="name-span">${internationalConfig.业务线}ID：</span><span class="val-span">${consumeInfo.businessId}</span></td>
			</tr>
			<tr>
				<td><span class="name-span">${internationalConfig.系统版本}：</span><span class="val-span">${consumeInfo.orderVersion}</span></td>
			</tr>
		</table>
	</div>
	<div class="cont2"><button class="close-btn" onclick="closeTab()">${internationalConfig.关闭}</button></div>

</div>
<script>
	parent.$.messager.progress('close');
	function addZero(data){
		if(parseInt(data)<10){
			return "0"+data;
		}else{
			return data;
		}
	}
	function closeTab(){
		parent.$('.tabs .tabs-selected .tabs-close').trigger("click");
	}
</script>
</body>
</html>