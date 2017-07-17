<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>超级手机激活统计</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/highcharts.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/exporting.js" type="text/javascript"></script>
    <script type="text/javascript">
        var dataGrid;
        $(function () {
            parent.$.messager.progress('close');
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/letvPhoneStat/activeStat/dataGrid');
        });

        function renderDataGrid(url) {
            return $('#dataGrid').bossDataGrid({
                url: url,
                idField: 'channelId',
                sortName: 'onlineCount',
                sortOrder: 'desc',
                queryParams: {
                    beginDate: $("#queryBegin").val(),
                    endDate: $("#queryEnd").val()
                },
                columns: [
                    {
                        field: 'onlineCount',
                        title: '线上裸机销售量',
                        width: 130,
                        sortable: true
                    },
                    {
                        field: 'onlineVipCount',
                        title: '线上会员机销售量',
                        width: 130,
                        sortable: true
                    },
                    {
                        field: 'activeCount',
                        title: '线上会员机激活量',
                        width: 130,
                        sortable: true
                    },
                    {
                        field: 'activeRate',
                        title: '线上会员机激活率',
                        width: 130,
                        sortable: true,
                        formatter: function (value, row, index) {
                            return $.formatString('{0}%', parseInt(10000 * row.activeRate) / 100);
                        }
                    },
                    {
                        field: 'activeYears',
                        title: '手机年卡激活量',
                        width: 130,
                        sortable: true
                    },
                    {
                        field: 'offlineCount',
                        title: '线下裸机销售量',
                        width: 130,
                        sortable: true
                    },
                    {
                        field: 'offlineVipPhoneCount',
                        title: '线下会员机销售量',
                        width: 130,
                        sortable: true
                    },
                    {
                        field: 'offlineVipCount',
                        title: '线下合约卡激活量',
                        width: 130,
                        sortable: true
                    }
                ]
            });
        }

        function exportActiveExcel() {
            var begin = $('#queryBegin').combobox('getValue');
            var end = $('#queryEnd').combobox('getValue');
            var url = '${pageContext.request.contextPath}/tj/letvPhoneStat/activeStat/excel?beginDate=' + begin + '&endDate=' + end + '&status=1';
            location.href = url;
        }
        function exportNotActiveExcel() {
            var begin = $('#queryBegin').combobox('getValue');
            var end = $('#queryEnd').combobox('getValue');
            var url = '${pageContext.request.contextPath}/tj/letvPhoneStat/activeStat/excel?beginDate=' + begin + '&endDate=' + end + '&status=0';
            location.href = url;
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
         style="height: 120px; overflow: auto;">
        <form id="searchForm">
            <table class="table table-hover table-condensed">
                <tr>
                    <td>开始时间</td>
                    <td>结束时间</td>
                    <td></td>
                </tr>
                <tr>
                    <td>
                        <input name="beginDate" id="queryBegin" class="easyui-datebox" data-options="required:true" value="${start}"
                               style="width: 160px; height: 29px"/>
                    </td>

                    <td>
                        <input name="endDate" id="queryEnd" class="easyui-datebox" data-options="required:true" value="${end}"
                               style="width: 160px; height: 29px">
                    </td>
                    <td>
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
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="exportActiveExcel();">导出激活明细数据</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="exportNotActiveExcel();">导出未激活明细数据</a>
</div>
</body>
</html>