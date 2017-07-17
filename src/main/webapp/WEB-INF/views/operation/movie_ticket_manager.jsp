<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>免费会员-渠道管理</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid')
				.datagrid(
						{
							url : '/movie_ticket/manager/data_grid',
							queryParams:$.serializeObject($('#searchForm')),
							fit : true,
							fitColumns : true,
							border : false,
							pagination : true,
							idField : 'id',
							pageSize : 20,
							pageList : [ 10, 20, 30, 40, 50 ],
							sortName : 'id',
							sortOrder : 'asc',
							checkOnSelect : false,
							selectOnCheck : false,
							singleSelect : true,
							nowrap : false,
							striped : true,
							rownumbers : false,
							singleSelect : true,
							frozenColumns : [ [ {
								field : 'id',
								title : '编号',
								width : 50,
								hidden : true
							} ] ],
							columns : [ [
									{
										field : 'id',
										title : '渠道id',
										width : 20,
										sortable : false
									},{
										field : 'name',
										title : '渠道名称',
										width : 60,
									},{
										field : 'description',
										title : '观影卷描述',
										width : 200,
									}
									,{
										field : 'days',
										title : '观影卷有效期',
										width : 30,
									},
									{
										field : 'weight',
										title : '权重',
										width : 30,
									}
									,{
										field : 'sendHz',
										title : '赠送人频次',
										width : 30,
									}
									,{
										field : 'receiveHz',
										title : '领取人频次',
										width : 30,
									},{
										field : 'eachCount',
										title : '每次赠送张数',
										width : 30,
									}
									,{
										field : 'eachNum',
										title : '每次赠送人数',
										width : 30,
									},
									{
										field : 'operator',
										title : '操作者',
										width : 40
									},
									{
										field : 'start',
										title : '开始时间',
										width : 60,
										sortable : true
									},
									{
										field : 'end',
										title : '结束时间',
										sortable : true,
										width : 60
									},
									{
										field : 'updateTime',
										title : '更新时间',
										width : 60,
										sortable : true
									},
									{
										field : 'action',
										title : '操作',
										width : 60,
										formatter : function(value, row, index) {
											var str = '';
											
											str += $.formatString('<img onclick="addFun(\'{0}\');" src="{1}" title="编辑"/>', row.id, '/static/style/images/extjs_icons/pencil.png');
								
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
	});
	


	function searchFun() {
		dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
	}
	function cleanFun() {
		$('#searchForm input').val('');
		dataGrid.datagrid('load', {});
	}
	function addFun(id){
		parent.$.modalDialog({
			title : '赠送观影卷管理',
			width : 500,
			height : 600,
			href : '/movie_ticket/manager/edit?id='+id,
			buttons : [ {
				text : '保存',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;
					var f = parent.$.modalDialog.handler.find('#form');
					f.submit();
				}
			} ]
		});
	}
</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',title:'查询条件',border:false"
			style="height: 80px; overflow: hidden;">
			<form id="searchForm">
				<table class="table-td-two"
				>
					<tr>
						<td>渠道名称：<input name="name" class="span2"/></td>
					
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
			data-options="iconCls:'pencil_add',plain:true" onclick="addFun(0);">添加</a>
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a>
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'brick_delete',plain:true"
			onclick="cleanFun();">清空条件</a>
	</div>
</body>
</html>