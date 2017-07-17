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
							url : '${pageContext.request.contextPath}/lotteryconf/award/add.do',
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
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title=""
		style="overflow: hidden;">
		<form id="form" method="post"
			action="${pageContext.request.contextPath}/mealController/create">
			<table style="margin-left: 30px; margin-top: 20px">

				<tr>
					<th>${internationalConfig.名称}</th>
					<td><label> <input type="text" name="awardName"
							style="width: 150px" class="easyui-validatebox"
							data-options="required:true" />
					</label></td>
				</tr>
				
				<tr>
					<th>${internationalConfig.抽奖活动}</th>
					<td><label> <select name="lotteryId" style="width: 165px">
								<c:forEach items="${lotteries}" var="var">
									<option value="${var.id}">${var.lotteryName}</option>
								</c:forEach>
						</select>
					</label></td>
				</tr>
				
				<tr>
					<th>${internationalConfig.等级}</th>
					<td><label> <select name="awardGrade" style="width: 135px">
								<option value="0">${internationalConfig.特等奖}</option>
								<option value="1">1<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.等奖}</option>
								<option value="2">2<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.等奖}</option>
								<option value="3">3<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.等奖}</option>
								<option value="4">4<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.等奖}</option>
								<option value="5">5<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.等奖}</option>
								<option value="6">6<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.等奖}</option>
								<option value="7">7<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.等奖}</option>
								<option value="8">8<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.等奖}</option>
								<option value="9">9<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.等奖}</option>
								<option value="10">10<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.等奖}</option>
								<option value="11">11<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.等奖}</option>
								<option value="12">12<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.等奖}</option>
								<option value="13">13<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.等奖}</option>
								<option value="14">14<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.等奖}</option>
						</select>
					</label></td>
				</tr>
				
				<tr>
					<th>${internationalConfig.总量限制}</th>
					<td><label> <select name="limited" style="width: 135px">
					<option value="1">${internationalConfig.无限制}</option>
					<option value="2">${internationalConfig.有限制}</option>
						</select>
					</label></td>
				</tr>
				
				<tr>
					<th>${internationalConfig.总量}</th>
					<td><label> <input type="text" name="total"
							id="easyui-numberbox" style="width: 135px" 
							data-options="min:0,max:10000,precision:0"
							class="easyui-validatebox" data-options="required:false" />
					</label></td>
				</tr>
				
				<tr>
				</tr>

			</table>
		</form>
	</div>
</div>