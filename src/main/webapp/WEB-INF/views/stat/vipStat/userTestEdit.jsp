<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<style type="text/css">
		table th {text-align:right}
</style>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="">
		<form id="form" method="post">
			<table class="table table-form" style="width:100%">
				<input type="hidden" name="id" value="${userTest.id}">
				<tr>
					<th style="text-align:right">${internationalConfig.用户}ID：</th><td><input type="text" name="userId" class="easyui-validatebox" value="${userTest.userId}"
						data-options="required:true,validType:'int'" <c:if test="${userTest.id != null}"> disabled </c:if> onBlur="showLeInfo(this.value)">&nbsp;&nbsp;<span style="font-weight: bold; color: red">* 乐视网ID</span></td>
				</tr>
				<tr>
					<th style="text-align:right">${internationalConfig.用户名}：</th><td><input type="text" name="userName" class="easyui-validatebox" value="${userTest.userName}"></td>
				</tr>
				<tr>
					<th style="text-align:right">${internationalConfig.电话号码}：</th><td><input type="text" name="phone" class="easyui-validatebox" data-options="validType:'int'" value="${userTest.phone}"></td>
				</tr>
				<tr>
					<th style="text-align:right">${internationalConfig.邮箱}：</th><td><input type="text" name="email" class="easyui-validatebox" data-options="validType:'email'" value="${userTest.email}"></td>
				</tr>
				<tr>
					<th style="text-align:right">${internationalConfig.状态}：</th>
					<td>
						<select name="status" style="width:160px">
						<option value="1" <c:if test="${userTest.status == 1}"> selected </c:if> >${internationalConfig.启用}</option>
						<option value="0" <c:if test="${userTest.status == 0}"> selected </c:if> >${internationalConfig.停用}</option>
						</select>
					</td>
				</tr>
				<tr>
					<th style="text-align:right">${internationalConfig.用途描述}：</th><td><textarea name="description" rows=5 class="textarea easyui-validatebox" style="width:200px">${userTest.description}</textarea></td>
				</tr>
				
			</table>
		</form>
	</div>
</div>
<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');
		$('#form')
			.form(
					{
						url : '${pageContext.request.contextPath}/vipController/userTest/save',
						onSubmit : function() {
							parent.$.messager.progress({
								title : '${internationalConfig.提示}',
								text : '${internationalConfig.数据处理中请稍后}....'
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
								parent.$.messager.alert('${internationalConfig.失败}', result.msg, 'error');
							}
						}
					});
	});
	
	function showLeInfo(userId){
		$('input[name="userName"]').val('');
		$('input[name="phone"]').val('');
		$('input[name="email"]').val('');
		if(userId == ''){
			return ;
		}
		$.getJSON('${pageContext.request.contextPath}/vipController/userTest/ssoInfo' , {userId: userId} , function(result){
			if(result.code == 0){
				var user = result.data;
				if(user.nickname)
					$('input[name="userName"]').val(user.nickname);
				if(user.mobile)
					$('input[name="phone"]').val(user.mobile);
				if(user.email)
					$('input[name="email"]').val(user.email);
			}else{
				parent.$.messager.alert('${internationalConfig.失败}', result.msg, 'error');
			}
		})
		
	}
</script>