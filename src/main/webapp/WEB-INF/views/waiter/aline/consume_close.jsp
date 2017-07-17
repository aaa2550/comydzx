<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="/WEB-INF/views/inc/jstl.inc"%>
<style>
.blue{color:#00438a;}
.mb10{margin-bottom:10px;}
</style>
<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');
		if($("#isRenew").val()!=1){
			$("#cancle-dy").attr("disabled","disabled");
		}
		$('#form').form({
			url : '/consume/close',
			onSubmit : function() {
				parent.$.messager.progress({
					title : '${internationalConfig.提示}',
					text : '${internationalConfig.数据处理中}....'
				});
				
				
				//return isValid;
			},
			success : function(result) {
				parent.$.messager.progress('close');
				result = $.parseJSON(result);
				if (result.code == 0) {
					parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.关闭订单成功}', 'success');
					parent.$.modalDialog.openner_dataGrid.datagrid('reload');
					parent.$.modalDialog.handler.dialog('close');
				} else {
					parent.$.messager.alert(
							'${internationalConfig.错误}', '${internationalConfig.关闭订单失败}',
							'error');
				}
			}
		});
	});
	
</script>

<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="">
		<form id="form" method="post">
			<div style="padding:10px 0 0 20px;">
				<input type="hidden" name="userid" value="${userid}">
				<input type="hidden" name="orderid" value="${orderid}">
				<input type="hidden" id="isRenew" value="${isRenew}">

				<p><input type="radio" checked='checked' name="action" value="2"/>${internationalConfig.取消这个订单}</p>
				<p class="blue mb10">${internationalConfig.本订单对应的服务将被取消}</p>
				<p><input id="cancle-dy" type="radio" name="action" value="1"/>${internationalConfig.取消这个订单并取消订阅}</p>
				<p class="blue">${internationalConfig.变更用户的订阅状态}</p>
			</div>
		</form>
	</div>
</div>