<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>商品购买记录</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script src="${pageContext.request.contextPath}/static/lib/highcharts/highcharts.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/static/lib/highcharts/exporting.js" type="text/javascript"></script>
<script type="text/javascript">
<m:auth uri="/hades/payment/view.json">  $.canView = true;</m:auth>
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid').datagrid({
				url : '${pageContext.request.contextPath}/hades/payment/payment_list.json',
				fit : true,
				fitColumns : true,
				border : false,
				pagination : true,
				idField : 'id',
				pageSize : 10,
				pageList : [ 10, 20, 30, 40, 50 ],
				checkOnSelect : false,
				selectOnCheck : false,
				nowrap : false,
				striped : true,
				rownumbers : true,
				singleSelect : true,
				frozenColumns : [ [ {
					field : 'paymentTxId',
					title : 'paymentTxId',
					width : 100,
					hidden : true
				} ] ],
				columns : [ [ 
				{
					field : 'orderNumber',
					title : '订单号',
					width : 120,
					sortable : true
				},   
				{
					field : 'appName',
					title : '应用名称',
					width : 100,
					sortable : true
				},   
				{
					field : 'poStatus',
					title : '订单状态',
					width : 80,
					sortable : true,
					formatter : function(value, row, index) {
						if (value == "OC") {
							return "订单完成";
						} else if(value == "CG"){
							return "订单支付完成";
						} else if(value == "AUTH"){
							return "支付中";
						} else if(value == "N") {
							return "新订单";
						} else if(value == "CF") {
							return "支付失败";
						} else if(value == "R") {
							return "退款";
						} else {
							return "其他";
						}
					}
				},   
				{
					field : 'orderSubject',
					title : '产品名称',
					width : 150,
					sortable : true
				}, {
					field : 'amount',
					title : '价格',
					width : 80,
					sortable : true
				},   
				{
					field : 'currencyCode',
					title : '币种',
					width : 80,
					sortable : true,
					formatter : function(value) {
						if (value == "CNY") {
							return "人民币";
						} else {
							return "其他";
						}
					}
				}
				, {
					field : 'paymentType',
					title : '支付方式',
					width : 100,
					sortable : true,
					formatter : function(value) {
						if (value == "ALI") {
							return "阿里";
						} else if(value == "WX"){
							return "微信"
						} else if(value == "DUMMY"){
							return "0元购"
						} else {
							return "其他";
						}
					}
				}
				, {
					field : 'createTime',
					title : '支付时间',
					width : 160,
					sortable : true
				}
				, {
					field : 'createdBy',
					title : '支付人',
					width : 150,
					sortable : true,
					formatter : function(value) { 
						return value.replace(/letv/gi,'');
						}
				}
				, {
					field : 'action',
					title : '操作',
					width : 80,
					formatter : function(value, row, index) {
						var str = '&nbsp;&nbsp;&nbsp;';
                        if ($.canView) {
                            str += $.formatString('<img onclick="viewFun(\'{0}\');" src="{1}" title="查看"/>', row.paymentTxId, '/static/style/images/extjs_icons/bug/bug_edit.png');
                        }
                        return str;
					}
				}
				] ],
				toolbar : '#toolbar',
				onLoadSuccess : function() {
					$('#searchForm table').show();
					parent.$.messager.progress('close');
				},
				onRowContextMenu : function(e, rowIndex, rowData) {
					e.preventDefault();
					$(this).datagrid('unselectAll');
					$(this).datagrid('selectRow', rowIndex);
					$('#menu').menu('show', {
						left : e.pageX,
						top : e.pageY
					});
				}
			});
	});
	Date.prototype.format = function(format) {
		if (!format) {
			format = "yyyy-MM-dd hh:mm:ss";
		}
		var o = {
			"M+" : this.getMonth() + 1, // month
			"d+" : this.getDate(), // day
			"h+" : this.getHours(), // hour
			"m+" : this.getMinutes(), // minute
			"s+" : this.getSeconds(), // second
			"q+" : Math.floor((this.getMonth() + 3) / 3), // quarter
			"S" : this.getMilliseconds()
		// millisecond
		};
		if (/(y+)/.test(format)) {
			format = format.replace(RegExp.$1, (this.getFullYear() + "")
					.substr(4 - RegExp.$1.length));
		}
		for ( var k in o) {
			if (new RegExp("(" + k + ")").test(format)) {
				format = format.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k]
						: ("00" + o[k]).substr(("" + o[k]).length));
			}
		}
		return format;
	};
	function formatterdate(val, row) {
		var date = new Date(val);
		if(date ="Invalid Date"){
			return "";
		}
		return date.format("yyyy-MM-dd hh:mm:ss");
	}
	function searchFun() {
		dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
		renderChart();
	}
	function cleanFun() {
		$('#searchForm input').val('');
		dataGrid.datagrid('load', {});
	}
	
	function viewFun(id){
		parent.$
		.modalDialog({
			title : '查看',
			width : 700,
			height : 330,
			href : '${pageContext.request.contextPath}/hades/payment/view.json?id=' + id,
			buttons : [{
				text : '关闭',
				handler : function() {
					parent.$.modalDialog.handler.dialog('close');					
				}
			}  ]
		});
	}
	$(function () {
        parent.$.messager.progress('close');
    });
	
	
</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false" style="height: 80px; overflow: hidden;">
			<form id="searchForm">
				<table class="table-more">
					<tr>
						<td>应用名称：<input id="grid-payment-list-keyword" name="appName" type="text" class="span2" /></td>
						<td>订单状态：<select name="orderStatus" id="orderStatus" class="span2">
							<option value="">全部</option>
							<c:forEach items="${orderStatusList}" var="orderStatus">
								<option value="${orderStatus.status}">${orderStatus.statusName}</option>
							</c:forEach></select>
						</td>
						<td>起始时间：<input type="text" id="grid-payment-list-timeStart" name="start" class="easyui-datebox" value="${start}"/></td>
                        <td>截止时间：<input type="text" id="grid-payment-list-timeEnd" name="end" class="easyui-datebox" value="${end}"/></td>
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