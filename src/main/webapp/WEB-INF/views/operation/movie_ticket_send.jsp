<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');
		$('#form')
				.form(
						{
							url : '/movie_ticket/send',
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
								} else if(result.code == 1){
									parent.$.messager.alert('错误', "请输入用户id",'error');
								} else if(result.code == 2){
									parent.$.messager.alert('错误', "批量添加的uid超过最大限制",'error');
								} else if(result.code == 3){
									parent.$.messager.alert('错误', "输入用户ID和批量导入用户ID每次只可选择一种",'error');
								} else {
									parent.$.messager.alert('错误', "调用出现异常，失败",'error');
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
					<li><span>输入用户ID&nbsp;：</span><input name="uids" type="text" class="easyui-validatebox span2" value="" style="margin-left:5px"></li>
					<li style="padding-left:20px">或者</li>
					<li><span>批量导入UID：</span><input type="file" name="myfile" value="批量导入"></li>
					</ul>
					</td>
				</tr>
				<tr>
					<td>
					<ul>
					<li style="margin:3px"><span>观影券有效期：</span><input type="text"  name="days" class="tabla_form_input_px  easyui-numberbox"   data-options="required:true" style="width:100px" />&nbsp;&nbsp;天</li>
					<li style="margin:3px"><span>观影券数量：&nbsp;&nbsp;&nbsp;</span><input type="text"  name="num" class="tabla_form_input_px  easyui-numberbox"   data-options="required:true" style="width:100px" />&nbsp;&nbsp;张</li>
					</ul>
					</td>
				</tr>
				<tr>
					<td>
						<dl>
							<dt>说明</dt>
							<dd>1、输入用户ID和批量导入用户ID每次只可选择一种；</dd>
							<dd>2、UID可批量导入，且是txt文件，uid用<b style="color:#f00">逗号</b>分隔为，每次导入的uid个数不超过 <b style="color:#f00">10,000 </b>个；</dd>
							<dd>3、观影券仅限<b style="color:#f00">影视会员</b>身份获取，系统会自动识别会员身份；</dd>
							<dd>4、观影券天数会限制不得大于会员剩余时间，当大于时，会自动降为等同于会员剩余时间。</dd>
						</dl>
					</td>
				</tr>
			</table>
		</form>
	</div>
</div>