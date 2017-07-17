<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>乐购订单渠道流量</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script type="text/javascript">
        var dataGrid;
        $(function () {
            parent.$.messager.progress('close');
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/legoCashier/refFlow/dataGrid');
        });

        function renderDataGrid(url) {
            return $('#dataGrid').bossDataGrid({
                url: url,
                sortName: 'pageUv',
                sortOrder: 'desc',
                queryParams: $.serializeObject($('#searchForm')),
                columns: [
                    {
                        field: 'cpsNo',
                        title: 'cps_no',
                        width: 120
                    },
                    {
                        field: 'cpsName',
                        title: 'cps_no名称',
                        width: 120
                    },
                    {
                        field: 'pageUv',
                        title: '流量Uv',
                        width: 60,
                        align: 'right',
                        sortable: true
                    },
                    {
                        field: 'payUv',
                        title: '支付成功Uv',
                        width: 60,
                        align: 'right',
                        sortable: true
                    },
                    {
                        field: 'rateUv',
                        title: '转化率Uv',
                        width: 60,
                        align: 'right',
                        formatter: function(value, row, index){
                        	return value.toFixed(2) + "%";
                        }
                    },
                    {
                        field: 'pagePv',
                        title: '流量Pv',
                        width: 60,
                        align: 'right',
                        sortable: true
                    },
                    {
                        field: 'payPv',
                        title: '支付成功Pv',
                        width: 60,
                        align: 'right',
                        sortable: true
                    },
                    {
                        field: 'ratePv',
                        title: '转化率Pv',
                        width: 60,
                        align: 'right',
                        formatter: function(value, row, index){
                        	return value.toFixed(2) + "%";
                        }
                    },
                    {
                        field: 'income',
                        title: '收入',
                        width: 60,
                        align: 'right',
                        sortable: true,
                        formatter: function(value, row, index){
                        	return value.toFixed(2);
                        }
                    },
                    {
                        field: 'operation', 
                        title: '操作',
                        noExport: true,
                        width: 	120,
                        sortable: false,
                        formatter : function(value, row, index) {
                            return '<a href="javascript:void(0)" onclick=gotoDetail("'+row.cpsNo+'","'+row.cpsName+'")>查询明细</a>';
                        }
                    }
                ]
            });
        }

        function searchFun() {
            dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
        }
        
        function gotoDetail(cpsNo, cpsName){//详情跳转
    		parent.iframeTab.init({url:'${pageContext.request.contextPath}/tj/legoCashier/refDetail/index?cpsNo='+cpsNo+'&cpsName='+encodeURI(encodeURI(cpsName))
    			//+'&dateStart='+$('input[name=dateStart]').val()+'&dateEnd='+$('input[name=dateEnd]').val()
    			,text:'乐购订单渠道流量明细'});
    	}
        
    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false" style="height: 120px; overflow-y: hidden; overflow-x: auto">
        <form id="searchForm" method="post" action="${pageContext.request.contextPath}/tj/legoCashier/refFlow/excel">
            <table class="table table-hover table-condensed">
                <tr>
                    <th>开始日期</th>
                    <th>结束日期</th>
                    <th>cps_no</th>
                </tr>
                <tr>
                    <td>
                        <input name="dateStart" class="easyui-datebox" value="${dateStart}"/>
                    </td>
                    <td>
                        <input name="dateEnd" class="easyui-datebox" value="${dateEnd}"/>
                    </td>
                    <td>
                        <input name="cpsNo" class="easyui-textbox" style="width: 180px;"/>
                    </td>
                </tr>
            </table>
        </form>
    </div>
    <div data-options="region:'center',border:false" style="overflow: hidden">
        <table id="dataGrid"></table>
    </div>
</div>
<div id="toolbar" style="display: none;">
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_search',plain:true" onclick="searchFun();">查询</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_go',plain:true" onclick="exportExcel();">导出Excel</a>
</div>
</body>
</html>
