<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="/WEB-INF/views/inc/jstl.inc"%>
<style>
	#tk-table{}
	#tk-table tr{height:30px;}
	#tk-table tr th{border-width: 0 1px 1px 0;border-color: #ccc;border-style: dotted;background:#999;color:#eee;padding:0 10px;}
	#tk-table tr td{border-width: 1px;border-color: #ccc;border-style: dotted;padding:0 15px;}
</style>
<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');
		var orderid = $("#orderid").val();
		var userId = $("#userId").val();
		var reason = $("#reason").val();
		$.ajax({
			type: 'GET',
			url: "/consume/refundList?userId="+userId+"&orderid="+orderid+"&reason="+reason,
			dataType: 'json',
			success: function(res){
				var rows = res.rows;
				var length = res.total;
				var html = "";
				if(rows.length>0){
					var money = ${payPrice};
					for(var i=0;i<length;i++){
						var status = "";
						if(rows[i].status==1){
							status = "${internationalConfig.发起退款}";
						}else if(rows[i].status==8){
							money -= parseFloat(rows[i].refundPrice);
							money = money.toFixed(2);
							status = "${internationalConfig.退款成功}";
						}else if(rows[i].status==9){
							status = "${internationalConfig.退款失败}";
						}else{
							status = "";
						}//reason
						html+="<tr><td>"+((rows[i].createTime==undefined)?"":rows[i].createTime)+"</td><td>"+((rows[i].refundPrice==undefined)?"":rows[i].refundPrice)+"</td><td>"+((rows[i].reason==undefined)?"":rows[i].reason)+"</td><td>"+((rows[i].result==undefined)?"":rows[i].result)+"</td><td>"+status+"</td><td>"+rows[i].payOrderid+"</td><td>"+((rows[i].payRefundNo==undefined)?"":rows[i].payRefundNo)+"</td><td>"+((rows[i].payRefundChannelNo==undefined)?"":rows[i].payRefundChannelNo)+"</td><td>"+((rows[i].payRefundTime==undefined)?"":rows[i].payRefundTime)+"</td></tr>";
					}
					$(".ref_money").html(money);
					$("#payPrice").numberbox({
						max:money
					});
				}
				$("#tk-table").append(html);

			}
		});
		$('#form').form({
			url : '/consume/refund.do',
			onSubmit : function() {
				parent.$.messager.progress({
					title : '${internationalConfig.提示}',
					text : '${internationalConfig.数据处理中}....'
				});

				var isValid = $(this).form('validate');
				if (!isValid) {
					parent.$.messager.progress('close');
				}
				return isValid;
			},
			success : function(result) {
				parent.$.messager.progress('close');
				result = $.parseJSON(result);
				if (result.code == 0) {
					parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.退款处理中}...', 'success');
					parent.$.modalDialog.openner_dataGrid.datagrid('reload');
					parent.$.modalDialog.handler.dialog('close');
				}else if(result.code==2){
					parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.您退款太频繁}', 'error');
				}else if(result.code==3){
					parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.退款结果未知}', 'error');
				}else {
					parent.$.messager.alert('${internationalConfig.错误}', '${internationalConfig.退款失败}'+'('+(result.msg)+")", 'error');
				}
			}
		});
	});

	//增加自定义的表单验证规则
	$.extend($.fn.validatebox.defaults.rules, {
		number : {
			validator : function(value, param) {
				var reg = new RegExp("^[0-9]+(.[0-9]+)?$");
				return reg.test(value);
			},
			message : '${internationalConfig.请输入合法数字}'
		}
	});

	$.extend($.fn.validatebox.defaults.rules, {
		int : {
			validator : function(value, param) {
				var reg = new RegExp("^[0-9]+$");
				return reg.test(value);
			},
			message : '${internationalConfig.请输入合法整数}'
		}
	});
</script>

<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="">
		<form id="form" method="post">
			<input type="hidden" id="userId" name="userId" value="${userId}">
			<table style="width: 100%" class="table table-form">
				<colgroup>
					<col width="90">
					<col width="100">
					<col width="120">
					<col width="*">
				</colgroup>
				<tr>
					<th>${internationalConfig.订单号}</th>
					<td><input type="text" id="orderid" name="orderid" value="${orderid}" readonly="readonly" /></td>
					<th>${internationalConfig.退费金额}</th>
					<td><input type="text" name="payPrice" id="payPrice" class="easyui-validatebox easyui-numberbox" precision="2" min="0" max="${payPrice}"
							   data-options="required:true,validType:'number'" />(${internationalConfig.订单金额}：${payPrice}${internationalConfig.元},${internationalConfig.可退款金额}：<span class="ref_money">${payPrice}</span>${internationalConfig.元})</td>
				</tr>
				<tr>
					<th>${internationalConfig.退款原因}</th>
					<td><input type="text" id="reason" name="reason"/></td>
				</tr>
			</table>
			<p style="padding:8px;font-weight:bold;">${internationalConfig.退款记录}</p>
			<div style="width:1200px;">
				<table id="tk-table">
					<tr>
						<th width="150">${internationalConfig.发起时间}</th>
						<th width="50">${internationalConfig.退款金额}</th>
						<th width="150">${internationalConfig.退款原因}</th>
						<th width="150">${internationalConfig.退款结果}</th>
						<th width="80">${internationalConfig.退款状态}</th>
						<th width="200">${internationalConfig.支付平台订单号}</th>
						<th width="200">${internationalConfig.支付平台退款号}</th>
						<th width="200">${internationalConfig.第三方支付退款流水}</th>
						<th width="150">${internationalConfig.退款成功时间}</th>
					</tr>

				</table>
			</div>
		</form>
	</div>
</div>