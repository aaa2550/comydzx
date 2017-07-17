<%@page import="jmind.core.security.MD5"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');
		$('#form')
				.form(
						{
							url : '/rebate/channel/type_edit',
							onSubmit : function() {
								parent.$.messager.progress({
									title : '${internationalConfig.提示}',
									text : '${internationalConfig.数据处理中}'
								});
								var isValid = $(this).form('validate');
								if (!isValid) {
									parent.$.messager.progress('close');
								}
								// alert(isValid);
								return isValid;
							},
							success : function(result) {
								parent.$.messager.progress('close');
								result = $.parseJSON(result);
								if (result.code == 0) {
									parent.$.messager.alert('${internationalConfig.成功}', result.msg, 'success');
									parent.$.modalDialog.openner_dataGrid.datagrid('reload');
									parent.$.modalDialog.handler.dialog('close');
								} else {
									parent.$.messager.alert('${internationalConfig.错误}', result.msg,'error');
								}
							}
						});
	});


</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="">
		<form id="form" method="post">
			<table class="table table-form" style="width:100%">
				<tr>
					<td >
					<input name="id"  type="hidden"  value="${channel.id }">
					<span class="left_span">${internationalConfig.渠道类型}：</span>
					<input name="type"  type="text" class="easyui-validatebox span2"  value="${channel.type }"   data-options="required:true"></td>
				</tr>
				<tr>				
					<td >
					<span class="left_span">${internationalConfig.渠道描述}：</span>
					<textarea name="description"  rows="" cols="">${channel.description }</textarea>
					</td>
				</tr>
			</table>
		</form>
	</div>
</div>