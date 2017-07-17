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
            $('select[name=payChannelOne]').cascade('payChannelTwo', function(){
            	$('select[name=payChannelTwo]').cascade('payChannelThree', null, '/tj/cascade/payChannel');	
            }, '/tj/cascade/payChannel');
            searchFun();
        });

        function renderDataGrid(url) {
            return $('#dataGrid').bossDataGrid({
                url: url,
                fit: false,
                sortName: 'totalIncome',
                sortOrder: 'desc',
                pageSize: 50,
                pageList: [50, 100, 200, 300, 500],
                queryParams: $.serializeObject($('#searchForm')),
                columns: [
                    {
                        field: 'productId',
                        title: '产品ID',
                        width: 60,
                        sortable: true
                    },
                    {
                        field: 'productName',
                        title: '产品名称',
                        width: 60,
                        sortable: true
                    },
                    {
                        field: 'totalCount',
                        title: '订单数',
                        width: 60,
                        align: 'right',
                        sortable: true
                    },
                    {
                        field: 'totalIncome',
                        title: '总收入',
                        width: 60,
                        align: 'right',
                        sortable: true,
                        formatter: function(value,row,index){
                        	return value.toFixed(2);
                        }
                    }
                ],
                onLoadSuccess: function(data){
                }
            });
        }

        function searchFun() {
        	loadDataGrid();
        }
        
        function loadDataGrid() {
            if (!dataGrid) {
            	dataGrid = renderDataGrid('${pageContext.request.contextPath}/vipController/incomeTvodV2/${productTypes}/dataGrid');
            } else {
                dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
            }
        }
    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false" style="height: 120px; overflow-y: hidden; overflow-x: auto">
        <form id="searchForm" method="post" action="${pageContext.request.contextPath}/vipController/incomeTvodV2/${productTypes}/excel">
            <table class="table table-hover table-condensed">
                <tr>
                    <th>开始日期</th>
                    <th>结束日期</th>
                    <th>终端</th>
                    <th>子终端</th>
                    <th>一级渠道</th>
                    <th>二级渠道</th>
                    <th>三级渠道</th>
                    <th>产品ID</th>
                    <!-- <th>产品名称</th> -->
                </tr>
                <tr>
                    <td>
                        <input name="startDate" class="easyui-datebox" value="${startDate}" style="width:110px"/>
                    </td>
                    <td>
                        <input name="endDate" class="easyui-datebox" value="${endDate}" style="width:110px"/>
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
                    <td>
                    	<input id="productId" class="easyui-textbox" name="productId" style="width:110px"/>
                    </td>
                    <!-- <td>
                    	<input id="productName" class="easyui-textbox" name="productName"/>
                    </td> -->
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
</div>
</body>
</html>
