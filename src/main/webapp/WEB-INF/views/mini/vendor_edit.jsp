<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/inc/jstl.inc"%>
<!DOCTYPE html>
<html>
<head>
    <title>新增商户</title>
    <script src="/static/lib/swfupload/swfupload.js" type="text/javascript" charset="utf-8"></script>
    <%@ include file="/WEB-INF/views/inc/head.inc"%>
    <script type="text/javascript">
        /* <m:auth uri="/consume/open">
         $.canOpen = true;
        </m:auth> */
        <m:auth uri="/consume/close">
        $.canClose = true;
        </m:auth>
        <m:auth uri="/consume/refund.do">
        $.canRefund = true;
        </m:auth>
    </script>
    <style>
        .cont1{width:100%;}
        .cont2{margin:0 20px;padding:14px 20px;color:#444;position: relative;font-size: 12px;}
        .cont2:last-child{border-bottom:0px dashed #aaa;}
        .title{margin-bottom: 10px;font-weight: bold;text-decoration: underline;}
        td{height: 54px;}
        td input{width: 300px;height: 25px;padding: 1px 10px;}
        td select{width: 316px;height: 30px;padding: 1px 10px;margin-right:25px;}
        td textarea{width: 292px;height: 80px;padding: 1px 10px;margin-right:25px;}
        .name-span{float: none;margin-left: 10px;}
        table tr td span{margin-right: 10px;display: inline-block;float: none;}
        table tr td input{margin-right: 30px;}
        .val-span{min-width:100px;color:#777;float: none;}
        .attention{color:#f00;float:left;margin-top: 54px;}
        .close-btn{margin: 20px 0 0 60px;padding: 2px 6px;}
        .save-btn{margin: 20px 0 0 450px;padding: 2px 6px;}
        .gray{color: gray;}
    </style>
</head>
<body>
<div class="cont1">
    <div class="cont2">
        <p class="title">商户信息</p>
        <form id="vendor_form">
            <input type="hidden" name="vendorId" value="${vendor.id}"/>
        <table>
            <tr>
                <td width="122"><b style="color: red">*</b><span class="name-span">商户编码</span></td>
                <td><input type="text" name="vendorNo" value="${vendor.vendorNo}" readonly="readonly"/></td>
                <td><span class="gray">自动生成，不得修改</span></td>
            </tr>
            <tr>
                <td><b style="color: red">*</b><span class="name-span">商户名称</span></td>
                <td><input type="text" name="name" value="${vendor.name}" class="easyui-validatebox" data-options="required:true,validType:'maxLength[60]'"/></td>
                <td><span class="gray">不得超过30个汉字或60个字符</span></td>
            </tr>
            <tr>
                <td><b style="color: red">*</b><span class="name-span">供应商编码</span></td>
                <td><input type="text" name="vendorCode" value="${vendor.vendorCode}" class="easyui-validatebox" data-options="required:true,validType:'maxLength[60]'"/></td>
                <td><span class="gray">由ERP系统分配</span></td>
            </tr>
            <%--<tr>
                <td><b style="color: red">*</b><span class="name-span">商户简称</span></td>
                <td><input type="text" name="" value="" class="easyui-validatebox" data-options="required:true,validType:'maxLength[20]'"/></td>
                <td><span class="gray">不得超过10个汉字或20个字符</span></td>
            </tr>--%>
            <%--<tr>--%>
                <%--<td><b style="color: red">*</b><span class="name-span">商户类型</span></td>--%>
                <%--<td>--%>
                    <%--<select>--%>
                        <%--<option>自营</option>--%>
                        <%--<option>非自营</option>--%>
                    <%--</select>--%>
                    <%--<span class="gray">区分乐视集团内外商户</span>--%>
                <%--</td>--%>
            <%--</tr>--%>
            <%--<tr>--%>
                <%--<td><b style="color: red">*</b><span class="name-span">商户合作模式</span></td>--%>
                <%--<td>--%>
                    <%--<select>--%>
                        <%--<option>商户发货</option>--%>
                        <%--<option>销售主体发货</option>--%>
                    <%--</select>--%>
                <%--</td>--%>
                <%--<td><span class="gray"></span></td>--%>
            <%--</tr>--%>
            <tr>
                <td><b style="color: red">*</b><span class="name-span">支付成功回调地址</span></td>
                <td><input type="text" name="successNotifyUrl" value="${vendor.successNotifyUrl}" class="easyui-validatebox" data-options="required:true,validType:'isUrl'"/></td>
                <td><span class="gray">虚拟商品购买成功后系统回调该地址通知商户开通服务</span></td>
            </tr>
            <tr>
                <td><b style="color: red">*</b><span class="name-span">退款回调地址</span></td>
                <td><input type="text" name="refundNotifyUrl" value="${vendor.refundNotifyUrl}" class="easyui-validatebox" data-options="required:true,validType:'isUrl'"/></td>
                <td><span class="gray">虚拟商品退款成功后系统回调该地址通知商户关闭服务</span></td>
            </tr>
            <tr>
                <td><b style="color: red">*</b><span class="name-span">商户秘钥</span></td>
                <td><input type="text" name="signKey" value="${vendor.signKey}" readonly="readonly" data-options="required:true"/></td>
                <td><span class="gray">调用接口加密使用，自动生成，不得修改</span></td>
            </tr>
            <tr>
                <td><span class="name-span">联系人</span></td>
                <td><input type="text" name="contactName" value="${vendor.contactName}"/></td>
                <td><span class="gray">商户联系人</span></td>
            </tr>
            <tr>
                <td><span class="name-span">联系电话</span></td>
                <td><input type="text" name="contactTel" class="easyui-validatebox" data-options="validType:'phoneNum'" value="${vendor.contactTel}"/></td>
                <td><span class="gray">商户联系电话</span></td>
            </tr>
            <tr>
                <td><span class="name-span">联系地址</span></td>
                <td><input type="text" name="contactAddress" value="${vendor.contactAddress}"/></td>
                <td><span class="gray">商户联系地址</span></td>
            </tr>
            <tr>
                <td><span class="name-span">商户LOGO</span></td>
                <td>
                    <input type="text" id="common_pic" name="vendorLogo" value="${vendor.vendorLogo}" style="width: 145px;vertical-align: top;margin-right:20px"/>
                    <input class="buttoncenter" type="button" value="${internationalConfig.上传文件}" id="common_upload_btn" style="margin-top:10px;margin-right:30px;"/>
                    <c:if test="${not empty vendor.vendorLogo}"><a style="vertical-align: top;margin-left: 20px;" href="${vendor.vendorLogo}" target="_blank">查看图片</a></c:if>
                </td>
                <td><span class="gray"></span></td>
            </tr>
            <tr>
                <td><span class="name-span">商户描述</span></td>
                <td><textarea rows="3" cols="20" name="vendorDesc" value="${vendor.vendorDesc}" data-options="validType:'maxLength[200]'">${vendor.vendorDesc}</textarea></td>
                <td><span class="gray">不得超过100个汉字或200个字符</span></td>
            </tr>
        </form>
        </table>
    </div>

    <div class="cont2">
        <button class="save-btn" onclick="saveTab()">${internationalConfig.保存}</button>
        <button class="close-btn" onclick="closeTab()">${internationalConfig.关闭}</button>
    </div>

</div>
<script>
    $.extend($.fn.validatebox.defaults.rules, {
        maxLength: {
            validator: function(value, param){
                var length = value.replace(/[\u0391-\uFFE5]/g,"aa").length;
                return param[0] >= length;
            },
            message: '不得超过{0}个字符'
        },
        phoneNum: { //验证手机号
            validator: function(value, param){
                return /^1[3-8]+\d{9}$/.test(value);
            },
            message: '请输入正确的手机号码。'
        },
        isUrl:{ //验证链接
            validator: function(value, param){
                return /^(file|http|https|ftp|mms|telnet|news|wais|mailto):\/\/(.+)$/.test(value);
            },
            message: '请输入正确的地址。'
        }
    });
    (function($) {
        parent.$.messager.progress('close');
        $.fn.serializeJson = function() {
            var serializeObj = {};
            var array = this.serializeArray();
            $(array).each(function() { // 遍历数组的每个元素 {name : xx , value : xxx}
                if (serializeObj[this.name]) { // 判断对象中是否已经存在 name，如果存在name
                    serializeObj[this.name] += "," + this.value;
                } else {
                    serializeObj[this.name] = this.value; // 如果元素name不存在，添加一个属性 name:value
                }
            });
            return serializeObj;
        }

        newCommonUploadBtn('common_upload_btn','common_pic','common_preview')
    })(jQuery)

    function addZero(data){
        if(parseInt(data)<10){
            return "0"+data;
        }else{
            return data;
        }
    }
    function saveTab() {

        if ($("#vendor_form").form("validate")) {
            parent.$.messager.progress({
                title : '${internationalConfig.提示}',
                text : '${internationalConfig.数据处理中}....'
            });
            $.ajax({
                url : "/mini/vendor/modify",   //保存链接
                type : "post",
                data : $("#vendor_form").serializeJson(),
                dataType : "json",
                success : function(result) {
                    parent.$.messager.progress('close');
                    if (result.code == 0) {
                        parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.保存成功}', 'success');
                        if(parent.refreshDataGrid.venderDataGrid) {
                            parent.refreshDataGrid.venderDataGrid.datagrid('reload');
                        }
                        parent.$('.tabs .tabs-selected .tabs-close').trigger("click");
                    } else {
                        parent.$.messager.alert('${internationalConfig.错误}', '<div style="word-break:break-all;">'+result.msg+'</div>', 'error');
                    }
                }
            })
        }
    }

    function closeTab(){
        parent.$('.tabs .tabs-selected .tabs-close').trigger("click");
    }
    function newCommonUploadBtn(buttonId,inputId,previewId){
        new SWFUpload({
            button_placeholder_id: buttonId,
            flash_url: "/static/lib/swfupload/swfupload.swf?rt=" + Math.random(),
            upload_url: '/upload?cdn=sync',
            button_image_url: Boss.util.defaults.upload.button_image,
            button_cursor: SWFUpload.CURSOR.HAND,
            button_action: SWFUpload.BUTTON_ACTION.SELECT_FILE,
            file_size_limit: '8 MB',
            button_width: "61",
            button_height: "24",
            file_post_name: "myfile",
            file_types: "*.jpg;*.jpeg;*.png;*.bmp;*.gif",
            file_types_description: "All Image Files",
            button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
            upload_start_handler: function () {
            },
            upload_success_handler: function (file, response) {
                if (response.indexOf("http")!=0){
                    alert("${internationalConfig.上传失败请稍后重试}");
                    return;
                }
                if (previewId) {
                    var HTML_VIEWS = '<a href=' + response + ' target="_blank">${internationalConfig.查看图片}</a>&nbsp;&nbsp;&nbsp;&nbsp;';
                    $("#" + previewId).html(HTML_VIEWS);
                }
                $("#"+inputId).val(response);
            },
            file_queued_handler: function () {
                this.startUpload();
            },
            upload_error_handler: function (file, code, msg) {
                var message = '${internationalConfig.UploadFailed}' + code + ': ' + msg + ', ' + file.name;
                alert(message);
            }
        });
    }
</script>
</body>
</html>