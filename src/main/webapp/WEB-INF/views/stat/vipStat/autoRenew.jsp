<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>自动续费查询V2</title>
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
                sortName: 'date',
                sortOrder: 'asc',
                fit: false,
                queryParams: $.serializeObject($('#searchForm')),
                columns: [
                    {
                        field: 'date',
                        title: '日期',
                        width: 60
                    },
                    {
                        field: 'newUser',
                        title: '订阅用户数',
                        width: 60,
                        sortable: true
                    },
                    {
                        field: 'newIncome',
                        title: '订阅收入',
                        width: 60,
                        sortable: true
                    },
                    {
                        field: 'xufeiOrder',
                        title: '自动续费订单数',
                        width: 60
                    },
                    {
                        field: 'xufeiIncome',
                        title: '自动续费收入',
                        width: 60,
                        sortable: true
                    },
                    {
                        field: 'totalIncome',
                        title: '总收入',
                        width: 60,
                        sortable: true
                    },
                    {
                        field: 'keepUser',
                        title: '总留存用户数',
                        width: 60
                    },
                    {
                        field: 'lostUser',
                        title: '流失用户数',
                        width: 60
                    }
                ],
                onLoadSuccess: function(data){
                	loadCashierChart(data);
                }
            });
        }

        function searchFun() {
        	loadDataGrid();
        }
        
        function loadDataGrid() {
            if (!dataGrid) {
            	dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/autoRenew/dailyInfo/dataGrid');
            } else {
                dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
            }
        }
        
        function loadCashierChart(data) {
            var rows = data.rows;
            //根据长度设置步长，防止x轴数据太多显示不全
            var step = Math.round(rows.length / 6);
           	$('#serial').highcharts({
       	        title: {
       	            text: '自动续费收入'
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
       	                text: '收入（元）'
       	            },
       	            labels: {
       	                format: '{value}'
       	            }
       	        }],
       	        tooltip: {
       	            shared: true
       	        },
       	        legend: {
       	            layout: 'vertical',
       	            align: 'right',
       	            verticalAlign: 'middle',
       	            floating: true,
       	            backgroundColor: '#FFFFFF'
       	        },
       	        series: [{
       	            name: '订阅',
       	            color: '#5D9CEC',
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['newIncome'];
                       })
       	        },{
       	            name: '续费',
       	            color: '#48CFAD',
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['xufeiIncome'];
                       })
       	        },{
       	            name: '总计',
       	            color: '#FFCE54',
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['totalIncome'];
                       })
       	        }
       			]
       	    });
        }
    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false" style="height: 120px; overflow-y: hidden; overflow-x: auto">
        <form id="searchForm" method="post" action="${pageContext.request.contextPath}/tj/autoRenew/dailyInfo/excel">
            <table class="table table-hover table-condensed">
                <tr>
                    <th>开始日期</th>
                    <th>结束日期</th>
                    <th>终端</th>
                    <th>支付渠道</th>
                    <th>会员类型</th>
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
                            <option value="-2">全部</option>
                            <c:forEach items="${terminals}" var="terminal">
                                <option value="${terminal.terminalId}">${terminal.terminalName}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                        <select name="parentChannel">
                            <option value="-2">全部</option>
                            <option value="1">支付宝</option>
              				<option value="2">微信</option>
                        </select>
                    </td>
                    <td>
                        <select name="vipType">
                            <option value="-2">全部</option>
                            <option value="1">乐次元</option>
              				<option value="9">超级影视</option>
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
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_search',plain:true" onclick="searchFun();">查询</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_go',plain:true" onclick="exportExcel();">导出Excel</a>
    <div id="serial" style="min-width: 310px; height: 300px; margin: 0 auto; overflow: auto"></div>
</div>
</body>
</html>
