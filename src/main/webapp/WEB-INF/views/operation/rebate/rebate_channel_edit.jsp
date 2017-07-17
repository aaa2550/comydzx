<%@page import="jmind.core.security.MD5"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<style type="text/css">

</style>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title=""
		style="overflow: hidden;">
		<form id="form" method="post">
			<table class="table table-form easyui-form" style="width:100%">
				<tr>				
					<td >
						<span class="left_span">${internationalConfig.渠道名称}：</span>
						<input name="id" type="hidden"  value="${channel.id }">
						<input name="name" type="text" class="easyui-validatebox  easyui-textbox span2"  value="${channel.name }"   data-options="required:true">
					</td>						
				 <td>
				 	<span class="left_span">${internationalConfig.渠道类型}：</span>
					<select name="type" class="rebate_select">				
						<c:forEach items="${ channelType}" var="item">
							<option value="${item.key }"   >${item.value }</option>
						</c:forEach>
					</select>
				</td>
				</tr>
				<tr>					
			     <td>	
			     	<span class="left_span">${internationalConfig.状态}：</span>
					<select name="status" class="rebate_select">				
						<option value="1">${internationalConfig.有效}</option>
						<option value="2">${internationalConfig.失效}</option>
						<option value="3">${internationalConfig.暂停}</option>
					</select>
				</td>
				<td>
					<span class="left_span">${internationalConfig.区域}：</span>
					<select name="area" class="rebate_select">				
						<c:forEach items="${ province}" var="item">
							<option value="${item.key }"   >${item.value }</option>
						</c:forEach>
					</select>
				</td>
				</tr>
				<tr>					
					<td >
					<span class="left_span">${internationalConfig.负责人}：</span>
					<input type="text"  name="principal"  value="${channel.principal }" /></td>							
					<td >
					<span class="left_span">${internationalConfig.联系方式}：</span>
					<input type="text"  name="mobile"  value="${channel.mobile }" /></td>
				</tr>
				<tr>					
					<td >
					<span class="left_span">${internationalConfig.上级渠道}：</span>
					<select name="parentId" class="rebate_select">	
						<option value="0" >${internationalConfig.无}</option>
						<c:forEach items="${channels }"  var="item">
						<option value="${item.id }"   >${item.name }</option>
						</c:forEach>
					</select>
              		</td>
					<td >
					<span class="left_span">${internationalConfig.渠道级别}：</span>
					<select name="level" class="rebate_select">				
						<c:forEach begin="1"  end="10" var="item">
						<option value="${item }"   >${item }${internationalConfig.级}</option>
						</c:forEach>
					</select>
					</td>
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
							url : '/rebate/channel/edit',
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
<c:if test="${! empty channel }">
<script> 
$("select[name=type]").val('${channel.type}');
$("select[name=status]").val('${channel.status}');
$("select[name=parentId]").val('${channel.parentId}');
$("select[name=area]").val('${channel.area}');
$("select[name=level]").val('${channel.level}');
</script>
</c:if>