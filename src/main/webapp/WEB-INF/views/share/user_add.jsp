<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript">

	$(function() {
		parent.$.messager.progress('close');
		$('#addform').form({
			url : '${pageContext.request.contextPath}/share_user/add_submit.json',
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
				if (result.code == 0) {
					parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.添加成功初始密码为}:' + result.msg, 'success');
				} else {
					parent.$.messager.alert('${internationalConfig.错误}', result.msg,'error');
				}
				parent.$.modalDialog.openner_dataGrid.datagrid('reload');
				parent.$.modalDialog.handler.dialog('close');
			}
		});
	});
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="" style="overflow: hidden;">
		<form id="addform" method="post">
			<table class="table table-hover table-condensed">
				<tr>
					<th>${internationalConfig.操作员名}</th>
					<td><input name="name" type="text" placeholder="${internationalConfig.请输入操作员名}" class="easyui-validatebox span2" data-options="required:true" value=""></td>
				</tr>
				<tr>
					<th>${internationalConfig.接收邮箱}</th>
					<td><input name="email" type="text" class="easyui-validatebox" data-options="validType:'email'"></td>
				</tr>
				<tr>
					<th>${internationalConfig.关联角色}</th>
					<td>
						<select name="roleId" style="width: 160px">
                        	<c:forEach items="${roleList}" var="var">
        				    <option value='${var.id}' >${var.name}</option>
                        	</c:forEach>
                        </select>
					</td>
				</tr>
			</table>
		</form>
	</div>
</div>