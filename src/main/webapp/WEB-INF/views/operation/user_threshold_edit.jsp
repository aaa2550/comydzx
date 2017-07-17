<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');
		$('#form').form({
			url : '${pageContext.request.contextPath}/user_threshold/update.json',
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
					parent.$.messager.alert('成功', '编辑成功', 'success');
					parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
					parent.$.modalDialog.handler.dialog('close');
				} else {
					parent.$.messager.alert('错误', '编辑失败', 'error');
				}
			}
		});
	});
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="">
		<form id="form" method="post">
			<table class="table table-form">
				<colgroup>
					<col width="100">
					<col width="*">
				</colgroup>
				<tr>
					<td width="100">IP个数</td>
					<td style="display: none"><input type="text" id="id" name="id" value="${threshold.id}"/></td>
					<td><input type="text" id="ips" name="ips" style="width:95%;" class="easyui-validatebox span2" data-options="required:true" value="${threshold.ipCount}"></input></td>
				</tr>
				<tr>
					<td>会员影片个数</td>
					<td><input type="text" id="ids" name="ids" style="width:95%;" class="easyui-validatebox span2" data-options="required:true" value="${threshold.idCount}"></input></td>
				</tr>
				<tr>
					<td>直播第三方标识数</td>
					<td><input type="text" id="flags" name="flags" style="width:95%;" class="easyui-validatebox span2" data-options="required:true" value="${threshold.flagCount}"></input></td>
				</tr>
				<tr>
					<td>直播第三方标识数</td>
					<td><input type="text" id="onecounts" name="onecounts" style="width:95%;" class="easyui-validatebox span2" data-options="required:true" value="${threshold.oneCount}"></input></td>
				</tr>
			</table>
		</form>
	</div>
</div>