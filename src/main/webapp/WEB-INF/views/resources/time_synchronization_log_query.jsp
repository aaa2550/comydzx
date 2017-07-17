<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>时长同步日志查询</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">
</script>

<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid')
				.datagrid(
						{
							url : '/time_synchronization_log/data_grid.json',
							queryParams:$.serializeObject($('#searchForm')),
							fit : true,
							fitColumns : true,
							border : false,
							pagination : true,
							idField : 'id',
							pageSize : 50,
							pageList : [ 10, 20, 30, 40, 50 ],
							checkOnSelect : false,
							selectOnCheck : false,
							sortName : 'sp',
							sortOrder : 'desc',
							nowrap : false,
							striped : true,
							rownumbers : true,
							singleSelect : true,
							frozenColumns : [ [ {
								field : 'id',
								title : '${internationalConfig.编号}',
								width : 150,
								hidden : true
							} ] ],
							columns : [ [
									{
										field : 'deviceVersion',
										title : '${internationalConfig.绑定设备类型}',
										width : 120,
										sortable : false
									},	
									{
										field : 'sn',
										title : 'sn',
										width : 120,
										sortable : false
									},
									{
										field : 'mac',
										title : 'mac',
										width : 180,
										sortable : false
									},
									{
										field : 'deviceKey',
										title : 'deviceKey',
										width : 150,
										sortable : false
									},
									{
										field : 'operator',
										title : '${internationalConfig.操作人}',
										width : 150,
										sortable : false
									},
									{
										field : 'businessId',
										title : '${internationalConfig.同步来源}',
										width : 240,
										sortable : false
									},
									{
										field : 'createTime',
										title : '${internationalConfig.操作时间}',
										width : 180,
										sortable : false
									},
									{
										field : 'productName',
										title : '${internationalConfig.会员名称}',
										width : 180,
										sortable : false
									},
									{
										field : 'productDuration',
										title : '${internationalConfig.会员时长}',
										width : 180,
										sortable : false,
										formatter: function(value,row){
											if(row.productDurationUnit==1){
												return value+'${internationalConfig.年}';
											}else if(row.productDurationUnit==2){
												return value+'${internationalConfig.月}';
											}else if(row.productDurationUnit==5){
												return value+'${internationalConfig.天}';
											}
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
		if (date = "Invalid Date") {
			return "";
		}
		return date.format("yyyy-MM-dd hh:mm:ss");
	}
	function searchFun() {
		var mac = $('#mac').val();
		var sn = $('#sn').val();
		var deviceKey = $('#deviceKey').val();
		if((mac==''||mac==undefined) && (sn==''||sn==undefined) && (deviceKey==''||deviceKey==undefined)){
			$.messager.alert('${internationalConfig.错误}', "deviceKey,mac,sn ${internationalConfig.至少输入一个参数}", 'error');
			return;
		}
		dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
	}
	function cleanFun() {
		$('#searchForm input').val('');
		dataGrid.datagrid('load', {});
	}
	
</script>
</head>
<body  >
	<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="bodyCls:'boss_common_scroll',region:'north',title:'${internationalConfig.查询条件}',border:false,height:'auto'">
			<form id="searchForm">
				<table class="table-td-more">
					<tr>
						<td>mac：<input name="mac" id="mac" class="span2"></input>
						</td>
						<td>sn：<input name="sn" id="sn" class="span2"></input>
						</td>
						<td>deviceKey：<input name="deviceKey" id="deviceKey" class="span2"></input>
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
			data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a><a
			href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_delete',plain:true"
			onclick="cleanFun();">${internationalConfig.清空条件}</a>
	</div>
	<!-- <div id="win" class="easyui-window" title="输入提示框" closed="true" 
	 collapsible="false" minimizable="false" maximizable="false" style="width:300px;height:100px;padding:5px;color: red;">  
	<font size="2">请输入完整的用户名! </font>  
    </div>  -->
</body>
</html>