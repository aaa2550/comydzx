<%@ page contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh">
<head>
<title>${internationalConfig.用户支付信息查询}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid')
				.datagrid(
						{
							url : '${pageContext.request.contextPath}/user_log/list.json',
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
							sortName : 'operateTime',
							sortOrder : 'desc',
							rownumbers : true,
							singleSelect : true,
							frozenColumns : [ [ {
								field : 'operateUid',
								title : '${internationalConfig.编号}',
								width : 80,							
								hidden : true
							} ] ],
							columns : [ [ {
								field : 'operater',
								title : '${internationalConfig.用户名}',
								width : 80,
								sortable : false
							}, {
								field : 'operateIp',
								title : '${internationalConfig.IP地址}',
								width : 80,
								sortable : false
							}, {
								field : 'operateTime',
								title : '${internationalConfig.操作时间}',
								width : 80,
								sortable : true
							}, {
								field : 'operation',
								title : '${internationalConfig.操作}',
								width : 80,				
								sortable : false

							}, {
								field : 'ext',
								title : '${internationalConfig.操作详细}',
								width : 250,
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
	
	function searchFun() {
		dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
	}
	function cleanFun() {
		$('#searchForm input').val('');
		dataGrid.datagrid('load', {});
	}
</script>
<style type="text/css">
.table th, .table td{
	border:none;
}
</style>
</head>

<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false"
			style="height: 130px; overflow: hidden; padding-top:10px;">
			<form id="searchForm">
				<table class="table table-hover table-condensed"
					style="display: none;">
					<tr>
						<th></th>
						<td>${internationalConfig.用户名}：<input name="operater"
							class="easyui-validatebox"></input>
						</td>
						<td>${internationalConfig.用户}&nbsp;ip：<input name="operateIp"
							class="easyui-validatebox"></input>
						</td>
						<td>${internationalConfig.起始时间}：<input name="operateTime"
							class="easyui-datebox" class="easyui-validatebox"></input>
						</td>
						<td>${internationalConfig.截止时间}：<input  name="endTime"
							class="easyui-datebox" class="easyui-validatebox"></input>
						</td>
					</tr>
					<tr>
						<th></th>
						<td>${internationalConfig.操作}：<input id="operation" name="operation"
							class="easyui-validatebox"></input>
						</td>
						<td>${internationalConfig.操作详细}：<input id="ext" name="ext"
							class="easyui-validatebox"></input>
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
			onclick="cleanFun();">${internationalConfig.清除条件}</a>
		<!--<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="exportExcel();">导出excel</a> -->
	</div>

</body>
</html>