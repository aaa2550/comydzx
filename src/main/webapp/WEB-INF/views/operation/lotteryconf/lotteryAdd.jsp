<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');
		$('#form')
				.form(
						{
							url : '${pageContext.request.contextPath}/lotteryconf/lottery/add.do',
							onSubmit : function() {
								parent.$.messager.progress({
									title : '${internationalConfig.提示}',
									text : '${internationalConfig.数据处理中}'
								});

								var isValid = $(this).form('validate');
								if (!isValid) {
									parent.$.messager.progress('close');
								}
								return isValid;
							},
							success : function(obj) {
								parent.$.messager.progress('close');
								var result = $.parseJSON(obj);
								if (result.code == 0) {
									parent.$.modalDialog.openner_dataGrid
											.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
									parent.$.modalDialog.handler
											.dialog('close');
								} else {
									parent.$.messager.alert('${internationalConfig.页面错误}',
											result.msg, 'error');
								}
							}
						});
	});

	//增加自定义的表单验证规则
	/**	$.extend($.fn.datebox.defaults.rules,
	 {
	 endTime : {
	 validator : function(value, param) {//
	 if (param[0] && value) {
	 if (value.length > 10) {
	 value = value.substring(0, 10);
	 }
	 var ed_arr = value.split('-');
	 var endDate = new Date(ed_arr[0], ed_arr[1] - 1,
	 ed_arr[2]);
	 var sDate = $(param[0]).datebox('getValue');
	 if (sDate) {
	 if (sDate.length > 10) {
	 sDate = sDate.substring(0, 10);
	 }
	 var sd_arr = sDate.split('-');
	 var startDate = new Date(sd_arr[0],
	 sd_arr[1] - 1, sd_arr[2]).getTime();
	 if ((endDate.getTime() - startDate) > 0) {
	 return true;
	 }
	 }
	 }
	 return false;
	 },
	 message : "结束时间必须大于开始时间或者日期不是yyyy-MM-dd格式"
	 }
	 });
	 */
	$.extend($.fn.validatebox.defaults.rules, {
		number : {
			validator : function(value, param) {
				var reg = new RegExp("^[0-9]+(.[0-9]+)?$");
				return reg.test(value);
			},
			message : '${internationalConfig.请输入合法数字}'
		}
	});
	$.extend($.fn.validatebox.defaults.rules, {
		int : {
			validator : function(value, param) {
				var reg = new RegExp("^[0-9]+$");
				return reg.test(value);
			},
			message : '${internationalConfig.请输入合法整数}'
		}
	});
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title=""
		style="overflow: hidden;">
		<form id="form" method="post"
			action="${pageContext.request.contextPath}/mealController/create">
			<table style="margin-left: 30px; margin-top: 20px">

				<tr>
					<th>${internationalConfig.名称}</th>
					<td><label> <input type="text" name="lotteryName"
							style="width: 150px" class="easyui-validatebox"
							data-options="required:true" />
					</label></td>
				</tr>

				<tr>
					<th>${internationalConfig.状态}</th>
					<td><label> <select name="status" style="width: 135px">
								<option value="1">${internationalConfig.线上}</option>
								<option value="2">${internationalConfig.线下}</option>
						</select>
					</label></td>
				</tr>

				<tr>
					<th>${internationalConfig.开始时间}</th>
					<td><label> <input type="text" name="startTime"
							id="expireDate" style="width: 165px" class="easyui-datebox"
							class="easyui-validatebox" data-options="required:true" />
					</label></td>
				</tr>

				<tr>
					<th>${internationalConfig.结束时间}</th>
					<td><label> <input type="text" name="endTime"
							id="expireDate" style="width: 165px" class="easyui-datebox"
							class="easyui-validatebox" data-options="required:true" />
					</label></td>
				</tr>

				<tr>
				</tr>

			</table>
		</form>
	</div>
</div>