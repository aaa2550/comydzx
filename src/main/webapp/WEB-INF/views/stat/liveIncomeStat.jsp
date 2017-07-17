<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>直播收入统计</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script type="text/javascript">
        var dataGrid;
        $(function () {
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/vipController/liveIncome/query');
        });

        function renderDataGrid(url) {
            return $('#dataGrid').bossDataGrid({
                url: url,
                sortName: "liveTime",
                sortOrder: "desc",
                queryParams: {
                    beginDate: $("input[name = 'beginDate']").val(),
                    endDate: $("input[name = 'endDate']").val(),
                    status: $("select[name = 'status']").val()
                },
                columns: [
                    {
                        field: 'extendId',
                        title: '场次ID',
                        width: 200
                    },
                    {
                        field: 'movieName',
                        title: '直播名称',
                        width: 200
                    },
                    {
                        field: 'liveTime',
                        title: '直播时间',
                        width: 200
                    },
                    {
                        field: 'totalNumber',
                        title: '总人数',
                        width: 150,
                        sortable: true
                    },
                    {
                        field: 'totalIncome',
                        title: '总收入',
                        width: 150,
                        sortable: true
                    }
                ]
            });
        }

        function searchFun() {
            //renderDataGrid('${pageContext.request.contextPath}/vipController/liveIncome/query?' + $("#searchForm").serialize());
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
         style="height: 130px; overflow: auto;">
        <form id="searchForm">
            <table class="table table-hover table-condensed">
                <tr>
                    <td>开始日期</td>
                    <td>结束日期</td>
                    <td>直播状态</td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td>
                        <input name="beginDate" class="easyui-datebox" value="${start}" style="width: 160px; height: 29px"/>
                    </td>

                    <td>
                        <input name="endDate" class="easyui-datebox" value="${end}" style="width: 160px; height: 29px">
                    </td>
                    <td>
                        <select name="status">
                            <option value="-1">全部</option>
                            <option value="0">线上</option>
                            <option value="1">已下线</option>
                        </select>
                    </td>
                    <td></td>
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
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="cleanFun();">清空条件</a>
</div>
</body>
</html>