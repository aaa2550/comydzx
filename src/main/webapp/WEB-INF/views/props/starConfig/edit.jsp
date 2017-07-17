
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<script src="/static/lib/swfupload/swfupload.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript" src="/static/lib/uploadImgCommon.js" charset="utf-8"></script>
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
        <form id="form" method="post" action="/props/starConfig/save">
            <input type="hidden" name="id" value="${propsStarConfig.id}">
            <table style="width: 100%" class="table table-form">
                <tr>
                    <th><b style="color: red">*</b>明星名称：</th>
                    <td>
                        <input name="name" value="${propsStarConfig.name}" class="span2, easyui-validatebox" data-options="required:true">&nbsp;&nbsp;
                    </td>
                </tr>
                <tr>
                    <th><b style="color: red">*</b>头像：</th>
                    <td>
                        <input type="text" name="pic" value="${propsStarConfig.pic}" id="common_pic" class="span2, easyui-validatebox" data-options="required:true">&nbsp;&nbsp;
                        <input type="button" value="上传" id="common_upload_btn"><br>
                        格式：png， jpg，gif
                    </td>
                </tr>
                <tr>
                    <th>初始人气值：</th>
                    <td>
                        <input name="weight" value="${propsStarConfig.weight}" class="span2, easyui-validatebox">&nbsp;&nbsp;<input value="${propsStarConfig.totalPrice * 10}" placeholder="道具值" readonly class="start_noput">
                    </td>
                </tr>
                <tr>
                    <th>排序：</th>
                    <td><input name="no" value="${propsStarConfig.no}" class="span2, easyui-validatebox">数值越小的排在前面</td>
                </tr>
            </table>
        </form>
    </div>
</div>
<script type="text/javascript">
    $(function () {
        parent.$.messager.progress('close');

        /**
         * 表单验证
         */
        $('#form').form({
            url: '/props/starConfig/save',
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

    function validateConfig() {
        var msg = '';

        var name = $("input[name='name']").val();
        if (name != $.trim(name)) {
            return "名称不能为空或包含前后空格";
        }

        var pic = $("input[name='pic']").val();
        if (pic != $.trim(pic)) {
            return "图片路径不能为空或包含前后空格";
        }

        if (msg) {
            return msg;
        }

    }

    /**
     * 验证道具名称是否可用
     */
    /*function validateCodeName(){
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
    }*/

</script>
