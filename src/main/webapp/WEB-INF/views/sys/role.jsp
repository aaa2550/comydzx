<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.角色管理}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">
<m:auth uri="/role/edit.json">
$.canEdit = true;
</m:auth>
<m:auth uri="/role/delete.json">
$.canDelete = true;
</m:auth>
<m:auth uri="/role/grant.json">
$.canGrant = true;
</m:auth>
</script>
<script type="text/javascript">
	var treeGrid;
	$(function() {
		treeGrid = $('#treeGrid').treegrid({
			url : '/role/list.json',
			idField : 'id',
			treeField : 'name',
			parentField : 'pid',
			fit : true,
			fitColumns : false,
			border : false,
			nowrap : true,
			frozenColumns : [ [ {
				title : '${internationalConfig.编号}',
				field : 'id',
				width : 150,
				hidden : true
			}, {
				field : 'name',
				title : '${internationalConfig.角色名称}',
				width : 150
			} ] ],
			columns : [ [ {
				field : 'seq',
				title : '${internationalConfig.排序}',
				width : 40
			}, {
				field : 'pid',
				title : '${internationalConfig.上级角色}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>ID',
				width : 150,
				hidden : true
			}, {
				field : 'pname',
				title : '${internationalConfig.上级角色}',
				width : 80,
				hidden : true
			}, {
				field : 'ridNames',
				title : '${internationalConfig.拥有资源}',
				width : 250
			},  {
				field : 'remark',
				title : '${internationalConfig.备注}',
				width : 150,
				formatter : function(value, row, index) {
					if (value) {
						return $.formatString('<span title="{0}">{1}</span>', value, value);
					}
					return '';
				}
			}, {
				field : 'action',
				title : '${internationalConfig.操作}',
				width : 70,
				formatter : function(value, row, index) {
					var str = '';
					if ($.canEdit) {
						str += $.formatString('<img onclick="editFun(\'{0}\');" src="{1}" title="${internationalConfig.编辑}"/>', row.id, '/static/style/images/extjs_icons/bug/bug_edit.png');
					}
					str += '&nbsp;';
					if ($.canGrant) {
						str += $.formatString('<img onclick="grantFun(\'{0}\');" src="{1}" title="${internationalConfig.授权}"/>', row.id, '/static/style/images/extjs_icons/key.png');
					}
					str += '&nbsp;';
					if ($.canDelete) {
						str += $.formatString('<img onclick="deleteFun(\'{0}\');" src="{1}" title="${internationalConfig.删除}"/>', row.id, '/static/style/images/extjs_icons/bug/bug_delete.png');
					}
					return str;
				}
			} ] ],
			toolbar : '#toolbar',
			onContextMenu : function(e, row) {
				e.preventDefault();
				$(this).treegrid('unselectAll');
				$(this).treegrid('select', row.id);
				$('#menu').menu('show', {
					left : e.pageX,
					top : e.pageY
				});
			},
			onLoadSuccess : function() {
				parent.$.messager.progress('close');
			}
		});
	});

	function deleteFun(id) {
		if (id != undefined) {
			treeGrid.treegrid('select', id);
		}
		var node = treeGrid.treegrid('getSelected');
		if (node) {
			parent.$.messager.confirm('${internationalConfig.询问}', '${internationalConfig.您是否要删除当前角色}？', function(b) {
				if (b) {
					parent.$.messager.progress({
						title : '${internationalConfig.提示}',
						text : '${internationalConfig.数据处理中}'
					});
					$.post('/role/delete.json', {
						id : node.id
					}, function(result) {
						if (result.code==0) {
							parent.$.messager.alert('${internationalConfig.提示}', "${internationalConfig.操作管理}", 'info');
							treeGrid.treegrid('reload');
						}
						parent.$.messager.progress('close');
					}, 'JSON');
				}
			});
		}
	}

	function editFun(id) {
		if (id != undefined) {
			treeGrid.treegrid('select', id);
		}
		var node = treeGrid.treegrid('getSelected');
		if (node) {
			parent.$.modalDialog({
				title : '${internationalConfig.编辑角色}',
				width : 500,
				height : 300,
				href : '${pageContext.request.contextPath}/role/edit_page?id=' + node.id,
				buttons : [ {
					text : '${internationalConfig.保存}',
					handler : function() {
						parent.$.modalDialog.openner_treeGrid = treeGrid;//因为添加成功之后，需要刷新这个treeGrid，所以先预定义好
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
	}

	function addFun() {
		parent.$.modalDialog({
			title : '${internationalConfig.添加角色}',
			width : 500,
			height : 300,
			href : '${pageContext.request.contextPath}/role/edit_page',
			buttons : [ {
				text : '${internationalConfig.添加}',
				handler : function() {
					parent.$.modalDialog.openner_treeGrid = treeGrid;//因为添加成功之后，需要刷新这个treeGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#form');
					f.submit();
				}
			}  , {
				text : "${internationalConfig.取消}",
				handler : function() {
					parent.$.modalDialog.handler.dialog('close');
				}
			} ]
		});
	}

	function redo() {
		var node = treeGrid.treegrid('getSelected');
		if (node) {
			treeGrid.treegrid('expandAll', node.id);
		} else {
			treeGrid.treegrid('expandAll');
		}
	}

	function undo() {
		var node = treeGrid.treegrid('getSelected');
		if (node) {
			treeGrid.treegrid('collapseAll', node.id);
		} else {
			treeGrid.treegrid('collapseAll');
		}
	}

	function grantFun(id) {
		if (id != undefined) {
			treeGrid.treegrid('select', id);
		}
		var node = treeGrid.treegrid('getSelected');
		if (node) {
			parent.$.modalDialog({
				title : '${internationalConfig.角色授权}',
				width : 500,
				height : 500,
				href : '/role/grant_page?id=' + node.id,
				buttons : [ {
					text : '${internationalConfig.授权}',
					handler : function() {
						parent.$.modalDialog.openner_treeGrid = treeGrid;//因为添加成功之后，需要刷新这个treeGrid，所以先预定义好
						var f = parent.$.modalDialog.handler.find('#form');
						f.submit();
					}
				} ]
			});
		}
	}
</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit:true,border:false">
		<div data-options="region:'center',border:false" title="" style="overflow: hidden;">
			<table id="treeGrid"></table>
		</div>
	</div>
	<div id="toolbar" style="display: none;">
		<m:auth uri="/role/edit.json">
			<a onclick="addFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'pencil_add'">${internationalConfig.添加}</a>
		</m:auth>
		<a onclick="redo();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'resultset_next'">${internationalConfig.展开}</a> <a onclick="undo();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'resultset_previous'">${internationalConfig.折叠}</a> <a onclick="treeGrid.treegrid('reload');" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'transmit'">${internationalConfig.刷新}</a>
	</div>

	<div id="menu" class="easyui-menu" style="width: 120px; display: none;">
		<div onclick="addFun();" data-options="iconCls:'pencil_add'">${internationalConfig.增加}</div>
		<div onclick="deleteFun();" data-options="iconCls:'pencil_delete'">${internationalConfig.删除}</div>
		<div onclick="editFun();" data-options="iconCls:'pencil'">${internationalConfig.编辑}</div>
	</div>
</body>
</html>