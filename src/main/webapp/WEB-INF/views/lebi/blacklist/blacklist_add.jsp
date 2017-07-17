<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');
		$('#form').form({
			url : '${pageContext.request.contextPath}/lebi/blacklist/blacklistsave',
			success : function(result) {
				parent.$.messager.progress('close');
				result = $.parseJSON(result);
				if (result.code == 0) {
                	parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.添加成功}', 'success');
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
		<form id="form" method="post" >
			<table style="width: 100%" class="table table-form" id="tb1">
				<colgroup>
					<col width="90">
					<col width="100">
					<col width="80">
					<col width="*">
				</colgroup>
				<tr>
					<th>用户ID：</th>
					<td>
						<input type="text" name="userid" class="easyui-validatebox" data-options="required:true" />
					</td>
					<td></td>
					<td></td>
				</tr>
				<!-- 新增APP_PRODUCT_ID参数 -->
				<tr>
					<th>用户手机号：</th>
					<td>	<input type="text" name="userphone" class="easyui-validatebox" data-options="required:true" /></td>
					<td></td>
					<td></td>
				</tr>	
				
				<tr>
					<th>终端地址：</th>
					<td>
						<input type="text" name="terminaladdr" class="easyui-validatebox" data-options="required:true" />
					</td>
					<td></td>
					<td></td>
				</tr>
				<tr>
					<th>限制期限：</th>
					<td colspan="3">
					  <select name="limitterm" class="span2">
		            	<option value="" selected>全部</option>
		                <option value="7">7天</option>
		                <option value="30">1个月</option>
		                <option value="90">3个月</option>
		                <option value="360">12个月</option>
		                <option value="3600">永久</option>
		              </select>
					</td>
				</tr>
				<tr>
					<th>限制原因</th>
					<td colspan="3">
						<textarea id="limitreason" class="text-area" name="limitreason" rows="5" cols="60">${recommendConfig.smsContent } </textarea>
					</td>
				</tr>
			</table>
		</form>
	</div>
</div>