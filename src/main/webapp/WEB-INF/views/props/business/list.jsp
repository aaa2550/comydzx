<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>道具业务线管理</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
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
            dataGrid = renderDataGrid('/props/business/query');
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
                pageList: [10, 20, 30, 40, 50],
                sortName: 'id',
                sortOrder: 'asc',
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
                            field: 'id',
                            title: 'ID',
                            width: 60
                        },
                        {
                            field: 'name',
                            title: '业务线名称',
                            width: 100
                        },
                        {
                            field: 'secret',
                            title: '业务线KEY（内部）',
                            width: 200
                        },
                        {
                            field: 'ext',
                            title: '说明',
                            width: 250
                        },
                        {
                            field: 'action',
                            title: '操作',
                            width: 200,
                            formatter: function (value, row, index) {
                                var str = $.formatString("<a href='javascript:void(0);' onclick='editBusiness({0}, \"{1}\")' class='propsOperation'>修改</a>", row.id, '修改业务线');
                                /*str += $.formatString("<a href='javascript:void(0);' onclick='delBusiness({0})' class='propsOperation'>删除</a>", row.id);*/
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
         * 添加修改业务线
         */
        function editBusiness(id, title) {
            parent.$.modalDialog({
                title: title,
                width: 500,
                height: 300,
                href: '${pageContext.request.contextPath}/props/business/edit?id='+id,
                buttons: [
                    {
                        text: '保存',
                        handler: function () {
                            parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                            var f = parent.$.modalDialog.handler.find('#form');
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

        /**
         * 删除
         */
        function delBusiness(id){
            $.messager.confirm("询问", "确认删除业务线吗？", function(b){
                if(!b) return;
                $.post('/props/business/delete', {id: id},
                        function(json){
                            if(json.code == 0){
                                $.messager.alert("删除业务线", "删除业务线成功！");
                                dataGrid.datagrid('load', {});
                            } else {
                                $.messager.alert("删除业务线", json.msg);
                            }
                        }, "json"
                );
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
                        业务线名称：<input name="name" style="width: 310px" class="span2">
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
    <a onclick="editBusiness(0, '添加业务线');" href="javascript:void(0);"
       class="easyui-linkbutton" data-options="plain:true,iconCls:'pencil_add'">添加业务线</a>
</div>


</body>
</html>