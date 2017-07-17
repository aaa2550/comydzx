<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');
		$('#form')
				.form(
						{
							url : '${pageContext.request.contextPath}/hades/app/add_submit.json',
							onSubmit : function() {
								parent.$.messager.progress({
									title : '提示',
									text : '数据处理中，请稍后....'
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
									parent.$.messager.alert('成功', result.msg, 'success');
									parent.$.modalDialog.openner_dataGrid.datagrid('reload');
									parent.$.modalDialog.handler.dialog('close');
								} else {
									parent.$.messager.alert('错误', result.msg,'error');
								}
							}
						});
	});

	function submit() {
		$("#form").submit();
	}
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title=""
		style="overflow: auto;">
		<form id="form" method="post">
			<table class="table table-form">
				<colgroup>
					<col width="100">
					<col width="100">
					<col width="80">
					<col width="*">
				</colgroup>			
				<tr>
					
			<td style="text-align: right;">应用名称：</td>
			<td>
			<input type="text" name="name" maxlength="50" class="easyui-validatebox"  value="${paymentDetail.appName}"/>
			</td>
			<td style="text-align: right;">appKey：</td>
			<td ><input type="text" name="appKey" style="width:280px;" value="${paymentDetail.appKey}"/></td>
		</tr>
		<tr>
			<td style="text-align: right;">订单号：</td>
			<td><input type="text" name="orderNumber" maxlength="50" value="${paymentDetail.orderNumber}"/></td>
			<td style="text-align: right;">订单状态：</td>
			<td><input type="text" name="orderStatus" style="width:280px" value="${paymentDetail.poStatus}"/></td>
		</tr>
		<tr>
			<td style="text-align: right;">产品名称：</td>
			<td><input type="text" name="orderSubject"  maxlength="50"  value="${paymentDetail.orderSubject}"/></td>
			<td style="text-align: right;">支付价格：</td>
			<td ><input type="text" name="amount"  style="width:280px"  value="${paymentDetail.amount}"/></td>
		</tr>
		<tr>
			<td style="text-align: right;">币种：</td>
			<td><input type="text" name="currencyCode"  maxlength="50" value="${paymentDetail.currencyCode}"/></td>
			<td style="text-align: right;">支付方式：</td>
			<td><input type="text" name="paymentType"  style="width:280px" value="${paymentDetail.paymentType}"/></td>
		</tr>
		<tr>
			<td style="text-align: right;">支付人：</td>			
			<td ><input type="text" name="createdBy"  maxlength="50" value="${paymentDetail.createdBy}"/></td>
			<td style="text-align: right;">支付时间：</td>
			<td ><input type="text" name="createTime"  style="width:280px" value="${paymentDetail.createTime}"/></td>
		</tr>
			</table>
		</form>
	</div>
</div>