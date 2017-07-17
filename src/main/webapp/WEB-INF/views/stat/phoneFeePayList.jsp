<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>话费支付信息查询</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script src="${pageContext.request.contextPath}/static/lib/highcharts/highcharts.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/static/lib/highcharts/exporting.js" type="text/javascript"></script>

<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid')
				.datagrid(
						{
							url : '${pageContext.request.contextPath}/phoneFeePayController/packageList',
							fit: false,
			                fitColumns: false,
			                border: false,
			                pagination: true,
			                idField: 'id',
							pageSize : 50,
							pageList : [ 10, 20, 30, 40, 50 ],
							sortName: 'queryDate',
			                sortOrder: 'asc',
							checkOnSelect : false,
							selectOnCheck : false,
							nowrap : false,
							striped : true,
							rownumbers : true,
							singleSelect : true,
							remoteSort: false,
							frozenColumns: [
						                    [
						                    ]
						                ],
							columns : [ [
									{
										field: 'queryDate',
					                    title: '日期',
					                    width: 180,
					                    sortable: true
									},
									{
										field : 'keepUserNo',
										title : '留存用户数',
										width : 180,
										sortable : true,
									},
									{
										field : 'succOrderNo',
										title : '订购数',
										width : 180,
										sortable : true
									},
									{
										field : 'cancelNo',
										title : '退订数',
										width : 180,
										sortable : true
									},
									{
										field : 'validOrderNo',
										title : '有效订购数',
										width : 180,
										sortable : true
									},
									{
										field : 'validInfoFee',
										title : '有效信息费',
										width : 180,
										sortable : true
									},
									{
										field : 'forecastIncome',
										title : '预估收入',
										width : 180,
										sortable : true
									},
									{
										field : 'orderNo',
										title : '订单数',
										width : 180,
										sortable : true
									},
									{
										field : 'paySuccRate',
										title : '支付成功率',
										width : 180,
										sortable : true
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
	function searchFun() {
		dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
	}
	function cleanFun() {
		$('#searchForm input').val('');
		dataGrid.datagrid('load', {});
	}
</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',title:'查询条件',border:false"
			style="height: 120px; overflow: hidden;">
			<form id="searchForm">
				<table class="table table-hover table-condensed"
					style="display: none;">
					<tr>
	                    <td>开始日期</td>
	                    <td>结束日期</td>
	                    <td>会员类型</td>
	                    <td>终端</td>
	                    <td>运营商</td>
	                </tr>
					<tr>
						<td><input id="begin" name="beginDate"
							class="easyui-datebox" value="${start}" style="width: 160px; height: 29px"></input>
						</td>
						<td><input id="end" name="endDate"
							class="easyui-datebox" value="${end}" style="width: 160px; height: 29px"></input>
						</td>
						<td><select name="svip" style="width: 160px;">
								<option value="-1" selected>全部</option>
								<option value="1">移动影视会员</option>
								<option value="9">全屏影视会员</option>
							</select>
						</td>
						<td><select name="terminal" style="width: 160px;">
								<option value="-1" selected>全部</option>
								<option value="112">PC</option>
								<option value="111">TV</option>
								<option value="130">移动</option>
								<option value="113">M站</option>
							</select>
						</td>
						<td><select name="sp" style="width: 160px;">
								<option value="-1" selected>全部</option>
								<option value="00">联通</option>
								<option value="02">移动</option>
								<option value="01">电信</option>
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
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a><a
			href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_delete',plain:true"
			onclick="cleanFun();">清空条件</a>
	</div>
</body>
</html>