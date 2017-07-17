<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<title>活动配置管理</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>

<script type="text/javascript">
<m:auth uri="/activity/buysend/edit.json">
	$.canEdit = true;
</m:auth>
<m:auth uri="/activity/buysend/delete.json">
	$.canDelete = true;
</m:auth>
</script>

<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = renderDataGrid('${pageContext.request.contextPath}/activity/buysend/data_grid.json');
	});

	function renderDataGrid(url) {
		return $('#dataGrid')
				.datagrid(
						{
							url : url,
							fit : true,
							fitColumns : true,
							border : false,
							pagination : true,
							idField : 'id',
							pageSize : 50,
							pageList : [ 50, 100 ],
							sortName : 'id',
							sortOrder : 'asc',
							checkOnSelect : false,
							selectOnCheck : false,
							nowrap : false,
							striped : true,
							rownumbers : true,
							singleSelect : true,
							frozenColumns : [ [ {
								field : 'id',
								title : '活动ID',
								width : 150,
								hidden : true
							} ] ],
							columns : [ [
									{
										field : 'id',
										title : '活动Id',
										width : 80,
										sortable : false
									},
									{
										field : 'name',
										title : '名称',
										width : 100,
										sortable : false
									},
									{
										field : 'status',
										title : '状态',
										width : 50,
										sortable : false,
										formatter : function(value) {
											if (value == 0) {
												return "下线";
											}
											if (value == 1) {
												return "上线";
											}
										}
									},
									{
										field : 'activityMode',
										title : '活动方式',
										width : 80,
										sortable : false,
										formatter : function(value) {
											if (value == 1) {
												return "单活动买赠实物";
											}
											if (value == 2) {
												return "单活动买赠虚拟";
											}
											if (value == 3) {
												return "双活动买赠实物";
											}
											if (value == 4) {
												return "双活动买赠虚拟";
											}
										}
									},
									{
										field : 'startTime',
										title : '活动开始时间',
										width : 100,
										sortable : false

									},
									{
										field : 'endTime',
										title : '活动结束时间',
										width : 100,
										sortable : false

									},
									{
										field : 'createTime',
										title : '活动创建时间',
										width : 100,
									},
									{
										field : 'updateTime',
										title : '活动更新时间',
										width : 100,
									},
									{
										field : 'action',
										title : '操作',
										width : 100,
										formatter : function(value, row, index) {
											var str = '';
											
											if ($.canEdit) {
												str += $
														.formatString(
																'<img onclick="editFun(\'{0}\');" src="{1}" title="编辑"/>',
																row.id,
																'${pageContext.request.contextPath}/static/style/images/extjs_icons/bug/bug_edit.png');
											}
									
											str += '&nbsp;';											
											return str;
										}
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
	}

	function editFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		}

		parent.$.modalDialog({
			title : '编辑活动',
			width : 780,
			height : 500,
			href : '${pageContext.request.contextPath}/activity/buysend/edit.json?activityId='
					+ id,
			onClose:function(){
				this.parentNode.removeChild(this);
			},		
			buttons : [ {
				text : '保存',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#form');
					f.submit();
				}
			} ]
		});
	}

	function addFun() {
		parent.$.modalDialog({
			title : '添加活动',
			width : 780,
			height : 600,
			href : '${pageContext.request.contextPath}/activity/buysend/add.json',
			onClose:function(){
				this.parentNode.removeChild(this);
			},	
			buttons : [ {
				text : '添加',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#form');
					f.submit();
				}
			} ]
		});
	}

	function searchFun() {
		parent.$.messager.progress({
			title : '提示',
			text : '数据处理中，请稍后....'
		});
		renderDataGrid('${pageContext.request.contextPath}/activity/buysend/data_grid.json?'
				+ $('#searchForm').serialize());
		parent.$.messager.progress('close');
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
			style="overflow: hidden;height:85px;">
			<form id="searchForm">
				<table  class="table-more">
					<tr>
						<td>活动ID:<input type=text name="id"/></td>
						<td>活动名称：<input type=text name="name"/></td>
						<td>开始时间：<input id="begin" name="startTime"
                                    class="easyui-datebox">
                    --<input id="end" name="endTime"
                                    class="easyui-datebox"></td>
						<td>活动状态：<select class="span2" name="status" style="margin-top: 5px">
								<option value="-1" selected="selected">所有状态</option>
								<option value="1">上线</option>
								<option value="0">下线</option>
						</select></td>
					</tr>
				</table>
			</form>
		</div>
		<div data-options="region:'center',border:false">
			<table id="dataGrid"></table>
		</div>
	</div>
	<div id="toolbar" style="display: none;">

			<a onclick="addFun();" href="javascript:void(0);"
				class="easyui-linkbutton"
				data-options="plain:true,iconCls:'bug_add'">添加</a>

		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a>
	</div>

	<div id="menu" class="easyui-menu" style="width: 120px; display: none;">
		<div onclick="addFun();" data-options="iconCls:'pencil_add'">增加</div>
		<div onclick="deleteFun();" data-options="iconCls:'pencil_delete'">删除</div>
		<div onclick="editFun();" data-options="iconCls:'pencil'">编辑</div>
	</div>
</body>
</html>