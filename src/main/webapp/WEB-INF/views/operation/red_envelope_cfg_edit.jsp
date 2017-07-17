<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="">
		<form id="form" method="post">
			<table class="table table-form" style="width:100%">
				<tr>
					<td >
					<span>类型：</span>
				<select name="type">	
					<option value="1">红包配置</option>
					<option value="2">赠送观影卷</option>
					</select>
					</td>
				</tr>
				<tr>				
					<td >
					<span>终端：</span>		   
			   <select name="terminal">
									<c:forEach items="${terminals }" var="item">
									<option value="${item.key }" >${item.value }</option>
								</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<td>
						<input type="radio" name="support" <c:if test="${redEnvelopeCfg.support == 0}"> checked="checked" </c:if> value="0" />&nbsp;不支持
						&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="support" <c:if test="${redEnvelopeCfg.support == 1}"> checked="checked" </c:if> value="1" />&nbsp;支持
					</td>
				</tr>
				<tr>
					<td><span>秘钥key：</span><input type="text" name="keyValue" class="easyui-validatebox"
						 value="${redEnvelopeCfg.keyValue}"></td>
				</tr>
				<tr>
					<td><span>活动id：</span><input type="text" name="activityId" class="easyui-validatebox"
						data-options="required:true,validType:'int'" value="${redEnvelopeCfg.activityId}"></td>
				</tr>
				<tr>
					<td ><span>推广图：</span><input type="text" id="imgUrl" name="imgUrl" value="${redEnvelopeCfg.imgUrl}"/>
				&nbsp;&nbsp;&nbsp;<input class="buttoncenter" type="button" value="上传文件" id="upload_btn" />
					   &nbsp;&nbsp;&nbsp;<span id="imgUrl-upd" name="imgUrl-upd" ><c:if test="${not empty redEnvelopeCfg.imgUrl}"><a href="${redEnvelopeCfg.imgUrl}" target="_blank">查看图片</a></c:if></span>
					</td>
				</tr>
			</table>
		</form>
	</div>
</div>
<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');
		$('#form')
				.form(
						{
							url : '/red_envelope_cfg/update.json',
							onSubmit : function() {
								parent.$.messager.progress({
									title : '提示',
									text : '数据处理中，请稍后....'
								});
								var isValid = $(this).form('validate');
								if (!isValid) {
									parent.$.messager.progress('close');
								}
								// alert(isValid);
								return isValid;
							},
							success : function(result) {
								parent.$.messager.progress('close');
								result = $.parseJSON(result);
								if (result.code == 0) {
									parent.$.messager.alert('成功', result.msg, 'success');
									parent.$.modalDialog.openner_dataGrid.datagrid('reload');
									parent.$.modalDialog.handler.dialog('close');
								} else {
									parent.$.messager.alert('错误', result.msg,'error');
								}
							}
						});
	});

	var max_expand_photo = new SWFUpload({
	    button_placeholder_id: "upload_btn",
	    flash_url: "/static/lib/swfupload/swfupload.swf?rt="+Math.random(),
	    upload_url: '/upload?cdn=sync',
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
	        $("#imgUrl-upd").html(HTML_VIEWS);
	        $("#imgUrl").val(response);
	    },
	    file_queued_handler: function() {
	        this.startUpload();
	    },
	    upload_error_handler: function(file, code, msg) {
	        var message = Boss.util.defaults.upload.err + code + ': ' + msg + ', ' + file.name;
	        alert(message);
	    }
	});

</script>
<c:if test="${! empty  redEnvelopeCfg}">
<script>
$("select[name=type]").val('${redEnvelopeCfg.type}');
$("select[name=terminal]").val('${redEnvelopeCfg.terminal}');
</script>
</c:if>