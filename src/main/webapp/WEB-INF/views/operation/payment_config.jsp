<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="/WEB-INF/views/inc/head.inc"%>

<script src="/static/lib/swfupload/swfupload.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
    
	$(function() {
		parent.$.messager.progress('close');
		$('#form').form({
			url : '${pageContext.request.contextPath}/payment_config/update.json',
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
                	parent.$.messager.alert('成功', '编辑成功', 'success');
					parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
					parent.$.modalDialog.handler.dialog('close');
				} else {
					parent.$.messager.alert('错误', result.msg, 'error');
				}
			}
		});
		
		for(var i=1; i <= parseInt('${paymentConfigSize}'); i ++) {
			(function(i) {
				new SWFUpload({
		            button_placeholder_id: "js_upload_btn" + i,
		            flash_url: "${pageContext.request.contextPath}/static/lib/swfupload/swfupload.swf?rt="+Math.random(),
		            upload_url: '${pageContext.request.contextPath}/upload?cdn=sync',
		            button_image_url: Boss.util.defaults.upload.button_image,
		            button_cursor: SWFUpload.CURSOR.HAND,
		            button_action: SWFUpload.BUTTON_ACTION.SELECT_FILE,
		            file_size_limit: '8 MB',
		            button_width: "61",
		            file_post_name:"myfile",
		            button_height: "24",
		            file_types: "*.jpg;*.jpeg;*.png;*.bmp;*.gif",
		            file_types_description: "All Image Files",
		            button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
		            upload_start_handler: function() {
		            },
		            upload_success_handler: function(file, response) {
		                var HTML_VIEWS = '<a href='+response+' target="_blank">'+Boss.util.defaults.upload.viewText+'</a>&nbsp;&nbsp;&nbsp;&nbsp;';
		                $("#img-views" + i).html(HTML_VIEWS);
		                $("#logoImg" + i).val(response);
		            },
		            file_queued_handler: function() {
		                this.startUpload();
		            },
		            upload_error_handler: function(file, code, msg) {
		                var message = Boss.util.defaults.upload.err + code + ': ' + msg + ', ' + file.name;
		                alert(message);
		            }
		        });
			})(i);
		}
		
		$('input[type=checkbox]').click(
            function () {
            	var nameValue = $(this).attr("name");
            	this.value = (this.value == 0) ? 1 : 0;
            	if(nameValue == "pay_status") { //是否支持
            		var payStatusHtml = '<input type="hidden" name="status" value="' + this.value + '" />';
            		$(this).parents("tr").children("td").eq(8).html(payStatusHtml);
            	} else if(nameValue = "pay_activity_status") { //是否支持活动
            		var payStatusHtml = '<input type="hidden" name="activityStatus" value="' + this.value + '" />';
            		$(this).parents("tr").children("td").eq(9).html(payStatusHtml);
             	}
            });
		
	});
	
	function invokeForm() {
		var f = $('#form');
		f.submit();
	}
	
	function showTerminalPaymentConfig(termianl) {
		var type = $(termianl).val();
		window.location.href="/payment_config/payment_config.do?terminal=" + type;
	}
</script>

<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="">
		<form id="form" method="post"
			action="${pageContext.request.contextPath}/payment_config/add.json">
			<table class="table table-form">
				<colgroup>
					<col width="9%">
					<col width="10%">
					<col width="16%">
					<col width="31%">
					<col width="9%">
					<col width="18%">
					<col width="8%">
					<col width="*">
					<col width="*">
				</colgroup>
				<tr>
					<td style="text-align:left;width:50px;">配置终端：</td>
					<td style="text-align:left;width:100px;">
						<select name="terminal" onchange="showTerminalPaymentConfig(this)" class="tabla_form_input">
							<option value="0" <c:if test="${terminal eq '0' }">selected</c:if>>TV</option>
							<option value="1" <c:if test="${terminal eq '1' }">selected</c:if>>PC</option>
							<option value="2" <c:if test="${terminal eq '2' }">selected</c:if>>WEB</option>
							<option value="3" <c:if test="${terminal eq '3' }">selected</c:if>>Android</option>
							<option value="4" <c:if test="${terminal eq '4' }">selected</c:if>>领先版</option>
						</select>
					</td>
					<td>
						<m:auth uri="/payment_config/update.json">
			            	<input type="button" value="保存配置" onclick="invokeForm()" class="bcpz_btn">
						</m:auth>
					</td>
					<td colspan="4"></td>
				</tr>
				<c:forEach items="${paymentConfigList}" var="paymentConfig" varStatus="status">
					<tr>
						<td style="text-align:left;">支持：<input type="checkbox" name="pay_status" value="${paymentConfig.status}" <c:if test="${paymentConfig.status == 1}"> checked</c:if> /></td>
						<td style="text-align:left;">支持活动：<input type="checkbox" name="pay_activity_status" value="${paymentConfig.activityStatus}" <c:if test="${paymentConfig.activityStatus == 1}"> checked</c:if> /></td>
						<td style="text-align:left;">标题：<input class="tabla_form_input" name="title" value="${paymentConfig.title}" /></td>
						<td style="text-align:left;">副标题：<input class="tabla_form_input_fbt" name="subTitle" value="${paymentConfig.subTitle}" /></td>
						<td style="text-align:left;">排序：<input class="tabla_form_input_px" name="sort" value="${paymentConfig.sort}" /></td>
						<td><input class="tabla_form_input" type="text" id="logoImg${status.index + 1}" name="logoUrl" value="${paymentConfig.logoUrl}"/>
							<input class="buttoncenter" type="button" value="上传文件" id="js_upload_btn${status.index + 1}" /></td>
			            <td><div id="img-views${status.index + 1}" name="img-views${status.index + 1}" ><c:if test="${not empty paymentConfig.logoUrl}"><a href="${paymentConfig.logoUrl}" target="_blank">查看图片</a></c:if></div></td>
			            <td><input type="hidden" name="payType" value="${paymentConfig.payType}" /><input type="hidden" name="id" value="${paymentConfig.id}" /></td>
			            <td><input type="hidden" name="status" value="${paymentConfig.status}" /></td>
			            <td><input type="hidden" name="activityStatus" value="${paymentConfig.activityStatus}" /></td>
					</tr>
				</c:forEach>
			</table>
		</form>
		<p class="pay_zhushi">注释：<br>
		1、支持表示终端是否显示此付费方式<br>
		2、排序值越大，支付方式越靠前
			
		</p>
	</div>
</div>