<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<script src="/static/lib/swfupload/swfupload.js" type="text/javascript" charset="utf-8"></script>
<%@ include file="/WEB-INF/views/inc/jstl.inc"%>

<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');
		$('#form').form({
			url : '${pageContext.request.contextPath}/tv_nonmember_guide/add.json',
			onSubmit : function() {
				parent.$.messager.progress({
					title : '${internationalConfig.提示}',
					text : '${internationalConfig.数据处理中}'
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
					parent.$.modalDialog.openner_dataGrid.datagrid('reload');
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
	
	var img_url = img_url||null ; //大推广图片

	img_url = new SWFUpload({
	    button_placeholder_id: "mobile_upload_btn",
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
	        $("#imgUrl-mobile").html(HTML_VIEWS);
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
					<th>${internationalConfig.付费播放场景引导}</th>
					<td colspan="3">
						<select name="userType" class="span2">
						    <option value="1">${internationalConfig.前贴片广告}</option>
						    <option value="2">${internationalConfig.码流付费}</option>
						    <option value="3">${internationalConfig.单点影片}</option>
						    <option value="4">${internationalConfig.卡顿}</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>${internationalConfig.主标题}</th>
					<td><input name="mainTitle" type="text" class="easyui-validatebox" data-options="required:true"></td>
					<th>${internationalConfig.副标题}</th>
					<td><input name="subTitle" type="text" class="easyui-validatebox" data-options="required:true"></td>
				</tr>
				<tr>
					<th>${internationalConfig.支付方式}</th>
					<td colspan="3">
                        <input name="payType" type="radio" value="-1" checked="checked" />${internationalConfig.暂无}
						<input name="payType" type="radio" value="41,42" />${internationalConfig.信用卡}
                        <input name="payType" type="radio" value="24" />${internationalConfig.微信}
                        <input name="payType" type="radio" value="5" />${internationalConfig.支付宝}
                        <input name="payType" type="radio" value="33" />${internationalConfig.乐点}
                    </td>
				</tr>
				<tr>
					<th>${internationalConfig.全屏套餐}</th>
					<td colspan="3">
						<input name="packageType" type="radio" value="-1" checked="checked" />${internationalConfig.暂无}
						<input name="packageType" type="radio" value="2" />${internationalConfig.包月}
                        <input name="packageType" type="radio" value="3" />${internationalConfig.包季}
                        <input name="packageType" type="radio" value="5" />${internationalConfig.包年}
                    </td>
				</tr>
				<tr>
					<th>${internationalConfig.图片地址}：</th>
					<td ><input type="text" id="imgUrl" name="imgUrl" class="easyui-validatebox" data-options="required:true" /></td>
					<td>
						<input class="buttoncenter" type="button" value="${internationalConfig.上传文件}" id="mobile_upload_btn" />
					</td>
		            <td><div id="imgUrl-mobile" name="imgUrl-mobile" ></div></td>
				</tr>
				<tr>
					<th>${internationalConfig.按键文案配置}</th>
					<td><input type="text" name="keyDesc" class="easyui-validatebox" data-options="required:true" /></td>
				</tr>
			</table>
		</form>
	</div>
</div>