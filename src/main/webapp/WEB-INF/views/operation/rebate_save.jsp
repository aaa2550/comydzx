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
							url : '/rebate/save',
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
	<div data-options="region:'center',border:false" title=""
		style="overflow: hidden;">
		<form id="form" method="post">
			<table class="table table-form" style="width:100%">
			
			
				<tr>
				<td>	<span>${internationalConfig.套餐类型}：</span>
				<select name="vipType">
			    	<option value="0"    >${internationalConfig.选择套餐类型}</option>
					<c:forEach items="${ packageConfigList}" var="item">
					<option value="${item.id }"   ${rebate.vipType==item.id ?"selected" :"" }  >${item.description }</option>
					</c:forEach>
					</select>
				</td>
				</tr>
						<tr>
				<td>	<span>${internationalConfig.连续月份}：</span>
				<select name="month">
			    	<option value="0"    >${internationalConfig.请选择}</option>
					<c:forEach var="item"  begin="1" end="6">
					<option value="${item}"   ${rebate.month==item ?"selected" :"" }  >${internationalConfig.连续}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${item }<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.月}</option>
					</c:forEach>
					</select>
				</td>
				</tr>
					<tr>					
					<td ><span>${internationalConfig.减免价格}：</span><input type="text"  name="price"  value="${rebate.price }" class="tabla_form_input_px  easyui-numberbox"  />${internationalConfig.元}</td>
				</tr>			
				
				
				
				
			</table>
		</form>
	</div>
</div>