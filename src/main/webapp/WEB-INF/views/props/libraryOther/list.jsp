<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>第三方道具池管理</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script  src="/js/kv/propsBusiness.js"></script>
    <script  src="/js/kv/propsChannel.js"></script>
    <style type="text/css">
        a.propsOperation:link, a.propsOperation:visited {
            border-right: 1px solid grey;
            padding-right: 5px;
            padding-left: 5px;
            text-decoration: none;
            color: black;
        }
        a.propsOperation:hover{
            color: #8888FF;
            text-decoration: underline;
        }
        img.configImg {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            border: 1px solid #CCCCCC;
        }
    </style>
    <script type="text/javascript">
        var dataGrid;
        $(function () {
            dataGrid = renderDataGrid('/props/libraryOther/query');

            init();
        });

        function init() {
            $("[name='businessId']").trigger("change");
        }

        function renderDataGrid(url) {
            return $('#dataGrid').datagrid({
                url: url,
                fit: true,
                fitColumns: false,
                border: false,
                pagination: true,
                idField: 'otherId',
                pageSize: 10,
                pageList: [10, 20, 30, 40, 50],
                sortName: 'updateTime',
                sortOrder: 'desc',
                checkOnSelect: false,
                selectOnCheck: false,
                nowrap: false,
                striped: true,
                rownumbers: true,
                singleSelect: false,
                remoteSort: false,
                columns: [
                    [

                        {
                            field: 'otherId',
                            title: '第三方ID',
                            width: 100,
                            sortable: true
                        },

                        {
                            field: 'name',
                            title: '显示名称',
                            width: 100
                        },
                        {
                            field: 'nameescribe',
                            title: '名称描述',
                            width: 100

                        },

                        {
                            field: 'price',
                            title: '单价',
                            width: 80
                        },

                        {
                            field: 'updateTime',
                            title: '操作时间',
                            width: 150,
                            sortable: true
                        },
                        {
                            field: 'action',
                            title: '操作',
                            width: 200,
                            formatter: function (value, row, index) {
                                var str = $.formatString("<a href='javascript:void(0);' onclick='editLibraryOther({0},{1} ,\"{2}\")' class='propsOperation'>编辑道具</a>", row.otherId,row.source, '编辑道具');
                                return str;
                            }
                        }
                    ]
                ],
                toolbar: '#toolbar',
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

        /**
         * 查询
         */
        function searchFun() {
            dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
        }

        /**
         * 清空
         */
        function cleanFun() {
            $('#searchForm input').val('');
            dataGrid.datagrid('load', {});
        }

        /**
         * 添加修改
         */
        function editLibraryOther(id,source, title) {
            parent.$.modalDialog({
                title: title,
                width: 750,
                height: 500,
                href: '/props/libraryOther/edit?otherId='+id+"&source="+source,
                buttons: [
                   /** {
                        text: '暂存',
                        handler: function () {
                            parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                            var f = parent.$.modalDialog.handler.find('#form');
                            f.attr("action", "/props/libraryOther/save");
                            f.submit();
                        }
                    }, ***/
                    {
                        text: '保存到道具库',
                        handler: function () {
                            parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                            var f = parent.$.modalDialog.handler.find('#form');
                            f.attr("action", "/props/libraryOther/publish");
                            f.submit();
                        }
                    },
                    {
                        text: '取消',
                        handler: function () {
                            parent.$.modalDialog.handler.dialog('close');
                        }
                    }
                ]
            });
        }

    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false" style="overflow: hidden; height: 145px">
        <form id="searchForm">
            <table class="table-more">
                <tr>
                    <td>
                        操作时间：
                        <input class="easyui-datebox" name="startTime" style="width: 150px">&nbsp;&nbsp;
                        <input class="easyui-datebox" name="updateTime" style="width: 150px">
                    </td>

                </tr>
                <tr>
                    <td>
                        道具名称：<input name="name" style="width: 310px" class="span2">
                    </td>
                    <td>
                        来源：
                        <select name="source" class="span2">
                            <option value="0">全部</option>
                            <option value="1">斗鱼</option>
                        </select>
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
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a><a
        href="javascript:void(0);" class="easyui-linkbutton"
        data-options="iconCls:'brick_delete',plain:true"
        onclick="cleanFun();">清空条件</a>
    <a onclick="cleanFun();" href="javascript:void(0);"
       class="easyui-linkbutton" data-options="plain:true,iconCls:'pencil_add'">同步第三方道具</a>
</div>


</body>
</html>