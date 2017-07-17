<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>${internationalConfig.PriceMovieManage}</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
<script type="text/javascript"  src="/js/dict.js"></script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false" style="height: 120px; overflow: hidden;">
        <form id="searchForm">
            <table class="table-td-four" style="display: none;">
                <tr>
                    <td>${internationalConfig.Channel名称}：<input name="channelName" class="span2"/></td>
                    <td>Channel ID：<input name="channelId" class="span2"/></td>
                    <td>${internationalConfig.收费状态}：
                        <select name="isPay" class="span2">
                            <option value="-1">${internationalConfig.全部}</option>
                            <option value="0">${internationalConfig.免费}</option>
                            <option value="1" selected="selected">${internationalConfig.付费}</option>
                        </select>
                    </td>
                    <td>${internationalConfig.发布状态}：
                        <select name="status" class="span2">
                            <option value="0" selected>${internationalConfig.全部}</option>
                            <option value="1">${internationalConfig.未发布}</option>
                            <option value="3">${internationalConfig.已发布}</option>
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
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true"
       onclick="searchFun();">${internationalConfig.查询}</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true"
       onclick="cleanFun();">${internationalConfig.清空条件}</a>
</div>

</body>
<script type="text/javascript">
    var dataGrid;
    $(function () {
        dataGrid = $('#dataGrid').datagrid({
            url: '/v2/product/live_channel/data_grid',
            fit: true,
            fitColumns: true,
            border: false,
            queryParams:$.serializeObject($('#searchForm')),
            pagination: true,
            idField: 'channelId',
            pageSize: 20,
            pageList: [10, 20, 30, 40, 50],
            sortName: 'updateTime',
            sortOrder: 'desc',
            checkOnSelect: false,
            selectOnCheck: false,
            singleSelect: true,
            nowrap: false,
            striped: true,
            rownumbers: true,
            singleSelect: true,
            frozenColumns: [
                [
                    {
                        field: 'id',
                        title: '${internationalConfig.序号}',
                        width: 50,
                        hidden: true
                    }
                ]
            ],
            columns: [[
                {
                    field: 'channelName',
                    title: '${internationalConfig.Channel名称}',
                    width: 80
                },
                {
                    field: 'channelId',
                    title: '${internationalConfig.ChannelID}',
                    width: 100
                },
                {
                    field: 'isPay',
                    title: '${internationalConfig.收费状态}',
                    width: 100,
                    formatter: function (value) {
                        var str = '';
                        if("0" == value) {
                            str = "${internationalConfig.免费}";
                        }else if("1" == value) {
                            str = "${internationalConfig.付费}";
                        }
                        return str;
                    }
                },
                {
                    field: 'status',
                    title: '${internationalConfig.发布状态}',
                    width: 150,
                    formatter: function (value) {
                        var str = '';
                        if("1" == value) {
                            str = "${internationalConfig.未发布}";
                        }else if("3" == value) {
                            str = "${internationalConfig.已发布}";
                        }
                        return str;
                    }
                },
                {
                    field: 'updateTime',
                    title: '${internationalConfig.更新时间}',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'action',
                    title: '${internationalConfig.操作}',
                    width: 80,
                    formatter: function (value, row, index) {
                        var str = $.formatString('<img onclick="editFun(\'{0}\');" src="{1}" title="${internationalConfig.编辑}"/>', row.channelId, '/static/style/images/extjs_icons/pencil.png');
                        return str;
                    }
                }]],
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
    });

    //编辑信息
    function editFun(id) {
        if (id == undefined) {
            var rows = dataGrid.datagrid('getSelections');
            id = rows[0].channelId;
            alert(id);
        }
        parent.$.modalDialog({
            title: '${internationalConfig.编辑Channel}',
            width: 800,
            height: 550,
            resizable: true,
            href: '/v2/product/live_channel/update/' + id,
            buttons: [{
                text: '${internationalConfig.保存}',
                handler: function () {
                    parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                    var f = parent.$.modalDialog.handler.find('#form');
                    f.submit();
                }
            }, {
                text: "${internationalConfig.关闭}",
                handler: function () {
                    parent.$.modalDialog.handler.dialog('close');
                }
            }]
        });
    }


    function searchFun() {
        dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
    }
    function cleanFun() {
        $('#searchForm input').val('');
        $('#searchForm select').val('0');
        dataGrid.datagrid('load', {});
    }
</script>
</html>