<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.用户管理}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">
<m:auth uri="/user/delete.json">
$.canDelete = true;
</m:auth>
<m:auth uri="/user/grant.json">
$.canGrant = true;
</m:auth>
</script>


<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid').datagrid({
			url : '${pageContext.request.contextPath}/user/list.json',
			fit : true,
			fitColumns : true,
			border : false,
			pagination : true,
			idField : 'uid',
			pageSize : 10,
			pageList : [ 10, 20, 30, 40, 50 ],
			sortName : '',
			sortOrder : 'asc',
			checkOnSelect : false,
			selectOnCheck : false,
			nowrap : false,
			frozenColumns : [ [ {
				field : 'uid',
				title : '${internationalConfig.编号}',
				width : 150,
				checkbox : true
			}, {
				field : 'name',
				title : '${internationalConfig.登录名}',
				width : 80,
				sortable : true
			} ] ],
			columns : [ [  {
				field : 'createTime',
				title : '${internationalConfig.创建时间}',
				width : 150,
				sortable : true,
				
			}, {
				field : 'modifyTime',
				title : '${internationalConfig.最后修改时间}',
				width : 150,
				sortable : true,
		
			}, {
				field : 'rids',
				title : '${internationalConfig.角色} ID',
				hidden : true,
				width : 150
			
			}, {
				field : 'roleNames',
				title : '${internationalConfig.角色}',
				width : 200
			}, {
				field : 'action',
				title : '${internationalConfig.操作}',
				width : 100,
				formatter : function(value, row, index) {
					var str = '';
				
					str += '&nbsp;';
					if ($.canGrant) {
						str += String.format('<img onclick="grantFun(\'{0}\');" src="{1}" title="${internationalConfig.授权}"/>', row.uid, '/static/style/images/extjs_icons/key.png');
					}
					str += '&nbsp;';
					if ($.canDelete) {
						str += String.format('<img onclick="deleteFun(\'{0}\');" src="{1}" title="${internationalConfig.删除}"/>', row.uid, '/static/style/images/extjs_icons/bug/bug_delete.png');
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


	function addFun() {
		parent.$.modalDialog({
			title : '${internationalConfig.添加用户}',
			width : 500,
			height : 300,
			href : '/user/add',
			buttons : [ {
				text : '${internationalConfig.增加}',
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
			id = rows[0].uid;
		}
		parent.$.messager.confirm('${internationalConfig.询问}', '${internationalConfig.您是否要删除此信息}', function(b) {
			if (b) {
				var currentUserId = '${sessionInfo.uid}';/*当前登录用户的ID*/
				if (currentUserId != id) {
					parent.$.messager.progress({
						title : '${internationalConfig.提示}',
						text : '${internationalConfig.数据处理中}....'
					});
					$.post('${pageContext.request.contextPath}/user/delete.json', {
						ids : id
					}, function(result) {
						if (result.code==0) {
							parent.$.messager.alert('${internationalConfig.提示}', "${internationalConfig.操作成功}", 'info');
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

	function batchDeleteFun() {
		var rows = dataGrid.datagrid('getChecked');
		var ids = [];
		if (rows.length > 0) {
			parent.$.messager.confirm('${internationalConfig.确认}', '${internationalConfig.您是否要删除当前选中的项目}', function(r) {
				if (r) {
					parent.$.messager.progress({
						title : '${internationalConfig.提示}',
						text : '${internationalConfig.数据处理中}....'
					});
					var currentUserId = '${sessionInfo.uid}';/*当前登录用户的ID*/
					var flag = false;
					for ( var i = 0; i < rows.length; i++) {
						if (currentUserId != rows[i].id) {
							ids.push(rows[i].uid);
						} else {
							flag = true;
						}
					}
					$.getJSON('${pageContext.request.contextPath}/user/delete.json?ids='+ids.join('&ids=')
					, function(result) {
						if (result.code==0) {
							dataGrid.datagrid('load');
							dataGrid.datagrid('uncheckAll').datagrid('unselectAll').datagrid('clearSelections');
						}
						if (flag) {
							parent.$.messager.show({
								title : '${internationalConfig.提示}',
								msg : '${internationalConfig.不可以删除自己}'
							});
						} else {
							parent.$.messager.alert('${internationalConfig.提示}', "${internationalConfig.操作成功}", 'info');
						}
						parent.$.messager.progress('close');
					});
				}
			});
		} else {
			parent.$.messager.show({
				title : '${internationalConfig.提示}',
				msg : '${internationalConfig.请勾选要删除的记录}'
			});
		}
	}

	function editFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].uid;
		}
		parent.$.modalDialog({
			title : '${internationalConfig.编辑用户}',
			width : 500,
			height : 300,
			href : '${pageContext.request.contextPath}/user/edit?id=' + id,
			buttons : [ {
				text : '${internationalConfig.编辑}',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#form');
					f.submit();
				}
			} ]
		});
	}



	function batchGrantFun() {
		var rows = dataGrid.datagrid('getChecked');
		var ids = [];
		if (rows.length > 0) {
			for ( var i = 0; i < rows.length; i++) {
				ids.push(rows[i].uid);
			}
			parent.$.modalDialog({
				title : '${internationalConfig.用户授权}',
				width : 500,
				height : 300,
				href : '${pageContext.request.contextPath}/user/grant?ids=' + ids.join(','),
				buttons : [ {
					text : '${internationalConfig.授权}',
					handler : function() {
						parent.$.modalDialog.openner_dataGrid = dataGrid;//因为授权成功之后，需要刷新这个dataGrid，所以先预定义好
						var f = parent.$.modalDialog.handler.find('#form');
						f.submit();
					}
				} ]
			});
		} else {
			parent.$.messager.show({
				title : '${internationalConfig.提示}',
				msg : '${internationalConfig.请勾选要授权的记录}'
			});
		}
	}

	function grantFun(id) {
		parent.$.modalDialog({
			title : '${internationalConfig.用户授权}',
			width : 500,
			height : 300,
			href : '${pageContext.request.contextPath}/user/grant_page?id=' + id,
			buttons : [ {
				text : '${internationalConfig.授权}',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为授权成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#form');
					f.submit();
				}
			} ]
		});
	}

	function searchFun() {
		exportParam=$.serializeObject($('#searchForm'));
		dataGrid.datagrid('load', exportParam);
	}
	function cleanFun() {
		$('#searchForm input').val('');
		$('#searchForm select').val('');
		dataGrid.datagrid('load', {});
	}
	var exportParam='';
	$(function(){
		$('#exportIcon').click(function(){
			var url = '/user/exportexcel.do?'+$.param(exportParam);
			window.open(url);
		});
	});
</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false,height:'auto'" style="overflow: hidden;">
			<form id="searchForm">
				<table class="table-more" >
					<tr>
						<td>${internationalConfig.登录名}：<input name="name" placeholder="${internationalConfig.可以模糊查询登录名}" class="span2" /></td>
						<td>${internationalConfig.创建时间}：<input class="span2" name="start" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" />${internationalConfig.至}<input class="span2" name="end" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd HH:mm:ss'})" /></td>
						<td>${internationalConfig.角色}：
							<select name="rid">
								<option value="">${internationalConfig.全部}</option>
								<c:forEach items="${roles}" var="r"><option value="${r.key}">${r.value}</option></c:forEach>
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
	 <m:auth uri="/user/add.json">
			<a onclick="addFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'pencil_add'">${internationalConfig.增加}</a>
	</m:auth>
	 <m:auth uri="/user/delete.json">
			<a onclick="batchDeleteFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'delete'">${internationalConfig.批量删除}</a>
		</m:auth>
		<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a><a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="cleanFun();">${internationalConfig.清空条件}</a>
		<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'bullet_disk',plain:true" id="exportIcon">${internationalConfig.导出}</a>
		<%--<img src="/static/style/images/extjs_icons/page/page_excel.png" id="exportIcon">${internationalConfig.导出}--%>
	</div>

<%--   
	<div id="menu" class="easyui-menu" style="width: 120px; style:none">
		<div onclick="addFun();" data-options="iconCls:'pencil_add'">增加</div>
		<div onclick="deleteFun();" data-options="iconCls:'pencil_delete'">删除</div>
		<div onclick="editFun();" data-options="iconCls:'pencil'">编辑</div>
	</div>
--%>
</body>
</html>