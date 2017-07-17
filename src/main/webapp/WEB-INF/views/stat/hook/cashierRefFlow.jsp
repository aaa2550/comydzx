<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>收银台渠道流量</title>
    <%@ include file="/WEB-INF/views/inc/head.inc" %>
    <script type="text/javascript">
        var dataGrid;
        $(function () {
            parent.$.messager.progress('close');
            dataGrid = renderDataGrid('${pageContext.request.contextPath}/tj/cashier/refFlow/dataGrid');
        });

        function renderDataGrid(url) {
            return $('#dataGrid').bossDataGrid({
                url: url,
                sortName: 'pageUv',
                sortOrder: 'desc',
                queryParams: $.serializeObject($('#searchForm')),
                columns: [
                    {
                        field: 'ref',
                        title: '来源Ref',
                        width: 120
                    },
                    {
                        field: 'refName',
                        title: '来源名称',
                        width: 120
                    },
                    {
                        field: 'pageUv',
                        title: '流量Uv',
                        width: 60,
                        sortable: true
                    },
                    {
                        field: 'payUv',
                        title: '支付成功Uv',
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
                        title: '支付成功Pv',
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
                    },
                    {
                        field: 'operation', 
                        title: '操作',
                        noExport: true,
                        width: 	120,
                        sortable: false,
                        formatter : function(value, row, index) {
                            return '<a href="javascript:void(0)" onclick=gotoDetail("'+row.ref+'","'+row.refName+'")>查询明细</a>';
                        }
                    }
                ]
            });
        }

        function searchFun() {
            dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
        }
        
        function gotoDetail(ref, refName){//详情跳转
    		parent.iframeTab.init({url:'${pageContext.request.contextPath}/tj/cashier/refDetail/index?ref='+ref+'&refName='+encodeURI(encodeURI(refName))
    			//+'&dateStart='+$('input[name=dateStart]').val()+'&dateEnd='+$('input[name=dateEnd]').val()
    			+'&terminal='+$('select[name=terminal]').val()
    			,text:'收银台渠道流量明细'});
    	}
        
    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false" style="height: 120px; overflow-y: hidden; overflow-x: auto">
        <form id="searchForm" method="post" action="${pageContext.request.contextPath}/tj/cashier/refFlow/excel">
            <table class="table table-hover table-condensed">
                <tr>
                    <th>开始日期</th>
                    <th>结束日期</th>
                    <th>终端</th>
                    <th>Ref</th>
                </tr>
                <tr>
                    <!-- <input type="hidden" name="excelFields">
                	<input type="hidden" name="sheetTitle"> -->
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
                        <input name="ref" class="easyui-textbox" style="width: 180px;"/>
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
