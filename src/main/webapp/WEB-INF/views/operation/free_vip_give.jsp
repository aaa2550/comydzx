<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<style>
	span {
		margin-right: 10px;
	}
	textarea {
		width: 400px;
		height: 60px;
	}
</style>
<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');
		$('#form')
				.form(
						{
							url : '/free_vip/vip_give.json',
							onSubmit : function() {
								parent.$.messager.progress({
									title : '${internationalConfig.提示}',
									text : '${internationalConfig.数据处理中请稍后}....'
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
									parent.$.messager.alert('${internationalConfig.成功}', "${internationalConfig.请求已发送}", 'success');
									parent.$.modalDialog.openner_dataGrid.datagrid('reload');
									parent.$.modalDialog.handler.dialog('close');
								} else {
									parent.$.messager.alert('${internationalConfig.错误}', "${internationalConfig.请输入用户id}",'error');
								}
							}
						});
	});


</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="" style="overflow: hidden;">
		<form id="form" method="post"  enctype="multipart/form-data"    accept-charset="utf-8">
			<table class="table table-form" style="width:100%">
				<tr>
					<td>
					<ul>
					<li><span>${internationalConfig.输入用户ID}</span><input name="userId" type="text" class="easyui-validatebox span2" value=""></li>
					<li style="padding-left:20px">${internationalConfig.或者}</li>
					<li><span>${internationalConfig.批量导入UID}</span><input type="file" name="myfile" value="${internationalConfig.批量导入}"></li>
					</ul>
					</td>
				</tr>
				<tr>
					<td >
					<span>${internationalConfig.选择套餐类型}</span>
					<select name="vipType">
					<c:forEach items="${ packageConfigList}" var="item">
						<c:if test="${item.category!=103}"> <%-- 无法赠送站外会员 --%>
						<option value="${item.id }">${item.name }</option>
						</c:if>
					</c:forEach>
					</select>
					 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span>${internationalConfig.服务时长}</span><input type="text"  name="days" class="tabla_form_input_px  easyui-numberbox"   data-options="min:1,max:365,required:true" />&nbsp;${internationalConfig.天}<%--，
					<span>${internationalConfig.观影券}</span><input type="text"  name="ticket" class="tabla_form_input_px  easyui-numberbox"   data-options="min:0,max:60;required:true"  value="0" />${internationalConfig.张}--%>
					</td>
				</tr>
				<tr>
					<td >
						<div>${internationalConfig.赠送理由}</div>
						<div>
							<textarea name="description" class="easyui-validatebox" data-options="required:true,maxlength:255" maxlength="255">${description}</textarea>
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<dl>
							<dt>${internationalConfig.说明}</dt>
							<dd>1、${internationalConfig.输入用户ID和批量导入UID一次性只可任选一种}；</dd>
							<dd>2、${internationalConfig.UID可批量导入}</dd>
							<dd>3、${internationalConfig.天数最小1天}</dd>
							<dd>4、${internationalConfig.txt文件编码必须为ANSI}</dd>
						</dl>
					</td>
				</tr>
			</table>
		</form>
	</div>
</div>