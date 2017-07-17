<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<%@ include file="/WEB-INF/views/inc/jstl.inc"%>

<script>
$(function() {
	parent.$.messager.progress('close');
});
</script>


<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="">
		<form id="form" method="post"
			action="${pageContext.request.contextPath}/mealController/create">
			<table style="width: 100%" class="table table-form">
				<colgroup>
					<col width="90">
					<col width="100">
					<col width="80">
					<col width="*">
				</colgroup>
				<tr>
					<th>活动名称</th>
					<td>${activitySuccessCfg.activityName}</td>
					<th>套餐状态</th>
					<td>
						${activitySuccessCfg.packageDesc}
					</td>
				</tr>
				<tr>
					<th>所属终端</th>
					<td colspan="3">
						${activitySuccessCfg.terminalsDesc}
					</td>
				</tr>
				<tr>
					<th>所属分组</th>
	                <td colspan="3">
	                    ${activitySuccessCfg.groupIdsDesc}
	                </td>
				</tr>
				<tr>
					<th>生效日期</th>
					<td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${activitySuccessCfg.effectiveDate}"/>
					</td>
					<th>失效日期</th>
					<td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${activitySuccessCfg.invalidDate}"/>
					</td>
				</tr>
				<tr>
					<th>大推广图：</th>
					<td colspan="3"><c:if test="${not empty activitySuccessCfg.maxExpandPhoto}"><a href="${activitySuccessCfg.maxExpandPhoto}" target="_blank">查看图片</a></c:if></td>
				</tr>
				<tr>
					<th>小推广图：</th>
					<td colspan="3"><c:if test="${not empty activitySuccessCfg.minExpandPhoto}"><a href="${activitySuccessCfg.minExpandPhoto}" target="_blank">查看图片</a></c:if></td>
				</tr>
				<tr>
					<th>移动端推广图：</th>
					<td colspan="3"><c:if test="${not empty activitySuccessCfg.mobileExpandPhoto}"><a href="${activitySuccessCfg.mobileExpandPhoto}" target="_blank">查看图片</a></c:if></td>
				</tr>
				<tr>
					<th>TV端推广图：</th>
					<td colspan="3"><c:if test="${not empty activitySuccessCfg.tvExpandPhoto}"><a href="${activitySuccessCfg.tvExpandPhoto}" target="_blank">查看图片</a></c:if></td>
				</tr>
				<tr>
					<th>排序</th>
					<td>${activitySuccessCfg.sortValue}</td>
					<th>跳转url</th>
					<td>${activitySuccessCfg.redirectPage}</td>
				</tr>
				<tr>
					<th>状态</th>
					<td colspan="3">
	                    <c:if test="${activitySuccessCfg.status == 0}"> 下线 </c:if>
	                    <c:if test="${activitySuccessCfg.status == 1}"> 上线 </c:if>
					</td>
				</tr>
				<tr>
					<th>配置描述：</th>
					<td colspan="3">${activitySuccessCfg.configDesc }</td>
				</tr>
			</table>
		</form>
	</div>
</div>