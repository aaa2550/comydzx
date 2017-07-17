<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%
	request.setCharacterEncoding("UTF-8");
	String orderid = request.getParameter("orderid");
	String fromUserId = request.getParameter("userid");
%>
<script type="text/javascript">
	parent.$.messager.progress('close');
	$(function() {
		$('#form')
				.form(
						{
							url : '${pageContext.request.contextPath}/vip_transfer/submit.json',
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
								if (result.code == 0) {
									parent.$.messager.alert('${internationalConfig.成功}', result.msg, 'success');									
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
	<div data-options="region:'center'" title="" style="overflow: hidden;">
		<form id="form" method="post">
			<input type="hidden" name="orderId" value="<%=orderid%>" />
			<input type="hidden" name="fromUserId" value="<%=fromUserId%>" />
			<table style="margin-left: 20px; margin-top: 20px; width: 85%">
				<tr>
					<th style="width: 80px">${internationalConfig.转出用户}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>ID:</th>
					<th><input type="text" disabled="disabled" name="fromUserIdShow"
						style="width: 240px" class="easyui-validatebox"
						data-options="required:true" value="<%=fromUserId%>" /></th>
				</tr>
				<tr>
					<th style="width: 80px">${internationalConfig.订单}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>ID:</th>
					<th><input type="text" disabled="disabled" name="orderids"
						style="width: 240px" class="easyui-validatebox"
						data-options="required:true" value="<%=orderid%>" /></th>
				</tr>
				<tr>
					<th style="width: 80px">${internationalConfig.转入用户}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>ID:</th>
					<td><input type="text" name="toUserId" style="width: 240px"
						class="easyui-validatebox" data-options="required:true" /></td>
				</tr>

			</table>
		</form>
	</div>
</div>