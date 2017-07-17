<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');
		$('#form')
				.form(
						{
							url : '/free_vip/vip_send.json',
							onSubmit : function() {
								parent.$.messager.progress({
									title : '提示',
									text : '数据处理中，请稍后....'
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
									parent.$.messager.alert('成功', "请求已发送，请等待，1分钟后再查看！", 'success');
									parent.$.modalDialog.openner_dataGrid.datagrid('reload');
									parent.$.modalDialog.handler.dialog('close');
								} else {
									parent.$.messager.alert('错误', "请输入用户id",'error');
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
					<li><span>&nbsp;&nbsp;&nbsp;输入用户ID：</span><input name="userId" type="text" class="easyui-validatebox span2" value=""></li>
					<li style="padding-left:20px">或者</li>
					<li><span>批量导入UID：</span><input type="file" name="myfile" value="批量导入"></li>
					</ul>
					</td>
				</tr>
				<tr>
					<td >
					<span>选择套餐类型：</span>
					<select name="vipType">
					<c:forEach items="${ packageConfigList}" var="item">
					<option value="${item.id }">${item.description }</option>
					</c:forEach>
					</select>
					 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span>服务时长：</span><input type="text"  name="days" class="tabla_form_input_px  easyui-numberbox"   data-options="min:1,max:365,required:true" />天，
					<span>观影卷：</span><input type="text"  name="ticket" class="tabla_form_input_px  easyui-numberbox"   data-options="min:0,max:60;required:true"  value="0" />张
					</td>
				</tr>
				<tr>
					<td>
						<dl>
							<dt>说明</dt>
							<dd>1、输入用户ID和批量导入UID一次性只可任选一种；</dd>
							<dd>2、UID可批量导入，且是txt文件，uid用<b style="color:#f00">逗号</b>分隔为，每次导入的uid个数不超过 <b style="color:#f00">10,000 </b>个；</dd>
							<dd>3、天数最小<b style="color:#f00">1</b>天，最大<b style="color:#f00">365</b>天。</dd>
						</dl>
					</td>
				</tr>
			</table>
		</form>
	</div>
</div>