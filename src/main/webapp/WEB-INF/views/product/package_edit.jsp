<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script src="/static/lib/swfupload/swfupload.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript" src="/static/lib/uploadImg.js?v=20150408.01" charset="utf-8"></script>
<%@ include file="/WEB-INF/views/inc/jstl.inc"%>

<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');
		$('#form').form({
			url : '/package/update.json',
			onSubmit : function() {
				//去除两个默认checkbox的disabled属性，让后台能够得到这两个值
//				$("#feature30").attr("disabled", false);
//				$("#feature31").attr("disabled", false);
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
					parent.$.modalDialog.openner_dataGrid.datagrid('reload');
					parent.$.modalDialog.handler.dialog('close');
				} else {
					parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
				}
			}
		});
	});
	checkFeatures();
	checkTerminals();
	checkPackageGroup();
	checkRules();
	
	function checkFeatures() {
		$.features = ${packageInfo.featureList};
		for ( var i = 0; i < $.features.length; i++) {
			$("#feature" + $.features[i].id).attr("checked", true);
		}
		$("#feature30").attr("checked", true).attr("disabled", true);
		$("#feature31").attr("checked", true).attr("disabled", true);
	}
	
	function checkPackageGroup() {
		var groupId = ${packageInfo.groupId};
		
		$("input[name=packageGroups]").each(function() {
			if((groupId & $(this).val()) == $(this).val()) {
				$(this).attr("checked", true);
			}
		});
	}

	function checkTerminals() {
		$.terminals = ${packageInfo.terminalList};
		
		for ( var i = 0; i < $.terminals.length; i++) {
			$("#terminal" + $.terminals[i].terminalId).attr(
					"checked", true);
		}
	}
	
	function checkRules() {
		$.rules = ${packageInfo.ruleList};
		
		for ( var i = 0; i < $.rules.length; i++) {
			$("#rule" + $.rules[i].id).attr(
					"checked", true);
		}
	}

	//增加自定义的表单验证规则
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
	<div data-options="region:'center',border:false" title="">
		<form id="form" method="post"
			action="${pageContext.request.contextPath}/mealController/create">
			<input type="hidden" name="packageId" value="${packageInfo.id}" />
			<table style="width: 100%" class="table table-form">
				<colgroup>
					<col width="90">
					<col width="100">
					<col width="80">
					<col width="*">
				</colgroup>
				<tr>
					<th>${internationalConfig.套餐类型}</th>
					<td><select name="packageName">
							<c:forEach items="${packageNames}" var="packageName">
								<c:choose>
									<c:when test="${packageName.id == packageInfo.packageName}">
										<option value="${packageName.id}" selected="selected">${packageName.description}</option>
									</c:when>
									<c:otherwise>
										<option value="${packageName.id}">${packageName.description}</option>
									</c:otherwise>
								</c:choose>
							</c:forEach>
					</select></td>
					<th style="vertical-align: middle;text-align: right;">${internationalConfig.状态}</th>
					      <c:if test="${packageInfo.status == 20}">
							  <td>${internationalConfig.上线}</td>
						  </c:if>
						  <c:if test="${packageInfo.status == 21}">
							  <td>${internationalConfig.下线}</td>
						  </c:if>
				</tr>
	<!-- 套餐功能
				<tr>
					<th>${internationalConfig.套餐功能}</th>
					<td colspan="3">
						<table class="no-border-table">
							<tr><td style="padding-right: 5px">
								<c:forEach items="${features}" var="feature" varStatus="s">
									<input
										id="feature${feature.id}" type="checkbox" name="features"
										value="${feature.id}" />${feature.description}
								</c:forEach>
								</td>
							</tr>
						</table>
					</td>
				</tr>
	-->
	<!-- 新增APP_PRODUCT_ID参数 -->
				<tr>
					<th>APP_ID</th>
					<td >
						<input name="appId" data-options="required:false" value="${appleKey.appId }" type="text">
					</td>
					<th style="vertical-align: middle;text-align: right;">APP_KEY</th>
					<td >
						<input name="appKey" data-options="required:false" value="${appleKey.appKey }" type="text">
					</td>
				</tr>
				<tr>
					<th>${internationalConfig.终端}</th>
					<td colspan="3">
						<table class="no-border-table">
							<tr>
								<c:forEach items="${terminals}" var="terminal">
									<td style="padding-right: 5px"><input
										id="terminal${terminal.terminalId}" type="checkbox"
										name="terminals" value="${terminal.terminalId}" />${terminal.terminalName}
									</td>
								</c:forEach>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<th>${internationalConfig.使用规则}</th>
					<td>
						<table class="no-border-table">
							<tr>
								<c:forEach items="${rules}" var="rule">
									<td style="padding-right: 5px">
											<input type="checkbox" name="rules" value="${rule.id}" id="rule${rule.id}"/>&nbsp${rule.description}
										</td>
								</c:forEach>
							</tr>
						</table>
					</td>
					<th style="vertical-align: middle;text-align: right;">${internationalConfig.所属分组}</th>
					<td>
						<table class="no-border-table">
							<tr>
							<td style="padding-right: 5px">
								<c:forEach items="${packageGroups}" var="pg"
									varStatus="varStatus">
									<c:if test="${pg == '1'}">
										<input type="checkbox"
											name="packageGroups" value="${pg}" />&nbsp${internationalConfig.默认}
										
									</c:if>
									<c:if test="${pg != '1'}">
										<input type="checkbox"
											name="packageGroups" value="${pg}" />&nbsp${pg}
										
									</c:if>
								</c:forEach>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<th>${internationalConfig.有效期}</th>
					<td><select name="duration">
							<c:forEach items="${durations}" var="duration">
								<option value="${duration.id}" <c:if test="${duration.id == packageInfo.duration}"> selected="selected" </c:if> >${duration.description}</option>
							</c:forEach>
					</select></td>
					<th>${internationalConfig.价格}(${internationalConfig.元})</th>
					<td><input type="text" name="price"
						value="${packageInfo.price}" class="easyui-validatebox easyui-numberbox" precision="2"
						data-options="required:true,validType:'number',min:0.01,height:30" /></td>
				</tr>
				<tr>
					<th>${internationalConfig.原价}(${internationalConfig.元})</th>
					<td><input type="text" name="originPrice"
						value="${packageInfo.originPrice}" class="easyui-validatebox easyui-numberbox" precision="2"
						data-options="required:true,validType:'number',min:0.01,height:30" /></td>
					<th>${internationalConfig.首次优惠}(${internationalConfig.元})</th>
					<td><input type="text" name="bookPrice"
						value="${packageInfo.bookPrice}" class="easyui-validatebox easyui-numberbox" precision="2"
						data-options="validType:'number',height:30" /></td>
				</tr>
				<tr>
					<th>${internationalConfig.折扣开始}</th>
					<td><input type="text" name="discountStart" id="discountStart"
						value="<fmt:formatDate pattern="yyyy-MM-dd" value="${packageInfo.discountStart}"/>"
						class="easyui-datebox" data-options="required:true" /></td>
					<th>${internationalConfig.折扣结束}</th>
					<td><input type="text" name="discountEnd" id="discountEnd"
						value="<fmt:formatDate pattern="yyyy-MM-dd" value="${packageInfo.discountEnd}"/>"
						class="easyui-datebox" data-options="required:true" /></td>
				</tr>
				<tr>
					<th>${internationalConfig.赠送观影券}</th>
					<td><input type="text" name="couponCount"
						value="${packageInfo.coupons}" class="easyui-validatebox"
						data-options="required:true,validType:'int'" /></td>
					<th>${internationalConfig.赠送包月}</th>
					<td><input type="text" name="giftMonth"
						value="${packageInfo.giftMonth}" class="easyui-validatebox"
						data-options="required:true,validType:'int'" /></td>
				</tr>

				<tr>
					<th>${internationalConfig.套餐时长}</th>
					<td><input type="text" name="days"
						value="${packageInfo.days}" class="easyui-validatebox"
						data-options="required:true,validType:'int'" /></td>
					<th>${internationalConfig.排序}</th>
					<td><input type="text" name="sort"
						value="${packageInfo.sort}" class="easyui-validatebox"
						data-options="required:true,validType:'int'" /></td>
				</tr>
				<tr>
					<th>${internationalConfig.移动端图片}：</th>
					<td ><input type="text" id="mobileImg" name="mobileImg" value="${packageInfo.mobileImg}"/></td>
					<td>
						<input class="buttoncenter" type="button" value="上传文件" id="mobile_upload_btn" />
					</td>
		            <td><div id="img-mobile" name="img-mobile" ><c:if test="${not empty packageInfo.mobileImg}"><a href="${packageInfo.mobileImg}" target="_blank">${internationalConfig.查看图片}</a></c:if></div></td>
				</tr>
				<tr>
					<th>${internationalConfig.超级移动端图片}：</th>
					<td ><input type="text" id="superMobileImg" name="superMobileImg" value="${packageInfo.superMobileImg}"/></td>
					<td>
						<input class="buttoncenter" type="button" value="上传文件" id="super_mobile_upload_btn" />
					</td>
		            <td><div id="img-super-mobile" name="img-super-mobile" ><c:if test="${not empty packageInfo.superMobileImg}"><a href="${packageInfo.superMobileImg}" target="_blank">${internationalConfig.查看图片}</a></c:if></div></td>
				</tr>
				<tr>
					<th>${internationalConfig.套餐描述}：</th>
					<td colspan="3"><textarea name="vipDesc" class="txt-middle">${packageInfo.vipDesc}</textarea></td>
				</tr>
			</table>
		</form>
	</div>
</div>