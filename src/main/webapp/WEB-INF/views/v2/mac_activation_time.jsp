<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
</head>
<body>
    <div class="easyui-layout" data-options="fit : true,border : false">
        <div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false" style="height: 80px; overflow: hidden;">
            <form id="searchForm">
                <div style="margin-top: 10px;">
                <span style="margin:10px">MAC/IMEI</span><input name="mac" class="easyui-validatebox" data-options="required:true">
                </div>
            </form>
        </div>
        <div id="toolbar">
            <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_go',plain:true"
               onclick="searchFunc();">${internationalConfig.查询}</a>
        </div>
        <div data-options="region:'center',border:false">
            <table id="dg"></table>
        </div>
    </div>
<script>
    $(function(){
        render('mac=',false);
    });
    function searchFunc(){
        if(!$('#searchForm').form('validate'))
            return false;
        render();
    }
    function render(param){
        $('#dg').datagrid({
            url: '/macActivationTime/search',
            fit: true,
            queryParams:param?param:$.serializeObject($('#searchForm')),
            fitColumns: true,
            border: false,
            pagination: false,
            idField: 'id',
            checkOnSelect: false,
            selectOnCheck: false,
            singleSelect: true,
            nowrap: false,
            striped: true,
            rownumbers: true,
            singleSelect: true,
            toolbar: '#toolbar',
            columns: [[
                {
                    field: 'mac',
                    title: 'MAC/IMEI',
                    width: 150
                },
                {
                    field: 'activationTime',
                    title: '${internationalConfig.原始激活时间}',
                    width: 100
                },
                {
                    field: 'bossSetTime',
                    title: '${internationalConfig.新激活时间}',
                    width: 200,
                    formatter: function (value,row) {
                        if (value==undefined) value='';
                        var html = $.formatString('<form id="form{0}" method="POST">', row.mac);
                        if(row.id>0) {
                            html += $.formatString('<input type="hidden" name="id" value="{0}">', row.id);
                        }
                        html += '<div style="margin-top: 10px; margin-left: 5px; vertical-align: middle;height: 100%">';
                        html += $.formatString('<input type="hidden" name="mac" value="{0}">', row.mac);
                        html += $.formatString('<input type="text" id="mac{0}" name="bossSetTime" value="{1}" readonly="readonly" class="easyui-datetimebox" style="padding:0px">', row.mac, value);
                        html += $.formatString('&nbsp;&nbsp;<input type="button" onclick="enableEditTime(\'{0}\');" value="${internationalConfig.修改}" class="shortcut-item boss-btn">', row.mac);
                        html += $.formatString('&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" id="save{0}" onclick="update(\'{1}\')" value="${internationalConfig.保存}" class="shortcut-item boss-btn" style="display:none;padding-left:10px">', row.mac, row.mac);
                        html += '</div>';
                        html += '</form>';
                        return html;
                    }
                }, {
                    field: 'updateTime',
                    title: '${internationalConfig.最后修改时间}',
                    width: 100
                },
                {
                    field: 'operator',
                    title : '${internationalConfig.操作人}',
                    width: 80
                }]]
        });
    }
    function enableEditTime(mac){
        var input = $('#mac'+mac);
        if (input.prop('readonly')) {
            input.prop('readonly', false);
            input.datetimebox({required: true});
        }
        $('#save'+mac).show();
    }

    function update(mac){
        var form = $('#form' + mac);
        form.form(
                {
                    url: '/macActivationTime/save',
                    method: "POST",
                    onSubmit: function () {
                        if (!$(this).form('validate'))
                            return false;
                        parent.$.messager.progress({
                            title : '${internationalConfig.提示}',
                            text : '${internationalConfig.数据处理中}....'
                        });
                        return true;
                    },
                    success: function (result) {
                        parent.$.messager.progress('close');
                        result = $.parseJSON(result);
                        if (result.code == 0) {
                            //$('#mac'+mac).prop('readonly', true);
                            $('#save'+mac).hide();
                            parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.编辑成功}', 'success');
                        } else {
                            parent.$.messager.alert('${internationalConfig.错误}', result.msg, 'error');
                        }
                    }
                });
        form.submit();
    }
</script>
</body>
</html>