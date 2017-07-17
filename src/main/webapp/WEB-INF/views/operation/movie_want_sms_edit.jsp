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
						<span class="left_span">pid：</span>
						<input name="pid" type="text"  value="${channel.pid }"   class="easyui-numberbox"   data-options="min:1,required:true" >
					</td>						
				</tr>
				<tr>					
			     <td>	
			     <span class="left_span">${internationalConfig.短信文案}：</span>
			     	<textarea rows="" cols=""  name="content">${channel.content }</textarea>
				</td>
				</tr>
				<tr>
				<td>
					<span class="left_span">${internationalConfig.立即发送}：</span>
					<select name="flag" >				
						<option value="1">${internationalConfig.否}</option>
						<option value="2">${internationalConfig.是}</option>
					</select>
				</td>
				</tr>
			
				<tr>					
					<td >
					<span class="left_span">${internationalConfig.发送时间}：</span>
					<input name="opTime"  id="opTime"  value="${channel.opTime }" class="easyui-datetimebox " >
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
							url : '/movie_want/sms/edit',
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
