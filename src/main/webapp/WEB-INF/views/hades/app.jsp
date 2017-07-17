<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>应用列表</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>

<script type="text/javascript">
<m:auth uri="/hades/app/edit.json">  $.canEdit = true;</m:auth>
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid')
				.datagrid(
						{
							url : '${pageContext.request.contextPath}/hades/app/data_grid.json',
							fit : true,
							fitColumns : true,
							border : false,
							pagination : true,
							idField : 'id',
							pageSize : 50,
							pageList : [ 10, 20, 30, 40, 50 ],
							checkOnSelect : false,
							selectOnCheck : false,
							nowrap : false,
							striped : true,
							rownumbers : true,
							singleSelect : true,
							frozenColumns : [ [ {
								field : 'id',
								title : '应用ID',
								width : 80,
								hidden : true
							} ] ],
							columns : [ [ {
								field : 'id',
								title : '应用ID',
								width : 40,
								sortable : true
							},{
								field : 'name',
								title : '应用名字',
								width : 200
							}, {
								field : 'status',
								title : '状态',
								width : 80,
								formatter : function(value, row, index) {
									if (value == 'ACTIVE') {
										return "<font style='color:green;'>有效</font>";
									} else {
										return "<font style='color:red;'>无效</font>";
									}
								}
							}, {
								field : 'createTime',
								title : '创建时间',
								width : 130,
								sortable : true
							}, {
								field : 'updateTime',
								title : '更新时间',
								width : 130,
								sortable : true
							}, {
								field : 'createdBy',
								title : '操作者',
								width : 100,
								formatter : function(value, row, index) {
									if (row.updatedBy) {
										return value +"," +  row.updatedBy;
									} 
									return value;
								}
							},{
								field : 'action',
								title : '操作',
								width : 100,
								formatter : function(value, row, index) {
									var str = '&nbsp;&nbsp;&nbsp;';
			                        if ($.canEdit) {
			                            str += $.formatString('<img onclick="editFun(\'{0}\');" src="{1}" title="编辑"/>', row.id, '/static/style/images/extjs_icons/bug/bug_edit.png');
			                        }
			                        return str;
								}
							}] ],
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
	
	function addFun(){
		parent.$
		.modalDialog({
			title : '应用添加',
			width : 680,
			height : 400,
			href : '${pageContext.request.contextPath}/hades/app/add.json',
			buttons : [ {
				text : '确认',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#form');
					f.submit();
				}
			},{
				text : '关闭',
				handler : function() {
					parent.$.modalDialog.handler.dialog('close');					
				}
			}  ]
		});
	}
	
	function editFun(id){
		parent.$
		.modalDialog({
			title : '应用编辑',
			width : 680,
			height : 400,
			href : '${pageContext.request.contextPath}/hades/app/edit.json?id=' + id,
			buttons : [ {
				text : '确认',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#form');
					f.submit();
				}
			},{
				text : '关闭',
				handler : function() {
					parent.$.modalDialog.handler.dialog('close');					
				}
			}  ]
		});
	}
</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
    <div data-options="region:'north',title:'查询条件',border:false" style="height: 80px; overflow: hidden;">
			<form id="searchForm">
				<table style="display: none;" class="table-td-two">
					<tr>
						<td>app应用名称：<input id="name" name="name" class="span2"></input>
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
		<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true"
			onclick="cleanFun();">清空条件</a> 
		<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true"
			onclick="addFun();">添加</a> 
	</div>
</body>
</html>