<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');
		$('#form').form({
			url : '${pageContext.request.contextPath}/lecard/lecard_expire_update.json',
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
                	parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.编辑成功}', 'success');
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
	<div data-options="region:'center',border:false" title=""
		style="overflow: hidden;">
		<form id="form" method="post"
			action="${pageContext.request.contextPath}/mealController/create">
			<input type="hidden" name="number" value="${lecard.number}" />
			<table style="width: 100%" class="table table-form">
				<colgroup>
					<col width="90">
					<col width="100">
					<col width="80">
					<col width="*">
				</colgroup>
				<tr>
					<th>${internationalConfig.卡号}</th>
					<td>${lecard.number}</td>
				</tr>
				<tr>
					<th>${internationalConfig.过期时间}(注：此修改是对整个批次时间修改)</th>
					<td><input type="text" name="expireDate" id="expireDate"
						value="<fmt:formatDate pattern="yyyy-MM-dd" value="${lecard.expireDate}"/>"
						class="easyui-datebox" data-options="required:true" /></td>
				</tr>
			</table>
		</form>
	</div>
</div>