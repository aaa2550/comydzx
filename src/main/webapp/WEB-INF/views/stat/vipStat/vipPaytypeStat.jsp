<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>支付地域统计</title>
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
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/vipController/query/paytypeStat');
        });

        function renderDataGrid(url) {
            return $('#dataGrid').datagrid({
                url: url,
                fit: true,
                fitColumns: false,
                border: false,
                pagination: true,
                idField: 'id',
                pageSize: 100,
                pageList: [  20, 50, 100, 200 ],
                sortName: 'money',
                sortOrder: 'desc',
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
						    field: 'paytypeName',
						    title: '支付方式名称',
						    width: '220',
						    sortable: true
						},
						{
						    field: 'orders',
						    title: '订单数',
						    width: '100',
						    sortable: true
						},
						{
						    field: 'money',
						    title: '金额',
						    width: '100',
						    sortable: true
						} 
                    ]
                ],
                toolbar: '#toolbar',
                onLoadSuccess: function (data) {
                    parent.$.messager.progress('close');
                    rows = data['rows']
                    pickMealTypeAndRender("orders");
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
                return {name: row['paytypeName'], y: row[mealType]}
            })
            renderChart(pies, $('input[name=mealType]:checked').attr("title"));
        }

        function renderChart(pies, mealTypeText) {
            $('#container').highcharts({
                chart: {
                    plotBackgroundColor: null,
                    plotBorderWidth: null,
                    plotShadow: false
                },
                title: {
                    text: '支付方式分布' + "(" + mealTypeText + ")",
                    align: "center",
                    float : false,
                    verticalAlign :"bottom"
                },
                tooltip: {
                    pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
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
                        name: '比例',
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
                            <option value="-2">全部</option>
                            <option value="112">pc</option>
                            <option value="130">mobile</option>
                            <option value="111">tv</option>
                            <option value="113">M站</option>
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
        <span style="padding: 5px">
            <input type="radio" name="mealType" onclick="pickMealTypeAndRender('orders')" checked="checked" title="订单数"/>订单数
        </span>
         <span style="padding: 5px">
            <input type="radio" name="mealType" onclick="pickMealTypeAndRender('money')"  title="金额"/>金额
        </span>
        
    <div id="container" style="min-width: 310px; height: 250px; margin: 0 auto; overflow: auto"></div>
</div>


</body>
</html>