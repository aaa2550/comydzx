<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>商品热度排行</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script src="${pageContext.request.contextPath}/static/lib/highcharts/highcharts.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/static/lib/highcharts/exporting.js" type="text/javascript"></script>
<script type="text/javascript">
<m:auth uri="/hades/payment/view.json">  $.canView = true;</m:auth>
	var dataGrid;
	$(function () {
	    dataGrid = renderDataGrid('${pageContext.request.contextPath}/hades/payment/payment_product_top_list.json');
	});

	function renderDataGrid(url) {
	    return $('#dataGrid').datagrid({
	        url: url,
	        fit: true,
	        fitColumns: false,
	        border: false,
	        pagination: true,
	        idField: 'id',
	        pageSize: 20,
	        pageList: [ 10,20,40,50,100 ],
	        sortName: 'totalMoney',
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
					    field: 'orderSubject',
					    title: '商品名称',
					    width: '200',
					    sortable: true
					},
	                {
	                    field: 'orderCount',
	                    title: '订单数',
	                    width: '150',
	                    sortable: true
	                },
					{
	                    field: "totalMoney",
	                    title: '订单总金额',
	                    width: '150',
	                    sortable: true,
	                },
					{
	                	field : 'currencyCode',
						title : '币种',
						width : '150',
						sortable : true,
						formatter : function(value) {
							if (value == "CNY") {
								return "人民币";
							} else {
								return "其他";
							}
						}
	                },
					{
					    field: 'appId',
					    title: '应用ID',
					    width: '100',
					    sortable: true
					},
					{
	                    field: 'appName',
	                    title: '应用名称',
	                    width: '200',
	                    sortable: true
	                }
	            ]
	        ],
	        toolbar: '#toolbar',
	        onLoadSuccess: function (data) {
	            parent.$.messager.progress('close');
	            /*loadChart(data)*/
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
		var s = $("input[name=beginDate]").val();
	    var s1 = $("input[name=endDate]").val();
	    dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
	}
	function cleanFun() {
	    $('#searchForm input').val('');
	    dataGrid.datagrid('load', {});
	}


	$(function () {
	    parent.$.messager.progress('close');
	});


	
</script>
</head>
<body>
<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false"
         style="height: 120px; overflow: auto;">
        <form id="searchForm">
            <table class="table table-hover table-condensed">
                <tr>
                    <td>起始时间</td>
                    <td>截止时间</td>
                    <td>业务类型</td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td>
                        <input name="start" class="easyui-datebox" data-options="required:true" value="${start}" style="width: 160px; height: 29px"/>
                    </td>

                    <td>
                        <input name="end" class="easyui-datebox" data-options="required:true" value="${end}" style="width: 160px; height: 29px">
                    </td>
                    <td>
                    	<select name="category" style="width: 160px">
                    		<option value="">全部</option>
                            <option value="theme">主题</option>
                            <option value="game">游戏</option>
                        </select>
                    </td>
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
</div>


</body>
</html>