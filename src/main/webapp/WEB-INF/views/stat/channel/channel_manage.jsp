<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>渠道管理</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script type="text/javascript">
        var dataGrid;
        $(function () {
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/xtj/channel/query');
        });

        function renderDataGrid(url) {
            return $('#dataGrid').datagrid({
                url: url,
                fit: true,
                fitColumns: false,
                border: false,
                pagination: true,
                idField: 'id',
                pageSize: 100,
                pageList: [10, 20, 50, 100],
                sortName: 'channelId',
                sortOrder: 'desc',
                checkOnSelect: false,
                selectOnCheck: false,
                nowrap: false,
                striped: true,
                rownumbers: true,
                singleSelect: true,
                remoteSort: false,
                columns: [
                    [
                        {
                            field: 'channelId',
                            title: '渠道ID',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'channelName',
                            title: '渠道名称',
                            width: 240
                        },
                        {
                            field: 'channelParameter',
                            title: '渠道参数',
                            width: 150
                        },
                        {
                            field: 'moduleId',
                            title: '渠道类别ID',
                            width: 80,
                            sortable: true
                        },
                        {
                            field: 'moduleName',
                            title: '渠道类别',
                            width: 80
                        },
                        {
                            field: 'domainName',
                            title: '渠道级别',
                            width: 80,
                            sortable: true
                        },
                        {
                            field: 'createTime',
                            title: '创建时间',
                            width: 150,
                            sortable: true
                        },
                        {
                            field: 'updateUser',
                            title: '创建人',
                            width: 100
                        },
                        {
                            field: 'action',
                            title: '操作',
                            width: 80,
                            formatter: function (value, row, index) {
                                var str = '&nbsp;&nbsp;&nbsp;';
                                str += $.formatString('<img onclick="editFun(\'{0}\');" src="{1}" title="编辑"/>', row.channelId, '/static/style/images/extjs_icons/pencil.png');
                                str += '&nbsp;&nbsp;&nbsp;';

                                str += $.formatString('<img onclick="deleteFun(\'{0}\');" src="{1}" title="删除"/>', row.channelId, '/static/style/images/extjs_icons/cancel.png');
                                return str;
                            }
                        }

                    ]
                ],
                toolbar: '#toolbar',
                onLoadSuccess: function () {
                    $('#searchForm table').show();
                    parent.$.messager.progress('close');
                },
                onRowContextMenu: function (e, rowIndex, rowData) {
                    e.preventDefault();
                    $(this).datagrid('unselectAll');
                    $(this).datagrid('selectRow', rowIndex);
                    $('#menu').menu('show', {
                        left: e.pageX,
                        top: e.pageY
                    });
                }
            });
        }

        function addFun() {
            parent.$.modalDialog({
                title: '创建渠道',
                width: 680,
                height: 300,
                href: '${pageContext.request.contextPath}/xtj/channel/channel_add',
                buttons: [
                    {
                        text: '添加',
                        handler: function () {
                            parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                            var f = parent.$.modalDialog.handler.find('#form');
                            f.submit();
                        }
                    },
                    {
                        text: "关闭",
                        handler: function () {
                            parent.$.modalDialog.handler.dialog('close');
                        }
                    }
                ]
            });
        }

        function editFun(channelId) {
            parent.$.modalDialog({
                title: '更新渠道',
                width: 680,
                height: 300,
                href: '${pageContext.request.contextPath}/xtj/channel/channel_update?channelId='+channelId,
                buttons: [
                    {
                        text: '更新',
                        handler: function () {
                            parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                            var f = parent.$.modalDialog.handler.find('#form');
                            f.submit();
                        }
                    },
                    {
                        text: "关闭",
                        handler: function () {
                            parent.$.modalDialog.handler.dialog('close');
                        }
                    }
                ]
            });
        }

        /**
         * 删除渠道
         * @param channelId
         */
        function deleteFun(channelId) {
            parent.$.messager.confirm('询问', '您是否要删除此信息？', function (b) {
                if (b) {
                    parent.$.messager.progress({
                        title: '提示',
                        text: '数据处理中，请稍后....'
                    });
                    $.post('${pageContext.request.contextPath}/xtj/channel/delete', {
                            channelId: channelId},
                        function (result) {
                            if (result.code == 0) {
                                parent.$.messager.alert('提示', result.msg, 'INFO');
                                dataGrid.datagrid('reload');
                            } else {
                                parent.$.messager.alert('提示', result.msg, 'ERROR');
                            }
                            parent.$.messager.progress('close');
                        }, 'JSON');
                }
            });
        }

        function searchFun() {
            renderDataGrid('${pageContext.request.contextPath}/xtj/channel/query?' + $("#searchForm").serialize());
        }
        function cleanFun() {
            $('#searchForm input').val('');
            dataGrid.datagrid('load', {});
        }

        function loadModuleByDomain() {
            var domainSelect = $("#domainId");
            var domainId = domainSelect.val();
            var moduleSelect = $("#moduleId");

            $.getJSON("${pageContext.request.contextPath}/tj/channelStat/channel/module", {domainId: domainId}, function (modules) {
                var options = "";
                modules = modules['rows'];
                var size = modules.length;
                if (size > 0) {
                    options += "<option value=''>全部</option>";
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
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false"
         style="height: 120px; overflow: auto;">
        <form id="searchForm" method="post">
            <table class="table table-hover table-condensed">
                <tr>
                    <td>渠道级别</td>
                    <td>渠道类别</td>
                    <td></td>
                </tr>
                <tr>
                    <td><select id="domainId" name="domainId" title="ex:360,baidu为站外"
                                style="width: 160px" onchange="loadModuleByDomain()">
                        <option value="" selected>全部</option>
                        <option value="1">站内</option>
                        <option value="0">站外</option>
                        <option value="2">支付域</option>
                    </select>
                    </td>
                    <td><select id="moduleId" name="moduleId" style="width: 160px">
                        <option value="" selected>全部</option>
                    </select>
                    </td>
                    <td></td>
                    <td></td>
                </tr>
            </table>
        </form>
    </div>
    <div data-options="region:'center',border:false">
        <table id="dataGrid"></table>
    </div>
</div>
<div id="toolbar" style="display: none;">
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a>
    <a onclick="addFun();" href="javascript:void(0);"
       class="easyui-linkbutton" data-options="plain:true,iconCls:'pencil_add'">创建渠道</a>
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">刷新</a>
</div>

</body>
</html>