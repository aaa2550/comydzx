<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:if test="${not empty param.singlePage}">
    <%@ include file="/WEB-INF/views/inc/head.inc"%>
</c:if>
<c:choose>
    <c:when test="${not empty channel}">
        <c:set var="action" value="edit"/>
    </c:when><c:otherwise>
        <c:set var="action" value="create"/>
    </c:otherwise>
</c:choose>

<style>
    .main_table{
        width: 90%;
        margin:10px 0 10px 10px;
        line-height: 40px;
        overflow: hidden;
    }
    .title-span{
        width: 40px;
        margin-left: 5px;
        margin-right: 5px;
    }
    select {
        width: 126px;
    }
</style>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title="">
        <form id="form" method="post" name = "activityForm" action="/v2/orderSrcChannel/save">
            <table class="main_table">
                <c:if test="${not empty channel}">
                 <tr>
                    <td colspan="2">
                        <span class="title-span">${internationalConfig.渠道ID}</span>
                        <input name="id" value="${channel.id}" readonly="readonly">
                    </td>
                  </tr>
                </c:if>
                <tr>
                    <td>
                        <span class="title-span">${internationalConfig.别名}</span>
                        <input name="alias" value="${channel.alias}" class="span2 easyui-validatebox" <c:choose><c:when test="${not empty channel}">readonly=readonly</c:when><c:otherwise>data-options="required:true" onchange="checkAlias(this)"</c:otherwise></c:choose>>
                    </td>
                    <td>
                        <span class="title-span">${internationalConfig.描述}</span>
                        <input name="description" value="${channel.description}" class="span2 easyui-validatebox" data-options="required:true" onchange="trimInput(this)">
                    </td>
                </tr>
                <tr>
                    <td>
                        <span class="title-span">${internationalConfig.类型}</span>
                        <select name="type" class="easyui-validatebox" data-options="required:true">
                            <option value="">${internationalConfig.请选择}</option>
                            <option value="1" <c:if test="${channel.type==1}">selected</c:if>>${internationalConfig.站内}</option>
                            <option value="2" <c:if test="${channel.type==2}">selected</c:if>>${internationalConfig.站外}</option>
                        </select>
                    </td>
                    <td>
                        <span class="title-span">${internationalConfig.状态}</span>
                        <select name="status" class="easyui-validatebox" data-options="required:true">
                            <option value="">${internationalConfig.请选择}</option>
                            <option value="1" <c:if test="${channel.status==1}">selected</c:if>>${internationalConfig.生效}</option>
                            <option value="2" <c:if test="${channel.status==2}">selected</c:if>>${internationalConfig.未生效}</option>
                        </select>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>
<script>
    $(document).ready(function() {
        parent.$.messager.progress('close');
    });
    (function onSubmit() {
        $('#form').form({
            url : '/v2/orderSrcChannel/save',
            method: "POST",
            onSubmit : function() {
                var isValid = $(this).form('validate');
                if (!isValid)
                    return isValid;
                parent.$.messager.progress({
                    title : "${internationalConfig.提示}",
                    text : "${internationalConfig.数据处理中}"
                });
                return isValid;
            },
            success : function(result) {
                parent.$.messager.progress('close');
                result = $.parseJSON(result);
                if (result.code == 0) {
                    parent.$.messager.alert("${internationalConfig.成功}", '${action}'=='create'?'${internationalConfig.创建成功}':'${internationalConfig.编辑成功}', 'success');
                    parent.$.modalDialog.handler.dialog('close');
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');
                } else {
                    parent.$.messager.alert("${internationalConfig.错误}", result.msg, 'error');
                }
            },
            error: function(result){
                parent.$.messager.progress('close');
                parent.$.messager.alert("${internationalConfig.错误}", result, 'error');
            }
        });
    })();
    function checkAlias(input){
        var input = $(input);
        var value = $.trim(input.val());
        input.val(value);
        if (value !== '') {
            var url = '/v2/orderSrcChannel/check_alias_existence';
            var data = {alias: value, <c:if test="${not empty channel}">id:'${channel.id}'</c:if>};
            $.getJSON(url, data, function(result){
                if (result.code != 0) {
                    parent.$.messager.alert("${internationalConfig.错误}", result.msg, 'error');
                }
            });
        }
    }
    function trimInput(input) {
        var input = $(input);
        var value = $.trim(input.val());
        input.val(value);
    }
</script>