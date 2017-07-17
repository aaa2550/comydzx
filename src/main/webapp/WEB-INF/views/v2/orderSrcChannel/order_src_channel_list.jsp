<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <title>${internationalConfig.订单来源渠道管理}</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <style>
        .searchtable{
            width: 720px;
            line-height: 40px;
        }
    </style>
</head>
<body>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false" style="height: 130px; padding-left:20px; overflow: hidden;">
        <form id="searchForm">
            <table class="searchtable" style="display: none;">
                <tr>
                    <td>${internationalConfig.渠道ID}:&nbsp;&nbsp;<input class="span2" name="id"/></td>
                    <td>${internationalConfig.别名}:&nbsp;&nbsp;<input class="span2" name="alias"/></td>
                    <td>${internationalConfig.描述}:&nbsp;&nbsp;<input class="span2" name="description"/></td>
                </tr>
                <tr>
                    <td>
                        ${internationalConfig.类型}:&nbsp;&nbsp;<select class="span2" name="type" id="type">
                            <option value="">${internationalConfig.全部}</option>
                            <option value="1">${internationalConfig.站内}</option>
                            <option value="2">${internationalConfig.站外}</option>
                        </select>
                    </td>
                    <td colspan="2">
                        ${internationalConfig.创建时间}:&nbsp;&nbsp;
                        <input type="text" name="createTimeFrom" class="easyui-datebox">
                        &nbsp;&nbsp;--&nbsp;&nbsp;
                        <input type="text" name="createTimeTo" class="easyui-datebox">
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
    <a onclick="add();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'pencil_add'">${internationalConfig.新增}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_go',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="cleanFun();">${internationalConfig.清空条件}</a>
</div>
<script src="/static/lib/date.js"></script>
<script type="text/javascript">
    var dataGrid;
    $(function () {
        dataGrid = renderDataGrid('/v2/orderSrcChannel/datagrid?' + $('#searchForm').serialize());
    });

    function renderDataGrid(url) {
        return $('#dataGrid').datagrid({
            url: url,
            fit: true,
            fitColumns: true,
            border: false,
            pagination: true,
            idField: 'id',
            pageSize: 10,
            pageList: [ 10, 20, 30, 40, 50 ],
            sortName: 'createTime',
            sortOrder: 'desc',
            checkOnSelect: false,
            selectOnCheck: false,
            nowrap: false,
            striped: true,
            rownumbers: true,
            singleSelect: true,
            remoteSort: false,
            method: 'get',
            frozenColumns: [
                []
            ],
            columns: [
                [
                    {
                        field: 'id',
                        title: '${internationalConfig.渠道ID}',
                        width: 100
                    },
                    {
                        field: 'alias',
                        title: '${internationalConfig.别名}',
                        width: 100
                    },
                    {
                        field: 'description',
                        title: '${internationalConfig.描述}',
                        width: 80
                    },
                    {
                        field: 'type',
                        title: '${internationalConfig.类型}',
                        width: 50,
                        formatter: function(value){
                            var types = {1: "${internationalConfig.站内}", 2: "${internationalConfig.站外}"};
                            return types[value];
                        }
                    },
                    {
                        field: 'createTime',
                        title: '${internationalConfig.创建时间}',
                        width: 100,
                        sortable: true,
                        formatter: function(value){
                            return value.substr(0, 10);
                        }
                    },
                    {
                        field: 'updateTime',
                        title: '${internationalConfig.更新时间}',
                        width: 100,
                        sortable: true,
                        formatter: function(value){
                            return value.substr(0, 10);
                        }
                    },
                    {
                        field: 'status',
                        title: '${internationalConfig.状态}',
                        width: 50,
                        formatter: function(value){
                            var statuses = {1: "${internationalConfig.生效}", 2: "${internationalConfig.未生效}"};
                            return statuses[value];
                        }
                    },
                    {
                        field: 'action',
                        title: '${internationalConfig.操作}',
                        width: 120,
                        formatter: function (value, row, index) {
                            var str = $.formatString('<a href="#" onclick="edit({0})">${internationalConfig.修改}<a>',row.id);
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

    function edit(id,readOnly) {
        parent.$.modalDialog({
            title:  readOnly=='Y'?'${internationalConfig.查看}':'${internationalConfig.修改}',
            width: 450,
            height: 250,
            href: '/v2/orderSrcChannel/edit?id='+id+"&readOnly="+readOnly,
            buttons: readOnly=='Y'?[
                {
                    text: '${internationalConfig.确定}',
                    handler: function () {
                        parent.$.modalDialog.handler.dialog('close');
                    }
                }
            ]:[
                {
                    text: '${internationalConfig.保存}',
                    handler: function () {
                        parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                        var f = parent.$.modalDialog.handler.find('#form');
                        f.submit();
                    }
                },
                {
                    text: '${internationalConfig.取消}',
                    handler: function () {
                        parent.$.modalDialog.handler.dialog('close');
                    }
                }
            ]
        });
    }

    function add() {
        parent.$.modalDialog({
            title: '${internationalConfig.新增}',
            width: 450,
            height: 200,
            href: '/v2/orderSrcChannel/create',
            buttons: [
                {
                    text: '${internationalConfig.保存}',
                    handler: function () {
                        parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                        var f = parent.$.modalDialog.handler.find('#form');
                        f.submit();
                    }
                },
                {
                    text: '${internationalConfig.取消}',
                    handler: function () {
                        parent.$.modalDialog.handler.dialog('close');
                    }
                }
            ]
        });
    }

    function searchFun() {
        dataGrid = renderDataGrid('/v2/orderSrcChannel/datagrid?' + $('#searchForm').serialize());
    }
    function cleanFun() {
        $('#searchForm input').val('');
        $("#status").val('');
        $("#type").val('');
        $(".easyui-datebox").datebox('setValue', '');
        dataGrid.datagrid('load', {});
    }


</script>
</body>
</html>