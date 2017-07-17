
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<%@ include file="/WEB-INF/views/inc/jstl.inc"%>
<script  src="/js/kv/propsBusiness.js"></script>
<script  src="/js/kv/propsChannel.js"></script>
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
        <form id="form" method="post" action="/props/type/save">
            <input type="hidden" name="id" value="${propsType.id}">
            <table style="width: 100%" class="table table-form">
                <tr>
                    <th><b style="color: red">*</b>分类名称：</th>
                    <td>
                        <input name="name" value="${propsType.name}" class="span2, easyui-validatebox" data-options="required:true">&nbsp;&nbsp;
                    </td>
                </tr>
                <tr>
                    <th><b style="color: red">*</b>业务线：</th>
                    <td>
                        <%@ include file="/WEB-INF/views/inc/props_business.inc" %>
                        <%@ include file="/WEB-INF/views/inc/props_channel.inc" %>
                    </td>
                </tr>
                <tr>
                    <th>排序：</th>
                    <td><input name="no" value="${propsType.no}" class="span2, easyui-validatebox">数值越小的排在前面</td>
                </tr>
            </table>
        </form>
    </div>
</div>
<script type="text/javascript">
    $(function () {
        parent.$.messager.progress('close');

        init();
        /**
         * 表单验证
         */
        $('#form').form({
            url: '/props/type/save',
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
        $("[name='businessId']").trigger("change");
    }

    function validateConfig() {
        var msg = '';

        var name = $("input[name='name']").val();
        if (name != $.trim(name)) {
            return "名称不能为空或包含前后空格";
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
