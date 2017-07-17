<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<%@ include file="/WEB-INF/views/inc/jstl.inc"%>

<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');
		$(".helpBtn").hover(function(){
			$(".hover-text").toggleClass("hide-text")
		})
		$('#form').form({
			url : '/channelAssociation/save',
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
					parent.$.messager.alert('${internationalConfig.成功}', '${channelAssociation==null?internationalConfig.添加成功:internationalConfig.编辑成功}', 'success');
					parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
					parent.$.modalDialog.handler.dialog('close');
				} else if(result.code == 1){
					parent.$.messager.alert('${internationalConfig.失败}', '${internationalConfig.合作公司名称重复}', 'error');
				}else if(result.code == 2){
					parent.$.messager.alert('${internationalConfig.失败}', '${internationalConfig.合作公司名称或者合作公司描述过长}', 'error');
				}else{
					parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
				}
			}
		});
	});

</script>
<style>
	.helpBtn{display: inline-block;width: 20px;height:20px;padding-left: 10px;}
	.helpBtn img{margin-bottom: 3px}
	.hover-text{position: absolute;width: 200px;top:-8px;left:80px;padding: 10px;border: 1px solid #ddd;box-shadow: 0 0 5px #ccc;background: #fff;border-radius: 5px}
	.hide-text{display: none;}
</style>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="">
		<form id="form" method="post"
			  action="/mealController/create">
			<table style="width: 100%" class="table table-form">
				<colgroup>
					<col width="90">
					<col width="140">
					<col width="*">
				</colgroup>
				<input type="hidden" name="id" value="${channelAssociation.id}"/>
				<tr>
					<th width="100"><b style="color: red">*</b>${internationalConfig.合作公司名称}</th>
					<td><input type="text" name="channelName" value="${channelAssociation.channelName}" class="easyui-validatebox"
							   data-options="required:true"/> <span id="message" style="color: red;font-size: 12px"></span></td>
				</tr>

				<tr>
					<th style="position: relative;">
						${internationalConfig.申请人}<span class="helpBtn"><img src="/static/style/images/stat/help_03.png"></span>
						<p class="hover-text hide-text">${internationalConfig.申请人为业务方申请创建公司的联系人非实际创建人}</p>
					</th>
					<td><input type="text" name="applicant" value="${channelAssociation.applicant}" class="easyui-validatebox" placeholder="@le.com"/>
					</td>
				</tr>

				<tr>
					<th>${internationalConfig.合作公司类型}</th>
					<td>
						<select name="companyType" class="easyui-validatebox" data-options="validType:'selectRequire'">
							<option value="1" ${channelAssociation.companyType == 1 ? "selected":""}>${internationalConfig.合作公司}</option>
							<option value="2" ${channelAssociation.companyType == 2 ? "selected":""}>${internationalConfig.合作公司收款公司}</option>
						</select>
					</td>
				</tr>

				<tr>
					<th><b style="color: red">*</b>${internationalConfig.合作公司描述}</th>
					<td>
						<textarea style="height:100px;width:500px;" name="ext" class="txt-middle easyui-validatebox" data-options="required:true">${channelAssociation.ext}</textarea>
					</td>
				</tr>

			</table>
		</form>
	</div>
</div>