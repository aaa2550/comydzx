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
							url : '${pageContext.request.contextPath}/lotteryconf/award/edit.do',
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
			action="${pageContext.request.contextPath}/lotteryconf/award/edit.do">
			<table style="margin-left: 30px; margin-top: 20px">
				<input type="hidden" name="awardId" class="easyui-validatebox"
					data-options="required:true" value="${award.id}" />
				<tr>
					<th>${internationalConfig.名称}</th>
					<td><label> <input type="text" name="awardName"
							style="width: 150px" class="easyui-validatebox"
							data-options="required:true" value="${award.awardName}" />
					</label></td>
				</tr>

				<tr>
					<th>${internationalConfig.抽奖活动}</th>
					<td><label> <select name="lotteryId"
							style="width: 165px">
								<c:forEach items="${lotteries}" var="var">
									<c:choose>
										<c:when test="${var.id==award.lotteryId}">
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
					<th>${internationalConfig.等级}</th>
					<td><label> <select name="awardGrade"
							style="width: 135px">
								<c:choose>
									<c:when test="${award.awardGrade==0}">
										<option value="${award.awardGrade}" selected="selected">${internationalConfig.特等奖}</option>
									</c:when>
									<c:otherwise>
										<option value="0">${internationalConfig.特等奖}</option>
									</c:otherwise>
								</c:choose>
								<c:forEach var="item" varStatus="status" begin="1" end="12">
									<c:choose>
										<c:when test="${award.awardGrade==status.index}">
											<option value="${status.index}" selected="selected">${status.index}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.等奖}</option>
										</c:when>
										<c:otherwise>
											<option value="${status.index}">${status.index}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.等奖}</option>
										</c:otherwise>
									</c:choose>
								</c:forEach>
						</select>
					</label></td>
				</tr>

				<tr>
					<th>${internationalConfig.总量限制}</th>
					<td><label> <select name="limited"
							style="width: 135px">
								<c:choose>
									<c:when test="${award.limited==1}">
										<option value="1" selected="selected">${internationalConfig.无限制}</option>
									</c:when>
									<c:otherwise>
										<option value="1">${internationalConfig.无限制}</option>
									</c:otherwise>
								</c:choose>
								<c:choose>
									<c:when test="${award.limited==2}">
										<option value="2" selected="selected">${internationalConfig.有限制}</option>
									</c:when>
									<c:otherwise>
										<option value="2">${internationalConfig.有限制}</option>
									</c:otherwise>
								</c:choose>
						</select>
					</label></td>
				</tr>

				<tr>
					<th>${internationalConfig.总量}</th>
					<td><label> <input type="text" name="total"
							id="easyui-numberbox" style="width: 135px"
							data-options="min:0,max:10000,precision:0"
							class="easyui-validatebox" data-options="required:false"
							value="${award.total}" />
					</label></td>
				</tr>

				<tr>
				</tr>

			</table>
		</form>
	</div>
</div>