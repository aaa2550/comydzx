<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>活动成功页配置管理</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>

<script type="text/javascript">
<m:auth uri="/activity_success/activity_success_edit.json">
	$.canEdit = true;
</m:auth>
<m:auth uri="/activity_success/activity_success_delete.json">
	$.canDelete = true;
</m:auth>
<m:auth uri="/activity_success/activity_success_view.json">
	$.canView = true;
</m:auth>
</script>

<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid').datagrid({
			url : '${pageContext.request.contextPath}/activity_success/data_grid.json',
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
				field : 'activityName',
				title : '活动名称',
				width : 80,
				sortable : true
			},
			{
				field : 'packageDesc',
				title : '套餐描述',
				width : 100,
				sortable : true
			},
			{
				field : 'terminalsDesc',
				title : '所属终端描述',
				width : 100,
				sortable : true
			},
			{
				field : 'groupIdsDesc',
				title : '所属分组',
				width : 80,
			}, {
				field : 'status',
				title : '状态',
				width : 150,
				formatter : function(value) {
					var str = '';
					if("0" == value) {
						str = "下线";
					}else if("1" == value) {
						str = "上线";
					}
					
					return str;
				}
			},  {
				field : 'action',
				title : '操作',
				width : 100,
				formatter : function(value, row, index) {
					var str = '';
					if ($.canEdit) {
						str += $.formatString('<img onclick="editFun(\'{0}\');" src="{1}" title="编辑"/>', row.id, '${pageContext.request.contextPath}/static/style/images/extjs_icons/pencil.png');
					}
					
					if($.canView) {
						str += '&nbsp;&nbsp;';
						str += $.formatString('<img onclick="viewFun(\'{0}\');" src="{1}" title="明细"/>', row.id, '${pageContext.request.contextPath}/static/style/images/extjs_icons/bug/bug_link.png');
					}
					
					if($.canDelete) {
						str += '&nbsp;&nbsp;';
						str += $.formatString('<img onclick="deleteFun(\'{0}\');" src="{1}" title="删除"/>', row.id, '${pageContext.request.contextPath}/static/style/images/extjs_icons/bug/bug_delete.png');
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
			title : '编辑活动成功页配置',
			width : 620,
			height : 500,
			resizable : true,
			href : '${pageContext.request.contextPath}/activity_success/activity_success_edit.json?activitySuccessCfgId=' + id,
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
			title : '添加活动成功页配置',
			width : 620,
			height : 500,
			href : '${pageContext.request.contextPath}/activity_success/activity_success_add.json',
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

	function viewFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		}
		parent.$.modalDialog({
			title : '查看套餐',
			width : 600,
			height : 500,
			href : '${pageContext.request.contextPath}/activity_success/activity_success_view.json?activitySuccessCfgId='
					+ id,
			onClose:function(){
				this.parentNode.removeChild(this);
			},
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
					'${pageContext.request.contextPath}/activity_success/delete.json',
					{
						activitySuccessCfgId : id
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
					    
						<td>活动名称：<input name="activityName" class="span2" /></td>
						<td>关联会员套餐：
							<select name="packageId" class="span2">
							    <option value="-1" selected>全部</option>
								<c:forEach items="${vipList}" var="vip">
									<option value="${vip.id}">${vip.packageNameDesc}_${vip.durationDesc}</option>
								</c:forEach>
							</select>
						</td>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;状态：
							<select name="status" class="span2">
							    <option value="-1" selected>全部</option>
								<option value="0">下线</option>
								<option value="1">上线</option>
							</select>
						</td>
						<td>所属分组：<select class="span2" name="groupId" style="margin-top: 5px">
								<option value="0" selected="selected">所有分组</option>
								<c:forEach items="${packageGroups}" var="pg">
									<c:if test="${pg == '1'}">
										<option value="${pg}">默认</option>
									</c:if>
									<c:if test="${pg != '1'}">
									<option value="${pg}">${pg}</option>
									</c:if>
								</c:forEach>
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
		<m:auth uri="/activity_success/activity_success_add.json">
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