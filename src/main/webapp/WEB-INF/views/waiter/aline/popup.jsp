<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<%@ include file="/WEB-INF/views/inc/jstl.inc"%>
<style>
	.table-in{
		width: 95%;
		margin: 0 auto;
		border:1px solid #ddd;
		text-align:center;


	}
	.table-in td{
		padding: 7px;
	}
</style>
<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');
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
					<col width="140">
					<col width="*">
				</colgroup>
				<!-- <input type="hidden" name="id" value="${packageDurationInfo.id}"/> -->
				<tr >

					<th>&nbsp;&nbsp;&nbsp;用户ID：</th>
					<td><input type="text" value="${ssoUser.uid}" /></td>
					<th>用户名：</th>
					<td><input type="text" value="${ssoUser.username}" /></td>
				</tr>

				<tr>
					<table width='80%' border="1" align="center" class="table-in">
						<tr >
							<td>服务类型</td>
							<td>会员到期时间</td>
						</tr>
						<c:forEach var="stu" items="${vipInfo}">
						<tr>
							<td>${stu.name}</td>
							<td>${stu.endtime}</td>
						</tr>
						</c:forEach>
					</table>
				</tr>
				
				
				
			</table>
		</form>
	</div>
</div>