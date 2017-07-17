<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>数据修复</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script type="text/javascript">
        var dataGrid;
        $(function () {
            dataGrid = $('#dataGrid').datagrid({
                url: '/repair/search',
                fit: true,
                fitColumns: true,
                border: false,
                pagination: true,
                idField: 'id',
                pageSize: 10,
                pageList: [10, 20, 30, 40, 50],
                checkOnSelect: false,
                selectOnCheck: false,
                singleSelect: true,
                nowrap: false,
                rownumbers: true,
                sortName: 'id',
                sortOrder: 'desc',
                frozenColumns: [
                    [
                        {
                            field: 'id',
                            title: '${internationalConfig.编号}',
                            width: 50,
                            hidden: true
                        }
                    ]
                ],
                columns: [[{
                    field: 'ruleId',
                    title: '${internationalConfig.规则ID}',
                    width: 200
                }, {
                    field: 'cid',
                    title: 'cid',
                    width: 200
                }, {
                    field: 'albumId',
                    title: '${internationalConfig.专辑ID}',
                    width: 200,
                    formatter: function (value, row, index) {
                        return value == '0' ? '' : value;
                    }
                }, {
                    field: 'memberType',
                    title: '${internationalConfig.会员类型}',
                    width: 100
                }, {
                    field: 'configType',
                    title: '${internationalConfig.分成类型}',
                    width: 200,
                    formatter: function (value, row, index) {
                        var str = '';
                        if (value == 1) {
                            str = '${internationalConfig.付费分成}';
                        } else if (value == 2) {
                            str = '${internationalConfig.CPM分成}';
                        } else if (value == 3) {
                            str = '${internationalConfig.播放分成}';
                        } else if (value == 4) {
                            str = '${internationalConfig.累计时长分成}';
                        } else if (value == 5) {
                            str = '${internationalConfig.会员订单分成}';
                        } else if (value == 6) {
                            str = '${internationalConfig.业务订单分成}';
                        } else {
                            str = '${internationalConfig.其它}';
                        }
                        return str;
                    }
                }, {
                    field: 'startTime',
                    title: '${internationalConfig.开始时间}',
                    width: 200
                }, {
                    field: 'endTime',
                    title: '${internationalConfig.结束时间}',
                    width: 200
                }, {
                    field: 'progressTime',
                    title: '进度日期',
                    width: 200
                }, {
                    field: 'status',
                    title: '执行状态',
                    width: 200,
                    formatter: function (value, row, index) {
                        var str = '';
                        if (value == 0) {
                            str = '待执行';
                        } else if (value == 1) {
                            str = '准备中';
                        } else if (value == 2) {
                            str = '处理中';
                        } else if (value == 3) {
                            str = '执行完毕';
                        } else {
                            str = '${internationalConfig.未知}';
                        }
                        return str;
                    }
                }, {
                    field: 'remark',
                    title: '详情',
                    width: 200
                }, {
                    field: 'action',
                    title: '操作',
                    width: 200,
                    formatter: function (value, row, index) {
                        var str = '';
                        if (row.status == 0) {
                            str = "<a onclick='doRepairFun("+row.id+");' href='javascript:void(0);' class='easyui-linkbutton' data-options='plain:true,iconCls:'pencil_add''>执行</a>";
                        } else{
                            str = '--';
                        }
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

            var t1 = window.setInterval(searchFun,5000);

        });


        function saveFun(updateId) {
            parent.$.modalDialog({
                title: '数据修复',
                width: 520,
                height: 300,
                href: '/repair/save?id=' + updateId,
                buttons: [{
                    text: '${internationalConfig.提交}',
                    handler: function () {
                        parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                        var f = parent.$.modalDialog.handler.find('#form');
                        f.submit();
                    }
                }]
            });
        }

        function doRepairFun(id) {
            $.get('/repair/doRepair?id=' + id);
            searchFun();
        }

        function searchFun() {
            dataGrid.datagrid({
                url: '/repair/search',
                queryParams: $.serializeObject($('#searchForm'))
            });
        }


        function cleanFun() {
            $('#searchForm input').val('');
            $('#searchForm select').val('');
            dataGrid.datagrid('load', {});
        }


    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false" style="height: 120px; overflow: hidden;">
        <form id="searchForm">
            <table class="table-more">
                <tr>
                    <td>${internationalConfig.分成类型}：
                        <select name="configType">
                            <option value="">${internationalConfig.全部}</option>
                            <option value="1">${internationalConfig.付费分成}</option>
                            <option value="2">${internationalConfig.CPM分成}</option>
                            <option value="3">${internationalConfig.播放分成}</option>
                            <option value="4">${internationalConfig.累计时长分成}</option>
                            <option value="5">${internationalConfig.会员订单分成}</option>
                            <option value="6">${internationalConfig.业务订单分成}</option>
                        </select>
                    </td>
                    <td>${internationalConfig.状态}：<select name="status">
                        <option value="">${internationalConfig.全部}</option>
                        <option value="0">待执行</option>
                        <option value="1">处理中</option>
                        <option value="2">执行完毕</option>
                    </select></td>
                </tr>
                <tr>
                    <td>规则ID ：<input name="ruleId" class="span2"/></td>
                    <td>${internationalConfig.专辑ID} ：<input name="albumId" class="span2"/></td>
                    <td>会员类型 ：<input name="memberType" class="span2"/></td>
                </tr>
            </table>
        </form>
    </div>
    <div data-options="region:'center',border:false">
        <table id="dataGrid"></table>
    </div>
</div>
<div id="toolbar" style="display: none;">

    <a onclick="saveFun(0);" href="javascript:void(0);" class="easyui-linkbutton"
       data-options="plain:true,iconCls:'pencil_add'">${internationalConfig.添加}</a>


    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true"
       onclick="searchFun();">${internationalConfig.查询}</a><a href="javascript:void(0);" class="easyui-linkbutton"
                                         data-options="iconCls:'brick_delete',plain:true" onclick="cleanFun();">${internationalConfig.清空条件}</a>
</div>

</body>
</html>