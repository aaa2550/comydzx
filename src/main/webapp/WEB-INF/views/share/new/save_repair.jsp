<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">

	$(function() {

		parent.$.messager.progress('close');

		$('#form').form({
			url : '/repair/save',
			onSubmit : function() {
				parent.$.messager.progress({
					title : '${internationalConfig.提示}',
					text : '${internationalConfig.数据处理中请稍后}'
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
				if (result.code==0) {
					parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.操作成功}', 'success');
					parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
					parent.$.modalDialog.handler.dialog('close');
				} else {
					parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
				}
			}
		});
	});

</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="">
		<form id="form" method="post">
			<input name="id" type="hidden" value="${copyright.id}">
			<table class="table">
				<tr>
					<th>规则ID：</th>
					<td><input name="ruleId" value="${dataRepairRecord.ruleId}"/></td>
				</tr>
				<tr>
					<th>开始时间：</th>
					<td><input name="startTime" value="${dataRepairRecord.startTime}" class="easyui-datebox"/></td>
				</tr>
			</table>
		</form>
	</div>
</div>