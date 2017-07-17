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
	<div data-options="region:'center',border:false" title="">
			<table class="table-scan" style="width: 100%">
			    <tr>
					<th>${internationalConfig.频道}</th>
					<td>
					${packagePrice.matchname}
					</td>
					<th>${internationalConfig.赛事}</th>
					<td>
					 ${packagePrice.itemname}
					</td>
				</tr>
				<tr>
				   <th>${internationalConfig.赛季}</th>
					<td>
					  ${packagePrice.sessionname}
					</td>
					<th>${internationalConfig.套餐名称}</th>
					<td>
					${packagePrice.name}
					</td>
				</tr>
				<tr>
					<th>${internationalConfig.套餐状态}</th>
					<td>
					  <c:if test="${packagePrice.status == 0}">
					 ${internationalConfig.上线}
					  </c:if>
					   <c:if test="${packagePrice.status != 0}">
					  ${internationalConfig.下线}
					  </c:if>
					</td>
					<th>${internationalConfig.直播券张数}</th>

					<td>
					${packagePrice.counts}${internationalConfig.张}
					</td>
				</tr>
				
				<c:if test="${eplPackage.matchid == '09'}">
				<tr id="round_number">
				   <th>${internationalConfig.轮次}</th>
				   <td>
					 <select name="rounds" id="rounds" style="margin-top: 5px" disabled="disabled">
						<option value="${eplPackage.rounds}"> ${internationalConfig.第}${eplPackage.rounds}${internationalConfig.轮次}</option>
					 </select>
					</td>
					<th>${internationalConfig.场次}</th>
					<td>
					<select name="play_number" id="type" disabled="disabled">
						<option value="${eplPackage.play_number}"> ${internationalConfig.第}${eplPackage.play_number}${internationalConfig.场次}</option>
					 </select>
					</td>
				</tr>
				</c:if>

			
				<tr>
					
					<th>vip${internationalConfig.价格}</th>
					<td>${packagePrice.vip_price}</td>
						<th>${internationalConfig.非会员价格}</th>
					<td>${packagePrice.regular_price}</td>
				</tr>

				<tr>
					<th>${internationalConfig.直播卷有效时长}</th>
					<td>${packagePrice.validate_days}</td>
						<th>${internationalConfig.赛季结束时间   }</th>
					<td><label> ${endTime}
					</label></td>
				</tr>
				
				<tr id="app_id">
				   <th>APP_PRODUCT_ID</th>
				   <td>${packagePrice.app_product_id}</td>
					<th>APP_${internationalConfig.价格}</th>
					 <td>${packagePrice.app_price}
					 </td>
				</tr>
				<tr id="app_id">
				   <th>IPAD_PRODUCT_ID</th>
				   <td>${packagePrice.ipadProductId}</td>
					<th>IPAD_${internationalConfig.价格}</th>
					 <td>${packagePrice.ipadPrice}
					 </td>
				</tr>
				<tr>
					<th>${internationalConfig.分成比例}</th>
					<td>${packagePrice.dividedProportion}</td>
					<th>${internationalConfig.直播名称}：</th>
						<td>${packagePrice.playName}</td>
				</tr>
				<tr>
					<th>${internationalConfig.移动端图片}：</th>
					<td><c:if test="${not empty packagePrice.mobileImg}"><a href="${packagePrice.mobileImg}" target="_blank">${internationalConfig.查看图片}</a></c:if></td>
					<th>${internationalConfig.超级移动端图片}：</th>
					<td><c:if test="${not empty packagePrice.superMobileImg}"><a href="${packagePrice.superMobileImg}" target="_blank">${internationalConfig.查看图片}</a></c:if></td>
				</tr>
				<tr>
					<th>${internationalConfig.套餐描述}：</th>
					<td colspan="3">${packagePrice.playDesc}</td>
				</tr>
			</table>
	</div>
</div>