<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.点播价格管理}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">
<m:auth uri="/movie_charge/movie_charge_edit.json">
	$.canEdit = true;
</m:auth>

<m:auth uri="/movie_charge/delete.json">
	$.canDelete = true;
</m:auth>
</script>

<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid').datagrid({
			url : '/movie_charge/data_grid.json',
			fit : true,
			fitColumns : true,
			border : false,
			pagination : true,
			idField : 'id',
			pageSize : 10,
			pageList : [ 10, 20, 30, 40, 50 ],
			sortName : 'chargeName',
			sortOrder : 'asc',
			checkOnSelect : false,
			selectOnCheck : false,
			nowrap : false,
			singleSelect: true,
			frozenColumns : [ [ {
				field : 'chargeId',
				checkbox : true
			} ] ],
			columns : [ [ {
				field : 'chargeName',
				title : '${internationalConfig.方案名称}',
				width : 80,
				sortable : true
			}, {
				field : 'validTime',
				title : '${internationalConfig.有效期}',
				width : 60,
				sortable : true
			}, {
				field : 'memberDiscounts',
				title : '${internationalConfig.会员折扣}',
				width : 150,
				formatter : function(value) {
					var str = '';
					if("0" == value) {
						str = "${internationalConfig.原价}";
					}else if("1" == value) {
						str = "${internationalConfig.半价}";
					}
					return str;
				}
			}, {
				field : 'action',
				title : '${internationalConfig.操作}',
				width : 100,
				formatter : function(value, row, index) {
					var str = '';
					
					if ($.canEdit) {
						str += $.formatString('<img onclick="editFun(\'{0}\');" src="{1}" title="${internationalConfig.编辑}"/>', row.chargeId, '${pageContext.request.contextPath}/static/style/images/extjs_icons/bug/bug_edit.png');
					}
					str += '&nbsp;';
					
					if ($.canDelete) {
						str += $.formatString('<img onclick="deleteFun(\'{0}\');" src="{1}" title="${internationalConfig.删除}"/>', row.chargeId, '${pageContext.request.contextPath}/static/style/images/extjs_icons/bug/bug_delete.png');
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
	
	function deleteFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].chargeId;
		}
		
		parent.$.messager.confirm('${internationalConfig.询问}', '${internationalConfig.您是否要删除此信息}', function(b) {
			if (b) {
				var currentUserId = '${sessionInfo.uid}';/*当前登录用户的ID*/
				if (currentUserId != id) {
					parent.$.messager.progress({
						title : '${internationalConfig.提示}',
						text : '${internationalConfig.数据处理中}....'
					});
					$.post('/movie_charge/delete.json', {
						chargeId : id
					}, function(result) {
						if (result.code == 0) {
							parent.$.messager.alert('${internationalConfig.提示}', '${internationalConfig.删除成功}', 'info');
							dataGrid.datagrid('reload');
						}
						parent.$.messager.progress('close');
					}, 'JSON');
				} else {
					parent.$.messager.show({
						title : '${internationalConfig.提示}',
						msg : '${internationalConfig.不可以删除自己}'
					});
				}
			}
		});
	}

	function editFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].chargeId;
		}
		
		parent.$.modalDialog({
			title : '${internationalConfig.编辑}',
			width : 940,
			height : 400,
			href : '/movie_charge/movie_charge_edit.json?chargeId=' + id,
			buttons : [ {
				text : '${internationalConfig.保存}',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#form');
					f.submit();
				}
			} , {
				text : "${internationalConfig.取消}",
				handler : function() {
					parent.$.modalDialog.handler.dialog('close');
				}
			} ]
		});
	}

	function addFun() {
		parent.$.modalDialog({
			title : '${internationalConfig.增加}',
			width : 940,
			height : 400,
			href : '/movie_charge/movie_charge_add.json',
			buttons : [ {
				text : '${internationalConfig.增加}',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#form');
					f.submit();
				}
			} , {
				text : "${internationalConfig.取消}",
				handler : function() {
					parent.$.modalDialog.handler.dialog('close');
				}
			} ]
		});
	}

	function cleanFun() {
		$('#searchForm input').val('');
		dataGrid.datagrid('load', {});
	}
</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'center',border:false">
			<table id="dataGrid"></table>
		</div>
	</div>
	<div id="toolbar" style="display: none;">
		<m:auth uri="/movie_charge/movie_charge_add.json">
			<a onclick="addFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'pencil_add'">${internationalConfig.增加}</a>
		</m:auth>
	</div>

	<div id="menu" class="easyui-menu" style="width: 120px; display: none;">
	<m:auth uri="/movie_charge/movie_charge_add.json">
		<div onclick="addFun();" data-options="iconCls:'pencil_add'">${internationalConfig.增加}</div>
	</m:auth>
	<m:auth uri="/movie_charge/movie_charge_edit.json">
		<div onclick="editFun();" data-options="iconCls:'pencil'">${internationalConfig.编辑}</div>
	</m:auth>
	<m:auth uri="/movie_charge/delete.json">
		<div onclick="deleteFun();" data-options="iconCls:'pencil_delete'">${internationalConfig.删除}</div>
	</m:auth>
	</div>
</body>
</html>