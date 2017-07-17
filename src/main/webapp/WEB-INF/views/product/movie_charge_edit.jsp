<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');
		$('#form').form({
			url : '/movie_charge/update.json',
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
					parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.编辑成功}', 'success');
					parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
					parent.$.modalDialog.handler.dialog('close');
				} else {
					parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
				}
			}
		});
	});
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="" style="overflow: auto;">
		<form id="form" method="post">
			<table class="table table-form">
				<colgroup>
					<col width="80">
					<col width="100">
					<col width="80">
					<col width="100">
					<col width="80">
					<col width="*">
				</colgroup>
				<tr>
					<td colspan="2">${internationalConfig.方案名称}：<input name="chargeName" type="text" class="easyui-validatebox span3" data-options="required:true" value="${charge.chargeName}"><input name="chargeId" type="hidden" value="${charge.chargeId }"></td>
					<td colspan="2">${internationalConfig.有效期}：<input name="validTime" type="text" class="easyui-validatebox span2" data-options="required:true" value="${charge.validTime}"></td>
					<td colspan="2">${internationalConfig.会员优惠}：<c:choose>
							<c:when test="${charge.memberDiscounts == 0 }">
								<input name="memberDiscounts" type="radio" value="0" checked="checked">${internationalConfig.原价}
								<input name="memberDiscounts" type="radio" value="1">${internationalConfig.半价}
							</c:when>
							<c:when test="${charge.memberDiscounts == 1 }">
								<input name="memberDiscounts" type="radio" value="0">${internationalConfig.原价}
								<input name="memberDiscounts" type="radio" value="1" checked="checked">${internationalConfig.半价}
							</c:when>
						</c:choose>
					</td>
				</tr>
				<tr>
					<td colspan="3">APP_PRODUCT_ID：<input name="appId" type="text" class="easyui-validatebox span3" value="${app.appId}"></td>
					<td colspan="3">IPAD_PRODUCT_ID：<input name="ipadId" type="text" class="easyui-validatebox span2" value="${app.ipadId}"></td>
				</tr>
				<tr>
					<td colspan="3">VIP_APP_PRODUCT_ID：<input name="vipAppId" type="text" class="easyui-validatebox span3" value="${app.vipAppId}"></td>
					<td colspan="3">VIP_IPAD_PRODUCT_ID：<input name="vipIpadId" type="text" class="easyui-validatebox span2" value="${app.vipIpadId}"></td>
				</tr>
				<tr>
						<td>${internationalConfig.终端}</td>
						<td>${internationalConfig.价格}</td>
						<td>${internationalConfig.原价}</td>
						<td>${internationalConfig.预定价格}</td>
						<td>${internationalConfig.折扣开始}</td>
						<td>${internationalConfig.折扣结束}</td>
				</tr>
				<c:forEach var="price" items="${terminalPrices}" varStatus="status">
 					<tr>
						<td style="display: none"><input type="text" name="terminalsId[${status.count-1 }]" class="span2" value="${price.terminalsId[0] }" readonly="readonly"/></td>
						<td><input type="text" name="terminalsName[${status.count-1 }]" class="span2" value="${price.terminalsName[0] }" readonly="readonly"/></td>
						<td><input type="text" name="price[${status.count-1 }]" class="span2 easyui-numberbox" precision="2" data-options="min:0.01,height:30" value="${price.price[0] }"/></td>
						<td><input type="text" name="oringinPrice[${status.count-1 }]" class="span2 easyui-numberbox" precision="2" data-options="min:0.01,height:30"  value="${price.oringinPrice[0] }"/></td>
						<td><input type="text" name="bookPrice[${status.count-1 }]" class="span2 easyui-numberbox" precision="2" data-options="min:0.01,height:30" value="${price.bookPrice[0] }"/></td>
						<td><input type="text" name="discountBegin[${status.count-1 }]" class="span2 easyui-datebox" data-options="width:120,height:30"  value="${price.discountBegin[0] }"/></td>
						<td><input type="text" name="discountEnd[${status.count-1 }]" class="span2 easyui-datebox" data-options="width:120,height:30"  value="${price.discountEnd[0] }"/></td>
					</tr>	 
				</c:forEach>
			</table>
		</form>
	</div>
</div>