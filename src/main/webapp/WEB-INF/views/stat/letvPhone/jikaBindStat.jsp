<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>机卡绑定统计</title>
    <%@ include file="/WEB-INF/views/inc/head.inc"%>

    <script src="${pageContext.request.contextPath}/static/lib/highcharts/highcharts.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/exporting.js" type="text/javascript"></script>
    <script type="text/javascript">
        /**
         * 待绑定行数据
         */
        var rows;

        var dataGrid;
        $(function () {
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/letvPhoneStat/jikaBind/dataGrid');
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
                pageList: [  20, 50, 100, 200 ],
                checkOnSelect: false,
                selectOnCheck: false,
                nowrap: false,
                striped: true,
                rownumbers: true,
                singleSelect: true,
                remoteSort: false,
                frozenColumns: [
                    [
                    ]
                ],
                columns: [
                    [   
						{
						    field: 'ordertype',
						    title: '月类型',
						    width: 130,
						    sortable: true
						},
						{
                            field: 'nums',
                            title: '数量',
                            width: 130,
                            sortable: true
                        }
                    ]
                ],
                toolbar: '#toolbar',
                onLoadSuccess: function (data) {
                    parent.$.messager.progress('close');
                    rows = data['rows']
                    pickMealTypeAndRender("nums");
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


        $(function () {
            parent.$.messager.progress('close');
        });


        function pickMealTypeAndRender(mealType) {
            //get the pie data from the rows
            var pies = $.map(rows, function (row) {
                return {name: row['ordertype'], y: row[mealType]}
            })
            renderChart(pies, '月');
        }

        function renderChart(pies, mealTypeText) {
            $('#container').highcharts({
                chart: {
                    plotBackgroundColor: null,
                    plotBorderWidth: null,
                    plotShadow: false
                },
                title: {
                    text: '机卡绑定分布' + "(" + mealTypeText + ")",
                    align: "left",
                    float : false,
                    verticalAlign :"middle"
                },
                tooltip: {
                    pointFormat: '<b>{point.y}	{point.percentage:.1f}%</b>'
                },
                plotOptions: {
                    pie: {
                        allowPointSelect: true,
                        cursor: 'pointer',
                        dataLabels: {
                            enabled: true,
                            color: '#000000',
                            connectorColor: '#000000',
                            format: '<b>{point.name}</b>: {point.y} {point.percentage:.1f}  %'
                        },
                        showInLegend: true
                    }
                },
                legend: {
                    layout: 'vertical',
                    align: 'right',
                    verticalAlign: 'middle',
                    width: 100,
                    borderWidth: 0
                },
                series: [
                    {
                        type: 'pie',
                        data: pies
                    }
                ]
            });
        }
    </script>
    <style>
        .span {
            padding: 10px;
        }
    </style>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false"
         style="height: 120px; overflow: auto;">
        <form id="searchForm">
            <table class="table table-hover table-condensed">
                <tr>
                    <td>开始日期</td>
                    <td>结束日期</td>
                    <td>终端</td>
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
                    <td>
                    	<select name="terminal" style="width: 160px" id="one">
                            <option value="111">TV</option>
                            <option value="120">超级手机</option>
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
    <a href="javascript:void(0);" class="easyui-linkbutton"
       data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a><a
        href="javascript:void(0);" class="easyui-linkbutton"
        data-options="iconCls:'brick_delete',plain:true"
        onclick="cleanFun();">清空条件</a>
       
        
    <div id="container" style="min-width: 310px; height: 350px; margin: 0 auto; overflow: auto"></div>
</div>


</body>
</html>