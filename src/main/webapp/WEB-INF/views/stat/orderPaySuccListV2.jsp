<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<title>${title}</title>
	<%@ include file="/WEB-INF/views/inc/head.inc" %>
	<script src="${pageContext.request.contextPath}/static/lib/highcharts/highcharts.js" type="text/javascript"></script>
	<script src="${pageContext.request.contextPath}/static/lib/highcharts/exporting.js" type="text/javascript"></script>
	<script type="text/javascript">
        var dataGrid;
        $(function () {
            parent.$.messager.progress('close');
            $('select[name=parentTerminal]').cascade('terminal');
            searchFun();
        });

        function renderDataGrid(url) {
            return $('#dataGrid').bossDataGrid({
                url: url,
                sortName: 'cdate',
                sortOrder: 'asc',
                pageSize: 400,
                pageList: [50, 100, 200, 400],
                fit:false,
                queryParams: $.serializeObject($('#searchForm')),
                columns: [
                    {
                        field: 'cdate',
                        title: '日期',
                        width: 73,
                        sortable: true
                    },
                    {
                        field: 'succRate',
                        title: '总支付成功率',
                        width: 75,
						halign:'center',
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                            return value.toFixed(2)+"%";
                        }
                    },
                    {
                        field: 'superSuccRate',
                        title: '超级影视成功率',
                        width: 75,
                        halign:'center',
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                            return value.toFixed(2)+"%";
                        }
                    },
                    {
                        field: 'generalSuccRate',
                        title: '乐次元成功率',
                        width: 75,
                        halign:'center',
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                            return value.toFixed(2)+"%";
                        }
                    },
                    {
                        field: 'singleSuccRate',
                        title: '点播成功率',
                        width: 75,
						halign:'center',
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                            return value.toFixed(2)+"%";
                        }
                    },
                    {
                        field: 'totalSum',
                        title: '订单总数',
                        width: 75,
						halign:'center',
                        align: 'right',
                        sortable: true
                    },
                    {
                        field: 'superTotalSum',
                        title: '超级影视订单数',
                        width: 75,
						halign:'center',
                        align: 'right',
                        sortable: true
                    },
                    {
                        field: 'generalTotalSum',
                        title: '乐次元订单数',
                        width: 75,
						halign:'center',
                        align: 'right',
                        sortable: true
                    },
                    {
                        field: 'singleTotalSum',
                        title: '点播订单数',
                        width: 75,
						halign:'center',
                        align: 'right',
                        sortable: true
                    },
                    {
                        field: 'succTotalSum',
                        title: '订单成功总数',
                        width: 75,
						halign:'center',
                        align: 'right',
                        sortable: true
                    },
                    {
                        field: 'succSuperTotalSum',
                        title: '超级影视订单成功数',
                        width: 85,
						halign:'center',
                        align: 'right',
                        sortable: true
                    },
                    {
                        field: 'succGeneralTotalSum',
                        title: '乐次元订单成功数',
                        width: 76,
						halign:'center',
                        align: 'right',
                        sortable: true
                    },
                    {
                        field: 'succSingleTotalSum',
                        title: '点播订单成功数',
                        width: 75,
						halign:'center',
                        align: 'right',
                        sortable: true
                    }
                ],
                onLoadSuccess: function(data){
					loadCashierChart(data);
                },
            });
        }

        function searchFun() {
            loadDataGrid();
        }

        function loadDataGrid() {
            if (!dataGrid) {
                dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/orderPaySuccController/${productTypes}/${productSubTypes}/dataGrid');
            } else {
                dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
            }
        }

        var highchart;
        function loadCashierChart(data) {
            var rows = data.rows;
            console.log(rows)
            //根据长度设置步长，防止x轴数据太多显示不全
            var step = Math.round(rows.length / 6);
            highchart = new Highcharts.Chart({
                chart: {
                    renderTo: 'serial',
                    type: 'spline'
                },
                title: {
                    text: '订单支付转化率'
                },
                credits: {
                    enabled:false
                },
                xAxis: [{
                    tickInterval: step,
                    categories: $.map(rows, function (element) {
                        return element['cdate'];
                    }),
                }],
                yAxis: [{
                    title: {
                        text: '转化率(%)'
                    },
                    labels: {
                        format: '{value}'
                    }
                }],
                tooltip: {
                    valueSuffix:"%",
                    shared: true
                },
                legend: {
                    layout: 'vertical',
                    align: 'right',
                    verticalAlign: 'middle',
                    borderWidth: 1 ,
                    borderRadius: 5
                },
                series: [{
                    name: '总支付成功率',
                    type: 'spline',
                    data: $.map(rows, function (element) {
                        return element['succRate'];
                    })
                },{
					name: '超级影视成功率',
					type: 'spline',
					data: $.map(rows, function (element) {
						return element['superSuccRate'];
					})
				},{
                    name: '乐次元成功率',
                    type: 'spline',
                    data: $.map(rows, function (element) {
                        return element['generalSuccRate'];
                    })
                },{
					name: '点播成功率',
					type: 'spline',
					data: $.map(rows, function (element) {
						return element['singleSuccRate'];
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
		<form id="searchForm" method="get" >
			<table class="table table-hover table-condensed">
				<tr>
					<th>开始日期</th>
					<th>结束日期</th>
					<th>终端</th>
					<th>子终端</th>
				</tr>
				<tr>
					<td>
						<input name="startDate" class="easyui-datebox" value="${startDate}"/>
					</td>
					<td>
						<input name="endDate" class="easyui-datebox" value="${endDate}"/>
					</td>
					<td>
						<select name="parentTerminal">
							<option value="">全部</option>
							<c:forEach items="${parentTerminals}" var="parentTerminal">
								<option value="${parentTerminal.key}">${parentTerminal.value}</option>
							</c:forEach>
						</select>
					</td>
					<td>
						<select name="terminal"><option value="">全部</option></select>
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
	<div id="serial" style="min-width: 310px; height: 270px; margin: 0 auto; overflow: auto"></div>
</div>
</body>
</html>
