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
							url : '${pageContext.request.contextPath}/lotteryconf/awardconf/edit.do',
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

	function dynamicChangeAward() {
		var lotteryId = $("#lotteryId").val();
		$
				.ajax({
					url : "${pageContext.request.contextPath}/lotteryconf/awardconf/getAwardsByLotteryId.json",
					data : {
						'lotteryId' : lotteryId
					},
					success : function(result) {
						var awardIndex = null;
						var optionsHtml = "";
						for (awardIndex in result.rows) {
							var award = result.rows[awardIndex];
							var optionHtml = '<option value="'+award.id+'">'
									+ award.awardName + '</option>';
							optionsHtml += optionHtml;
						}
						$("#awardId").html(optionsHtml);
					},
					dataType : "json",
					cache : false
				});
	}
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title=""
		style="overflow: hidden;">
		<form id="form" method="post"
			action="${pageContext.request.contextPath}/mealController/create">
			<input type="hidden" name="awardConfigId" class="easyui-validatebox"
				data-options="required:true" value="${awardConfig.id}" />
			<table style="margin-left: 30px; margin-top: 20px">

				<tr>
					<th>${internationalConfig.活动名称}</th>
					<td><label> <select id="lotteryId" name="lotteryId"
							onchange="dynamicChangeAward()" style="width: 165px">
								<option value="">${internationalConfig.请选择}</option>
								<c:forEach items="${lotteries}" var="var">
									<c:choose>
										<c:when test="${var.id==awardConfig.award.lotteryId}">
											<option value="${var.id}" selected="selected">${var.lotteryName}</option>
										</c:when>
										<c:otherwise>
											<option value="${var.id}">${var.lotteryName}</option>
										</c:otherwise>
									</c:choose>
								</c:forEach>
						</select>
					</label></td>
				</tr>
				
				<tr>
					<th>${internationalConfig.奖项名称}</th>
					<td><label> <select id="awardId" name="awardId"
							style="width: 165px">
								<c:forEach items="${awards}" var="var">
									<c:choose>
										<c:when test="${var.id==awardConfig.awardId}">
											<option value="${var.id}" selected="selected">${var.awardName}</option>
										</c:when>
										<c:otherwise>
											<option value="${var.id}">${var.awardName}</option>
										</c:otherwise>
									</c:choose>
								</c:forEach>
						</select>
					</label></td>
				</tr>

				<tr>
					<th>${internationalConfig.开始日期}</th>
					<td><label> <input type="text" name="startDate"
							id="expireDate" style="width: 165px" class="easyui-datebox"
							class="easyui-validatebox" data-options="required:true"
							value="${awardConfig.startDate}" />
					</label></td>
				</tr>

				<tr>
					<th>${internationalConfig.结束日期}</th>
					<td><label> <input type="text" name="endDate"
							id="expireDate" style="width: 165px" class="easyui-datebox"
							class="easyui-validatebox" data-options="required:true"
							value="${awardConfig.endDate}" />
					</label></td>
				</tr>
				<tr>
					<th>${internationalConfig.每天开始时间}</th>
					<td><label> <input type="text" name="startTimeFloat"
							id="easyui-numberbox" style="width: 135px"
							data-options="min:0,max:10000,precision:1"
							class="easyui-validatebox" data-options="required:false"
							value="${awardConfig.startTimeFloat}" />
					</label></td>
				</tr>

				<tr>
					<th>${internationalConfig.每天结束时间}</th>
					<td><label> <input type="text" name="endTimeFloat"
							id="easyui-numberbox" style="width: 135px"
							data-options="min:0,max:24,precision:1"
							class="easyui-validatebox" data-options="required:false"
							value="${awardConfig.endTimeFloat}" />
					</label></td>
				</tr>


				<tr>
					<th>${internationalConfig.奖品分布}</th>
					<td>${internationalConfig.每隔} <c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if><input type="text" name="minutes" id="easyui-numberbox"
						style="width: 35px" data-options="min:0,max:24,precision:1"
						class="easyui-validatebox" data-options="required:false"
						value="${awardConfig.minutes}" /><c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.分钟},${internationalConfig.发放}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if><input type="text"
						name="total" id="easyui-numberbox" style="width: 35px"
						data-options="min:0,max:10000,precision:0"
						class="easyui-validatebox" data-options="required:false"
						value="${awardConfig.total}" /><c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.个奖品}
					</td>
				</tr>

				<tr>
					<th>${internationalConfig.详细}</th>
					<td><label> <textarea name="details" cols="30"
								rows="5">${awardConfig.details}</textarea>
					</label></td>
				</tr>

				<tr>
				</tr>

			</table>
		</form>
	</div>
</div>