<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>收银台渠道流量明细</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/highcharts.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/static/lib/highcharts/exporting.js" type="text/javascript"></script>
    <script type="text/javascript">
        var dataGrid;
        $(function () {
            parent.$.messager.progress('close');
            searchFun();
        });

        function renderDataGrid(url) {
            return $('#dataGrid').bossDataGrid({
                url: url,
                fit: false,
                fitColumns: true,
                striped: true,
                sortName: 'date',
                sortOrder: 'asc',
                queryParams: $.serializeObject($('#searchForm')),
                columns: [
                    {
                        field: 'date',
                        title: '日期',
                        width: 60
                    },
                    {
                        field: 'pageUv',
                        title: '流量Uv',
                        width: 60,
                        sortable: true
                    },
                    {
                        field: 'payUv',
                        title: '支付Uv',
                        width: 60,
                        sortable: true
                    },
                    {
                        field: 'rateUv',
                        title: '转化率Uv',
                        width: 60,
                        formatter: function(value, row, index){
                        	return value + "%";
                        }
                    },
                    {
                        field: 'pagePv',
                        title: '流量Pv',
                        width: 60,
                        sortable: true
                    },
                    {
                        field: 'payPv',
                        title: '支付Pv',
                        width: 60,
                        sortable: true
                    },
                    {
                        field: 'ratePv',
                        title: '转化率Pv',
                        width: 60,
                        formatter: function(value, row, index){
                        	return value + "%";
                        }
                    },
                    {
                        field: 'newOrderCount',
                        title: '新增订单数',
                        width: 60,
                        sortable: true
                    },
                    {
                        field: 'xufeiOrderCount',
                        title: '续费订单数',
                        width: 60,
                        sortable: true
                    },
                    {
                        field: 'newIncome',
                        title: '新增收入',
                        width: 60,
                        sortable: true,
                        formatter: function(value, row, index){
                        	return parseFloat(value.toFixed(2));
                        }
                    },
                    {
                        field: 'xufeiIncome',
                        title: '续费收入',
                        width: 60,
                        sortable: true,
                        formatter: function(value, row, index){
                        	return parseFloat(value.toFixed(2));
                        }
                    }
                ]
            });
        }

        function searchFun() {
        	loadDataGrid();
            loadCashierChart();
        }
        
        function loadDataGrid() {
            if (!dataGrid) {
            	dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/cashier/refDetail/dataGrid');
            } else {
                dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
            }
        }
        
        function loadCashierChart() {
            $.getJSON('${pageContext.request.contextPath}/tj/cashier/refDetail/serial', $.serializeObject($('#searchForm')), function (result) {
                var rows = result;
                //根据长度设置步长，防止x轴数据太多显示不全
                var step = Math.round(rows.length / 6);
               	$('#serial').highcharts({
           	        chart: {
           	            zoomType: 'xy'
           	        },
           	        title: {
           	            text: '收银台流量及转化率'
           	        },
           	        credits: {
       	   	            enabled:false
       	   	        },
           	        xAxis: [{
           	        	tickInterval: step,
           	            categories: $.map(rows, function (element) {
                               return element['date'];
                           }),
           	        }],
           	        yAxis: [{
           	        	title: {
           	                text: '流量'
           	            },
           	            labels: {
           	                format: '{value}'
           	            }
           	        }, {
           	            title: {
           	                text: '转化率(%)'
           	            },
           	            labels: {
           	                format: '{value}'
           	            },
           	            opposite: true
           	        }],
           	        tooltip: {
           	            shared: true
           	        },
           	        legend: {
           	            layout: 'vertical',
           	            align: 'left',
           	            x: 120,
           	            verticalAlign: 'top',
           	            y: 100,
           	            floating: true,
           	            backgroundColor: '#FFFFFF'
           	        },
           	        series: [{
           	            name: '流量Uv',
           	            color: '#51A7F9',
           	            type: 'spline',
           	            data: $.map(rows, function (element) {
                               return element['pageUv'];
                           })
           	        },
           			{
           				name: '转化率Uv',
           				color: '#22BA66',
           				type: 'spline',
           				yAxis: 1,
           				data: $.map(rows, function (element) {
                               return element['rateUv'];
                           }),
           				tooltip: {
           					valueSuffix: ' %'
           				}
           			}
           			]
           	    });
            });
        }
    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false" style="height: 120px; overflow-y: hidden; overflow-x: auto">
        <form id="searchForm" method="post" action="${pageContext.request.contextPath}/tj/cashier/refDetail/excel">
            <table class="table table-hover table-condensed">
                <tr>
                    <th>开始日期</th>
                    <th>结束日期</th>
                    <th>终端</th>
                    <th>Ref</th>
                </tr>
                <tr>
                    <td>
                        <input name="dateStart" class="easyui-datebox" value="${dateStart}"/>
                    </td>
                    <td>
                        <input name="dateEnd" class="easyui-datebox" value="${dateEnd}"/>
                    </td>
                    <td>
                    	<select name="terminal">
                            <option value="">全部</option>
                            <option value="112" <c:if test="${terminal == 112}"> selected="selected" </c:if>>PC</option>
                            <option value="113" <c:if test="${terminal == 113}"> selected="selected" </c:if>>M站</option>
                        </select>
                    </td>
                    <td>
                        <input name="ref" style="width: 180px;" value="${ref}" readonly="readonly"/>
                        <span>${refName}</span>
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
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_search',plain:true" onclick="searchFun();">查询</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_go',plain:true" onclick="exportExcel();">导出Excel</a>
    <div id="serial" style="min-width: 310px; height: 300px; margin: 0 auto; overflow: auto"></div>
</div>
</body>
</html>
