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
        var type = '${type}';
        $(function () {
            parent.$.messager.progress('close');
            $('select[name=parentTerminal]').cascade('terminal');
            $('select[name=payChannelOne]').cascade('payChannelTwo', function(){
            	$('select[name=payChannelTwo]').cascade('payChannelThree', null, '/tj/cascade/payChannel');	
            }, '/tj/cascade/payChannel');
            searchFun();
        });

        function renderDataGrid(url) {
            return $('#dataGrid').bossDataGrid({
                url: url,
                fit: false,
                sortName: 'cdate',
                sortOrder: 'asc',
                pageSize: 400,
                pageList: [50, 100, 200, 400],
                queryParams: $.serializeObject($('#searchForm')),
                columns: [
                    {
                        field: 'cdate',
                        title: '日期',
                        width: 60,
                        sortable: true
                    },
                    {
                        field: 'totalIncome',
                        title: '会员总' + getTypeName(),
                        width: 60,
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                        	return formatValue(value);
                        }
                    },
                    {
                        field: 'newIncome',
                        title: '新用户' + getTypeName(),
                        width: 60,
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                        	return formatValue(value);
                        }
                    },
                    {
                        field: 'xufeiIncome',
                        title: '老用户' + getTypeName(),
                        width: 60,
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                        	return formatValue(value);
                        }
                    },
                    {
                        field: 'monthIncome',
                        title: '包月' + getTypeName(),
                        width: 60,
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                        	return formatValue(value);
                        }
                    },
                    {
                        field: 'subscribeIncome',
                        title: '订阅' + getTypeName(),
                        width: 60,
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                        	return formatValue(value);
                        }
                    },
                    {
                        field: 'autoRenewIncome',
                        title: '自动续费' + getTypeName(),
                        width: 60,
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                        	return formatValue(value);
                        }
                    },
                    {
                        field: 'quarterIncome',
                        title: '包季' + getTypeName(),
                        width: 60,
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                        	return formatValue(value);
                        }
                    },
                    {
                        field: 'halfYearIncome',
                        title: '包半年' + getTypeName(),
                        width: 60,
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                        	return formatValue(value);
                        }
                    },
                    {
                        field: 'yearIncome',
                        title: '包年' + getTypeName(),
                        width: 60,
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                        	return formatValue(value);
                        }
                    },
                    {
                        field: 'threeYearIncome',
                        title: '包三年' + getTypeName(),
                        width: 60,
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                        	return formatValue(value);
                        }
                    },
                    {
                        field: 'otherIncome',
                        title: '其他' + getTypeName(),
                        width: 60,
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                        	return formatValue(value);
                        }
                    }
                ],
                onSortColumn: function(sort, order){
                	highchartTitle = '整体'+getTypeName()+'趋势【按' + getTitleByGridColumnField(sort) + (order == 'asc'? '升序': '降序') + '】';
                	reloadHighchartTitle();
                },
                onLoadSuccess: function(data){
                	var orderride = {"cdate": '<b>合计</b>'};
                	if(validObjPropExistInArray(orderride)){
                		deleteObjInArray(orderride, data.rows);
                		loadCashierChart(data);
                	}else{
                		loadCashierChart(data);                		
                		addSummary(orderride);
                	}
                	reloadHighchartTitle();
                },
            });
        }
        
        var highchartTitle = '整体'+getTypeName()+'趋势【按日期升序】';
        
        function reloadHighchartTitle(){
        	highchart.setTitle({'text': highchartTitle});
        }
        
        function getTypeName(){
        	if(type == 1)
        		return "收入";
        	if(type == 2)
        		return "订单";
        	if(type == 3)
        		return "用户";
        }
        
        function formatValue(value){
        	if(type == 1)
        		return value.toFixed(2);
        	return value;
        }

        function searchFun() {
        	loadDataGrid();
        }
        
        function loadDataGrid() {
            if (!dataGrid) {
            	dataGrid = renderDataGrid('${pageContext.request.contextPath}/vipController/incomeDetailV2/${productSubtypes}/dataGrid');
            } else {
                dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
            }
        }
        
        var highchart;
        function loadCashierChart(data) {
            var rows = data.rows;
            //根据长度设置步长，防止x轴数据太多显示不全
            var step = Math.round(rows.length / 6);
            highchart = new Highcharts.Chart({
                chart: {
                    renderTo: 'serial',
                    type: 'spline'
                },
       	        title: {
       	            text: '整体'+getTypeName()+'趋势'
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
       	                text: getTypeName()
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
	   	            borderWidth: 1 ,
	   	            borderRadius: 5
	   	        },
       	        series: [{
       	            name: '会员总' + getTypeName(),
       	            color: '#5D9CEC',
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['totalIncome'];
                       })
       	        },{
       	            name: '新用户' + getTypeName(),
       	            color: '#DA4453',
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['newIncome'];
                       })
       	        },{
       	            name: '老用户' + getTypeName(),
       	            color: '#FFCE54',
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['xufeiIncome'];
                       })
       	        },{
       	            name: '包月' + getTypeName(),
       	            color: '#EC87C0',
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['monthIncome'];
                       })
       	        },{
       	            name: '订阅' + getTypeName(),
       	            color: '#4FC1E9',
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['subscribeIncome'];
                       })
       	        },{
       	            name: '自动续费' + getTypeName(),
       	            color: '#FC6E51',
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['autoRenewIncome'];
                       })
       	        },{
       	            name: '包季' + getTypeName(),
       	            color: '#AC92EC',
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['quarterIncome'];
                       })
       	        },{
       	            name: '包半年' + getTypeName(),
       	            color: '#AC92EC',
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['harfYearIncome'];
                       })
       	        },{
       	            name: '包年' + getTypeName(),
       	            color: '#48CFAD',
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['yearIncome'];
                       })
       	        },{
       	            name: '包三年' + getTypeName(),
       	            color: '#A0D468',
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['threeYearIncome'];
                       })
       	        },{
       	            name: '其他' + getTypeName(),
       	            color: '#A6AD00',
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['otherIncome'];
                       })
       	        }]
       	    });
        }
    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false" style="height: 120px; overflow-y: hidden; overflow-x: auto">
        <form id="searchForm" method="post" action="${pageContext.request.contextPath}/vipController/incomeDetailV2/${productSubtypes}/excel">
            <table class="table table-hover table-condensed">
                <tr>
                    <th>开始日期</th>
                    <th>结束日期</th>
                    <th>会员名称</th>
                    <th>终端</th>
                    <th>子终端</th>
                    <th>一级渠道</th>
                    <th>二级渠道</th>
                    <th>三级渠道</th>
                </tr>
                <tr>
                	<input type="hidden" name="type" value="${type}">
                    <td>
                        <input name="startDate" class="easyui-datebox" value="${startDate}" style="width:110px"/>
                    </td>
                    <td>
                        <input name="endDate" class="easyui-datebox" value="${endDate}" style="width:110px"/>
                    </td>
                    <td>
                        <select name="productId" style="width:110px">
                            <option value="">全部</option>
                            <c:forEach items="${vipPackages}" var="vipPackage">
                            	<option value="${vipPackage.id}">${vipPackage.name}</option>	
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                    	<select name="parentTerminal" style="width:110px">
                            <option value="">全部</option>
                            <c:forEach items="${parentTerminals}" var="parentTerminal">
                                <option value="${parentTerminal.key}">${parentTerminal.value}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                    	<select name="terminal" style="width:130px"><option value="">全部</option></select>
                    </td>
                    <td>
                        <select name="payChannelOne" style="width:130px">
                            <option value="">全部</option>
                            <c:forEach items="${abstractPayChannels}" var="abstractPayChannel">
                                <option value="${abstractPayChannel.key}" <c:if test="${abstractPayChannel.key == 1}"> selected = "selected"</c:if>>${abstractPayChannel.value}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                        <select name="payChannelTwo" style="width:130px"><option value="">全部</option></select>
                    </td>
                    <td>
                        <select name="payChannelThree" style="width:200px"><option value="">全部</option></select>
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
