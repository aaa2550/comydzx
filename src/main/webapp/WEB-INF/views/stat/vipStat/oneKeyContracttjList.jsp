<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>一键支付统计</title>
 <%@ include file="/WEB-INF/views/inc/head.inc"%>

<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid')
				.datagrid(
						{
							url : '${pageContext.request.contextPath}/vipController/oneKeyContracttjList',
							fit : true,
							fitColumns : true,
							border : false,
							pagination : true,
							idField : 'id',
							pageSize : 10,
							pageList : [ 10, 20, 50, 100, 1000 ],
							checkOnSelect : false,
							selectOnCheck : false,
							nowrap : false,
							striped : true,

							rownumbers : true,
							singleSelect : true,

							columns : [ [ {
								field : 'tjDate',
								title : '日期',
								width : 80,
								sortable : false
							}, {
								field : 'contractTotalCount',
								title : '新增发起一键支付绑定人数',
								width : 100,
								sortable : false
							}, {
								field : 'contractSuccessCount',
								title : '新增成功绑定一键支付人数',
								width : 100,
								sortable : false

							}, {
								field : 'contractSuccessCountRate',
								title : '一键支付绑定成功率',
								width : 100,
								sortable : false
							}, {
								field : 'totalCount',
								title : '累计成功绑定一键支付人数',
								width : 100,
								sortable : false
							}, {
								field : 'rennewCount',
								title : '绑定一键支付且开通自动续费人数',
								width : 110,
								sortable : false
							}, {
								field : 'rennewCountRate',
								title : '自动续费签约率',
								width : 100,
								sortable : false
							} ] ],
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
		if (val == null) {
			return "";
		}
		var date = new Date(val);
		return date.format("yyyy-MM-dd");
	}
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
			style="height: 80px; overflow: hidden;">
			<form id="searchForm">
				<table class="table table-hover table-condensed"
					style="display: none;">
					<tr>
						<th></th>
					 
						<td>起始时间：<input id="startDate" name="startDate"
							class="easyui-datebox" class="easyui-validatebox" value="${startDate}"></input>
						</td>
						<td>截止时间：<input id="endDate" name="endDate"
							class="easyui-datebox" class="easyui-validatebox" value="${endDate}"></input>
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
			data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a>
		<!--<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="exportExcel();">导出excel</a> -->
	</div>

</body>
</html>