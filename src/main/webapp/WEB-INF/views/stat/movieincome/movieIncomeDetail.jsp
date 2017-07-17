<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>影片收入明细</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/highcharts.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/exporting.js" type="text/javascript"></script>
    <script type="text/javascript">
        var dataGrid;
        $(function () {
            parent.$.messager.progress('close');
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/movieIncome/incomeDetail/dataGrid');
        });

        function renderDataGrid(url) {
            return $('#dataGrid').datagrid({
                url: url,
                fit: true,
                fitColumns: false,
                border: false,
                pagination: true,
                idField: 'id',
                pageSize: 20,
                pageList: [10, 20, 30, 40, 50],
                sortName: 'allIncome',
                sortOrder: 'desc',
                checkOnSelect: false,
                selectOnCheck: false,
                nowrap: false,
                striped: true,
                rownumbers: true,
                singleSelect: true,
                remoteSort: false,
                frozenColumns: [[]],
                columns: [
                    [
                        {
                            field: 'playlistId',
                            title: '专辑ID',
                            width: '100'
                        },
                        {
                            field: 'palylistName',
                            title: '专辑名称',
                            width: '130'
                        },
                        {
                            field: 'pcInformalNum',
                            title: 'PC端付费试看人数',
                            width: '120'
                        },
                        {
                            field: 'mobileInformalNum',
                            title: '移动端付费试看人数',
                            width: '120'
                        },
                        {
                            field: 'leadInformalNum',
                            title: '领先版付费试看人数',
                            width: '120'
                        },
                        {
                            field: 'pcFormalNum',
                            title: 'PC端付费播放人数',
                            width: '120'
                        },
                        {
                            field: 'mobileFormalNum',
                            title: '移动端付费播放人数',
                            width: '120'
                        },
                        {
                            field: 'leadFormalNum',
                            title: '领先版付费播放人数',
                            width: '120'
                        },
                        {
                            field: 'pcMovieIncome',
                            title: 'PC端影片会员收入',
                            width: '120',
                            sortable: true
                        },
                        {
                            field: 'mobileMovieIncome',
                            title: '移动端影片会员收入',
                            width: '120',
                            sortable: true
                        },
                        {
                            field: 'leadMovieIncome',
                            title: '领先版影片会员收入',
                            width: '120',
                            sortable: true
                        },
                        {
                            field: 'singleIncome',
                            title: '点播收入',
                            width: '100',
                            sortable: true
                        },
                        {
                            field: 'allIncome',
                            title: '总收入',
                            width: '100',
                            sortable: true
                        }
                    ]
                ],
                toolbar: '#toolbar',
                onLoadSuccess: function (data) {
                    parent.$.messager.progress('close');
                    //loadChart(data)
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

        function exportExcel() {
            var beginDate = $('#beginDate').combobox('getValue');
            var endDate = $('#endDate').combobox('getValue');
            var playlistId = $("#playlistId").val();
            var url = '${pageContext.request.contextPath}/tj/movieIncome/incomeDetail/excel?beginDate=' + beginDate + '&endDate=' + endDate + '&playlistId=' + playlistId;
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
         style="height: 130px; overflow: auto;">
        <form id="searchForm">
            <table class="table table-hover table-condensed">
                <tr>
                    <td>开始日期</td>
                    <td>结束日期</td>
                    <td>专辑ID</td>
                </tr>
                <tr>
                    <td>
                        <input id="beginDate" name="beginDate" class="easyui-datebox" data-options="required:true" value="${start}"
                               style="width: 160px; height: 29px"/>
                    </td>

                    <td>
                        <input id="endDate" name="endDate" class="easyui-datebox" data-options="required:true" value="${end}"
                               style="width: 160px; height: 29px">
                    </td>
                    <td>
                        <input id="playlistId" class="easyui-textbox" name="playlistId" style="width: 160px; height: 29px"/>
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
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="exportExcel();">导出excel</a>
</div>
</body>
</html>