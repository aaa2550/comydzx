<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html>
<head>
    <title>影片收入趋势</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/highcharts.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/exporting.js" type="text/javascript"></script>
    <script type="text/javascript">
        var dataGrid;
        $(function () {
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/movieIncome/incomeTrend/dataGrid');
        });

        function renderDataGrid(url) {
            return $('#dataGrid').datagrid({
                url: url,
                fit: false,
                fitColumns: false,
                border: false,
                pagination: true,
                idField: 'id',
                pageSize: 10,
                pageList: [10, 20, 30, 40, 50],
                sortName: 'date',
                sortOrder: 'asc',
                checkOnSelect: false,
                selectOnCheck: false,
                nowrap: false,
                striped: true,
                rownumbers: true,
                singleSelect: true,
                remoteSort: false,
                frozenColumns: [
                    []
                ],
                columns: [
                    [
                        {
                            field: 'date',
                            title: '日期',
                            width: '100',
                            sortable: true
                        },
                        {
                            field: 'totalIncome',
                            title: 'PC+移动+领先版现金收入',
                            width: '180',
                            sortable: true
                        },
                        {
                            field: 'movieTotalIncome',
                            title: 'PC+移动+领先版内容收入',
                            width: '180',
                            sortable: true
                        },
                        {
                            field: 'incomeRate',
                            title: '内容现金收入占比',
                            width: '150',
                            formatter: function (value, row, index) {
                                return $.formatString('{0}%', row.incomeRate);
                            },
                            sortable: true
                        },
                        {
                            field: 'pcIncome',
                            title: 'PC端现金收入',
                            width: '150',
                            sortable: true
                        },
                        {
                            field: 'moviePCIncome',
                            title: 'PC端内容收入',
                            width: '150',
                            sortable: true
                        },
                        {
                            field: 'mobileIncome',
                            title: '移动端现金收入',
                            width: '150',
                            sortable: true
                        },
                        {
                            field: 'movieMobileIncome',
                            title: '移动端内容收入',
                            width: '150',
                            sortable: true
                        },
                        {
                            field: 'leadIncome',
                            title: '手机领先版现金收入',
                            width: '150',
                            sortable: true
                        },
                        {
                            field: 'movieLeadIncome',
                            title: '手机领先版内容收入',
                            width: '150',
                            sortable: true
                        }
                    ]
                ],
                toolbar: '#toolbar',
                onLoadSuccess: function (data) {
                    parent.$.messager.progress('close');
                    loadChart(data);
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

        function searchFun() {
            dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
        }
        function cleanFun() {
            $('#searchForm input').val('');
            dataGrid.datagrid('load', {});
        }

        function loadChart(data) {
            var rows = data['rows'];
            $('#container').highcharts({
                chart: {
                    //type: 'column'
                },
                title: {
                    text: '影片收入趋势',
                    x: -20 //center
                },
                xAxis: {
                    categories: $.map(rows, function (element) {
                        return element['date'];
                    })
                },
                yAxis: {
                    title: {
                        text: ''
                    },
                    plotLines: [{
                        value: 0,
                        width: 1,
                        color: '#808080'
                    }]
                },
                credits: {
                    enabled: false
                },
                tooltip: {
                    //  valueSuffix: '（访问次数）' ,
                    pointFormat: '{series.name}: <b>{point.y}</b><br/>',
                    shared: true
                },

                legend: {
                    layout: 'vertical',
                    align: 'right',
                    verticalAlign: 'middle',
                    borderWidth: 1,
                    borderRadius: 5
                },
                series: [{
                    //color:'#00EEEE',
                    //type: 'column',
                    name: '总现金收入',
                    data: $.map(rows, function (element) {
                        //console.info(element) ;
                        return Number(element['totalIncome']);
                    })
                }
                ]
            });
        }


        $(function () {
            parent.$.messager.progress('close');
        });


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
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td>
                        <input name="beginDate" class="easyui-datebox" data-options="required:true" value="${start}" style="width: 160px; height: 29px"/>
                    </td>

                    <td>
                        <input name="endDate" class="easyui-datebox" data-options="required:true" value="${end}" style="width: 160px; height: 29px">
                    </td>
                    <td></td>
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
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a><a
        href="javascript:void(0);" class="easyui-linkbutton"
        data-options="iconCls:'brick_delete',plain:true"
        onclick="cleanFun();">清空条件</a>

    <div id="container" style="min-width: 310px; height: 300px; margin: 0 auto; overflow: auto"></div>

    <!-- <div id="container" style="min-width: 310px; height: 220px; margin: 0 auto; overflow: auto"></div> -->
</div>
</body>
</html>