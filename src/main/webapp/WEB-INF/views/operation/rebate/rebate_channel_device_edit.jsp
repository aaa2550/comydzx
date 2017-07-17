<%@page import="jmind.core.security.MD5"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title=""
		style="overflow: hidden;">
		<form id="form" method="post"  enctype="multipart/form-data"    accept-charset="utf-8">
			<table class="table table-form" style="width:100%">
				<tr>
					<td >
					<span class="left_span">${internationalConfig.批次标识}：</span>
					<input name="id" type="hidden"  value="${channel.id }">
					<input name="name" type="text" class="easyui-validatebox span2"  value="${channel.name }">
					</td>
						
				 <td>
				 	<span class="left_span">${internationalConfig.销售渠道}：</span>
					<select name="channel" class="rebate_select">				
						<c:forEach items="${ channels}" var="item">
							<option value="${item.id }"   >${item.name }</option>
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
						<span class="left_span">${internationalConfig.设备类型}：</span>
						<select name="devicetype" class="rebate_select">				
						<option value="1">${internationalConfig.超级电视}</option>
						<option value="2">${internationalConfig.超级手机}</option>
						</select>
					</td>
				</tr>
				<tr>					
					<td colspan="2">
					<span class="left_span">${internationalConfig.销售人}：</span>
					<input type="text"  name="principal"  value="${channel.principal }"/>
					</td>
				</tr>
				<tr>					
					<td colspan="2">
					<span class="left_span">${internationalConfig.销售数据}</span>
					<input type="file"   name="myfile" />  
					<a href="/static/mb/channel_device.xlsx">${internationalConfig.模板下载}</a></td>
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
							url : '/rebate/channel/device_edit',
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
$("select[name=devicetype]").val('${channel.devicetype}');
$("select[name=channel]").val('${channel.channel}');
$("select[name=status]").val('${channel.status}');
</script>
</c:if>