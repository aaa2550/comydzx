<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>收入来源渠道管理</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script type="text/javascript">
        var dataGrid;
        $(function () {
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/income_channel/data_grid.json');
        });

        function renderDataGrid(url) {
            return $('#dataGrid').datagrid({
                url: url,
                fit: true,
                fitColumns: false,
                border: false,
                pagination: true,
                idField: 'id',
                pageSize: 10,
                pageList: [ 10, 20, 30, 40, 50 ],
                sortName: 'updateTime',
                sortOrder: 'desc',
                checkOnSelect: false,
                selectOnCheck: false,
                nowrap: false,
                striped: true,
                rownumbers: true,
                singleSelect: true,
                remoteSort: false,
                frozenColumns: [
                    [
                        {
                            field: 'id',
                            title: '编号',
                            width: 150,
                            hidden: true
                        }
                    ]
                ],
                columns: [
                    [
                        {
                            field: 'channelName',
                            title: '渠道',
                            width: 100,
                            sortable: true
                        },
                        {
                            field: 'updateTime',
                            title: '更新时间',
                            width: 150,
                            sortable: true
                        },
                        {
                            field: 'status',
                            title: '状态',
                            width: 100,
                            formatter: function (data) {
                                if (data == 0) {
                                    return "正常"
                                } else if (data == 1) {
                                    return "失效"
                                } else {
                                    return "未知"
                                }
                            }
                        },
                        {
                            field: "modules",
                            title: "模块列表",
                            formatter: function (data) {
                                var linkArray = $.map(data, function (element) {
                                    return $.formatString('<a onclick="editModule({0});">{1}</a>', element["id"], element["moduleName"])
                                });

                                return  linkArray.join("; ")
                            }
                        },
                        {
                            field: 'action',
                            title: '操作',
                            width: 100,
                            formatter: function (value, row, index) {
                                var str = '&nbsp;&nbsp;&nbsp;';
                                str += $.formatString('<a onclick="editFun(\'{0}\');">编辑</a>', row.id);
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

        function editModule(moduleid) {
            parent.$.modalDialog({
                title: '更新模块',
                width: 680,
                height: 300,
                href: '${pageContext.request.contextPath}/income_channel/module/edit.json?moduleId=' + moduleid,
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

        function addFun() {
            parent.$.modalDialog({
                title: '创建渠道',
                width: 680,
                height: 300,
                href: '${pageContext.request.contextPath}/income_channel/add.json',
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

        function editFun(channelid) {
            parent.$.modalDialog({
                title: '更新渠道',
                width: 700,
                height: 350,
                href: '${pageContext.request.contextPath}/income_channel/edit.json?channelId=' + channelid,
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

        function searchFun() {
        	dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
        }
        function cleanFun() {
            $('#searchForm input').val('');
            dataGrid.datagrid('load', {});
        }


    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false"
         style="height: 80px; overflow: auto;">
        <form id="searchForm">
            <table class="table-td-two"
                   style="display: none;">
                <tr>
                    <td>渠道名称：<input id="channelName" name="channelName" class="span2">
                    </td>
                </tr>
            </table>
        </form>
    </div>
    <div data-options="region:'center',border:false">
        <table id="dataGrid"></table>
    </div>
</div>
<div id="toolbar" style="display: none;">
    <a onclick="addFun();" href="javascript:void(0);"
       class="easyui-linkbutton" data-options="plain:true,iconCls:'bug_add'">创建渠道</a>
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a><a
        href="javascript:void(0);" class="easyui-linkbutton"
        data-options="iconCls:'brick_delete',plain:true"
        onclick="cleanFun();">清空条件</a>
</div>


</body>
</html>