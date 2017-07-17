<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<%@ include file="/WEB-INF/views/inc/jstl.inc"%>

<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');

		var dedefineTime=$(".defineTime_box").find('.defineTime').clone(true);

		var dedefineTimeBox=$(".defineTime_box");
		dedefineTimeBox.find('.defineTime').eq(1).remove();

		$('#form').form({
			url : '/v2/product/template/save',
			onSubmit : function() {
				var vipName = $("#typeId").val();
				if(vipName==null){
					parent.$.messager.alert('${internationalConfig.失败}', '${internationalConfig.请选择会员名称}', 'error');
					return false;
				}

				parent.$.messager.progress({
					title : '${internationalConfig.提示}',
					text : '${internationalConfig.数据处理中}....'
				});
				$("#typeId").removeAttr("disabled");
				$("#vipType").removeAttr("disabled");
				$("#incidentType").removeAttr("disabled");
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
					parent.$.messager.alert('${internationalConfig.成功}', '${noteTemplate==null?internationalConfig.添加成功:internationalConfig.编辑成功}', 'success');
					parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
					parent.$.modalDialog.handler.dialog('close');
				}else if(result.code == 1){
					parent.$.messager.alert('${internationalConfig.失败}', '${internationalConfig.已存在该类型短信模板}', 'error');
				}else if(result.code == 2){
					parent.$.messager.alert('${internationalConfig.失败}', '${internationalConfig.短信名称或者短信内容模板字数多长}', 'error');
				}else{
					parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
				}
			}
		});
	});


	$.extend($.fn.validatebox.defaults.rules, {
		specificNo : {
			validator : function(value, param) {
				var reg = new RegExp("^\\s*[0-9]*[1-9][0-9]*\\s*$");
				return reg.test(value);
			},
			message : '${internationalConfig.请输入合法整数}'
		}
	});
	var chose = '${noteTemplate.typeId}';
	if(chose!=""){
		$("#typeId").attr("disabled","disabled");
		$("#vipType").attr("disabled","disabled");
		$("#incidentType").attr("disabled","disabled");
	}
	function choose(){
		var vipType = $("#vipType").val();
		$.ajax({
			url : "/v2/product/template/getTypeId",
			data : {
				'pid' : vipType
			},
			success : function(result) {


				var directIndex = null;
				var optionsHtml = "";
				var optionhtml = '';
				var select = '';
				optionsHtml += optionhtml;
				$("#typeId").empty();
				for (directIndex in result) {
					var directModel = result[directIndex];
					if(chose==directModel.id){select='selected'}else{select=''}
					var optionHtml = '<option value="'+directModel.id+'"'+select+'>'+directModel.name+'</option>';
					optionsHtml += optionHtml;
				}
				$("#typeId").html(optionsHtml);
			},
			dataType : "json",
			cache : false
		});
	}
	//会员类别联动
	$(function(){
		choose();
		$("#vipType").change(function() {
			choose();
		});
	});
	$.extend($.fn.validatebox.defaults.rules, {
		selectRequire: {
			validator: function (value, param) {
				if(value=="-1"){
					return false;
				}else{
					return true;
				}
			},
			message: '${internationalConfig.请选择}'
		},
		textareaReq:{
			validator: function (value, param) {
				if(value==""){
					return false;
				}else{
					return true;
				}
			},
			message: '${internationalConfig.请输入内容}'
		}
	});

</script>

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
				<input type="hidden" name="id" value="${noteTemplate.id}"/>
				<tr>
					<th><b style="color: red">*</b>${internationalConfig.短信名称}</th>
					<td><input type="text" name="noteName" value="${noteTemplate.noteName}" class="easyui-validatebox"
							   data-options="required:true,"/> <span id="message" style="color: red;font-size: 12px"></span></td>
				</tr>

				<tr>
					<th><b style="color: red">*</b>${internationalConfig.会员类型}</th>
					<td>
						<select name="vipType" id="vipType" class="easyui-validatebox" data-options="validType:'selectRequire'">
							<option value="-1">${internationalConfig.全部}</option>
							<c:forEach items="${vipCategoryList}" var="vipCategory">
								<option value="${vipCategory.category}" ${vipCategory.category == noteTemplate.vipType ? "selected":""}> ${internationalConfig[vipCategory.name]}</option>
							</c:forEach>
						</select>
					</td>
				</tr>

				<tr>
					<th><b style="color: red">*</b>${internationalConfig.会员名称}</th>
					<td>
						<div class="defineTime_box">
							<div class="txt-middle" >
								<select name="typeId" id="typeId">

								</select>

							</div>
						</div>

					</td>

				</tr>

				<tr>
					<th><b style="color: red">*</b>${internationalConfig.事件类型}</th>
					<td>
						<select name="incidentType" id="incidentType"  class="easyui-validatebox">
							<option ${noteTemplate.incidentType == 10001 ? "selected":""} value="10001">${internationalConfig.开通会员提醒}</option>
							<option ${noteTemplate.incidentType == 10002 ? "selected":""} value="10002">${internationalConfig.会员自扣费提醒}</option>
							<option ${noteTemplate.incidentType == 10003 ? "selected":""} value="10003">${internationalConfig.解除自扣费提醒}</option>
						</select>
					</td>
				</tr>

				<tr>
					<th><b style="color: red">*</b>${internationalConfig.微信支付宝短信内容模板}</th>
					<td>
						<textarea style="height:100px;width:500px;" name="noteContent"  class="txt-middle easyui-validatebox" data-options="required:true">${noteTemplate.noteContent}</textarea>
					</td>
				</tr>

				<tr>
					<th><b style="color: red">*</b>${internationalConfig.手机话费短信内容模板}</th>
					<td>
						<textarea style="height:100px;width:500px;" name="phoneBillNoteContent"  class="txt-middle easyui-validatebox" data-options="required:true">${noteTemplate.phoneBillNoteContent}</textarea>
					</td>
				</tr>

				<tr>
					<th><b style="color: red">*</b>${internationalConfig.IAP短信内容模板}</th>
					<td>
						<textarea style="height:100px;width:500px;" name="iapNoteContent"  class="txt-middle easyui-validatebox" data-options="required:true">${noteTemplate.iapNoteContent}</textarea>
					</td>
				</tr>

			</table>
		</form>
	</div>
</div>