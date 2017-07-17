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
			url : '/movie_ticket_issued_rules/save',
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
					parent.$.messager.alert('${internationalConfig.成功}', '${movieTicketIssuedRulesInfo==null?internationalConfig.添加成功:internationalConfig.编辑成功}', 'success');
					parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
					parent.$.modalDialog.handler.dialog('close');
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
				<input type="hidden" name="id" value="${movieTicketIssuedRulesInfo.id}"/>
				<tr>
					<th><b style="color: red">*</b>${internationalConfig.非会员下单发放}：</th>
					<td><input type="text" name="nonmember" value="${movieTicketIssuedRulesInfo.nonmember}" class="easyui-validatebox"
							   data-options="required:true,"/>${internationalConfig.张}</td>
				</tr>

				<tr>
					<th><b style="color: red">*</b>${internationalConfig.会员续费发放}：</th>
					<td><input type="text" name="vipRenewal" value="${movieTicketIssuedRulesInfo.vipRenewal}" class="easyui-validatebox"
							   data-options="required:true,"/>${internationalConfig.张}</td>
				</tr>

				<tr>
					<th><b style="color: red">*</b>${internationalConfig.会员周期发放}：</th>
					<td><input type="text" name="vipCycle" value="${movieTicketIssuedRulesInfo.vipCycle}" class="easyui-validatebox"
							   data-options="required:true,"/>${internationalConfig.张}</td>
				</tr>

				<tr>
					<th><b style="color: red">*</b>${internationalConfig.有效期}：</th>
					<td><input type="text" name="validPeriod" value="${movieTicketIssuedRulesInfo.validPeriod}" class="easyui-validatebox"
							   data-options="required:true,"/></td>
					<td>
						<select name="validPeriodUnit" id="validPeriodUnit"  class="easyui-validatebox">
							<option ${movieTicketIssuedRulesInfo.validPeriodUnit == 1 ? "selected":""} value="1">${internationalConfig.自然月}</option>
						</select>
					</td>
				</tr>

				<tr>
					<th><b style="color: red">*</b>${internationalConfig.发放周期}：</th>
					<td><input type="text" name="issueCycle" value="${movieTicketIssuedRulesInfo.issueCycle}" class="easyui-validatebox"
							   data-options="required:true,"/></td>
					<td>
						<select name="issueCycleUnit" id="issueCycleUnit"  class="easyui-validatebox">
							<option ${movieTicketIssuedRulesInfo.issueCycleUnit == 1 ? "selected":""} value="1">${internationalConfig.自然月首次下单时间推算}</option>
						</select>
					</td>
				</tr>

			</table>
		</form>
	</div>
</div>