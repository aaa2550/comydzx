<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');
		$('#form')
				.form(
						{
							url : '/free_vip/add.json',
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
		style="overflow: hidden;">
		<form id="form" method="post">
			<table class="table table-form" style="width:100%">
				<colgroup>
					<col width="250">
					<col width="*">
				</colgroup>
				<tr>
					<th style="text-align: right">输入手机号码：</th>
					<td style="text-align: left"><input name="phoneNo"
						type="text" class="easyui-validatebox span2" value=""></td>
				</tr>
				<tr>
					<th style="text-align: right">输入用户ID：</th>
					<td style="text-align: left"><input name="userId"
						type="text" class="easyui-validatebox span2" value=""></td>
				</tr>
				<tr>
					<th style="text-align: right">选择会员时长：</th>
					<td style="text-align: left"><input name="vipType"
						type="radio" value="1" checked="checked">7天全屏影视会员</td>
				</tr>
			</table>
		</form>
	</div>
</div>