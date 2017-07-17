<%@ page contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh">
<head>
<title>${internationalConfig.资源管理}</title>
	<%@ include file="/WEB-INF/views/inc/head.inc"%>
<m:auth uri="/sys/edit.json">
	<script type="text/javascript">
		$.canEdit = true;
	</script>
</m:auth>
<m:auth uri="/sys/delete.json">
	<script type="text/javascript">
		$.canDelete = true;
	</script>
</m:auth>
<script type="text/javascript">
	var treeGrid;
	$(function() {
		treeGrid = $('#treeGrid').treegrid({
			url : '${pageContext.request.contextPath}/sys/list.json',
			idField : 'id',
			treeField : 'name',
			parentField : 'pid',
			fit : true,
			fitColumns : false,
			border : false,
			frozenColumns : [ [ {
				title : '${internationalConfig.编号}',
				field : 'id',
				width : 150,
				hidden : true
			} ] ],
			columns : [ [ {
				field : 'name',
				title : '${internationalConfig.资源名称}',
				width : 200
			}, {
				field : 'url',
				title : '${internationalConfig.资源路径}',
				width : 230
			}, {
				field : 'typeId',
				title : '${internationalConfig.资源类型}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>ID',
				width : 150,
				hidden : true
			}, {
				field : 'type',
				title : '${internationalConfig.资源类型}',
				width : 80
			}, {
				field : 'seq',
				title : '${internationalConfig.排序}',
				width : 40
			}, {
				field : 'pid',
				title : '${internationalConfig.上级资源}<c:if test="${currentLanguage=='en'}"><c:out value=" "/></c:if>ID',
				width : 80
			
			}, {
				field : 'pname',
				title : '${internationalConfig.上级资源}',
				width : 80,
				hidden : true
			}, {
				field : 'action',
				title : '${internationalConfig.操作}',
				width : 50,
				formatter : function(value, row, index) {
					var str = '';
					if ($.canEdit) {
						str += $.formatString('<img onclick="editFun(\'{0}\');" src="{1}" title="${internationalConfig.编辑}"/>', row.id, '/static/style/images/extjs_icons/bug/bug_edit.png');
					}
					str += '&nbsp;';
					if ($.canDelete) {
						str += $.formatString('<img onclick="deleteFun(\'{0}\');" src="{1}" title="${internationalConfig.删除}"/>', row.id, '/static/style/images/extjs_icons/bug/bug_delete.png');
					}
					return str;
				}
			}, {
				field : 'remark',
				title : '${internationalConfig.备注}',
				width : 150,
				formatter : function(value, row, index) {
					if (value) {
						return $.formatString('<span title="{0}">{1}</span>', value, value);
					}
					return '';
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
			parent.$.messager.confirm('${internationalConfig.询问}', '${internationalConfig.您是否要删除当前资源}？', function(b) {
				if (b) {
					parent.$.messager.progress({
						title : '${internationalConfig.提示}',
						text : '${internationalConfig.数据处理中}'
					});
					$.post('${pageContext.request.contextPath}/sys/delete.json', {
						id : node.id
					}, function(result) {
						if (result.code==0) {
							treeGrid.treegrid('reload');
							if(parent.layout_west_tree)
							parent.layout_west_tree.tree('reload');
						}
						parent.$.messager.progress('close');
					}, 'json');
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
				title : '${internationalConfig.编辑资源}',
				width : 650,
				height : 420,
				href : '${pageContext.request.contextPath}/sys/edit_page?id=' + node.id,
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
				}]
			});
		}
	}

	function addFun() {
		parent.$.modalDialog({
			title : '${internationalConfig.添加资源}',
			width : 650,
			height : 420,
			href : '${pageContext.request.contextPath}/sys/edit_page',
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
			}]
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
</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit:true,border:false">
		<div data-options="region:'north',border:false" title="" style="height: 80px; overflow: hidden; padding: 5px;">
			<div class="well well-small">
				<span class="badge badge-important">${internationalConfig.提示}</span>
				<p>
					${internationalConfig.新添资源不属于当前用户所属的角色_长文本}
				</p>
			</div>
		</div>
		<div data-options="region:'center',border:false" title="" style="overflow: hidden;">
			<table id="treeGrid"></table>
		</div>
	</div>
	<div id="toolbar" style="display: none;">
		<m:auth uri="/sys/edit.json">
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