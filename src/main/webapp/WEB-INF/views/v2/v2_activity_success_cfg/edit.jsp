<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:if test="${not empty param.singlePage}">
    <%@ include file="/WEB-INF/views/inc/head.inc"%>
</c:if>
<style>
    input[type=text]{
        padding-top: 0;
        padding-bottom: 0;
    }
    .long_text{
        width:336px !important;
    }
    .mid_text{
        width:260px !important;
    }
    .long_select{
        width:350px !important;
    }
    .tinyint{
        width: 40px;
    }
    .short_select{
        width: 120px;
    }
</style>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title="">
        <form id="form" method="post" action="#">
            <input type="hidden" name="id" value="${cfg.id}" />
            <table style="width: 100%" class="table table-form">
                <tr>
                    <th style="width:60px;">${internationalConfig.活动名称}</th>
                    <td colspan="3"><input name="activityName" type="text" value="${fn:replace(cfg.activityName, '\"', '&#34;')}" class="easyui-validatebox long_text" data-options="required:true" maxlength="26" onchange="trimInput(this)">
                        <span>${internationalConfig.最多26个字符}</span>
                    </td>
                </tr>
                <tr>
                    <th>${internationalConfig.会员名称}</th>
                    <td colspan="3">
                        <select id="vipTypeId" name="vipTypeId" class="long_select">
                            <c:forEach var="item" items="${vipPackageTypes}">
                                <option value="${item.id}" <c:if test="${cfg.vipTypeId==item.id}">selected="selected"</c:if>>${item.name}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th>${internationalConfig.套餐内容}</th>
                    <td colspan="3">
                        <select id="vipPackageId" name="vipPackageId" class="easyui-validatebox long_select" data-options="required:true">
                        </select>
                    </td>
                </tr>
                <tr>
                    <th>${internationalConfig.支持终端}</th>
                    <td colspan="3">
                        <c:forEach items="${terminals}" var="item">
                            <input type="checkbox" id="terminal${item.terminalId}" name="terminal" value="${item.terminalId}">&nbsp;${item.terminalName}&nbsp;
                        </c:forEach>
                        <input type="hidden" id="terminals" name="terminals">
                     </td>
                </tr>
                <tr>
                    <th>${internationalConfig.生效时间}</th>
                    <td>
                        <input type="text" name="effectiveTime" id="effectiveTime" class="easyui-datetimebox" data-options="required:true" value="<fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${cfg.effectiveTime}"/>">
                    </td>
                    <th>${internationalConfig.失效时间}</th>
                    <td><input type="text" name="invalidTime" id="invalidTime" class="easyui-datetimebox" data-options="required:true,validType:'timeLaterThan[\'input[name=effectiveTime]\',\'yyyy-MM-dd HH:mm:ss\']'" value="<fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${cfg.invalidTime}"/>" />
                    </td>
                </tr>
                <tr>
                    <th>${internationalConfig.PC端图片}</th>
                    <td colspan="3">
                        <input type="text" id="iconPc" name="iconPc" value="${cfg.iconPc}" class="easyui-validatebox mid_text" validType="onlyHttpsUrl">&nbsp;&nbsp;
                        <input class="buttoncenter" type="button" value="${internationalConfig.上传}" id="iconPcUploadBtn" />&nbsp;&nbsp;
                        <span id="iconPcPreview"><c:if test="${cfg.iconPc!=null}"><a href="${cfg.iconPc}" target="_blank">${internationalConfig.查看图片}</a></c:if></span>
                    </td>
                </tr>
                <tr>
                    <th>${internationalConfig.移动端图片}</th>
                    <td colspan="3">
                        <input type="text" id="iconMobile" name="iconMobile" value="${cfg.iconMobile}" class="easyui-validatebox mid_text" validType="onlyHttpsUrl">&nbsp;&nbsp;
                        <input class="buttoncenter" type="button" value="${internationalConfig.上传}" id="iconMobileUploadBtn">&nbsp;&nbsp;
                        <span id="iconMobilePreview"><c:if test="${cfg.iconMobile!=null}"><a href="${cfg.iconMobile}" target="_blank">${internationalConfig.查看图片}</a></c:if></span>
                    </td>
                </tr>
                <tr>
                    <th>${internationalConfig.TV端图片}</th>
                    <td colspan="3">
                        <input type="text" id="iconTV" name="iconTv" value="${cfg.iconTv}" class="easyui-validatebox mid_text" validType="onlyHttpsUrl">&nbsp;&nbsp;
                        <input class="buttoncenter" type="button" value="${internationalConfig.上传}" id="iconTVUploadBtn" />&nbsp;&nbsp;
                        <span id="iconTVPreview"><c:if test="${cfg.iconTv!=null}"><a href="${cfg.iconTv}" target="_blank">${internationalConfig.查看图片}</a></c:if></span>
                    </td>
                </tr>
                <tr>
                    <th>${internationalConfig.跳转URL}</th>
                    <td colspan="3"><input type="text" name="redirectUrl" class="mid_text" value="${cfg.redirectUrl}"></td>
                </tr>
                <tr>
                    <th>${internationalConfig.排序}</th>
                    <td>
                        <input type="text" name="priority" class="easyui-numberbox tinyint" value="${cfg.priority}" data-options="required:true,precision:0,min:0,max:65535">
                        <span style="color: red">${internationalConfig.数值越大权重越高}</span>
                    </td>
                    <th>&nbsp;&nbsp;${internationalConfig.状态}</th>
                    <td><select name="status" id="status" class="short_select">
                        <option value="0" <c:if test="${cfg.status == 0}">selected="selected"</c:if>>${internationalConfig.未发布}</option>
                        <option value="1" <c:if test="${cfg.status == 1}">selected="selected"</c:if>>${internationalConfig.已发布}</option>
                    </select>
                    </td>
                </tr>
                <tr>
                    <th>${internationalConfig.配置描述}</th>
                    <td colspan="3"><textarea name="description" class="txt-middle">${fn:replace(cfg.description,'<','&lt;')}</textarea></td>
                </tr>
            </table>
        </form>
    </div>
</div>

<script src="/static/lib/date.js"></script>
<script src="/static/lib/swfupload/swfupload.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
    var vipPackages={<c:forEach items="${vipPackages}" var="item">${item.id}:{typeId:${item.typeId}, content:'${item.id} - ${fn:replace(item.name, '\'', '\\\'')} - ${fn:replace(item.durationName, '\'', '\\\'')} - ${item.price}'<c:if test="${item.autoRenew==1}">+$.formatString('${internationalConfig.自动续费X期}', ${item.autoRenewPeriod})</c:if>},</c:forEach>};
    $(document).ready(function(){
        parent.$.messager.progress('close');
        // 勾选终端
        (function(){
            var supportedTerminals = '${cfg.terminals}'.split(/\s*,\s*/);
            if (supportedTerminals)
                for ( var i = 0; i < supportedTerminals.length; i++) {
                    $("#terminal" + supportedTerminals[i]).prop("checked", true);
                }
        })();

        // 会员内容包联动
        $('#vipTypeId').change(function(){
            var vipTypeId=$(this).val();
            var packageInput=$('#vipPackageId');
            packageInput.empty();
            $.each(vipPackages, function(id, obj){
                if (obj.typeId==vipTypeId)
                    packageInput.append($('<option>',{value:id, text:obj.content}));
            });
            if(packageInput.find('option').length==0)
                packageInput.append($('<option>',{value:'', text:''}));
        });
        $('#vipTypeId').trigger('change');
        <c:if test="${cfg!=null}">$('#vipPackageId').val('${cfg.vipPackageId}');</c:if>

        newCommonUploadBtn('iconPcUploadBtn', 'iconPc', 'iconPcPreview');
        newCommonUploadBtn('iconMobileUploadBtn', 'iconMobile', 'iconMobilePreview');
        newCommonUploadBtn('iconTVUploadBtn', 'iconTV', 'iconTVPreview');
    });
    $(function() {
        parent.$.messager.progress('close');
        $('#form').form({
            url : '/v2/activity_success_cfg/save',
            method: 'POST',
            onSubmit : function() {
                parent.$.messager.progress({
                    title : '${internationalConfig.提示}',
                    text : '${internationalConfig.数据处理中}....'
                });

                var isValid = $(this).form('validate');
                if (isValid) {
                    var terminals = []
                    $('input[name=terminal]:checked').each(function(){
                        terminals.push($(this).val());
                    });
                    if (terminals) terminals = terminals.join(',');
                    $('#terminals').val(terminals);
                }
                if (!isValid) {
                    parent.$.messager.progress('close');
                }
                return isValid;
            },
            success : function(result) {
                parent.$.messager.progress('close');
                result = $.parseJSON(result);
                if (result.code == 0) {
                    msg = <c:choose><c:when test="${cfg==null}">'${internationalConfig.添加成功}'</c:when><c:otherwise>'${internationalConfig.编辑成功}'</c:otherwise></c:choose>;
                    parent.$.messager.alert('${internationalConfig.成功}', msg, 'success');
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
        onlyHttpsUrl : {
            validator : function(value, param) {
                return value.substring(0,8).toLowerCase() == 'https://';
            },
            message : '${internationalConfig.图片URL必须是HTTPS开头}'
        },
        timeLaterThan: {
            validator: function(value, param) {
                var tmThis=Date.parse(value.replace("24:00:00","23:59:59"), param[1]);
                var valueCompare=/^\d/.test(param[0])?param[0]:$(param[0]).val();
                if(valueCompare)valueCompare.replace("24:00:00","23:59:59");
                var tmCompare=Date.parse(valueCompare, param[1]);
                return tmThis>=tmCompare;
            },
            message: "${internationalConfig.结束时间不能早于开始时间}"
        }
    });

    function trimInput(input) {
        var input = $(input);
        var value = $.trim(input.val());
        input.val(value);
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
                response=response.replace("http://","https://");
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