<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>${internationalConfig.分成操作员管理}</title>
<%@ include file="/WEB-INF/views/inc/head.inc"%>
<script type="text/javascript">
<m:auth uri="/share_user/add.json">  $.canAdd = true;</m:auth>
<m:auth uri="/share_user/delete.json">  $.canDelete = true;</m:auth>
<m:auth uri="/share_user/modify.json">  $.canModify = true;</m:auth>
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid')
				.datagrid(
						{
							url : '${pageContext.request.contextPath}/share_user/data_grid.json',
							fit : true,
							fitColumns : false,
							border : false,
							pagination : true,
							idField : 'id',
							pageSize : 10,
							pageList : [ 10, 20, 30, 40, 50 ],
							checkOnSelect : false,
							selectOnCheck : false,
							nowrap : false,
							striped : true,
							rownumbers : true,
							singleSelect : true,
							frozenColumns : [ [ {
								field: 'id',
			                    title: '${internationalConfig.操作员id}',
			                    width: 100,
			                    sortable: true,
			                    hidden: false
							} ] ],
							columns : [ [
									{
										field: 'name',
					                    title: '${internationalConfig.操作员名}',
					                    width: 150,
					                    sortable: true
									},
									{
										field : 'roleName',
										title : '${internationalConfig.关联角色}',
										width : 150,
										sortable : true,
									},
									{
										field : 'action',
										title : '${internationalConfig.操作}',
										width : 90,
										formatter : function(value, row, index) {
											var str = '';
											if ($.canModify) {
												str += $.formatString('<img onclick="modifyFun(\'{0}\');" src="{1}" title="${internationalConfig.修改}"/>', row.id, '${pageContext.request.contextPath}/static/style/images/extjs_icons/pencil.png');
											}

											str += '&nbsp;&nbsp;&nbsp;';
											if ($.canDelete) {
												str += $.formatString('<img onclick="deleteFun(\'{0}\');" src="{1}" title="${internationalConfig.删除}"/>', row.id, '${pageContext.request.contextPath}/static/style/images/extjs_icons/cancel.png');
											}

											str += '&nbsp;&nbsp;&nbsp;';
											str += $.formatString('<img onclick="resetPwd(\'{0}\');" src="{1}" title="${internationalConfig.重置密码}"/>', row.id, '${pageContext.request.contextPath}/static/style/images/extjs_icons/bullet_key.png');
											return str;
										}
									}
							] ],
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
	
	function addFun() {
		parent.$.modalDialog({
			title : '${internationalConfig.添加操作员}',
			width : 350,
			height : 200,
			href : '${pageContext.request.contextPath}/share_user/add.json',
			buttons : [ {
				text : '${internationalConfig.添加}',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#addform');
					f.submit();
				}
			} ]
		});
	}
	
	function deleteFun(id) {
		parent.$.messager.confirm('${internationalConfig.询问}', '${internationalConfig.您是否要删除当前操作员吗}', function(b) {
			if (b) {
				parent.$.messager.progress({
					title : '${internationalConfig.提示}',
					text : '${internationalConfig.数据处理中请稍后}'
				});
				$.post('${pageContext.request.contextPath}/share_user/delete.json', {
					id : id
				}, function(result) {
					if (result.success) {
						dataGrid.datagrid('reload');
					}
					parent.$.messager.alert('${internationalConfig.提示}', result.msg, 'info');
					parent.$.messager.progress('close');
				}, 'JSON');
			}
		});
	}
	
	function modifyFun(id) {
		parent.$.modalDialog({
			title : '${internationalConfig.修改操作员}',
			width : 350,
			height : 200,
			href : '${pageContext.request.contextPath}/share_user/modify.json?id=' + id,
			buttons : [ {
				text : '${internationalConfig.修改}',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#form');
					f.submit();
				}
			} ]
		});
	}

	function resetPwd(id) {
		$.get('/share_user/resetPassword?userId=' + id, null, function(result) {
			result = $.parseJSON(result);
			if (result.code == 0) {
				parent.$.messager.alert('${internationalConfig.成功}', '${internationalConfig.密码重置为}:' + result.msg, 'success');
			} else {
				parent.$.messager.alert('${internationalConfig.错误}', result.msg,'error');
			}
		});
	}
	
</script>

</head>
<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',title:'${internationalConfig.查询条件}',border:false"
			style="height: 100px; overflow: hidden;">
			<form id="searchForm">
				<table class="table table-hover table-condensed"
					style="display: none;">
					<tr align="center">
                        <td>${internationalConfig.指定操作员}：
                        	<input type="text" name="userName" placeholder="${internationalConfig.请输入操作员名}" class="easyui-validatebox span2">
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
			data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">${internationalConfig.查询}</a>
		<a href="javascript:void(0);" class="easyui-linkbutton"
			data-options="iconCls:'bug_add',plain:true" onclick="addFun();">${internationalConfig.增加}</a>
	</div>
</body>
</html>