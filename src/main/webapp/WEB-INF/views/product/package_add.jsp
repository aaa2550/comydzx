<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<script src="/static/lib/swfupload/swfupload.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript" src="/static/lib/uploadImg.js?v=20150408.01" charset="utf-8"></script>
<%@ include file="/WEB-INF/views/inc/jstl.inc"%>

<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');
		$('#form').form({
			url : '/package/add.json',
			onSubmit : function() {
				//提交前,去除两个默认checkbox的disabled属性，让后台能够得到这两个值
				$("#feature30").attr("disabled", false);
				$("#feature31").attr("disabled", false);
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
                	parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.添加成功}', 'success');
					parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
					parent.$.modalDialog.handler.dialog('close');
				} else {
					parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
				}
			}
		});
	});

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
			<table style="width: 100%" class="table table-form">
				<colgroup>
					<col width="130">
					<col width="80">
					<col width="130">
					<col width="*">
				</colgroup>
				<tr>
					<th>${internationalConfig.套餐类型}</th>
					<td><select
						name="packageName">
							<c:forEach items="${packageNames}" var="packageName">
								<option value="${packageName.id}">${packageName.description}</option>
							</c:forEach>
					</select></td>
					<th style="vertical-align: middle;text-align: right;">${internationalConfig.状态}</th>
					<td><select name="status">
							<option value="20">${internationalConfig.上线}</option>
							<option value="21">${internationalConfig.下线}</option>
					</select></td>
				</tr>
		<!-- 
				<tr>
					<th>${internationalConfig.套餐功能}</th>
					<td colspan="3">
						<table class="no-border-table">
							<tr>
								<c:forEach items="${features}" var="feature"
									varStatus="varStatus">
									<c:choose>
											<c:when test="${feature.id == 30 || feature.id == 31}">
												<input checked="true" type="checkbox" name="features" id="feature${feature.id}"
													value="${feature.id}" disabled="true" />&nbsp${feature.description}
                                            </c:when>
											<c:otherwise>
												<input type="checkbox" name="features" id="feature${feature.id}"
													value="${feature.id}" />&nbsp${feature.description}
                                            </c:otherwise>
										</c:choose>
								</c:forEach>
							</tr>
						</table>
					</td>
				</tr>
			-->	
				<!-- 新增APP_PRODUCT_ID参数 -->
				<tr>
					<th>APP_ID</th>
					<td>
						<input name="appId" data-options="required:false"  type="text">
					</td>
					<th style="vertical-align: middle;text-align: right;">APP_KEY</th>
					<td>
					<input name="appKey" data-options="required:false"  type="text">
					</td>
				</tr>	
				
				<tr>
					<th>${internationalConfig.终端}</th>
					<td colspan="3">
						<table class="no-border-table">
							<tr>
								<c:forEach items="${terminals}" var="terminal"
									varStatus="varStatus">
									<td style="padding-right: 5px"><input type="checkbox"
										name="terminals" value="${terminal.terminalId}" />&nbsp${terminal.terminalName}
									</td>
								</c:forEach>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<th>${internationalConfig.使用规则}</th>
					<td>
						<c:forEach items="${rules}" var="var">
							<span style="padding-right: 5px;display:inline-block;"><input type="checkbox"
								name="rules" value="${var.id}" />&nbsp${var.description}</span>
						</c:forEach>
					</td>
					<th style="vertical-align: middle;text-align: right;">${internationalConfig.所属分组}</th>
					<td>
						<table class="no-border-table">
							<tr style="border:0">
								<td style="padding-right: 5px">
								<c:forEach items="${packageGroups}" var="pg"
									varStatus="varStatus">
									<c:if test="${pg == '1'}"><span style="display:inline-block;">
										<input type="checkbox"
										name="packageGroups" value="${pg}" />&nbsp${internationalConfig.默认}</span>
									</c:if>
									<c:if test="${pg != '1'}"><span style="display:inline-block;">
										<input type="checkbox"
											name="packageGroups" value="${pg}" />&nbsp${pg}</span>
									</c:if>
								</c:forEach>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<th>${internationalConfig.套餐名称}</th>
					<td><select name="duration">
							<c:forEach items="${durations}" var="duration">
								<option value="${duration.id}">${duration.description}</option>
							</c:forEach>
					</select></td>
					<th style="vertical-align: middle;text-align: right;">${internationalConfig.价格}</th>
					<td><input type="text" name="price" class="easyui-validatebox easyui-numberbox"  precision="2"
						data-options="required:true,min:0.01,validate:'digits',height:30" type="number"/></td>
				</tr>
				<tr>
					<th>${internationalConfig.原价}</th>
					<td><input type="text" name="originPrice"
						class="easyui-validatebox easyui-numberbox" precision="2" data-options="required:true,min:0.01,validate:'digits',height:30" type="number"/></td>
					<th>${internationalConfig.首次优惠}(${internationalConfig.元})</th>
					<td><input type="text" name="bookPrice"
						class="easyui-validatebox  easyui-numberbox" precision="2" data-options="required:true,validate:'digits',height:30" onkeyup="this.value=this.value.replace(/\D/g,'')"
								onafterpaste="this.value=this.value.replace(/\D/g,'')" type="number"/></td>
				</tr>
				<tr>
					<th>${internationalConfig.折扣开始}</th>
					<td><input type="text" name="discountStart" id="discountStart"
						class="easyui-datebox" data-options="required:true" /> <%--                        <input type="text" name="discountStart" id="discountStart" readonly="true"
                               onclick="WdatePicker()" class="easyui-validatebox" data-options="required:true"/>
                        <img onclick="WdatePicker({el:'discountStart'})"
                             src="${pageContext.request.contextPath}/jslib/My97DatePicker4.8b3/My97DatePicker/skin/datePicker.gif"
                             width="16" height="22" align="absmiddle">--%>
					</td>
					<th>${internationalConfig.折扣结束}</th>
					<td><input type="text" name="discountEnd" id="discountEnd"
						class="easyui-datebox" data-options="required:true" /> <%--                        <input type="text" name="discountEnd" id="discountEnd" readonly="true"
                               onclick="WdatePicker()" class="easyui-validatebox" data-options="required:true"/>
                        <img onclick="WdatePicker({el:'discountEnd'})"
                             src="${pageContext.request.contextPath}/jslib/My97DatePicker4.8b3/My97DatePicker/skin/datePicker.gif"
                             width="16" height="22" align="absmiddle">--%>
					</td>
				</tr>
				<tr>
					<th>${internationalConfig.赠送观影券}</th>
					<td><input type="text" name="couponCount"
						class="easyui-validatebox"
						data-options="required:true,validType:'int'" value="20" /></td>
					<th>${internationalConfig.赠送包月}</th>
					<td><input type="text" name="giftMonth"
						class="easyui-validatebox"
						data-options="required:true,validType:'int'" value="0" /></td>
				</tr>
				
				<tr>
					<th>${internationalConfig.套餐时长}</th>
					<td><input type="text" name="days" class="easyui-validatebox"
						data-options="required:true,validType:'int'" value="20" /></td>
					<th>${internationalConfig.排序}</th>
					<td><input type="text" name="sort" class="easyui-validatebox"
						data-options="required:true,validType:'int'" value="20" /></td>
				</tr>
				<tr>
					<th>${internationalConfig.移动端图片}：</th>
					<td ><input type="text" id="mobileImg" name="mobileImg" value="${eplPackage.mobileImg}"/></td>
					<td>
						<input class="buttoncenter" type="button" value="上传文件" id="mobile_upload_btn" />
					</td>
		            <td><div id="img-mobile" name="img-mobile" ><c:if test="${not empty eplPackage.mobileImg}"><a href="${eplPackage.mobileImg}" target="_blank">${internationalConfig.查看图片}</a></c:if></div></td>
				</tr>
				<tr>
					<th>${internationalConfig.超级移动端图片}：</th>
					<td ><input type="text" id="superMobileImg" name="superMobileImg" value="${eplPackage.superMobileImg}"/></td>
					<td>
						<input class="buttoncenter" type="button" value="上传文件" id="super_mobile_upload_btn" />
					</td>
		            <td><div id="img-super-mobile" name="img-super-mobile" ><c:if test="${not empty eplPackage.superMobileImg}"><a href="${eplPackage.superMobileImg}" target="_blank">${internationalConfig.查看图片}</a></c:if></div></td>
				</tr>
				<tr>
					<th>${internationalConfig.套餐描述}：</th>
					<td colspan="3"><textarea name="vipDesc" class="txt-middle"></textarea></td>
				</tr>
			</table>
		</form>
	</div>
</div>