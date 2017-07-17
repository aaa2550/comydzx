<%--
  Created by IntelliJ IDEA.
  User: kangxiongwei3
  Date: 2016/4/11
  Time: 16:44
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<script src="/static/lib/swfupload/swfupload.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript" src="/static/lib/uploadImg4PropsConfig.js" charset="utf-8"></script>
<script  src="/js/kv/propsBusiness.js"></script>
<script  src="/js/kv/propsChannel.js"></script>
<script  src="/js/kv/propsType.js"></script>
<script  src="/js/kv/propsUnit.js"></script>
<%@ include file="/WEB-INF/views/inc/jstl.inc"%>

<style type="text/css">
    .table th {
        text-align: right;
    }
    .inp_w{
        width: 110px;
    }
</style>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title="">
        <form id="form" method="post" action="/props/props_eidt.do">
            <input type="hidden" name="id" value="${props.id}">
            <table style="width: 100%" class="table table-form">
                <tr>
                    <th><b style="color: red">*</b>道具名称：</th>
                    <td>
                        <input name="codeName" value="${props.codeName}" class="span2, easyui-validatebox" data-options="required:true">&nbsp;&nbsp;
                        <input style="width: 80px; font-family: 'Microsoft YaHei'" type="button" value="验重" onclick="validateCodeName();">&nbsp;&nbsp;
                        <b id="validateInfo" style="color: red; display: none"></b>
                    </td>
                </tr>
                <tr>
                    <th><b style="color: red">*</b>显示名称：</th>
                    <td><input name="name" value="${props.name}" class="span2, easyui-validatebox" data-options="required:true"></td>
                </tr>
                <tr>
                    <th>名称描述：</th>
                    <td><input name="nameDescribe" value="${props.nameDescribe}" class="span2, easyui-validatebox"></td>
                </tr>
                <tr>
                    <th><b style="color: red">*</b>业务线：</th>
                    <td>
                        <%@ include file="/WEB-INF/views/inc/props_business.inc" %>
                        <%@ include file="/WEB-INF/views/inc/props_channel.inc" %>
                    </td>
                </tr>
                <tr>
                    <th>分类：</th>
                    <td>
                        <%@ include file="/WEB-INF/views/inc/props_type.inc" %>
                    </td>
                </tr>
                <tr>
                    <th><b style="color: red">*</b>道具配置：</th>
                    <td>
                        <%--M站文件上传--%>
                        移动端<br>
                        <input type="text" class="inp_w" name="mobilePic" value="${config.mobile.pic}" id="configMobilePic" placeholder="请选择缩略图" class="span2"/>&nbsp;&nbsp;
                        <input class="props_upload_btn" type="button" value="上传" id="mobile_upload_pic_btn" />

                        <input type="text" class="inp_w" name="mobileDynamicPic" value="${config.mobile.dynamicPic}" id="configMobileDynamicPic" placeholder="请选择动效图" class="span2"/>&nbsp;&nbsp;
                        <input class="props_upload_btn" type="button" value="上传" id="mobile_upload_dynamic_pic_btn" />

                        <input type="text" class="inp_w" name="mobileDynamicFile" value="${config.mobile.dynamicFile}" id="configMobileDynamicFile" placeholder="请选择动效文件" class="span2"/>&nbsp;&nbsp;
                        <input class="props_upload_btn" type="button" value="上传" id="mobile_upload_dynamic_file_btn" /><br>

                        <%--PC端文件上传--%>
                        PC端和M站<br>
                        <input type="text" class="inp_w" name="webPic" value="${config.web.pic}" id="configWebPic" placeholder="请选择缩略图" class="span2"/>&nbsp;&nbsp;
                        <input class="props_upload_btn" type="button" value="上传" id="web_upload_pic_btn">

                        <input type="text" class="inp_w" name="webDynamicPic" value="${config.web.dynamicPic}" id="configWebDynamicPic" placeholder="请选择动效图" class="span2"/>&nbsp;&nbsp;
                        <input class="props_upload_btn" type="button" value="上传" id="web_upload_dynamic_pic_btn" />

                        <input type="text" class="inp_w" name="webDynamicFile" value="${config.web.dynamicFile}" id="configWebDynamicFile" placeholder="请选择动效文件" class="span2"/>&nbsp;&nbsp;
                        <input class="props_upload_btn" type="button" value="上传" id="web_upload_dynamic_file_btn" /><br>
                        <%--TV端文件上传--%>
                        TV端<br>
                        <input type="text" class="inp_w" name="tvPic" value="${config.tv.pic}" id="configTvPic" placeholder="请选择缩略图" class="span2"/>&nbsp;&nbsp;
                        <input class="props_upload_btn" type="button" value="上传" id="tv_upload_pic_btn">

                        <input type="text" class="inp_w" name="tvDynamicPic" value="${config.tv.dynamicPic}" id="configTvDynamicPic" placeholder="请选择动效图" class="span2"/>&nbsp;&nbsp;
                        <input class="props_upload_btn" type="button" value="上传" id="tv_upload_dynamic_pic_btn" />

                        <input type="text" class="inp_w" name="tvDynamicFile" value="${config.tv.dynamicFile}" id="configTvDynamicFile" placeholder="请选择动效文件" class="span2"/>&nbsp;&nbsp;
                        <input class="props_upload_btn" type="button" value="上传" id="tv_upload_dynamic_file_btn" /><br>
                    </td>
                </tr>
                <tr>
                    <th><b style="color: red">*</b>单价：</th>
                    <td>
                        <input name="price" value="${props.price}" class="span2, easyui-numberbox" min="1" max="99999" data-options="required:true">&nbsp;&nbsp;
                        <%@ include file="/WEB-INF/views/inc/props_unit.inc" %><%--<b style="color: orange">请输入1～99999之间的数字</b>--%>
                    </td>
                </tr>
         
                <tr>
                    <th>属性配置：</th>
                    <td>
                        <input type="checkbox" value="1" ${props.isPublic ? 'checked':''} name="attributeConfigs">推荐&nbsp;&nbsp;
                        <input type="checkbox" value="2" ${props.isContinuousClick ? 'checked':''} name="attributeConfigs">可连击&nbsp;&nbsp;
                        <input type="checkbox" value="4" ${props.isNotifyAll ? 'checked':''} name="attributeConfigs">可通知所有人&nbsp;&nbsp;
                    </td>
                </tr>
                <tr>
                    <th><b style="color: red">*</b>状态：</th>
                    <td>
                        <select name="flag" class="span2">
                            <option value="1">上线</option>
                            <option value="2" <c:if test="${2 eq props.flag}">selected</c:if>>下线</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th>描述：</th>
                    <td><textarea name="ext" placeholder="请输入0-200字符" style="width: 360px; height: 80px" onchange="this.value=this.value.substring(0, 200)"
                                  onkeydown="this.value=this.value.substring(0, 200);"
                                  onkeyup="this.value=this.value.substring(0, 200);">${props.ext}</textarea></td>
                </tr>
            </table>
        </form>
    </div>
</div>
<script type="text/javascript">
    $("select[name=businessId]").val('${props.businessId}');
    $(function () {
        parent.$.messager.progress('close');

        init();
        //initConfig();
        disabledComponent();

        /**
         * 表单验证
         */
        $('#form').form({
            url: '/props/props_edit',
            onSubmit: function () {
                parent.$.messager.progress({
                    title: '${internationalConfig.提示}',
                    text: '${internationalConfig.数据处理中}....'
                });
                var isValid = $(this).form('validate');

                var errorMsg = validateConfig();
                if(errorMsg) {
                    parent.$.messager.alert('${internationalConfig.错误}', errorMsg, 'error');
                    parent.$.messager.progress('close');
                    return false;
                }

                if (!isValid) {
                    parent.$.messager.progress('close');
                }

           

                return isValid;
            },
            success: function (result) {
                parent.$.messager.progress('close');
                result = $.parseJSON(result);
                if (result.code == 0) {
                    parent.$.messager.alert('${internationalConfig.成功}', '保存成功', 'success');
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                } else {
                    parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
                }
            }
        });
    });

    function init() {
        //初始化业务线
        var businessId = $("select[name=businessId]");
        <c:if test="${props.businessId > 0}">
        businessId.val('${props.businessId}');
        </c:if>
        businessId.trigger("change");

        //初始化渠道
        var channelId = $("select[name=channelId]");
        <c:if test="${props.channelId > 0}">
        channelId.val('${props.channelId}');
        </c:if>
        channelId.trigger("change");

        //初始化分类
        var typeId = $("select[name=typeId]");
        <c:if test="${props.typeId > 0}">
        typeId.val('${props.typeId}');
        </c:if>

      

        //初始化单位
        <c:if test="${props.unitId > 0}">
        $("select[name=unitId]").val('${props.unitId}');
        </c:if>
    }

    function disabledComponent() {
        if ('${props.id}' && ${props.id} > 0) {
            $("#businessId").attr("readonly", "readonly");
            $("#businessId").attr("onfocus", "this.defaultIndex=this.selectedIndex");
            $("#businessId").attr("onchange", "this.selectedIndex=this.defaultIndex");
        }
    }

    function validateConfig() {
        var msg = '';
        var codeName = $("input[name='codeName']").val();
        if (codeName != $.trim(codeName)) {
            return "道具名称不能为空或包含前后空格";
        }

        var name = $("input[name='name']").val();
        if (name != $.trim(name)) {
            return "显示名称不能为空或包含前后空格";
        }

        /*var isChecked = false;
        $("input[name='config']:checked").each(function(i, e) {
            if (e.value == 'mobile') {
                isChecked = true;
                var mobilePic = $("input[name='mobilePic']").val();
                if (!mobilePic) {
                    msg = "请输入[移动端]图片信息";
                    return false;
                }
            } else if (e.value == 'web') {
                isChecked = true;
                var webPic = $("input[name='webPic']").val();
                if (!webPic) {
                    msg = "请输入[PC端和M站]图片信息";
                    return false;
                }
            } else if (e.value == 'tv') {
                isChecked = true;
                var tvPic = $("input[name='tvPic']").val();
                if (!tvPic) {
                    msg = "请输入[TV端]图片信息";
                    return false;
                }
            }

        });*/

        if (msg) {
            return msg;
        }

        var mobilePic = $("input[name='mobilePic']").val();
        var webPic = $("input[name='webPic']").val();
        var tvPic = $("input[name='tvPic']").val();

        if (!mobilePic && !webPic && !tvPic) {
            return "请至少勾选一项道具配置";
        }
    }

    /*function initConfig() {
        if ('${config.mobile}' != 'null' && '${config.mobile.pic}') {
            var a = $("input[name='config'][value='mobile']").val();
            $("input[name='config'][value='mobile']").prop('checked', true);
        }
        if ('${config.web}' != 'null' && '${config.web.pic}') {
            $("input[name='config'][value='web']").prop('checked', true);
        }
        if ('${config.tv}' != 'null' && '${config.tv.pic}') {
            $("input[name='config'][value='tv']").prop('checked', true);
        }
    }*/

    /**
     * 验证道具名称是否可用
     */
    function validateCodeName(){
        $("#validateInfo").css({display:"none"}).html("");
        var codeName = $("input[name='codeName']").val();

        if (!codeName || codeName != $.trim(codeName)) {
            $("#validateInfo").css({display:"inline"}).html("道具名不能为空或包含前后空格");
            return;
        }

        $.ajax({
            type: "POST",
            url: "/props/code_name",
            data: {"codeName": codeName},
            dataType: 'json',
            success: function(json){
                //alert(JSON.stringify(json));
                if(json.code == 0){
                    $("#validateInfo").css({display:"inline"}).html("该道具名可用");
                }
                else {
                    $("#validateInfo").css({display:"inline"}).html("该道具名不可用");
                }
            }
        });
    }



</script>
