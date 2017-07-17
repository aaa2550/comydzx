<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<script src="/static/lib/swfupload/swfupload.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript" src="/static/lib/payPlayDeliveryImg.js?v=20150908.01" charset="utf-8"></script>
<%@ include file="/WEB-INF/views/inc/jstl.inc"%>

<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');
		$('#form').form({
			url : '${pageContext.request.contextPath}/pay_play_delivery/update.json',
			onSubmit : function() {
				parent.$.messager.progress({
					title : '提示',
					text : '数据处理中，请稍后....'
				});
				
				var isValid = $(this).form('validate');
				if (!isValid) {
					parent.$.messager.progress('close');
				}
				
				
				if($("#img1").val() != "") {
					if($("#link1").val() == "") {
						parent.$.messager.alert('警告', "每个位置图片和对应的URL要么全填，要么全不填", 'error');
						parent.$.messager.progress('close');
						return false;
					}
				} else {
					if($("#link1").val() != "") {
						parent.$.messager.alert('警告', "每个位置图片和对应的URL要么全填，要么全不填", 'error');
						parent.$.messager.progress('close');
						return false;
					}
				}
				
				if($("#img2").val() != "") {
					if($("#link2").val() == "") {
						parent.$.messager.alert('警告', "每个位置图片和对应的URL要么全填，要么全不填", 'error');
						parent.$.messager.progress('close');
						return false;
					}
				} else {
					if($("#link2").val() != "") {
						parent.$.messager.alert('警告', "每个位置图片和对应的URL要么全填，要么全不填", 'error');
						parent.$.messager.progress('close');
						return false;
					}
				}
				
				if($("#img3").val() != "") {
					if($("#link3").val() == "") {
						parent.$.messager.alert('警告', "每个位置图片和对应的URL要么全填，要么全不填", 'error');
						parent.$.messager.progress('close');
						return false;
					}
				} else {
					if($("#link3").val() != "") {
						parent.$.messager.alert('警告', "每个位置图片和对应的URL要么全填，要么全不填", 'error');
						parent.$.messager.progress('close');
						return false;
					}
				}
				
				if($("#img4").val() != "") {
					if($("#link4").val() == "") {
						parent.$.messager.alert('警告', "每个位置图片和对应的URL要么全填，要么全不填", 'error');
						parent.$.messager.progress('close');
						return false;
					}
				} else {
					if($("#link4").val() != "") {
						parent.$.messager.alert('警告', "每个位置图片和对应的URL要么全填，要么全不填", 'error');
						parent.$.messager.progress('close');
						return false;
					}
				}
				
				var isTrue = true;
				
				$("input[name^='img']").each(function(){ 
					if($(this).val() != "") {
						isTrue = false;
					}
				});
				
				if(isTrue) {
					parent.$.messager.alert('警告', "位置图片和对应的URL至少要添加1条", 'error');
					parent.$.messager.progress('close');
					return false;
				}
				
				return isValid;
			},
			success : function(result) {
				parent.$.messager.progress('close');
				result = $.parseJSON(result);
				if (result.code == 0) {
                	parent.$.messager.alert('成功', '编辑成功', 'success');
					parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
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
			action="${pageContext.request.contextPath}/mealController/create">
			<input type="hidden" name="id" value="${payPlayPageDelivery.id}">
			<table style="width: 100%" class="table table-form">
				<colgroup>
					<col width="90">
					<col width="50">
					<col width="50">
					<col width="50">
					<col width="20">
					<col width="*">
				</colgroup>
				<tr>
					<th>项目名称：</th>
					<td><input name="name" class="easyui-validatebox" data-options="required:true" value="${payPlayPageDelivery.name}" /></td>
					<th>频道：</th>
					<td><select name="channel" class="span2">
							<option value="1" <c:if test="${payPlayPageDelivery.channel == 1}">selected</c:if>>电影</option>
							<option value="2" <c:if test="${payPlayPageDelivery.channel == 2}">selected</c:if>>电视剧</option>
						</select>
					</td>
					<td><b>PID值：</b><input name="pids" class="easyui-validatebox" data-options="required:true" value="${payPlayPageDelivery.pids}" /></td>
				</tr>
				<tr>
					<th>有效期：</th>
					<td><input type="text" name="startTime" id="startTime" value="<fmt:formatDate pattern="yyyy-MM-dd" value="${payPlayPageDelivery.startTime}"/>"
						class="easyui-datebox" data-options="required:true" /></td>
					<td colspan="4">
						至&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="endTime" id="endTime" class="easyui-datebox" data-options="required:true" value="<fmt:formatDate pattern="yyyy-MM-dd" value="${payPlayPageDelivery.endTime}"/>" />
					</td>
				</tr>
				<tr>
					<th>位置1图片：</th>
					<td ><input type="text" id="img1" name="img1" value="${payPlayPageDelivery.img1}"/></td>
					<td>
						<input class="buttoncenter" type="button" value="上传文件" id="img1_btn" />
					</td>
		            <td><div id="img-img1" name="img-img1" ><c:if test="${not empty payPlayPageDelivery.img1}"><a href="${payPlayPageDelivery.img1}" target="_blank">查看图片</a></c:if></div></td>
		            <td><b>URL1：</b><input name="link1" id="link1" value="${payPlayPageDelivery.link1}" /></td>
		            <td><b>CMS板块ID：3232</b></td>
				</tr>
				<tr>
					<th>位置2图片：</th>
					<td ><input type="text" id="img2" name="img2" value="${payPlayPageDelivery.img2}"/></td>
					<td>
						<input class="buttoncenter" type="button" value="上传文件" id="img2_btn" />
					</td>
		            <td><div id="img-img2" name="img-img2" ><c:if test="${not empty payPlayPageDelivery.img2}"><a href="${payPlayPageDelivery.img2}" target="_blank">查看图片</a></c:if></div></td>
		            <td><b>URL2：</b><input name="link2" id="link2" value="${payPlayPageDelivery.link2}" /></td>
		            <td><b>CMS板块ID：3220</b></td>
				</tr>
				<tr>
					<th>位置3图片：</th>
					<td ><input type="text" id="img3" name="img3" value="${payPlayPageDelivery.img3}"/></td>
					<td>
						<input class="buttoncenter" type="button" value="上传文件" id="img3_btn" />
					</td>
		            <td><div id="img-img3" name="img-img3" ><c:if test="${not empty payPlayPageDelivery.img3}"><a href="${payPlayPageDelivery.img3}" target="_blank">查看图片</a></c:if></div></td>
		            <td><b>URL3：</b><input name="link3" id="link3" value="${payPlayPageDelivery.link3}"/></td>
		            <td><b>CMS板块ID：3233</b></td>
				</tr>
				<tr>
					<th>位置4图片：</th>
					<td ><input type="text" id="img4" name="img4" value="${payPlayPageDelivery.img4}"/></td>
					<td>
						<input class="buttoncenter" type="button" value="上传文件" id="img4_btn" />
					</td>
		            <td><div id="img-img4" name="img-img4" ><c:if test="${not empty payPlayPageDelivery.img4}"><a href="${payPlayPageDelivery.img4}" target="_blank">查看图片</a></c:if></div></td>
		            <td><b>URL4：</b><input name="link4" id="link4" value="${payPlayPageDelivery.link4}" /></td>
		            <td><b>CMS板块ID：3234</b></td>
				</tr>
			</table>
		</form>
	</div>
</div>