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
            searchFun();
        });

        function renderDataGrid(url) {
            return $('#dataGrid').bossDataGrid({
                url: url,
                fit: false,
                fitColumns: false,
                sortName: 'cdate',
                sortOrder: 'asc',
                pageSize: 400,
                pageList: [50, 100, 200, 400],
                queryParams: $.serializeObject($('#searchForm')),
                columns: [
                    {
                        field: 'cdate',
                        title: '日期',
                        width: 73,
                        sortable: true
                    },
                    {
                        field: 'totalIncome',
                        title: '总' + getTypeName(),
                        width: 75,
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                        	return formatValue(value);
                        }
                    },
                    {
                        field: 'alipayIncome',
                        title: '支付宝',
                        width: 75,
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                        	return formatValue(value);
                        }
                    },
                    {
                        field: 'wechatIncome',
                        title: '微信',
                        width: 75,
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                        	return formatValue(value);
                        }
                    },
                    {
                        field: 'iapIncome',
                        title: 'IAP',
                        width: 75,
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                        	return formatValue(value);
                        }
                    },
                    {
                        field: 'mobileIncome',
                        title: '移动话费',
                        width: 75,
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                        	return formatValue(value);
                        }
                    },
                    {
                        field: 'unicomIncome',
                        title: '联通话费',
                        width: 75,
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                        	return formatValue(value);
                        }
                    },
                    {
                        field: 'telecomIncome',
                        title: '电信话费',
                        width: 75,
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                        	return formatValue(value);
                        }
                    },
                    {
                        field: 'yeepayIncome',
                        title: '易宝',
                        width: 75,
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                        	return formatValue(value);
                        }
                    },
                    {
                        field: 'unionpayIncome',
                        title: '银联',
                        width: 75,
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                        	return formatValue(value);
                        }
                    },
                    {
                        field: 'wingpayIncome',
                        title: '翼',
                        width: 75,
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                        	return formatValue(value);
                        }
                    },
                    {
                        field: 'cybersourceIncome',
                        title: 'cybersource',
                        width: 75,
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                        	return formatValue(value);
                        }
                    },
                    {
                        field: 'paypalIncome',
                        title: 'papal',
                        width: 75,
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                        	return formatValue(value);
                        }
                    },
                    {
                        field: 'cebbankIncome',
                        title: '光大银行',
                        width: 75,
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                        	return formatValue(value);
                        }
                    },
                    {
                        field: 'toBIncome',
                        title: '2B',
                        width: 75,
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                        	return formatValue(value);
                        }
                    },
                    {
                        field: 'legouIncome',
                        title: '大屏乐购',
                        width: 75,
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                        	return formatValue(value);
                        }
                    },
                    {
                        field: 'lepointIncome',
                        title: '乐点',
                        width: 75,
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                        	return formatValue(value);
                        }
                    },
                    {
                        field: 'lecardIncome',
                        title: '乐卡',
                        width: 75,
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                        	return formatValue(value);
                        }
                    },
                    {
                        field: 'deviceBindIncome',
                        title: '机卡绑定',
                        width: 75,
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                        	return formatValue(value);
                        }
                    },
                    {
                        field: 'movieTicketIncome',
                        title: '观影券',
                        width: 75,
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                        	return formatValue(value);
                        }
                    },
                    {
                        field: 'liveTicketIncome',
                        title: '直播票兑换',
                        width: 75,
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                        	return formatValue(value);
                        }
                    },
                    {
                        field: 'donateIncome',
                        title: '赠送渠道',
                        width: 75,
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                        	return formatValue(value);
                        }
                    },
                    {
                        field: 'warsuIncome',
                        title: '华数',
                        width: 75,
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                        	return formatValue(value);
                        }
                    },
                    {
                        field: 'affirmIncome',
                        title: 'affirm',
                        width: 75,
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                        	return formatValue(value);
                        }
                    },
                    {
                        field: 'quickMoneyIncome',
                        title: '快钱',
                        width: 75,
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                        	return formatValue(value);
                        }
                    },
                    {
                        field: 'qihooIncome',
                        title: '360手机助手支付',
                        width: 75,
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                        	return formatValue(value);
                        }
                    },
                    {
                        field: 'otherIncome',
                        title: '其他',
                        width: 100,
                        align: 'left',
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
            	dataGrid = renderDataGrid('${pageContext.request.contextPath}/vipController/incomeChannel/${productTypes}/${productSubtypes}/dataGrid');
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
       	            name: '总' + getTypeName(),
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['totalIncome'];
                       })
       	        },{
       	            name: '支付宝',
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['alipayIncome'];
                       })
       	        },{
       	            name: '微信',
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['wechatIncome'];
                       })
       	        },{
       	            name: 'IAP',
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['iapIncome'];
                       })
       	        },{
       	            name: '移动话费',
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['mobileIncome'];
                       })
       	        },{
       	            name: '联通话费',
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['unicomIncome'];
                       })
       	        },{
       	            name: '电信话费',
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['telecomIncome'];
                       })
       	        },{
       	            name: '易宝',
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['yeepayIncome'];
                       })
       	        },{
       	            name: '银联',
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['unionpayIncome'];
                       })
       	        },{
       	            name: '翼',
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['wingpayIncome'];
                       })
       	        },{
       	            name: 'cybersource',
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['cybersourceIncome'];
                       })
       	        },{
       	            name: 'papal',
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['paypalIncome'];
                       })
       	        },{
       	            name: '光大银行',
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['cebbankIncome'];
                       })
       	        },{
       	            name: '2B',
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['toBIncome'];
                       })
       	        },{
       	            name: '大屏乐购',
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['legouIncome'];
                       })
       	        },{
       	            name: '乐点',
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['lepointIncome'];
                       })
       	        },{
       	            name: '乐卡',
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['lecardIncome'];
                       })
       	        },{
       	            name: '机卡绑定',
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['deviceBindIncome'];
                       })
       	        },{
       	            name: '观影券',
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['movieTicketIncome'];
                       })
       	        },{
       	            name: '直播票兑换',
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['liveTicketIncome'];
                       })
       	        },{
       	            name: '赠送渠道',
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['donateIncome'];
                       })
       	        },{
       	            name: '华数',
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['warsuIncome'];
                       })
       	        },{
       	            name: 'affirm',
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['affirmIncome'];
                       })
       	        },{
       	            name: '快钱',
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['paypalIncome'];
                       })
       	        },{
       	            name: '360手机助手支付',
       	            type: 'spline',
       	            data: $.map(rows, function (element) {
                           return element['qihooIncome'];
                       })
       	        },{
       	            name: '其他',
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
        <form id="searchForm" method="post" action="${pageContext.request.contextPath}/vipController/incomeChannel/${productTypes}/${productSubtypes}/excel">
            <table class="table table-hover table-condensed">
                <tr>
                    <th>开始日期</th>
                    <th>结束日期</th>
                    <th>会员名称</th>
                    <th>终端</th>
                    <th>子终端</th>
                </tr>
                <tr>
                	<input type="hidden" name="type" value="${type}">
                    <td>
                        <input name="startDate" class="easyui-datebox" value="${startDate}"/>
                    </td>
                    <td>
                        <input name="endDate" class="easyui-datebox" value="${endDate}"/>
                    </td>
                    <td>
                        <select name="productId">
                            <option value="">全部</option>
                            <c:forEach items="${vipPackages}" var="vipPackage">
                            	<option value="${vipPackage.id}">${vipPackage.name}</option>	
                            </c:forEach>
                        </select>
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
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_go',plain:true" onclick="exportExcel();">导出Excel</a>
    <div id="serial" style="min-width: 310px; height: 600px; margin: 0 auto; overflow: auto"></div>
</div>
</body>
</html>
