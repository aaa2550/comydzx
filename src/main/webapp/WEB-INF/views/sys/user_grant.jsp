<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript">
	$(function() {

		$('#roleIds').combotree({
			url : '/role/tree',
			parentField : 'pid',
			lines : true,
			panelMaxHeight : 200,
			multiple : true,
			onLoadSuccess : function() {
				parent.$.messager.progress('close');
			},
			cascadeCheck : false,
			value : $.stringToList('${user.rids}')
		});

		$('#form').form({
			url : '${pageContext.request.contextPath}/user/grant.json',
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
				if (result.code==0) {
					parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
					parent.$.modalDialog.handler.dialog('close');
					parent.$.modalDialog.openner_dataGrid.datagrid('uncheckAll').datagrid('unselectAll').datagrid('clearSelections');
				} else {
					parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
				}
			}
		});
	});
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="" style="overflow: hidden;">
		<form id="form" method="post">
			<table class="table table-hover table-condensed table-form">
				<colgroup>
					<col width="70">
					<col width="100">
					<col width="70">
					<col width="*">
				</colgroup>
				<tr>
					<th>${internationalConfig.编号}</th>
					<td><input name="uid" type="text" class="span2" value="${user.uid}" readonly="readonly"></td>
					<th>${internationalConfig.所属角色}</th>
					<td><select id="roleIds" name="rids" style="width: 140px; height: 29px;"></select><img src="/static/style/images/extjs_icons/cut_red.png" onclick="$('#roleIds').combotree('clear');" /></td>
				</tr>
			</table>
		</form>
	</div>
</div>