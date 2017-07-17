<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.代金券模板详细信息}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<style type="text/css">
.label {
	width: 60px;
}
.table{margin:10px 0;}
.table input[type="checkbox"]{margin-left:5px;margin-right: 2px;}
</style>
</head>
<body>
	<div class="easyui-layout" data-options="fit:true,border:false">
		<div data-options="region:'center',border:false" title=""
			style="overflow: hidden;">
			<h4 style="margin:10px; ">${internationalConfig.代金券模板详细信息}</h4>
			<table style="width: 100%" class="table">
				<tr>
					<th width="70">${internationalConfig.名称}</th>
					<td>${couponTemplate.name}</td>
				</tr>
					<tr>
					<th>${internationalConfig.批次号}</th>
					<td>${couponTemplate.batchNo}</td>
				</tr>
				<tr>
					<th>${internationalConfig.代金券类型}</th>
					<td>${couponTemplate.ownerTypeName}</td>
				</tr>
				<tr>
					<th>${internationalConfig.面额}</th>
					<td>${couponTemplate.amountFmt}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.元}</td>
				</tr>
				<tr>
					<th>${internationalConfig.发放方}</th>
					<td>${couponTemplate.issuerName}</td>
				</tr>
				<tr>
					<th>${internationalConfig.有效期}</th>
					<td><fmt:formatDate pattern="yyyy-MM-dd"
							value="${couponTemplate.startTime}" /> - <fmt:formatDate
							pattern="yyyy-MM-dd" value="${couponTemplate.endTime}" /></td>
				</tr>
				<tr>
					<th>${internationalConfig.状态}</th>
					<td>${couponTemplate.statusName}</td>
				</tr>
				<tr>
					<th>${internationalConfig.创建时间}</th>
					<td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss"
							value="${couponTemplate.createTime}" /></td>
				</tr>
				<tr>
					<th>${internationalConfig.使用平台}</th>
					<td><c:forEach items="${terminals}" var="var">
							<input name="terminals" type="checkbox" value="${var.terminalId}"
								disabled="disabled"
								<c:if test="${fn:contains(couponTemplate.joinedTerminals, var.terminalId)}"> checked="checked" </c:if>> ${var.terminalName }
                        </c:forEach></td>
				</tr>
				<tr>
					<th style="vertical-align: text-top">${internationalConfig.使用限制}</th>
					<td style="padding:0;">
						<table style="width:100%;">
							<tr style="border:0;">
								<td>${internationalConfig.用户限额}: ${couponTemplate.userQuota}</td>
							</tr>
							<tr>
								<td>${internationalConfig.移动影视会员}: <c:forEach items="${commonPackageInfos}" var="var">
										<input name="vipRules" type="checkbox" value="${var.duration}"
											<c:if test="${var.check}"> checked="checked" </c:if>
											disabled="disabled">${var.description}
									</c:forEach>
								</td>
							</tr>
							<tr>
								<td>${internationalConfig.全屏影视会员}: <c:forEach items="${advancedPackageInfos}"
										var="var">
										<input name="seniorVipRules" type="checkbox"
											value="${var.duration}"
											<c:if test="${var.check}"> checked="checked" </c:if>
											disabled="disabled">${var.description}
									</c:forEach>
								</td>
							</tr>
							<tr>
								<td>${internationalConfig.电影}: <input name="movieRule" type="checkbox" value="1"
									disabled="disabled"
									<c:if test="${movieRule != null}"> checked="checked" </c:if>>${internationalConfig.支持单片}
								</td>
							</tr>
                            <tr>
                                <td>${internationalConfig.套餐}: <input name="combinePackageRule" type="checkbox" value="1"
                                               disabled="disabled"
                                <c:if test="${combinePackageRule != null}"> checked="checked" </c:if>>${internationalConfig.支持组合套餐}
                                </td>
                            </tr>
						</table>
					</td>
				</tr>
				<tr>	
					<th>
					</th>
					<td><a href="javascript:;" class="back-close">${internationalConfig.返回}</a></td>
				</tr>
			</table>
		</div>
	</div>

	<div id="toolbar" style="display: none;">
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a><a
			href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_delete',plain:true"
			onclick="cleanFun();">${internationalConfig.清空条件}</a>
	</div>

<script>

	$(function(){
		$(".back-close").click(function(){
			window.close();
		});
	});
</script>
</body>
</html>