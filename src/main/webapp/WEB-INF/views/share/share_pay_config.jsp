<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>付费分成配置</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">
<m:auth uri="/share_pay_config/delete.json">  $.canDelete = true;</m:auth>
<m:auth uri="/share_pay_config/edit.json">  $.canEdit = true;</m:auth>
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid').datagrid({
			url : '${pageContext.request.contextPath}/share_pay_config/data_grid.json',
			fit : true,
			fitColumns : true,
			border : false,
			pagination : true,
			idField : 'id',
			pageSize : 20,
			pageList : [ 10, 20, 30, 40, 50 ],
			sortName : 'albumId',
			sortOrder : 'asc',
			checkOnSelect : false,
			selectOnCheck : false,
			singleSelect: true,
			nowrap: false,
	        striped: true,
	        rownumbers: true,
	        singleSelect: true,
			frozenColumns: [
            [
                {
                    field: 'id',
                    title: '编号',
                    width: 50,
                    hidden: true
                }
            ]
        ],
			columns : [ [ 
			{
				field : 'albumId',
				title : '专辑ID',
				width : 80,
				sortable : true
			},
			{
				field : 'albumName',
				title : '专辑名称',
				width : 100,
				sortable : true
			},
			{
				field : 'copyrightCompany',
				title : '版权方',
				width : 100,
				sortable : true
			},
            {
				field : 'payBeginTime',
				title : '开始时间',
				width : 60
			},
			{
				field : 'payEndTime',
				title : '结束时间',
				width : 60
			}, 
			{
				field : 'price',
				title : '付费分成价格',
				width : 50
			},
			{
				field : 'ratio',
				title : '分成系数',
				width : 30
			}, 
			{
				field : 'action',
				title : '操作',
				width : 80,
				formatter : function(value, row, index) {
					var str = '';
					if ($.canEdit) {
						str += String.format('<img onclick="editFun(\'{0}\');" src="{1}" title="编辑"/>', row.id, '${pageContext.request.contextPath}/static/style/images/extjs_icons/pencil.png');
					}
					if ($.canDelete) {
						str += String.format('<img onclick="deleteFun(\'{0}\');" src="{1}" title="删除"/>', row.id, '${pageContext.request.contextPath}/static/style/images/extjs_icons/pencil_delete.png');
					}
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
	
	//编辑信息
	function editFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		}
		parent.$.modalDialog({
			title : '编辑付费分成信息',
			width : 1000,
			height : 500,
			resizable : true,
			href : '${pageContext.request.contextPath}/share_pay_config/edit.json?id=' + id,
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
			title : '新增付费分成信息',
			width : 1000,
			height : 500,
			resizable : true,
			href : '${pageContext.request.contextPath}/share_pay_config/add.json',
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
	function deleteFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		}
		parent.$.messager.confirm('询问', '您是否要删除配置？', function(b) {
			if (b) {
				parent.$.messager.progress({
					title : '提示',
					text : '数据处理中，请稍后....'
				});
				$.post('${pageContext.request.contextPath}/share_pay_config/delete.json', {
					id : id
				}, function(result) {
					if (result.code == 0) {
						parent.$.messager.alert('提示', '成功', 'info');
						searchFun();
					}else{
						parent.$.messager.alert('提示', '失败', 'info');
					}
					parent.$.messager.progress('close');
				}, 'JSON');
			}
		});
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
		<div data-options="region:'north',title:'查询条件',border:false" style="height: 80px; overflow: hidden;">
			<form id="searchForm">
				<table class="table table-hover table-condensed" style="display: none;">
					<tr>
					    <td>专辑ID：<input name="albumId" class="span2" /></td>
					    
						<td>专辑名称：<input name="albumName" class="span2" /></td>
					</tr>
				</table>
			</form>
		</div>
		<div data-options="region:'center',border:false">
			<table id="dataGrid"></table>
		</div>
	</div>
	<div id="toolbar" style="display: none;">
		<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a>
		<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="addFun();">增加</a>
		<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="cleanFun();">清空条件</a>
	</div>

	<div id="menu" class="easyui-menu" style="width: 120px;">
		<div onclick="editFun();" data-options="iconCls:'pencil'">编辑</div>
		<div onclick="deleteFun();" data-options="iconCls:'brick_delete'">删除</div>
	</div>
</body>
</html>