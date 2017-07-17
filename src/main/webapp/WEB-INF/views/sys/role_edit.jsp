<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript">
	$(function() {
		$('#pid').combotree({
			url : '/role/tree',
			parentField : 'pid',
			lines : true,
			panelMaxHeight:200,
			value : '${role.pid}',
			onLoadSuccess : function() {
				parent.$.messager.progress('close');
			}
		});

		$('#form').form({
			url : '${pageContext.request.contextPath}/role/edit.json',
			onSubmit : function() {
				parent.$.messager.progress({
					title : '${internationalConfig.提示}',
					text : '${internationalConfig.数据处理中}'
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
					parent.$.modalDialog.openner_treeGrid.treegrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_treeGrid这个对象，是因为role.jsp页面预定义好了
					parent.$.modalDialog.handler.dialog('close');
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
					<td><input name="id" type="text" class="span2" value="${empty role ? 0 : role.id}" readonly="readonly"></td>
					<th>${internationalConfig.角色名称}</th>
					<td><input name="name" type="text" placeholder="${internationalConfig.请输入角色名称}" class="easyui-validatebox span2" data-options="required:true" value="${role.name}"></td>
				</tr>
				<tr>
					<th>${internationalConfig.排序}</th>
					<td><input name="seq" value="${role.seq}" class="easyui-numberspinner" style="width: 140px; height: 29px;" required="required" data-options="editable:false"></td>
					<th>${internationalConfig.上级角色}</th>
					<td><select id="pid" name="pid" style="width: 140px; height: 29px;"></select><img src="/static/style/images/extjs_icons/cut_red.png" onclick="$('#pid').combotree('clear');" /></td>
				</tr>
				<tr>
					<th>${internationalConfig.备注}</th>
					<td colspan="3"><textarea name="remark" rows="" cols="" class="span5">${role.remark}</textarea></td>
				</tr>
			</table>
		</form>
	</div>
</div>