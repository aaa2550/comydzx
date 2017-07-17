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
							url : '/movie_ticket/manager/edit',
							onSubmit : function() {
								parent.$.messager.progress({
									title : '提示',
									text : '数据处理中，请稍后....'
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
									parent.$.messager.alert('成功', result.msg, 'success');
									parent.$.modalDialog.openner_dataGrid.datagrid('reload');
									parent.$.modalDialog.handler.dialog('close');
								} else {
									parent.$.messager.alert('错误', result.msg,'error');
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
				<colgroup>
					<col width="250">
					<col width="*">
				</colgroup>
				<tr>
					
					<td ><input name="id"  type="hidden"    value="${channel.id }"><span>渠道名称：</span>
					<input name="name" type="text" class="easyui-validatebox span2"  value="${channel.name }">
					</td>
				</tr>
				<tr>				
					<td ><span>观影卷描述：</span><input name="description" type="text" class="easyui-validatebox span2" value="${channel.description }"></td>
				</tr>
				<tr>					
					<td ><span>开始时间：</span><input name="start"  id="start"  value="${channel.start }" class="easyui-datetimebox " data-options="required:true"></td>
				</tr>
					<tr>
					
					<td ><span>结束时间：</span><input name="end"  id="end" value="${channel.end }" class="easyui-datetimebox " data-options="required:true"></td>
				</tr>
				<tr>
				<td>	<span>赠送途径：</span>
				<select name="way">
				<option value="1"    >微信红包</option>
				</select>
				</td>
				</tr>
				<tr>
				<td>	<span>观影卷类型：</span>
				<select name="type">
				<option value="1"    >通用观影卷</option>
				<option value="2"    >特定观影卷</option>
				</select>
				</td>
				</tr>
				<tr>					
					<td ><span>观影卷有效期：</span>
					<input type="text"  name="days"  value="${channel.days }"  class="tabla_form_input_px  easyui-numberbox"   data-options="min:0,required:true"    />
					&nbsp;&nbsp;&nbsp;<span>权重：</span><input type="text"  name="weight"  value="${channel.weight }"  class="tabla_form_input_px  easyui-numberbox"   data-options="min:0,required:true"    />
					</td>
				</tr>
					<tr>					
					<td ><span>赠送人频率/次：</span>
					<input type="text"  name="sendHz"  value="${channel.sendHz }" class="tabla_form_input_px  easyui-numberbox"   data-options="min:0,required:true" />日/次  
					&nbsp;&nbsp;&nbsp;<input type="checkbox"  value="1"  name="allowMe"   ${ channel.allowMe==1 ? "checked":""}>允许赠送人领取 
					</td>
				</tr>	
				<tr>					
					<td ><span>领取人人频率/次：</span><input type="text"  name="receiveHz"  value="${channel.receiveHz }" class="tabla_form_input_px  easyui-numberbox"   data-options="min:0,required:true" />日  
					 </td>
				</tr>		
					<tr>					
					<td ><span>每次赠送张数：</span><input type="text"  name="eachCount"  value="${channel.eachCount }"  class="tabla_form_input_px  easyui-numberbox"   data-options="min:0,required:true"    />张/次</td>
				</tr>				
					<tr>					
					<td ><span>每次赠送人数：</span><input type="text"  name="eachNum"  value="${channel.eachNum }"  class="tabla_form_input_px  easyui-numberbox"   data-options="min:0,required:true" />人/次</td>
				</tr>
	
			</table>
		</form>
	</div>
</div>