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
					<col width="70">
					<col width="100">
					<col width="80">
					<col width="*">
				</colgroup>
				<tr>
			<td style="text-align: right;">应用名称：</td>
			<td><input type="text" name="name" maxlength="50" class="easyui-validatebox" required="true"/></td>
			<td style="text-align: right;">状态：</td>
			<td><select name="status">
					<option value="ACTIVE">有效</option>
					<option value="INACTIVE">无效</option>
			</select></td>
		</tr>
		<tr>
			<td style="text-align: right;">appKey：</td>
			<td colspan="3"><input type="text" name="appKey" style="width:70%;"/></td>
		</tr>
		<tr>
			<td style="text-align: right;">secretKey：</td>
			<td colspan="3"><input type="text" name="secretKey"  style="width:70%;" /></td>
		</tr>
		<tr>
			<td style="text-align: right;">secretKey2：</td>
			<td colspan="3"><input type="text" name="secretKey2"  style="width:70%;" /></td>
		</tr>
		<tr>
			<td style="text-align: right;">描述：</td>
			<td colspan="3"><textarea name="description" class="txt-middle"></textarea></td>
		</tr>
			</table>
		</form>
	</div>
</div>