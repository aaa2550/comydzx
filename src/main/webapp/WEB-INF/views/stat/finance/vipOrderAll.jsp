<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>华数会员订单查询</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>

<script type="text/javascript">
var dataGrid;
$(function () {
    parent.$.messager.progress('close');
    dataGrid = renderDataGrid('${pageContext.request.contextPath}/vipController/vipOrderAll/${platform}/dataGrid');
});

function renderDataGrid(url) {
    return $('#dataGrid').bossDataGrid({
        url: url,
        sortName: 'createTime',
        sortOrder: 'desc',
        pageSize: 200,
        pageList: [100, 200, 300, 400, 500],
        queryParams: $.serializeObject($('#searchForm')),
        columns: [
            {
                field: 'orderid',
                title: '订单号',
                width: 80
            },
            {
                field: 'orderName',
                title: '订单名称',
                width: 80
            },
            {
                field: 'userId',
                title: '用户Id',
                width: 60
            },
            {
                field: 'payPrice',
                title: '金额',
                width: 60,
                sortable: true
            },
            {
                field: 'status',
                title: '状态',
                width: 60,
                sortable: true,
                formatter: function(value, row, index){
                	if(value == 0) return '未支付';
                	if(value == 1) return '支付成功';
                }
            },
            {
                field: 'startTime',
                title: '会员开始时间',
                width: 120,
                sortable: true
            },
            {
                field: 'endTime',
                title: '会员到期时间',
                width: 120,
                sortable: true
            },
            {
                field: 'createTime',
                title: '创建时间',
                width: 120,
                sortable: true
            },
            {
                field: 'successTime',
                title: '支付时间',
                width: 120,
                sortable: true
            },
            {
                field: 'payChannel',
                title: '支付渠道',
                width: 60,
                formatter: function(value, row, index){
                	if(value == '-1') return '无';
                	if(value == '26') return '微信';
               		if(value == '28') return '支付宝';
                }
            },
            {
                field: 'terminal',
                title: '终端',
                width: 60,
                formatter: function(value, row, index){
					if(value == '141001') return 'Web';
					if(value == '141002') return 'PC(Client)';
					if(value == '141003') return 'Mobile(Android)';
					if(value == '141004') return 'SuperMobile';
					if(value == '141005') return 'PAD(Android)';
					if(value == '141006') return 'MWeb';
					if(value == '141007') return 'SuperTV';
					if(value == '141008') return 'IPad';
					if(value == '141009') return 'IPhone';
					if(value == '141010') return 'TV';
                }
            }
        ]
    });
}

function searchFun() {
	doAfterValidDate(function(){dataGrid.datagrid('load', $.serializeObject($('#searchForm')))});
}

</script>
</head>
<body>
  <div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false" style="height: 120px; overflow-y: hidden; overflow-x: auto">
        <form id="searchForm" method="post" action="${pageContext.request.contextPath}/vipController/vipOrderAll/${platform}/excel">
            <table class="table table-hover table-condensed">
                <tr>
                    <th>开始日期</th>
                    <th>结束日期</th>
                    <th>状态</th>
                    <th>订单号</th>
                    <th>用户Id</th>
                </tr>
                <tr>
                    <td>
                        <input name="dateStart" class="easyui-datebox" value="${dateStart}"/>
                    </td>
                    <td>
                        <input name="dateEnd" class="easyui-datebox" value="${dateEnd}"/>
                    </td>
                    <td>
                    	<select name="status" >
                            <option value="">全部</option>
                            <option value="0">未支付</option>
                            <option value="1">支付成功</option>
                        </select>
                    </td>
                    <td>
                        <input name="orderid" class="easyui-textbox" style="width: 180px;"/>
                    </td>
                    <td>
                        <input name="userId" class="easyui-textbox" style="width: 180px;"/>
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