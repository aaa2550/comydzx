<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<script type="text/javascript">
    $(function () {
        parent.$.messager.progress('close');
        $('#form').form({
            url: '${pageContext.request.contextPath}/tj/channelStat/channel/update',
            onSubmit: function () {
                parent.$.messager.progress({
                    title: '提示',
                    text: '数据处理中，请稍后....'
                });
                var isValid = $(this).form('validate');
                if (!isValid) {
                    parent.$.messager.progress('close');
                }
                return isValid;
            },
            success: function (obj) {
                parent.$.messager.progress('close');
                var result = $.parseJSON(obj);
                if (result.code == 0) {
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');
                    //之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
                    parent.$.modalDialog.handler.dialog('close');
                } else {
                    parent.$.messager.alert('错误提示', result.msg, 'error');
                }
            }
        });

        $("#domainId").val('${channel.domainId}');
        loadModuleByChannel();
    });

    function loadModuleByChannel() {
        var domainSelect = $("#domainId");
        var domainId = domainSelect.val();
        var moduleSelect = $("#moduleId");

        $.getJSON("${pageContext.request.contextPath}/tj/channelStat/channel/module", {domainId: domainId}, function (modules) {
            var options = "";
            modules = modules['rows'];
            var size = modules.length;
            if (size > 0) {
                for (var i = 0; i < size; i++) {
                    var module = modules[i];
                    if (module['moduleId'] == '${channel.moduleId}') {
                        options += "<option value=" + module['moduleId'] + " selected>" + module['moduleName'] + "</option>";
                    } else {
                        options += "<option value=" + module['moduleId'] + ">" + module['moduleName'] + "</option>";
                    }
                }
                moduleSelect.html(options);
            } else {
                moduleSelect.html(options);

            }
        });
    }
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title="" style="overflow: hidden;">
        <form id="form" method="post" action="${pageContext.request.contextPath}/tj/channelStat/channel/update">
            <table style="margin:5px; margin-top:30px" class="table-hover table-condensed">
                <tr>
                    <th>渠道ID:</th>
                    <td><label>${channel.channelId}</label></td>
                    <td><input value="${channel.channelId}" name="channelId" type="hidden"/></td>
                </tr>
                <tr>
                    <th>渠道级别:</th>
                    <td><select id="domainId" name="domainId" title="ex:360,baidu为站外"
                                style="width: 160px" onchange="loadModuleByChannel()">
                        <option value="0">站外</option>
                        <option value="1">站内</option>
                        <option value="2">支付域</option>
                    </select></td>
                    <th>渠道类别:</th>
                    <td><select id="moduleId" name="moduleId" style="width: 160px">
                        <option value="10">站外</option>
                    </select></td>
                </tr>
                <tr></tr>
                <tr>
                    <th>渠道名称:</th>
                    <td><input type="text" name="channelName" value="${channel.channelName }" style="width: 160px"
                               class="easyui-validatebox" data-options="required:true"/></td>
                </tr>
                <tr>
                    <th>渠道参数:</th>
                    <td><input type="text" name="channelParameter" value="${channel.channelParameter }" style="width: 160px"
                               class="easyui-validatebox" data-options="required:true"/>
                        <span>(ref=xxx,前面不用带'?')</span>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>