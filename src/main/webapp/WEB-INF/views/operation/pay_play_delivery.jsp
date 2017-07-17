<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>付费播放页运营位投放管理</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>

<script type="text/javascript">
<m:auth uri="/pay_play_delivery/pay_play_delivery_edit.json">
	$.canEdit = true;
</m:auth>
<m:auth uri="/pay_play_delivery/delete.json">
	$.canDelete = true;
</m:auth>
<m:auth uri="/pay_play_delivery/pay_play_delivery_view.json">
$.canView = true;
</m:auth>
</script>

<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid').datagrid({
			url : '${pageContext.request.contextPath}/pay_play_delivery/data_grid.json',
			fit : true,
			fitColumns : true,
			border : false,
			pagination : true,
			idField : 'id',
			pageSize : 20,
			pageList : [ 10, 20, 30, 40, 50 ],
			sortName : 'id',
			sortOrder : 'desc',
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
				field : 'name',
				title : '项目名称',
				width : 80,
			}, {
				field : 'channel',
				title : '频道',
				width : 40,
				formatter : function(value) {
					var str = '未知';
					if("1" == value) {
						str = "电影";
					}else if("2" == value) {
						str = "电视剧";
					}
					
					return str;
				}
			},
			{
				field : 'pids',
				title : 'PID值',
				width : 100,
			}, {
				field : 'startTime',
				title : '开始时间',
				width : 40,
			},
			{
				field : 'endTime',
				title : '结束时间',
				width : 40,
			}, {
				field : 'statusDesc',
				title : '状态',
				width : 100,
			},  {
				field : 'action',
				title : '操作',
				width : 60,
				formatter : function(value, row, index) {
					var str = '';
					if ($.canEdit) {
						str += $.formatString('<img onclick="editFun(\'{0}\');" src="{1}" title="编辑"/>', row.id, '${pageContext.request.contextPath}/static/style/images/extjs_icons/pencil.png');
					}
					
					if($.canDelete) {
						str += '&nbsp;&nbsp;&nbsp;&nbsp;';
						str += $.formatString('<img onclick="deleteFun(\'{0}\');" src="{1}" title="删除"/>', row.id, '${pageContext.request.contextPath}/static/style/images/extjs_icons/bug/bug_delete.png');
					}
					
					if ($.canView) {
						str += '&nbsp;&nbsp;&nbsp;&nbsp;';
						str += $
								.formatString(
										'<img onclick="viewFun(\'{0}\');" src="{1}" title="查看"/>',
										row.id,
										'${pageContext.request.contextPath}/static/style/images/extjs_icons/bug/bug_link.png');
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
			title : '编辑付费播放页运营位投放配置',
			width : 850,
			height : 400,
			resizable : true,
			href : '${pageContext.request.contextPath}/pay_play_delivery/pay_play_delivery_edit.json?payPlayDeliveryId=' + id,
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
			}, {
				text : "关闭",
				handler : function() {
					parent.$.modalDialog.handler.dialog('close');
				}
			} ]
		});
	}
	
	function addFun() {
		parent.$.modalDialog({
			title : '添加付费播放页运营位投放配置',
			width : 850,
			height : 400,
			href : '${pageContext.request.contextPath}/pay_play_delivery/pay_play_delivery_add.json',
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
			}, {
				text : "关闭",
				handler : function() {
					parent.$.modalDialog.handler.dialog('close');
				}
			} ]
		});
	}
	
	function viewFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		}
		parent.$.modalDialog({
			title : '查看套餐',
			width : 900,
			height : 400,
			href : '${pageContext.request.contextPath}/pay_play_delivery/pay_play_delivery_view.json?payPlayDeliveryId='
					+ id,
			buttons : [ 
			{
				text : "关闭",
				handler : function() {
					parent.$.modalDialog.handler.dialog('close');
				}
			} ]
		});
	}

	function deleteFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		}
		parent.$.messager.confirm('询问', '您确定要删除当前配置吗？',
		function(b) {
			if (b) {
				parent.$.messager.progress({
					title : '提示',
					text : '数据处理中，请稍后....'
				});
				$.post(
					'${pageContext.request.contextPath}/pay_play_delivery/delete.json',
					{
						payPlayDeliveryId : id
					},
					function(result) {
						if (result.code == 0) {
							parent.$.messager
									.alert(
											'提示',
											'删除成功',
											'info');
							dataGrid
									.datagrid('reload');
						} else {
							parent.$.messager.alert('错误', '删除失败，请确认该配置处于线下状态', 'error');
						}
						parent.$.messager
								.progress('close');
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
				<table class="table-more" style="display: none;">
					<tr>
						<td>项目名称：<input name="name" class="span2" /></td>
						<td>频道：
							<select name="channel" class="span2">
							    <option value="-1" selected>全部</option>
								<option value="1">电影</option>
								<option value="2">电视剧</option>
							</select>
						</td>
						<td>PID值：<input name="pids" class="span2" /></td>
						<td>状态：
							<select name="status" class="span2">
							    <option value="-1" selected>全部</option>
								<option value="1">上线</option>
								<option value="2">下线</option>
							</select>
						</td>
						<td>位置栏不为空：
							<select name="imgValue" class="span2">
							    <option value="-1" selected>全部</option>
								<option value="1">位置1图片不为空</option>
								<option value="2">位置2图片不为空</option>
								<option value="3">位置3图片不为空</option>
								<option value="4">位置4图片不为空</option>
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
		<m:auth uri="/pay_play_delivery/pay_package_pre_add.json">
			<a onclick="addFun();" href="javascript:void(0);"
				class="easyui-linkbutton"
				data-options="plain:true,iconCls:'bug_add'">添加</a>
		</m:auth>
		<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">查询</a>
		<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="cleanFun();">清空条件</a>
	</div>

	<div id="menu" class="easyui-menu" style="width: 120px; display: none;">
		<div onclick="editFun();" data-options="iconCls:'pencil'">编辑</div>
	</div>
</body>
</html>