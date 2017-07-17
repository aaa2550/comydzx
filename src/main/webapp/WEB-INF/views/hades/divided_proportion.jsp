<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script src="/static/lib/swfupload/swfupload.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');
		$('#form').form({
			url : '${pageContext.request.contextPath}/hades/product/divided_proportion_upd.json',
			onSubmit : function() {
				//去除两个默认checkbox的disabled属性，让后台能够得到这两个值
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
                	parent.$.messager.alert('成功', '分成比例编辑成功', 'success');
					parent.$.modalDialog.openner_dataGrid.datagrid('reload');
					parent.$.modalDialog.handler.dialog('close');
				} else {
					parent.$.messager.alert('错误', result.msg, 'error');
				}
			}
		});
	});
</script>

<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="">
		<form id="form" method="post"
			action="#">
			<input type="hidden" name="appId" value="${app.id}" />
			<input type="hidden" name="appKey" value="${app.appKey}" />
			<table class="table table-form">
				<colgroup>
					<col width="100">
					<col width="*">
				</colgroup>
				<tr>
					<td style="text-align:right;">应用名称：</td>
					<td><input type="text" name="appName" value="${app.name}" readonly="readonly" /></td>
				</tr>
				<tr>
					<td style="text-align:right;">分成比例：</td>
					<td><input type="text" required="true" name="dividedProportion" class="easyui-numberbox" precision="2" value="0.1" /></td>
				</tr>
			</table>
		</form>
	</div>
</div>