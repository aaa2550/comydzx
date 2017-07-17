<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<title>${mb }<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>${internationalConfig.批量充值与兑换}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
</head>
<body>
<div id="toolbar"  class="czm_wrap" >



 <a href="/static/mb/${mb }" class="easyui-linkbutton" data-options="plain:true,iconCls:'bug_add'">${internationalConfig.模板下载}</a>
       <span style=" display: inline-block;   height: 28px;vertical-align: middle; width: 80px;"><a href="JavaScript:;" class="easyui-linkbutton" data-options="plain:true,iconCls:'tag_add'"  id="js_upload_btn" >${internationalConfig.导入附件}</a></span>
       <a href="JavaScript:;"  onclick="recharge();" class="easyui-linkbutton" data-options="plain:true,iconCls:'newspaper_link'"><c:if test="${ 'recharge'==recharge}">${internationalConfig.批量充值}</c:if><c:if test="${ 'recharge'!=recharge}">${internationalConfig.批量兑换}</c:if></a>

</div>
<div id="uploadfile"  class="file_upload_name"></div>



<script type="text/javascript">
var storeId=0 ;
var swfupload = new SWFUpload({
    button_placeholder_id: "js_upload_btn",
    flash_url: "/static/lib/swfupload/swfupload.swf?rt="+Math.random(),
    upload_url: '/op/lecard/${recharge}',
 //   button_image_url: '/static/lib/swfupload/fj_add.png',
    button_text : "<span class='redText'>${internationalConfig.导入附件}</span>",
    button_text_style:'.redText {font-size:14px;font-family:"microsoft yahei";text-align:center;padding-left:16px;color:#000 }',
    button_cursor: SWFUpload.CURSOR.HAND,
    button_action: SWFUpload.BUTTON_ACTION.SELECT_FILE,
    file_size_limit: '8 MB',
    button_width: "80",
    file_post_name:"myfile",
    button_height: "26",

    button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
    upload_start_handler: function() {
    },
    upload_success_handler: function(file, data) {
    	data = $.parseJSON(data);
    	$("#uploadfile").html(data.name);
        storeId=data.id ;
    },
    file_queued_handler: function() {
        this.startUpload();
    },
    upload_error_handler: function(file, code, msg) {
        var message = Boss.util.defaults.upload.err + code + ': ' + msg + ', ' + file.name;
        alert(message);
    }
});
function recharge(){
	$.post("/op/lecard/${recharge}.json",{storeId:storeId},function(){
		parent.$.messager.alert('${internationalConfig.成功}', "${internationalConfig.请求正在处理请稍后查收邮件}！", 'success');
	});
}
</script>
</body>
</html>