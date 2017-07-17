<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>${internationalConfig.PGC渠道代码}</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script type="text/javascript" src="/js/dict.js" charset="utf-8"></script>
    <script type="text/javascript">
        var dataGrid;
        $(function () {

            dataGrid = $('#dataGrid').datagrid({
                url: '/pgc_channel/search',
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
                    field: 'id',
                    title: 'id',
                    width: 30
                }, {
                    field: 'channelCode',
                    title: '${internationalConfig.渠道代码}',
                    width: 30
                }, {
                    field: 'remark',
                    title: '${internationalConfig.备注}',
                    width: 150
                }, {
                    field: 'updateTime',
                    title: '${internationalConfig.更新时间}',
                    width: 250
                }, {
                    field: 'status',
                    title: '${internationalConfig.状态}',
                    width: 250,
                    formatter: function (value, row, index) {
                        return value == 0 ? '${internationalConfig.使用}' : '${internationalConfig.不使用}';
                    }
                }, {
                    field: 'status',
                    title: '${internationalConfig.操作}',
                    width: 100,
                    formatter: function (value, row, index) {
                        return $.formatString("<a href='javascript:void(0);' onclick='updateFun({0},{1})' class='easyui-linkbutton' data-options='iconCls:brick_delete,plain:true'>${internationalConfig.修改}</a>", row.id,value);
                    }
                }]],
                toolbar: '#toolbar',
                onLoadSuccess: function () {
                    $('#searchForm table').show();
                    parent.$.messager.progress('close');
                }
            });
        });

        function updateFun(id,status) {
            $.get('${pageContext.request.contextPath}/pgc_channel/update?id=' + id, {status:status}, function (result) {
                if (result.code == 0) {
                    dataGrid.datagrid('reload');
                }
            }, 'JSON');
        }

        function searchFun() {
            dataGrid.datagrid({
                url: '/pgc_channel/search',
                queryParams: $.serializeObject($('#searchForm'))
            });
        }


        function cleanFun() {
            $('#searchForm input').val('');
            $('#searchForm select').val('0');
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
                    <td>${internationalConfig.渠道代码}：<input name="channelCode"/></td>
                    <td>${internationalConfig.备注}：<input name="remark"/></td>
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
       onclick="searchFun();">${internationalConfig.查询}</a><a href="javascript:void(0);" class="easyui-linkbutton"
                                         data-options="iconCls:'brick_delete',plain:true" onclick="cleanFun();">${internationalConfig.清空条件}</a>
</div>

</body>
</html>