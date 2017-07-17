<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="/WEB-INF/views/inc/jstl.inc"%>

<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');
		$('#form').form({
			url : '${pageContext.request.contextPath}/pay_query/refund.json',
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
                	parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.退款成功}', 'success');
					parent.$.modalDialog.openner_dataGrid.datagrid('reload');
					parent.$.modalDialog.handler.dialog('close');
				} else if(result.code == 2){
					parent.$.messager.alert('${internationalConfig.成功}','${internationalConfig.支付宝提交成功}' ,'success');
					parent.$.modalDialog.openner_dataGrid.datagrid('reload');
					parent.$.modalDialog.handler.dialog('close');
				} else {
					parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
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
			<input type="hidden" name="validatePrice" value="${validatePrice}">
			<input type="hidden" name="businessId" value="${businessId}">
			<input type="hidden" name="companyid" value="${companyid}">
			<table style="width: 100%" class="table table-form">
				<colgroup>
					<col width="90">
					<col width="100">
					<col width="120">
					<col width="*">
				</colgroup>
				<tr>
					<th>${internationalConfig.订单号}</th>
					<td><input type="text" id="corderId" name="corderId" value="${corderid}" readonly="readonly" /></td>
					<th>${internationalConfig.退费金额}</th>
					<td><input type="text" name="price"
						value="${validatePrice}" class="easyui-validatebox"
						data-options="required:true,validType:'number'" /></td>
				</tr>
			</table>
		</form>
	</div>
</div>