<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<script src="/static/lib/swfupload/swfupload.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript" src="/static/lib/uploadImg4activitySuccessCfg.js" charset="utf-8"></script>
<%@ include file="/WEB-INF/views/inc/jstl.inc"%>

<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');
		$('#form').form({
			url : '${pageContext.request.contextPath}/activity_success/add.json',
			onSubmit : function() {
				parent.$.messager.progress({
					title : '提示',
					text : '数据处理中，请稍后....'
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
                	parent.$.messager.alert('成功', '添加成功', 'success');
					parent.$.modalDialog.openner_dataGrid.datagrid('reload');
					parent.$.modalDialog.handler.dialog('close');
				} else {
					parent.$.messager.alert('错误', result.msg, 'error');
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
			message : '请输入合法数字'
		}
	});
	$.extend($.fn.validatebox.defaults.rules, {
		int : {
			validator : function(value, param) {
				var reg = new RegExp("^[0-9]+$");
				return reg.test(value);
			},
			message : '请输入合法整数'
		}
	});
</script>

<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="">
		<form id="form" method="post"
			action="#">
			<table style="width: 100%" class="table table-form">
				<colgroup>
					<col width="90">
					<col width="100">
					<col width="80">
					<col width="*">
				</colgroup>
				<tr>
					<th>活动名称</th>
					<td><input name="activityName" type="text" class="easyui-validatebox" data-options="required:true"></td>
					<th>套餐状态</th>
					<td>
						<select name="packageId" class="span2">
							<c:forEach items="${vipList}" var="vip">
								<option value="${vip.id}">${vip.packageNameDesc}_${vip.durationDesc}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th>所属终端</th>
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
					<th>所属分组</th>
					<td colspan="3">
						<table class="no-border-table">
							<tr>
								<c:forEach items="${packageGroups}" var="pg"
									varStatus="varStatus">
									<c:if test="${pg == '1'}">
										<td style="padding-right: 5px"><input type="checkbox"
										name="packageGroups" value="${pg}" />&nbsp默认
									</td>
									</c:if>
									<c:if test="${pg != '1'}">
										<td style="padding-right: 5px"><input type="checkbox"
											name="packageGroups" value="${pg}" />&nbsp${pg}
										</td>
									</c:if>
									
								</c:forEach>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<th>生效日期</th>
					<td><input type="text" name="effectiveDate" id="effectiveDate"
						class="easyui-datetimebox" data-options="required:true" />
					</td>
					<th>失效日期</th>
					<td><input type="text" name="invalidDate" id="invalidDate"
						class="easyui-datetimebox" data-options="required:true" />
					</td>
				</tr>
				<tr>
					<th>大推广图：</th>
					<td ><input type="text" id="maxExpandPhoto" name="maxExpandPhoto"/></td>
					<td>
						<input class="buttoncenter" type="button" value="上传文件" id="mobile_upload_btn" />
					</td>
		            <td><div id="maxExpandPhoto-mobile" name="maxExpandPhoto-mobile" ></div></td>
				</tr>
				<tr>
					<th>小推广图：</th>
					<td ><input type="text" id="minExpandPhoto" name="minExpandPhoto" /></td>
					<td>
						<input class="buttoncenter" type="button" value="上传文件" id="super_mobile_upload_btn" />
					</td>
		            <td><div id="minExpandPhoto-mobile" name="minExpandPhoto-mobile" ></div></td>
				</tr>
				<tr>
					<th>移动端推广图：</th>
					<td ><input type="text" id="mobileExpandPhoto" name="mobileExpandPhoto"/></td>
					<td>
						<input class="buttoncenter" type="button" value="上传文件" id="mobile_upload_btn" />
					</td>
		            <td><div id="mobileExpandPhoto-mobile" name="mobileExpandPhoto-mobile" ></div></td>
				</tr>
				<tr>
					<th>TV端推广图：</th>
					<td ><input type="text" id="tvExpandPhoto" name="tvExpandPhoto" /></td>
					<td>
						<input class="buttoncenter" type="button" value="上传文件" id="super_mobile_upload_btn" />
					</td>
		            <td><div id="tvExpandPhoto-mobile" name="tvExpandPhoto-mobile" ></div></td>
				</tr>
				<tr>
					<th>排序</th>
					<td><input type="text" name="sortValue" class="easyui-validatebox"
						data-options="required:true,validType:'int'" /></td>
					<th>跳转url</th>
					<td><input type="text" name="redirectPage" class="easyui-validatebox"	/></td>
				</tr>
				<tr>
					<th>状态</th>
					<td colspan="3"><select name="status" id="status">
                            <option value="0">下线</option>
                            <option value="1">上线</option>
                        </select>
					</td>
				</tr>
				<tr>
					<th>配置描述：</th>
					<td colspan="3"><textarea name="configDesc" class="txt-middle"></textarea></td>
				</tr>
			</table>
		</form>
	</div>
</div>