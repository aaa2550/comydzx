<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script type="text/javascript">
    $(function () {
        parent.$.messager.progress('close');
    });
</script>
<style type="text/css">
    .label {
        width: 60px;
    }
</style>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title="" style="overflow: hidden;">
    	<input type="hidden" name="id" value="${packageInfo.id}"/>
        <table class="table-scan" style="width: 100%">
            <tr>
                <th style="width: 150px">${internationalConfig.套餐类型}</th>
                <td style="width: 250px">
                    ${packageInfo.packageNameDesc}
                </td>
                <th style="width: 150px">${internationalConfig.状态}</th>
                <td>
                    ${packageInfo.statusDesc}
                </td>
            </tr>
     <!-- 套餐功能
            <tr>
                <th>${internationalConfig.套餐功能}</th>
                <td colspan="3">
                    <table>
                        <tr>
                            <c:forEach items="${packageInfo.featureList}" var="feature">
                                <td style="padding-right: 10px">
                                        ${feature.description}
                                </td>
                            </c:forEach>
                        </tr>
                    </table>
                </td>
            </tr>
     --> 
            <tr>
                <th>${internationalConfig.套餐规则}</th>
                <td>
                    <table>
                        <tr>
                            <c:forEach items="${packageInfo.ruleList}" var="rule">
                                <td style="padding-right: 10px">
                                        ${rule.description}
                                </td>
                            </c:forEach>
                        </tr>
                    </table>
                </td>
                <th>${internationalConfig.所属分组}</th>
                <td>
                    ${packageInfo.groupIdsDesc}
                </td>
            </tr>
            <tr>
                <th>${internationalConfig.终端}</th>
                <td colspan="3">
                    <table>
                        <tr>
                            <c:forEach items="${packageInfo.terminalList}" var="terminal">
                                <td style="padding-right: 10px">
                                        ${terminal.terminalName}
                                </td>
                            </c:forEach>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <th>${internationalConfig.有效期}</th>
                <td>
                    ${packageInfo.durationDesc}
                </td>
               
                <th>${internationalConfig.价格}(${internationalConfig.元})</th>
                <td>
                    ${packageInfo.price}
                </td>
            </tr>
            <tr>
                <th>${internationalConfig.原价}(${internationalConfig.元})</th>
                <td>
                    ${packageInfo.originPrice}
                </td>
                <th>${internationalConfig.预订价}(${internationalConfig.元})</th>
                <td>
                    ${packageInfo.bookPrice}
                </td>
            </tr>
            <tr>
                <th>${internationalConfig.折扣开始}</th>
                <td>
                    <fmt:formatDate pattern="yyyy-MM-dd" value="${packageInfo.discountStart}"/>
                </td>
                <th>${internationalConfig.折扣结束}</th>
                <td>
                    <fmt:formatDate pattern="yyyy-MM-dd" value="${packageInfo.discountEnd}"/>
                </td>
            </tr>
            <tr>
                <th>${internationalConfig.赠送观影券}</th>
                <td>
                    ${packageInfo.coupons}
                </td>
                <th>${internationalConfig.赠送包月}</th>
                <td>
                    ${packageInfo.giftMonth}
                </td>
            </tr>
             <tr>
                <th>${internationalConfig.套餐时长}</th>
                <td>
                    ${packageInfo.days}
                </td>
            </tr>
			<tr>
				<th>${internationalConfig.移动端图片}：</th>
				<td><c:if test="${not empty packageInfo.mobileImg}"><a href="${packageInfo.mobileImg}" target="_blank">${internationalConfig.查看图片}</a></c:if></td>
				<th>${internationalConfig.超级移动端图片}：</th>
				<td><c:if test="${not empty packageInfo.superMobileImg}"><a href="${packageInfo.superMobileImg}" target="_blank">${internationalConfig.查看图片}</a></c:if></td>
			</tr>    
			<tr>
				<th>${internationalConfig.套餐描述}：</th>
				<td colspan="3"><textarea name="vipDesc" class="txt-middle" disabled="disabled">${packageInfo.vipDesc}</textarea></td>
			</tr>        
            
        </table>
    </div>
</div>